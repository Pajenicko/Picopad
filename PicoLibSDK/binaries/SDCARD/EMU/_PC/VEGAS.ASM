; Vegas - Slot Machine
; (c) 1993-2024 Miroslav Nemecek

; The image on end of this file was created by screen capture with
; GDemo program (to *.SCR file) and then exported to ASM format with BinS.

HI       EQU       256

KROKU    EQU       6                        ; po‡et krok– pro posun obr zku

BAR3     EQU       0                        ; BAR 3
BAR2     EQU       1                        ; BAR 2
BAR1     EQU       2                        ; BAR 1
ZVON     EQU       3                        ; zvonek
SVES     EQU       4                        ; ¨vestka
JABL     EQU       5                        ; jablko
TRES     EQU       6                        ; t©e¨e¤
BARX     EQU       -2                       ; BAR ?
XXXX     EQU       -1                       ; ?

Code     SEGMENT
         ASSUME    cs:Code,ds:Code
         ORG       100h

; ------ test videokarty EGA/VGA

Start:   push      ds
         mov       ah,12h
         mov       bx,7e10h
         int       10h
         pop       ds
         cmp       bh,1
         ja        Start02
         cmp       bl,3
         jbe       Start04

; ------ chyba - nespr vn  videokarta

Start02: mov       dx,offset CardTxt
         mov       ah,9
         int       21h
         int       20h

; ------ £schova aktivn¡ho videom¢du

Start04: mov       ah,0fh
         int       10h
         mov       ds:[OldVMod],al

; ------ inicializace videom¢du

         mov       ax,0dh
         int       10h

; ------ test videokarty EGA/VGA

         mov       ah,0fh
         int       10h
         cmp       al,0dh
         jne       Start02                  ; videom¢d nenastaven

; ------ inicializace gener toru n hody a hodin

         call      CekInit                  ; inicializace hodin
         call      InitRnd                  ; inicializace gener toru n hody

; ------ zobrazen¡ tituln¡ho obr zku

         mov       si,offset Obrazek+16
         mov       cx,200*256+40
         xor       dx,dx
         call      DispObr                  ; zobrazen¡ titulku
Start11: call      DispStav                 ; zobrazen¡ aktu ln¡ho stavu
Start12: call      DispVkld                 ; zobrazen¡ vkladu

; ------ ‡ek n¡ na stisk kl vesy

Start2:  mov       ah,0
         int       16h

; ------ kl vesa MEZERA nebo ENTER - losov n¡

         cmp       al,13
         je        Start3
         cmp       al," "
         jne       Start4
Start3:  call      Hrej                     ; hra
         jc        Konec
         jmp       short Start11

; ------ ESC nebo Ctrl-Break - ukon‡en¡ programu

Start4:  or        ax,ax
         jz        Konec
         cmp       al,27
         je        Konec

	; up
	cmp	ah,48h
	jne	Start42
	mov	al,byte ptr ds:[Vklad]
	add	al,31h

	; down
Start42:cmp	ah,50h
	jne	Start43
	mov	al,byte ptr ds:[Vklad]
	add	al,2fh

Start43:

; ------ ‡¡slice - nastaven¡ v˜¨ky vkladu

         sub       al,"0"
         jbe       Start2
         cmp       al,5
         ja        Start2
Start8:  mov       byte ptr ds:[Vklad],al
         jmp       short Start12

; ------ konec programu

Konec:   mov       al,ds:[OldVMod]
         mov       ah,0
         int       10h
         int       20h

; -----------------------------------------------------------------------------
;        odstartov n¡ hry (CY=p©eru¨en¡)
; -----------------------------------------------------------------------------

Hrej     PROC      NEAR

; ------ ode‡ten¡ vkladu

         mov       ax,ds:[Vklad]
         sub       ds:[Celkem],ax
         mov       word ptr ds:[Vyhra],0
         call      DispStav                 ; nov‚ zobrazen¡ stavu

; ------ generov n¡ po‡tu krok– jednotliv˜ch kotou‡–

         call      Random
         and       al,0fh
         add       al,8
         mov       bl,al
         mov       ds:[TabCit],al

         call      Random
         and       al,0fh
         add       al,8
         add       bl,al
         mov       ds:[TabCit+1],bl

         call      Random
         and       al,0fh
         add       al,8
         add       bl,al
         mov       ds:[TabCit+2],bl

; ------ zv˜¨en¡ krok– jednotliv˜ch kol

Hrej1:   mov       byte ptr ds:[Faze],KROKU-1
         cmp       byte ptr ds:[TabCit],0
         je        Hrej2
         dec       byte ptr ds:[TabCit]
         jz        Hrej2
         inc       byte ptr ds:[TabKrok]
         cmp       byte ptr ds:[TabKrok],20
         jb        Hrej2
         mov       byte ptr ds:[TabKrok],0

Hrej2:   cmp       byte ptr ds:[TabCit+1],0
         je        Hrej3
         dec       byte ptr ds:[TabCit+1]
         jz        Hrej3
         inc       byte ptr ds:[TabKrok+1]
         cmp       byte ptr ds:[TabKrok+1],20
         jb        Hrej3
         mov       byte ptr ds:[TabKrok+1],0

Hrej3:   cmp       byte ptr ds:[TabCit+2],0
         je        Hrej6                    ; konec
         dec       byte ptr ds:[TabCit+2]
         jz        Hrej4
         inc       byte ptr ds:[TabKrok+2]
         cmp       byte ptr ds:[TabKrok+2],20
         jb        Hrej4
         mov       byte ptr ds:[TabKrok+2],0

; ------ zobrazen¡ kol

Hrej4:   mov       ah,1
         int       16h
         jz        Hrej5
         mov       ah,0
         int       16h
         or        ax,ax
         jz        Hrej8
         cmp       al,27
         je        Hrej8

Hrej5:   call      DispKol

; ------ ‡ek n¡ po kr tk˜ ‡as

         mov       cx,10
         call      Cekej

; ------ posun ukazatele f ze

         dec       byte ptr ds:[Faze]
         jns       Hrej4
         jmp       Hrej1

; ------ vyhodnocen¡ hry

Hrej6:   mov       word ptr ds:[Vyhra],0

; ------ vyhodnocen¡ smˆr–

         mov       al,1
         mov       bl,ds:[TabKrok]
         xor       dx,dx
         call      Hodnot                   ; hodnocen¡ smˆru 1
         dec       bx
         call      Hodnot                   ; hodnocen¡ smˆru 2
         inc       bx
         inc       bx
         call      Hodnot                   ; hodnocen¡ smˆru 3
         dec       dx
         call      Hodnot                   ; hodnocen¡ smˆru 4
         dec       bx
         dec       bx
         inc       dx
         inc       dx
         call      Hodnot                   ; hodnocen¡ smˆru 5

; ------ ulo‘en¡ dosa‘en‚ v˜hry

         inc       word ptr ds:[Her]        ; zv˜¨en¡ ‡¡ta‡e her
         mov       ax,ds:[Vyhra]            ; dosa‘en  v˜hra
         add       ds:[Celkem],ax           ; p©i‡ten¡ k celkov‚mu sk¢re
         call      DispStav                 ; nov‚ zobrazen¡ stavu
         clc
         ret

Hrej8:   stc
Hrej9:   ret

Hrej     ENDP

; -----------------------------------------------------------------------------
;        hodnocen¡ jednoho smˆru (vklad AL, polo‘ka BX, smˆr DX)
; -----------------------------------------------------------------------------

Hodnot   PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      si

; ------ test, zda je platn˜ vklad

         cmp       al,byte ptr ds:[Vklad]
         jbe       Hodnot0
         jmp       Hodnot9                  ; nepovolen˜ vklad

; ------ prvn¡ polo‘ka

Hodnot0: mov       bh,0
         cmp       bl,0
         jge       Hodnot1
         add       bl,20
Hodnot1: cmp       bl,20
         jl        Hodnot2
         sub       bl,20
Hodnot2: mov       cl,ds:[bx+Poradi1]

; ------ druh  polo‘ka

         sub       bl,ds:[TabKrok]
         add       bl,ds:[TabKrok+1]
         add       bl,dl
         cmp       bl,0
         jge       Hodnot3
         add       bl,20
Hodnot3: cmp       bl,20
         jl        Hodnot4
         sub       bl,20
Hodnot4: mov       ch,ds:[bx+Poradi2]

; ------ t©et¡ polo‘ka

         sub       bl,ds:[TabKrok+1]
         add       bl,ds:[TabKrok+2]
         add       bl,dl
         cmp       bl,0
         jge       Hodnot5
         add       bl,20
Hodnot5: cmp       bl,20
         jl        Hodnot6
         sub       bl,20
Hodnot6: mov       bl,ds:[bx+Poradi3]

; ------ nalezen¡ polo‘ky

         mov       si,offset TabBod
Hodnot7: mov       al,ds:[si]
         cmp       al,BARX
         jne       Hodnot72
         cmp       cl,2
         jbe       Hodnot73
Hodnot72:cmp       al,cl
         jne       Hodnot78

Hodnot73:mov       al,ds:[si+1]
         cmp       al,XXXX
         je        Hodnot75
         cmp       al,BARX
         jne       Hodnot74
         cmp       ch,2
         jbe       Hodnot75
Hodnot74:cmp       al,ch
         jne       Hodnot78

Hodnot75:mov       al,ds:[si+2]
         cmp       al,XXXX
         je        Hodnot8
         cmp       al,BARX
         jne       Hodnot76
         cmp       bl,2
         jbe       Hodnot8
Hodnot76:cmp       al,bl
         je        Hodnot8

Hodnot78:add       si,4
         cmp       si,offset TabBod0
         jb        Hodnot7
         jmp       short Hodnot9

; ------ ulo‘en¡ nalezen‚ho sk¢re

Hodnot8: mov       al,ds:[si+3]
         mov       ah,0
         add       ds:[Vyhra],ax            ; p©id n¡ v˜hry

; ------ n vrat registr–

Hodnot9: pop       si
         pop       cx
         pop       bx
         pop       ax
         inc       ax
         ret

Hodnot   ENDP

; -----------------------------------------------------------------------------
;        rotov n¡ kola (pozice DL)
; -----------------------------------------------------------------------------

RollKol  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      dx
         push      si
         push      di
         push      ds
         push      es

; ------ nastaven¡ z pisov‚ho m¢du

         mov       ax,0f02h
         call      Set3C4                   ; nastaven¡ z pisov‚ roviny
         mov       ax,105h
         call      Set3CE                   ; z pisov˜ m¢d 1

; ------ p©¡prava registr–

         mov       ax,0a000h
         mov       es,ax
         mov       ds,ax
         mov       dh,0
         mov       di,36*40 + 3*24*40 - 40
         mov       si,36*40 + 3*24*40 - 40 - 24/KROKU*40
         add       di,dx
         add       si,dx
         mov       dx,3*24 - 24/KROKU       ; po‡et linek k rotaci
         xor       cx,cx
         cld

; ------ rotace okna

RollKol1:mov       cl,40/8
         rep       movsb
         sub       si,40/8 + 40
         sub       di,40/8 + 40
         dec       dx
         jnz       RollKol1

; ------ n vrat z pisov‚ho m¢du

         mov       ax,5
         call      Set3CE                   ; z pisov˜ m¢d 1

; ------ n vrat registr–

         pop       es
         pop       ds
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

RollKol  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ aktu ln¡ho stavu kol
; -----------------------------------------------------------------------------

DispKol  PROC      NEAR

         xor       si,si                    ; ukazatel zobrazovan‚ho kola
         mov       di,offset Poradi1        ; tabulka po©ad¡ kola 1
         mov       dl,56/8                  ; po‡ te‡n¡ pozice

; ------ zobrazen¡ objekt–

DispKol1:cmp       byte ptr ds:[TabCit+si],0 ; dosud se to‡¡ ?
         je        DispKol5                 ; ji‘ se neto‡¡
         call      RollKol
         mov       dh,36                    ; po‡ te‡n¡ linka
         mov       bl,ds:[TabKrok+si]       ; krok hrac¡ho kola
         inc       bx
         call      DispOKol                 ; zobrazen¡ prvn¡ho obr zku

; ------ p©¡prava pro dal¨¡ hrac¡ kolo

DispKol5:inc       si                       ; zv˜¨en¡ ukazatele kola
         add       dl,48/8
         add       di,20                    ; adresa dal¨¡ tabulky po©ad¡
         cmp       si,3
         jb        DispKol1                 ; dal¨¡ hrac¡ kolo
         ret

DispKol  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ jednoho obr zku kola (s o©ez n¡m v˜¨ky)
; -----------------------------------------------------------------------------
; VSTUP: DL=pozice k zobrazen¡
;        DH=linka k zobrazen¡
;        BL=krok
;        DI=tabulka po©ad¡ kola
;        DS=datov˜ segment
; -----------------------------------------------------------------------------

DispOKol PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      dx
         push      si

; ------ p©ete‡en¡ kroku dol–

         mov       bh,0
         cmp       bl,0
         jge       DispOKl1
         add       bl,20

; ------ p©ete‡en¡ kroku nahoru

DispOKl1:cmp       bl,20
         jl        DispOKl2
         sub       bl,20

; ------ obr zek k zobrazen¡

DispOKl2:mov       al,ds:[di+bx]            ; obr zek k zobrazen¡

; ------ adresa obr zku

         mov       ah,0
         shl       ax,1
         xchg      ax,si
         mov       si,ds:[si+AdrOKol]       ; adresa obr zku
         mov       cx,24*HI + 40/8          ; rozmˆry obr zku

; ------ posun obr zku o f zi

         mov       al,24/KROKU              ; po‡et linek na krok
         mul       byte ptr ds:[Faze]       ; korekce linky
         sub       dh,al                    ; korekce linky

; ------ omezen¡ obr zku zdola

         cmp       dh,36                    ; minim ln¡ linka
         jae       DispOKl3                 ; linka je OK
         mov       al,36
         sub       al,dh                    ; korekce
         mov       dh,36
         sub       ch,al                    ; sn¡‘en¡ v˜¨ky obr zku
         jbe       DispOKl9                 ; nezbylo nic k zobrazen¡
         mov       ah,40                    ; po‡et bajt– na linku
         mul       ah                       ; p©epo‡et na offset
         add       si,ax                    ; korekce adresy obr zku

; ------ zobrazen¡ obr zku

DispOKl3:cmp       ch,24/KROKU
         jb        DispOKl4
         mov       ch,24/KROKU
DispOKl4:call      DispObr                  ; zobrazen¡ obr zku

; ------ n vrat registr–

DispOKl9:pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         add       dh,24
         dec       bx
         ret

DispOKol ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ vkladu
; -----------------------------------------------------------------------------

DispVkld PROC      NEAR

         mov       dh,70
         mov       al,1
         call      DispVk0                  ; "1"

         mov       dh,88
         mov       al,2
         call      DispVk0                  ; "2"

         mov       dh,52
         mov       al,3
         call      DispVk0                  ; "3"

         mov       dh,34
         mov       al,4
         call      DispVk0                  ; "4"

         mov       dh,106
         mov       al,5
         call      DispVk0                  ; "5"
         ret

DispVkld ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ jedn‚ polo‘ky vkladu (DH=linka, AL=vklad)
; -----------------------------------------------------------------------------

DispVk0  PROC      NEAR

         cmp       al,byte ptr ds:[Vklad]
         mov       si,offset Obrazek+16 + 8/8 + 70*40
         jbe       DispVk01
         mov       si,offset Obrazek+16 + 8/8 + 88*40
DispVk01:mov       cx,8*256 + 1
         mov       dl,8/8
         call      DispObr
         ret

DispVk0  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ aktu ln¡ho stavu
; -----------------------------------------------------------------------------

DispStav PROC      NEAR

         mov       dx,48*256 + 224/8
         mov       ax,ds:[Vyhra]
         call      DispNum

         mov       dh,71
         mov       ax,ds:[Celkem]
         call      DispNum

         mov       dh,96
         mov       ax,ds:[Her]
         call      DispNum
         ret

DispStav ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ obr zku SI (pozice DL, linka DH, CL=¨¡©ka, CH=v˜¨ka)
; -----------------------------------------------------------------------------

DispObr  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      cx
         push      dx
         push      si
         push      di
         push      es

; ------ v˜po‡et ukl dac¡ adresy

         mov       al,40                    ; po‡et bajt– na linku
         mul       dh                       ; p©epo‡et linky na adresu
         mov       dh,0
         add       ax,dx                    ; p©i‡ten¡ pozice
         xchg      ax,di                    ; DI <- ukl dac¡ adresa po‡ dku
         mov       ax,0a000h
         mov       es,ax                    ; ES <- segment videopamˆti
         cld

; ------ nastaven¡ z pisov‚ roviny

         mov       ah,1                     ; z pisov  rovina
DispObr1:mov       al,2
         call      Set3C4                   ; nastaven¡ z pisov‚ roviny

; ------ p©enesen¡ obr zku

         push      cx
         push      di
         push      si

DispObr2:push      cx
         push      di
         push      si
         mov       ch,0
         rep       movsb
         pop       si
         pop       di
         pop       cx

         add       si,40
         add       di,40
         dec       ch
         jnz       DispObr2

         pop       si
         pop       di
         pop       cx
         add       si,200*40

; ------ p©¡prava pro dal¨¡ rovinu

         shl       ah,1
         cmp       ah,10h
         jne       DispObr1

; ------ n vrat registr–

         pop       es
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       ax
         ret

DispObr  ENDP

; -----------------------------------------------------------------------------
;             zobrazen¡ ‡¡sla AX (v rozsahu -9999 a‘ +9999)
; -----------------------------------------------------------------------------
; VSTUP: AX=‡¡slo
;        DL=pozice konce ‡¡sla na © dku
;        DH=linka
; -----------------------------------------------------------------------------

DispNum  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      dx
         push      si

; ------ omezen¡ velikosti ‡¡sla

         cmp       ax,9999
         jl        DispNum1
         mov       ax,9999
DispNum1:cmp       ax,-9999
         jg        DispNum2
         mov       ax,-9999

; ------ absolutn¡ hodnota ‡¡sla

DispNum2:or        ax,ax                    ; je z porn‚ ‡¡slo ?
         mov       bl,11                    ; zobrazen¡ se mezera
         jns       DispNum3                 ; je kladn‚ ‡¡slo
         neg       ax                       ; absolutn¡ hodnota ‡¡sla
         dec       bx                       ; zobrazen¡ se znam‚nko "-"

; ------ p©¡prava registr–

DispNum3:mov       bh,4                     ; ‡¡ta‡ znak–
         mov       cx,10                    ; dˆlitel

; ------ v˜po‡et ‡¡sla

DispNum4:push      dx                       ; ukazatel pozice
         xor       dx,dx                    ; DX <- 0
         div       cx                       ; v˜po‡et jedn‚ ‡¡slice
         xchg      ax,si                    ; SI <- £schova ‡¡sla
         xchg      ax,dx                    ; AX <- zbytek po dˆlen¡
         pop       dx                       ; pozice
         mov       ah,14                    ; barva
         call      DispChr                  ; zobrazen¡ ‡¡slice
         dec       bh                       ; ‡¡ta‡ znak–
         xchg      ax,si                    ; AX <- n vrat ‡¡sla
         or        ax,ax                    ; je dal¨¡ ‡¡slice ?
         jnz       DispNum4                 ; bude dal¨¡ ‡¡slice

; ------ zobrazen¡ znam‚nka

         mov       ah,14                    ; barva
         mov       al,bl                    ; znam‚nko
         call      DispChr                  ; zobrazen¡ ‡¡slice

; ------ vymaz n¡ zbyl˜ch pozic

         or        bh,bh                    ; zbyly dal¨¡ pozice ?
         jz        DispNum6                 ; nezbyly dal¨¡ pozice
DispNum5:mov       ax,14*256 + 11
         call      DispChr                  ; zobrazen¡ mezery
         dec       bh
         jnz       DispNum5

; ------ n vrat registr–

DispNum6:pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

DispNum  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ znaku (pozice DL, linka DH, znak AL, barva AH, DL se zmen¨¡)
; -----------------------------------------------------------------------------

DispChr  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      cx
         push      dx
         push      si
         push      di
         push      es

; ------ nastaven¡ barvy a masky znaku

         push      ax
         not       ah
         mov       al,1
         call      Set3CE                   ; nastaven¡ registru barvy
         xor       ax,ax
         call      Set3CE                   ; registr 0 = ‡ern  barva
         mov       ax,0f02h
         call      Set3C4                   ; nastaven¡ masky rovin
         mov       ax,7f08h
         call      Set3CE                   ; nastaven¡ masky
         pop       ax

; ------ adresa fontu znaku

         mov       ah,8
         mul       ah
         add       ax,offset Font
         xchg      ax,si                    ; SI <- adresa znaku

; ------ v˜po‡et ukl dac¡ adresy

         mov       al,40                    ; po‡et bajt– na linku
         mul       dh                       ; p©epo‡et linky na adresu
         mov       dh,0
         add       ax,dx
         xchg      ax,di                    ; DI <- ukl dac¡ adresa po‡ dku
         mov       ax,0a000h
         mov       es,ax

; ------ zobrazen¡ znaku

         cld
         mov       cx,8
DispChr1:lodsb
         xchg      al,es:[di]
         add       di,40
         loop      DispChr1

; ------ n vrat registru barvy

         mov       ax,1
         call      Set3CE
         mov       ax,0ff08h
         call      Set3CE                   ; n vrat masky

; ------ n vrat registr–

         pop       es
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       ax
         dec       dl
         ret

DispChr  ENDP

; -----------------------------------------------------------------------------
;        nastaven¡ registru AL portu 3CEh na AH
; -----------------------------------------------------------------------------

Set3CE   PROC      NEAR

         push      dx
         mov       dx,3ceh
         jmp       short Set3C42

Set3CE   ENDP

; -----------------------------------------------------------------------------
;        nastaven¡ registru AL portu 3C4h na AH
; -----------------------------------------------------------------------------

Set3C4   PROC      NEAR

         push      dx
         mov       dx,3c4h
Set3C42: out       dx,al
         inc       dx
         xchg      al,ah
         out       dx,al
         xchg      al,ah
         pop       dx
         ret

Set3C4   ENDP

; -----------------------------------------------------------------------------
;                             InitRnd
;                  inicializace gener toru n hody
; -----------------------------------------------------------------------------
; VSTUP: DS=datov˜ segment
; -----------------------------------------------------------------------------

InitRnd  PROC      NEAR

         push      ax
         push      ds
         xor       ax,ax
         mov       ds,ax
         mov       ax,ds:[46ch]             ; ‡¡ta‡ syst‚mov‚ho ‡asova‡e
         pop       ds
         mov       word ptr ds:[RandomR],ax ; inicializa‡n¡ konstanta
         pop       ax
         ret

InitRnd  ENDP

; -----------------------------------------------------------------------------
;                              Random
;                    gener tor n hodn‚ho ‡¡sla
; -----------------------------------------------------------------------------
; VSTUP: DS=datov˜ segment
; VSTUP: AX=n hodn‚ ‡¡slo
; -----------------------------------------------------------------------------

Random   PROC      NEAR

         push      bx
         push      cx
         push      dx

         mov       ax,word ptr ds:[RandomR]
         mov       bx,word ptr ds:[RandomR+2]
         mov       cx,ax
         mul       word ptr cs:[RandomD]
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
         xchg      ax,dx

         pop       dx
         pop       cx
         pop       bx
         ret

Random   ENDP

;; -----------------------------------------------------------------------------
;;        nastaven¡ zvukov‚ho gener toru na AX
;; -----------------------------------------------------------------------------
;
;SetSound PROC      NEAR
;
;         push      ax
;         cli
;         mov       al,0b6h
;         out       [43h],al
;         pop       ax
;         push      ax
;         out       [42h],al                 ; LOW
;         xchg      ah,al
;         out       [42h],al                 ; HIGH
;         in        al,[61h]
;         or        al,3
;         out       [61h],al
;         sti
;         pop       ax
;         ret
;
;SetSound ENDP
;
;; -----------------------------------------------------------------------------
;;        vypnut¡ zvukov‚ho gener toru
;; -----------------------------------------------------------------------------
;
;SoundOff PROC      NEAR
;
;         push      ax
;         in        al,[61h]
;         and       al,not 3
;         out       [61h],al
;         pop       ax
;         ret
;
;SoundOff ENDP

; -----------------------------------------------------------------------------
;        cejchov n¡ hodin
; -----------------------------------------------------------------------------
; VSTUP: DS=datov˜ segment
; -----------------------------------------------------------------------------

CekInit  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      dx
         push      di

         push      ds

; ------ p©¡prava registr–

         sti
         xor       ax,ax                    ; AX <- 0
         mov       ds,ax
         xor       dx,dx                    ; DX <- 0
         mov       di,46ch

; ------ ‡ek n¡ na za‡ tek impulsu hodin

         mov       bx,ds:[di]
CekInit1:cmp       bx,ds:[di]
         je        CekInit1                 ; ‡ek n¡ na za‡ tek hodin

; ------ mˆ©en¡ ‡asu

         mov       bx,ds:[di]
         EVEN                               ; zarovn n¡ na sudou adresu
CekInit2:add       ax,1                     ; ‡¡ta‡ ni‘¨¡ho slova ‡asu
         adc       dx,0                     ; p©enos do vy¨¨¡ho slova
         cmp       bx,ds:[di]               ; byla zmˆna ?
         je        CekInit2                 ; ‡ek n¡ na zmˆnu hodin

; ------ v˜po‡et konstanty

         mov       bx,55                    ; dˆlitel
         cmp       dx,bx                    ; p©ete‡en¡ ‡¡sla ?
         jb        CekInit3                 ; nen¡ p©ete‡en¡ ‡¡sla
         mov       dx,54                    ; omezen¡ ‡¡sla
CekInit3:div       bx                       ; v˜po‡et konstanty
         or        ax,ax                    ; je = 0 ?
         jnz       CekInit4                 ; nen¡ = 0
         inc       ax                       ; korekce na 1
CekInit4:
         pop       ds
         mov       ds:[Cit1ms],ax           ; konstanta hodin

; ------ n vrat registr–

         pop       di
         pop       dx
         pop       bx
         pop       ax
         ret

CekInit  ENDP

; -----------------------------------------------------------------------------
;        ‡ek n¡ na uplynut¡ zadan‚ho ‡asu
; -----------------------------------------------------------------------------
; VSTUP: CX=po‘adovan  doba v milisekund ch
;        DS=datov˜ segment
; -----------------------------------------------------------------------------

Cekej    PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      dx
         push      di

; ------ ‡ek n¡ po zadanou dobu

         jcxz      Cekej9                   ; nen¡ ‘ dn‚ ‡ek n¡
         mov       di,offset Cit1ms         ; konstanta hodin
Cekej1:  xor       ax,ax                    ; ni‘¨¡ slovo ‡¡ta‡e hodin
         xor       dx,dx                    ; vy¨¨¡ slovo ‡¡ta‡e hodin

; ------ ‡¡t n¡ doby 1 ms

         EVEN                               ; zarovn n¡ na sudou adresu
Cekej2:  add       ax,1                     ; ‡¡ta‡ ni‘¨¡ho slova ‡asu
         adc       dx,0                     ; p©enos do vy¨¨¡ho slova
         cmp       ax,ds:[di]               ; dosa‘eno doby 1 ms ?
         jne       Cekej2                   ; ‡¡t n¡ doby 1 ms

         loop      Cekej1                   ; ‡ek n¡ na dal¨¡ 1 ms

; ------ n vrat registr–

Cekej9:  pop       di
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

Cekej    ENDP

; *****************************************************************************
;
;                                   Data
;
; *****************************************************************************

OldVMod  db        3                        ; uschovan˜ videom¢d
Sound    db        3                        ; 3=p©¡znak zapnut¡ zvuku (0=nen¡)

CardTxt  db        'Sorry, program requires EGA or VGA graphics card !',13,10,'$'

; ------ ‡asova‡

         EVEN                               ; za‡¡n  na sud‚ adrese jako 0:46ch
Cit1ms   dw        0                        ; konstanta pro dobu 1 ms

; ------ aktu ln¡ stav hry

Vklad    dw        1                        ; v˜¨ka vkladu
Vyhra    dw        0                        ; dosa‘en  v˜hra
Celkem   dw        0                        ; ‡¡ta‡ stavu celkem
Her      dw        0                        ; ‡¡ta‡ her

; ------ adresy obr zk– objekt–

AdrOKol  label     word
         dw        Obrazek+16 + 56/8 + 84*40   ; 0: BAR 3
         dw        Obrazek+16 + 58/8 + 36*40   ; 1: BAR 2
         dw        Obrazek+16 + 152/8 + 84*40  ; 2: BAR 1
         dw        Obrazek+16 + 152/8 + 60*40  ; 3: zvonek
         dw        Obrazek+16 + 104/8 + 36*40  ; 4: ¨vestka
         dw        Obrazek+16 + 56/8 + 60*40   ; 5: jablko
         dw        Obrazek+16 + 104/8 + 84*40  ; 6: t©e¨e¤

; ------ ukazatel hrac¡ch kol

Faze     db        0                        ; aktu ln¡ f ze rotace objekt–
TabCit   db        3 dup(0)                 ; tabulka ‡¡ta‡– posun–
TabKrok  db        3 dup(0)                 ; ukazatel krok– jednotliv˜ch kol

; ------ tabulka bodov n¡

TabBod   db        BAR3,BAR3,BAR3,200
         db        BAR2,BAR2,BAR2,100
         db        BAR1,BAR1,BAR1,50
         db        BARX,BARX,BARX,20
         db        ZVON,ZVON,ZVON,18
         db        ZVON,ZVON,BARX,18
         db        SVES,SVES,SVES,14
         db        SVES,SVES,BARX,14
         db        JABL,JABL,JABL,10
         db        JABL,JABL,BARX,10
         db        TRES,TRES,XXXX,5
         db        TRES,XXXX,XXXX,2
TabBod0  label     byte

; ------ tabulka po©ad¡ objekt–

Poradi1  db        SVES,JABL,ZVON,BAR3,SVES,JABL,TRES,JABL,SVES,JABL
         db        BAR2,JABL,TRES,JABL,ZVON,JABL,BAR1,JABL,SVES,JABL

Poradi2  db        SVES,BAR2,TRES,ZVON,TRES,BAR3,JABL,TRES,BAR1,TRES
         db        SVES,TRES,BAR2,ZVON,TRES,BAR1,TRES,JABL,BAR1,TRES

Poradi3  db        ZVON,SVES,JABL,SVES,ZVON,SVES,ZVON,BAR3,SVES,ZVON
         db        JABL,ZVON,BAR2,SVES,ZVON,SVES,ZVON,BAR1,ZVON,SVES

; ------ gener tor n hody

RandomR  dd        21510d31h                ; promˆnn  pro gener tor n hody
RandomD  dw        8405h                    ; pomocn  konstanta

; ------ fonty znak–

Font     label     byte
         db        00111100b                ; 0: "0"
         db        01000010b
         db        01000010b
         db        01000010b
         db        01000010b
         db        01000010b
         db        00111100b
         db        00000000b

         db        00001000b                ; 1: "1"
         db        00011000b
         db        00111000b
         db        00001000b
         db        00001000b
         db        00001000b
         db        00111110b
         db        00000000b

         db        00111100b                ; 2: "2"
         db        01000010b
         db        00000010b
         db        00011100b
         db        00100000b
         db        01000000b
         db        01111110b
         db        00000000b

         db        00111100b                ; 3: "3"
         db        01000010b
         db        00000010b
         db        00001100b
         db        00000010b
         db        01000010b
         db        00111100b
         db        00000000b

         db        00001000b                ; 4: "4"
         db        00011000b
         db        00101000b
         db        01001000b
         db        01111100b
         db        00001000b
         db        00111110b
         db        00000000b

         db        01111110b                ; 5: "5"
         db        01000000b
         db        01111100b
         db        00000010b
         db        00000010b
         db        01000010b
         db        00111100b
         db        00000000b

         db        00011100b                ; 6: "6"
         db        00100000b
         db        01000000b
         db        01111100b
         db        01000010b
         db        01000010b
         db        00111100b
         db        00000000b

         db        01111110b                ; 7: "7"
         db        01000010b
         db        00000100b
         db        00001000b
         db        00010000b
         db        00100000b
         db        00100000b
         db        00000000b

         db        00111100b                ; 8: "8"
         db        01000010b
         db        01000010b
         db        00111100b
         db        01000010b
         db        01000010b
         db        00111100b
         db        00000000b

         db        00111100b                ; 9: "9"
         db        01000010b
         db        01000010b
         db        00111110b
         db        00000010b
         db        00000100b
         db        00111000b
         db        00000000b

         db        00000000b                ; 10: "-"
         db        00000000b
         db        00000000b
         db        01111110b
         db        00000000b
         db        00000000b
         db        00000000b
         db        00000000b

         db        00000000b                ; 11: " "
         db        00000000b
         db        00000000b
         db        00000000b
         db        00000000b
         db        00000000b
         db        00000000b
         db        00000000b

;Zahlavi  db        16 dup(?)                ; z hlav¡ obr zku
Obrazek  label     byte                     ; obr zek

 	include	VEGAS.INC

Code     ENDS
         END       Start
