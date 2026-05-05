; Eggs
; (c) 1993-2024 Miroslav Nemecek

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
Start02: mov       dx,offset CardTxt
         mov       ah,9
         int       21h
         int       20h

; ------ £schova aktivn°ho videom¢du

Start04: mov       ah,0fh
         int       10h
         mov       ds:[OldVMod],al

; ------ inicializace gener†toru n†hody

         call      InitRnd                  ; inicializace gener†toru n†hody

; ------ inicializace videom¢du

         mov       ax,0dh
         int       10h

; ------ zobrazen° tituln°ho obr†zku

Start1:  mov       si,offset Titulek
         mov       cx,200*256+40
         xor       dx,dx
         call      DispObr                  ; zobrazen° titulku

; ------ áek†n° na stisk kl†vesy

         call      InitTime
Start102:call      GetTime
         cmp       ax,15*18
         mov       al,"D"
         jae       Start2
         mov       ah,1
         int       16h
         jz        Start102

         mov       ah,0
         int       16h
         or        ax,ax
         jz        Start11
         cmp       al,27
         jne       Start2
Start11: jmp       Konec

; ------ inicializace novÇ hry

Start2:  mov       byte ptr ds:[Dem],0
         cmp       al,"D"
         je        Start201
         cmp       al,"d"
         jne       Start20
Start201:inc       byte ptr ds:[Dem]

Start20: push      cs
         pop       es
         mov       di,offset Pole+11
         mov       al,0
         cld
         mov       bx,8
Start21: mov       cx,8
         rep       stosb
         inc       di
         inc       di
         dec       bx
         jnz       Start21

         mov       word ptr ds:[Pole+4*10+4],202h
         mov       word ptr ds:[Pole+5*10+4],202h
         mov       byte ptr ds:[Skore1],0
         mov       byte ptr ds:[Skore2],0

         mov       byte ptr ds:[Hrac],0
         cmp       byte ptr ds:[Dem],0
         jne       Start212
         mov       al,ds:[Hry]
         and       al,1
         mov       ds:[Hrac],al
         inc       byte ptr ds:[Hry]
Start212:mov       byte ptr ds:[Kurzor],3*8+3

; ------ zobrazen° novÇ hry

         mov       ah,0
         mov       dx,(3*8*8+1)*256
         mov       cx,7*256+40
         call      DispBox                  ; vymaz†n° volnÇho m°sta dole

         call      DispPole                 ; zobrazen° hrac°ho pole
         call      DispInf                  ; zobrazen° informaán°ho okna

; ------ p©°prava k jednomu tahu

Start3:  mov       bx,word ptr ds:[Hrac]
         mov       si,offset HelpTxt3
         cmp       byte ptr ds:[Dem],0
         jne       Start31

         cmp       byte ptr ds:[bx+Automat1],0
         je        Start32

         mov       si,offset HelpTxt2
Start31: call      DispHelp

         mov       dh,bl
         shl       dh,1
         dec       dh                       ; smàr p©°rustku kamenñ
         call      SrcTah                   ; nalezen° optim†ln°ho tahu

         cmp       dl,-1
         je        Start32                  ; nen° tah
         mov       ds:[Kurzor],dl           ; nov† pozice kurzoru
         jmp       short Start38

Start32:
         call      InitMozn                 ; inicializace moënòch tahñ
         jnc       Start33

         call      Vitez

Start322:mov       ah,1
         int       16h
         jz        Start323
         mov       ah,0
         int       16h
         jmp       short Start322

Start323:cmp       byte ptr ds:[Dem],0
         je        Start325
         call      InitTime

Start324:call      GetTime
         cmp       ax,10*18
         jae       Start34
         mov       ah,1
         int       16h
         jz        Start324

Start325:mov       ah,0
         int       16h
         cmp       byte ptr ds:[Dem],0
         jne       Start34
         or        ax,ax
         jz        Start34
         cmp       al,27
         je        Start34
         jmp       Start20


Start33: call      VolTah                   ; volba tahu hr†áem
         jnc       Start36
Start34: jmp       Start1                   ; p©eru®en° hry

Start36: call      ClrMozn                  ; vymaz†n° moënòch tahñ

Start38:
         mov       al,1
         mov       cx,3
Start381:call      KurzOn
         call      Cekej
         call      KurzOff
         call      Cekej
         loop      Start381

Strt3802:mov       bx,word ptr ds:[Hrac]
         cmp       byte ptr ds:[bx+Automat1],0
         je        Strt3803
         cmp       byte ptr ds:[Dem],0
         jne       Strt3803

         mov       ah,1
         int       16h
         jz        Strt3803

         mov       ah,0
         int       16h

         cmp       al,"A"
         je        Strt3804
         cmp       al,"a"
         jne       Strt3805

Strt3804:mov       byte ptr ds:[bx+Automat1],0
         call      DispStav
         jmp       Start32

Strt3805:or        ax,ax
         jz        Start34
         cmp       al,27
         je        Start34

         cmp       al,"S"
         je        Strt3806
         cmp       al,"s"
         jne       Strt3807

Strt3806:xor       byte ptr ds:[Sound],3

Strt3807:


Strt3803:call      ExecTah                  ; proveden° zvolenÇho tahu

         xor       byte ptr ds:[Hrac],1     ; zmàna aktivn°ho hr†áe

         mov       ah,1
         int       16h
         jz        Start39
         mov       ah,0
         int       16h

         cmp       al,"S"
         je        Strt3811
         cmp       al,"s"
         jne       Strt3812

Strt3811:xor       byte ptr ds:[Sound],3
         jmp       short Start39

Strt3812:cmp       byte ptr ds:[Dem],0
         je        Strt3815

Start349:jmp       Start1

Strt3815:
         or        ax,ax
         jz        Start349
         cmp       al,27
         je        STart349
         cmp       al,"A"
         je        Start382
         cmp       al,"a"
         jne       Start39

Start382:mov       bx,word ptr ds:[Hrac]
         xor       byte ptr ds:[bx+Automat1],1

Start39:

; ------ spoáten° sk¢re hr†áñ

         mov       byte ptr ds:[Skore1],0
         mov       byte ptr ds:[Skore2],0
         mov       cx,10*10
         mov       si,offset Pole
         cld
Start51: lodsb
         cmp       al,1
         jne       Start52
         inc       byte ptr ds:[Skore1]
Start52: cmp       al,3
         jne       Start53
         inc       byte ptr ds:[Skore2]
Start53: loop      Start51
         call      DispSkor

         call      DispStav

         jmp       Start3                   ; dal®° hr†á

Konec:
         mov       al,ds:[OldVMod]
         mov       ah,0
         int       10h

         int       20h

; -----------------------------------------------------------------------------
;        zobrazen° v°tàze
; -----------------------------------------------------------------------------

Vitez    PROC      NEAR

         mov       al,ds:[Skore1]
         cmp       al,ds:[Skore2]
         mov       di,offset HelpTxt5
         je        Vitez5

         mov       di,offset HelpTxt4

         mov       byte ptr ds:[HelpTxt4+14+1+10],"2"
         jb        Vitez1                   ; vyhr†ly slepice

         mov       byte ptr ds:[HelpTxt4+14+1+10],"1"

         mov       bl,1                     ; vejce
         mov       bh,5                     ; vejce v°tàz
         cmp       byte ptr ds:[Dem],0
         jne       Vitez2
         inc       byte ptr ds:[Vyhry1]
         jmp       short Vitez2

Vitez1:  mov       bl,3                     ; slepice
         mov       bh,6                     ; slepice v°tàz
         cmp       byte ptr ds:[Dem],0
         jne       Vitez2
         inc       byte ptr ds:[Vyhry2]

Vitez2:  push      bx
         call      DispVyh
         call      VitH
         pop       bx
         mov       dl,0                     ; ukazatel kamenñ
         mov       si,offset Pole+11

Vitez3:  cld
         lodsb
         cmp       al,-1
         je        Vitez3

         cmp       al,bl
         jne       Vitez4

         mov       byte ptr ds:[si-1],bh
         mov       al,bh
         call      DispKam

         mov       al,1
         call      Cekej
         mov       al,4
         call      BeepOn
         mov       al,1
         call      Cekej
         call      BeepOff

Vitez4:  inc       dx
         cmp       dl,8*8
         jb        Vitez3

; ------ zobrazen° hl†®en°

Vitez5:


Vitez9:
         ret

Vitez    ENDP



VitH     PROC      NEAR

         push      ax
         push      bx
         push      cx
         push      dx
         push      si


         mov       dx,(2*64+4)*256+3*8+1
         mov       cx,(64-4-2)*256+14
         mov       ah,9
         call      DispBox

         mov       si,di
         mov       dx,(2*64+8)*256+3*8+1
         mov       ah,12
         call      DispText

         mov       dx,(2*64+8+10)*256+3*8+1
         mov       cx,14
Vitez52: cld
         mov       ah,12
         lodsb
         cmp       al,"1"
         je        Vitez53
         cmp       al,"2"
         jne       Vitez54
Vitez53: mov       ah,14
Vitez54: call      DispChr
         loop      Vitez52

         mov       dx,(2*64+8+30)*256+3*8+1
         mov       si,offset HelpTxt6
         mov       cl,4
Vitez55: cld
         lodsb
         mov       ah,14
         call      DispChr
         loop      Vitez55

         mov       cl,10
Vitez56: cld
         lodsb
         mov       ah,10
         call      DispChr
         loop      Vitez56

         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

VitH     ENDP

; -----------------------------------------------------------------------------
;        proveden° tahu hr†áe
; -----------------------------------------------------------------------------

ExecTah  PROC      NEAR

; ------ p©°prava registrñ

         mov       dl,ds:[Kurzor]           ; kurzor
         call      GetAdrK                  ; poskytnut° adresy kamene
         mov       al,2
         mov       ds:[si],al               ; uloëen° ku©ete
         call      DispKam                  ; zobrazen° novÇho kamene
         inc       si                       ; p©ednastaven° adresy

         mov       bl,ds:[Hrac]             ; aktivn° hr†á
         shl       bl,1
         dec       bl                       ; zmàna kamene 1 nebo -1

; ------ proveden° tahu v jednotlivòch smàrech

         mov       dx,-11-1
         mov       bh,-9
         call      Exec0Tah
         inc       dx
         inc       bh
         call      Exec0Tah
         inc       dx
         inc       bh
         call      Exec0Tah
         mov       dl,-2
         mov       bh,-1
         call      Exec0Tah
         xor       dx,dx
         mov       bh,1
         call      Exec0Tah
         mov       dl,9-1
         mov       bh,7
         call      Exec0Tah
         inc       dx
         inc       bh
         call      Exec0Tah
         inc       dx
         inc       bh
         call      Exec0Tah
         ret

ExecTah  ENDP

; -----------------------------------------------------------------------------
;        proveden° tahu aktivn°ho hr†áe v jednom smàru
; -----------------------------------------------------------------------------
; VSTUP: DS:SI=vòchoz° adresa kamene + 1
;        DX=smàr - 1
;        BL=zmàna kamene (1 nebo -1)
;        BH=p©°rustek á°sla kamene
; -----------------------------------------------------------------------------
; zniáenÇ registry: AX, CX, DI
; -----------------------------------------------------------------------------

Exec0Tah PROC      NEAR

; ------ stanoven° poátu zmàn v danÇm smàru

         cld
         mov       ch,0
         call      Test0Tah                 ; test tahu v danÇm smàru
         jcxz      Exec0Th9                 ; nen° ë†dn† zmàna

; ------ proveden° tahu v danÇm smàru

         push      dx
         push      si

         mov       di,dx                    ; p©°rustek adresy
         mov       dl,ds:[Kurzor]           ; aktivn° pozice hr†áe

Exec0Th2:add       si,di                    ; posun adresy kamene
         add       dl,bh                    ; zvò®en° á°sla kamene
         cld
         lodsb                              ; naáten° kamene z pozice
         add       al,bl                    ; zmàna kamene
         jnz       Exec0Th3
         mov       al,3
Exec0Th3:cmp       al,3
         jbe       Exec0Th4
         mov       al,1
Exec0Th4:mov       ds:[si-1],al

         call      DispKam                  ; zobrazen° novÇho kamene

         mov       al,1
         call      Cekej
         mov       al,2
         call      BeepOn
         mov       al,1
         call      Cekej
         call      BeepOff

         loop      Exec0Th2

         pop       si
         pop       dx

Exec0Th9:ret

Exec0Tah ENDP

; -----------------------------------------------------------------------------
;        volba tahu hr†áem (CY=p©eru®en° hry, jinak DL=zvolenò tah)
; -----------------------------------------------------------------------------

VolTah   PROC      NEAR

; ------ zobrazen° n†povàdy

VolTah0:
         mov       si,offset HelpTxt1
         call      DispHelp                 ; zobrazen° n†povàdy

; ------ zapnut° kurzoru

VolTah1: call      KurzOn                   ; zapnut° kurzoru

; ------ áek†n° na stisk kl†vesy

VolTah2: mov       ah,0
         int       16h                      ; áek†n° na stisk kl†vesy
         mov       dl,ds:[Kurzor]           ; pozice kurzoru hr†áe

; ------ n†povàda

         cmp       al,"h"
         je        VolTah21
         cmp       al,"H"
         jne       VolTah22
VolTah21:
         call      KurzOff
         call      ClrMozn                  ; vymaz†n° moënòch tahñ

         mov       bx,word ptr ds:[Hrac]
         mov       byte ptr ds:[bx+Automat1],1
         call      DispStav

         mov       dh,ds:[Hrac]
         shl       dh,1
         dec       dh                       ; smàr p©°rustku kamenñ
         call      SrcTah                   ; nalezen° optim†ln°ho tahu

         push      dx
         call      InitMozn                 ; inicializace moënòch tahñ

         mov       bx,word ptr ds:[Hrac]
         mov       byte ptr ds:[bx+Automat1],0
         call      DispStav

         pop       dx

         mov       ds:[Kurzor],dl           ; nov† pozice kurzoru
         jmp       short VolTah1

VolTah22:cmp       al,"S"
         je        VolTah23
         cmp       al,"s"
         jne       VolTah24

VolTah23:xor       byte ptr ds:[Sound],3
         jmp       short VolTah0

; ------ test, zda je volba automatu

VolTah24:cmp       al,"A"
         je        VolTah25
         cmp       al,"a"
         jne       VolTah26

VolTah25:mov       bx,word ptr ds:[Hrac]
         mov       byte ptr ds:[bx+Automat1],1
         call      DispStav
         mov       si,offset HelpTxt2
         call      DispHelp                 ; zobrazen° n†povàdy

         call      KurzOff
         call      ClrMozn                  ; vymaz†n° moënòch tahñ

         mov       dh,ds:[Hrac]
         shl       dh,1
         dec       dh                       ; smàr p©°rustku kamenñ
         call      SrcTah                   ; nalezen° optim†ln°ho tahu
         mov       ds:[Kurzor],dl           ; nov† pozice kurzoru
         clc
         ret

; ------ test, zda je p©eru®en° hry

VolTah26:or        ax,ax
         je        VolTah27
         cmp       al,27
         jne       VolTah28
VolTah27:stc                                ; p©°znak p©eru®en° hry
         ret

VolTah28:

; ------ posun kurzoru vlevo

VolTah3: cmp       ah,4bh
         jne       VolTah4
         test      dl,7
         jz        VolTah32
         dec       dx
         jmp       short VolTah8
VolTah32:add       dl,7
         jmp       short VolTah8

; ------ posun kurzoru vpravo

VolTah4: cmp       ah,4dh
         jne       VolTah5
         inc       dx
         test      dl,7
         jnz       VolTah8
         sub       dl,8
         jmp       short VolTah8

; ------ posun kurzoru nahoru

VolTah5: cmp       ah,48h
         jne       VolTah6
         test      dl,111000b
         jz        VolTah52
         sub       dl,1000b
         jmp       short VolTah8
VolTah52:add       dl,111000b
         jmp       short VolTah8

; ------ posun kurzoru dolñ

VolTah6: cmp       ah,50h
         jne       VolTah7
         add       dl,1000b
         test      dl,111000b
         jnz       VolTah8
         sub       dl,1000000b
         jmp       short VolTah8

; ------ prvn° pozice ©†dku HOME

VolTah7: cmp       ah,47h
         jne       VolTah72
         and       dl,111000b
         jmp       short VolTah8

; ------ posledn° pozice ©†dku END

VolTah72:cmp       ah,4fh
         jne       VolTah74
         or        dl,111b
         jmp       short VolTah8

; ------ horn° ©†dek Page Up

VolTah74:cmp       ah,49h
         jne       VolTah76
         and       dl,111b
         jmp       short VolTah8

; ------ spodn° ©†dek Page Down

VolTah76:cmp       ah,51h
         jne       VolTah78
         or        dl,111000b

; ------ zmàna pozice kurzoru

VolTah8: call      KurzOff                  ; vypnut° kurzoru
         mov       ds:[Kurzor],dl           ; nov† pozice kurzoru
         jmp       VolTah1                  ; novÇ zobrazen° kurzoru

; ------ proveden° volby ENTER, mezera

VolTah78:cmp       al,13
         je        VolTah79                 ; Enter
         cmp       ah,4ch
         je        VolTah79                 ; [5]
         cmp       al," "
         je        VolTah79                 ; mezera
VolTah7A:jmp       VolTah2

; ------ test, zda je platn† pozice

VolTah79:call      GetAdrK                  ; poskytnut° adresy
         cmp       byte ptr ds:[si],4       ; je platn† pozice ?
         jne       VolTah7A                 ; nen° platn† pozice, jinak konec OK

; ------ vypnut° kurzoru

VolTah9: pushf
         call      KurzOff
         popf
         ret

VolTah   ENDP

; -----------------------------------------------------------------------------
;        vòpoáet adresy kamene DL v poli -> SI
; -----------------------------------------------------------------------------

GetAdrK  PROC      NEAR

         push      ax
         mov       si,offset Pole + 11
         mov       al,dl
         shr       al,1
         shr       al,1
         shr       al,1                     ; ©†dek kamene
         mov       ah,10
         mul       ah                       ; offset ©†dku kamene
         add       si,ax                    ; adresa ©†dku kamene
         mov       al,dl
         and       al,7                     ; pozice
         add       si,ax                    ; adresa kamene
         pop       ax
         ret

GetAdrK  ENDP

; -----------------------------------------------------------------------------
;        zapnut° kurzoru hr†áe
; -----------------------------------------------------------------------------

KurzOn   PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx

; ------ pozice kurzoru

         mov       dl,ds:[Kurzor]           ; kurzor

; ------ vòpoáet pozice kurzoru

         mov       dh,dl                    ; á°slo kamene
         and       dx,111000b*256+000111b   ; maskov†n° ©†dku a pozice
         mov       al,dh
         shl       al,1
         add       dh,al                    ; linka
         mov       al,dl
         shl       al,1
         add       dl,al                    ; pozice

; ------ zobrazen° kurzoru

         mov       cx,(3*8+1)*256+3
         mov       ax,12*256+80h
         call      DispHLin
         call      DispVLin
         add       dl,3
         call      DispVLin
         sub       dl,3
         add       dh,3*8
         call      DispHLin

; ------ n†vrat registrñ

         pop       dx
         pop       cx
         pop       ax
         ret

KurzOn   ENDP

; -----------------------------------------------------------------------------
;        vypnut° kurzoru hr†áe
; -----------------------------------------------------------------------------

KurzOff  PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx

; ------ pozice kurzoru

         mov       dl,ds:[Kurzor]           ; kurzor

; ------ vòpoáet pozice kurzoru

         mov       dh,dl                    ; á°slo kamene
         and       dx,111000b*256+000111b   ; maskov†n° ©†dku a pozice
         mov       al,dh
         shl       al,1
         add       dh,al                    ; linka
         mov       al,dl
         shl       al,1
         add       dl,al                    ; pozice

; ------ vypnut° kurzoru

         mov       cx,(3*8+1)*256+3
         mov       ax,15*256+80h
         call      DispHLin
         call      DispVLin
         add       dl,3
         call      DispVLin
         sub       dl,3
         add       dh,3*8
         call      DispHLin

; ------ n†vrat registrñ

         pop       dx
         pop       cx
         pop       ax
         ret

KurzOff  ENDP

; -----------------------------------------------------------------------------
;        zobrazen° hrac° plochy
; -----------------------------------------------------------------------------

DispPole PROC      NEAR

; ------ podkladovò obdÇln°k hrac° plochy

         xor       dx,dx
         mov       cx,(3*8*8)*256 + 3*8
         mov       ah,2
         call      DispBox

; ------ zobrazen° horizont†ln°ch linek

         mov       ah,15                    ; barva linek
         mov       cx,9*256 + 3*8
DispPol1:call      DispHLin
         add       dh,3*8
         dec       ch
         jnz       DispPol1

; ------ zobrazen° vertik†ln°ch linek

         xor       dx,dx
         mov       cx,(3*8*8)*256 + 8
         mov       al,80h                   ; maska
DispPol2:call      DispVLin
         add       dl,3
         dec       cl
         jnz       DispPol2

; ------ zobrazen° obsahu pole

         mov       si,offset Pole+11
         mov       dl,0
DispPol3:cld
         lodsb
         cmp       al,-1
         je        DispPol3
         cmp       al,0
         je        DispPol4
         call      DispKam
DispPol4:inc       dx
         cmp       dl,8*8
         jne       DispPol3
         ret

DispPole ENDP

; -----------------------------------------------------------------------------
;        zobrazen° jednoho kamene pole (DL=á°slo kamene, AL=k†men)
; -----------------------------------------------------------------------------

DispKam  PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx
         push      si

; ------ vòpoáet adresy obr†zku

         push      dx
         mov       ah,0
         mov       cx,(24*24/8)*4
         mul       cx
         add       ax,offset Volne          ; adresa obr†zku
         xchg      ax,si
         pop       dx

; ------ vòpoáet pozice kamene

         mov       dh,dl                    ; á°slo kamene
         and       dx,111000b*256+000111b   ; maskov†n° ©†dku a pozice
         mov       al,dh
         shl       al,1
         add       dh,al                    ; linka
         mov       al,dl
         shl       al,1
         add       dl,al                    ; pozice

; ------ zobrazen° kamene

         mov       cx,3*8*256+3
         call      DispObr                  ; zobrazen° obr†zku

; ------ n†vrat registrñ

         pop       si
         pop       dx
         pop       cx
         pop       ax
         ret

DispKam  ENDP

; -----------------------------------------------------------------------------
;        nalezen° optim†ln°ho tahu -> DL
; -----------------------------------------------------------------------------
; VSTUP: DH=smàr p©°rustku kamenñ (-1 nebo 1)
; VùSTUP:DL=nalezenò tah (-1 tah nenalezen)
; -----------------------------------------------------------------------------
; zniáenÇ registry: AX, CX, DI
; -----------------------------------------------------------------------------
;˛
SrcTah   PROC      NEAR

; ------ £schova registrñ

         push      cx
         push      si

         mov       di,offset BuffTah        ; buffer tahñ

; ------ p©°prava registrñ

         mov       al,-127
         imul      dh
         mov       ah,al                    ; bodov†n° nejlep®°ho tahu
         mov       dl,-1                    ; nalezenò nejlep®° tah
         mov       al,-1                    ; ukazatel tahñ
         mov       si,offset Pole+11        ; pole
         cld

; ------ nalezen° volnÇho pole (moënò tah)

SrcTah1: inc       si
         cmp       byte ptr ds:[si-1],-1
         je        SrcTah1
         inc       al
         cmp       byte ptr ds:[si-1],0
         je        SrcTah12
SrcTah11:cmp       al,8*8
         jb        SrcTah1
         jmp       SrcTah9

; ------ proveden° tahu ve v®ech smàrech

SrcTah12:push      ax
         push      dx
         push      di

         xor       cx,cx                    ; CH=st©adaá krokñ, CL=bodov†n°

         mov       bx,-11-1                 ; p©°rustek adresy
         call      Src0Tah                  ; proveden° tahu v jednom smàru
         inc       bx
         call      Src0Tah
         inc       bx
         call      Src0Tah

         mov       bl,-1-1
         call      Src0Tah
         inc       bx
         inc       bx
         call      Src0Tah

         mov       bl,9-1
         call      Src0Tah
         inc       bx
         call      Src0Tah
         inc       bx
         call      Src0Tah

         pop       di
         pop       dx
         pop       ax

; ------ test, zda je tah povolen

         or        ch,ch                    ; je tah povolen ?
         jz        SrcTah1                  ; tah nen° povolen - dal®° tah

; ------ vno©en° do vàt®° hloubky

         mov       byte ptr ds:[si-1],2     ; uloëen° ku©ete
         add       di,8                     ; zvò®en° ukazatele v bufferu tahñ

         push      dx
         push      ax

         neg       dh                       ; zmàna barvy
         call      Sr2Tah                   ; nalezen° dal®°ho tahu
         cmp       dl,-1
         je        SrcTah32                 ; nen° dal®° tah
         add       cl,ah                    ; novÇ bodov†n°

SrcTah32:pop       ax
         pop       dx

         sub       di,8                     ; n†vrat ukazatele v bufferu tahñ
         mov       byte ptr ds:[si-1],0     ; zru®en° ku©ete

; ------ test, zda byl nalezen lep®° tah

SrcTah4: cmp       dh,1                     ; je kladnò smàr zmàn ?
         jne       SrcTah42                 ; nen° kladnò smàr zmàn

         cmp       cl,ah                    ; je vy®®° ohodnocen° ?
         jl        SrcTah5                  ; nen° vy®®° ohodnocen°
         jg        SrcTah49                 ; je vy®®° ohodnocen°
         jmp       short SrcTah48           ; n†hoda

SrcTah42:cmp       cl,ah                    ; je nië®° bodov†n° ?
         jg        SrcTah5                  ; nen° nië®° bodov†n°
         jl        SrcTah49                 ; je vy®®° bodov†n°

SrcTah48:push      ax
         mov       ax,4
         call      Random
         or        ax,ax
         pop       ax
         jnz       SrcTah5

SrcTah49:mov       ah,cl                    ; novÇ bodov†n°
         mov       dl,al                    ; nalezenò nejlep®° tah

; ------ n†vrat tahu z bufferu

SrcTah5: push      ax
         push      di

         cld
         mov       ch,0

         mov       bx,-11-1                 ; p©°rustek adresy
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah51
         call      Ret0Tah                  ; n†vrat tahu v jednom smàru

SrcTah51:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah52
         call      Ret0Tah

SrcTah52:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah53
         call      Ret0Tah

SrcTah53:mov       bl,-1-1
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah54
         call      Ret0Tah

SrcTah54:inc       bx
         inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah55
         call      Ret0Tah

SrcTah55:mov       bl,9-1
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah56
         call      Ret0Tah

SrcTah56:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah57
         call      Ret0Tah

SrcTah57:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      SrcTah58
         call      Ret0Tah

SrcTah58:pop       di
         pop       ax

         jmp       SrcTah11                 ; dal®° tah

; ------ n†vrat registrñ

SrcTah9: pop       si
         pop       cx
         ret

SrcTah   ENDP

; -----------------------------------------------------------------------------
;        nalezen° optim†ln°ho tahu -> DL
; -----------------------------------------------------------------------------
; VSTUP: DH=smàr p©°rustku kamenñ (-1 nebo 1)
;        DI=ukazatel v bufferu tahñ
;        BP=á°taá hloubky vno©en° testu (1=posledn° tah)
; VùSTUP:DL=nalezenò tah (-1 tah nenalezen)
;        AH=bodov†n° nalezenÇho tahu (-vejce nebo +slepice)
; -----------------------------------------------------------------------------
; zniáenÇ registry: AL, CX
; -----------------------------------------------------------------------------

Sr2Tah   PROC      NEAR

; ------ £schova registrñ

         push      cx
         push      si

; ------ p©°prava registrñ

         mov       al,-127
         imul      dh
         mov       ah,al                    ; bodov†n° nejlep®°ho tahu
         mov       dl,-1                    ; nalezenò nejlep®° tah
         mov       al,-1                    ; ukazatel tahñ
         mov       si,offset Pole+11        ; pole
         cld

; ------ nalezen° volnÇho pole (moënò tah)

Sr2Tah1: inc       si
         cmp       byte ptr ds:[si-1],-1
         je        Sr2Tah1
         inc       al
         cmp       byte ptr ds:[si-1],0
         je        Sr2Tah12
Sr2Tah11:cmp       al,8*8
         jb        Sr2Tah1
         jmp       Sr2Tah9

; ------ proveden° tahu ve v®ech smàrech

Sr2Tah12:push      ax
         push      dx
         push      di

         xor       cx,cx                    ; CH=st©adaá krokñ, CL=bodov†n°

         mov       bx,-11-1                 ; p©°rustek adresy
         call      Src0Tah                  ; proveden° tahu v jednom smàru
         inc       bx
         call      Src0Tah
         inc       bx
         call      Src0Tah

         mov       bl,-1-1
         call      Src0Tah
         inc       bx
         inc       bx
         call      Src0Tah

         mov       bl,9-1
         call      Src0Tah
         inc       bx
         call      Src0Tah
         inc       bx
         call      Src0Tah

         pop       di
         pop       dx
         pop       ax

; ------ test, zda je tah povolen

         or        ch,ch                    ; je tah povolen ?
         jz        Sr2Tah1                  ; tah nen° povolen - dal®° tah

; ------ vno©en° do vàt®° hloubky

         mov       byte ptr ds:[si-1],2     ; uloëen° ku©ete
         add       di,8                     ; zvò®en° ukazatele v bufferu tahñ

         push      dx
         push      ax

         neg       dh                       ; zmàna barvy
         call      Sr4Tah                   ; nalezen° dal®°ho tahu
         cmp       dl,-1
         je        Sr2Tah32                 ; nen° dal®° tah
         add       cl,ah                    ; novÇ bodov†n°

Sr2Tah32:pop       ax
         pop       dx

         sub       di,8                     ; n†vrat ukazatele v bufferu tahñ
         mov       byte ptr ds:[si-1],0     ; zru®en° ku©ete

; ------ test, zda byl nalezen lep®° tah

Sr2Tah4:
         cmp       dh,1                     ; je kladnò smàr zmàn ?
         jne       Sr2Tah42                 ; nen° kladnò smàr zmàn

         cmp       cl,ah                    ; je vy®®° ohodnocen° ?
         jl        Sr2Tah5                  ; nen° vy®®° ohodnocen°
         jg        Sr2Tah49                 ; je vy®®° ohodnocen°
         jmp       short Sr2Tah48           ; n†hoda

Sr2Tah42:cmp       cl,ah                    ; je nië®° bodov†n° ?
         jg        Sr2Tah5                  ; nen° nië®° bodov†n°
         jl        Sr2Tah49                 ; je vy®®° bodov†n°

Sr2Tah48:push      ax
         mov       ax,4
         call      Random
         or        ax,ax
         pop       ax
         jnz       Sr2Tah5

Sr2Tah49:mov       ah,cl                    ; novÇ bodov†n°
         mov       dl,al                    ; nalezenò nejlep®° tah

; ------ n†vrat tahu z bufferu

Sr2Tah5: push      ax
         push      di

         cld
         mov       ch,0

         mov       bx,-11-1                 ; p©°rustek adresy
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah51
         call      Ret0Tah                  ; n†vrat tahu v jednom smàru

Sr2Tah51:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah52
         call      Ret0Tah

Sr2Tah52:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah53
         call      Ret0Tah

Sr2Tah53:mov       bl,-1-1
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah54
         call      Ret0Tah

Sr2Tah54:inc       bx
         inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah55
         call      Ret0Tah

Sr2Tah55:mov       bl,9-1
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah56
         call      Ret0Tah

Sr2Tah56:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah57
         call      Ret0Tah

Sr2Tah57:inc       bx
         mov       cl,ds:[di]
         inc       di
         jcxz      Sr2Tah58
         call      Ret0Tah

Sr2Tah58:pop       di
         pop       ax

         jmp       Sr2Tah11                 ; dal®° tah

; ------ n†vrat registrñ

Sr2Tah9: pop       si
         pop       cx
         ret

Sr2Tah   ENDP

; -----------------------------------------------------------------------------
;        nalezen° optim†ln°ho tahu -> DL
; -----------------------------------------------------------------------------
; VSTUP: DH=smàr p©°rustku kamenñ (-1 nebo 1)
;        DI=ukazatel v bufferu tahñ
;        BP=á°taá hloubky vno©en° testu (1=posledn° tah)
; VùSTUP:DL=nalezenò tah (-1 tah nenalezen)
;        AH=bodov†n° nalezenÇho tahu (-vejce nebo +slepice)
; -----------------------------------------------------------------------------
; zniáenÇ registry: AL, CX
; -----------------------------------------------------------------------------

Sr4Tah   PROC      NEAR

; ------ £schova registrñ

         push      cx
         push      si

; ------ p©°prava registrñ

         mov       al,-127
         imul      dh
         mov       ah,al                    ; bodov†n° nejlep®°ho tahu
         mov       dl,-1                    ; nalezenò nejlep®° tah
         mov       al,-1                    ; ukazatel tahñ
         mov       si,offset Pole+11        ; pole
         cld

; ------ nalezen° volnÇho pole (moënò tah)

Sr4Tah1: inc       si
         cmp       byte ptr ds:[si-1],-1
         je        Sr4Tah1
         inc       al
         cmp       byte ptr ds:[si-1],0
         je        Sr4Tah12
Sr4Tah11:cmp       al,8*8
         jb        Sr4Tah1
         jmp       Sr4Tah9

; ------ proveden° tahu ve v®ech smàrech

Sr4Tah12:push      ax
         push      dx

         xor       cx,cx                    ; CH=st©adaá krokñ, CL=bodov†n°

         mov       bx,-11-1                 ; p©°rustek adresy
         call      Src1Tah                  ; proveden° tahu v jednom smàru
         inc       bx
         call      Src1Tah
         inc       bx
         call      Src1Tah

         mov       bl,-1-1
         call      Src1Tah
         inc       bx
         inc       bx
         call      Src1Tah

         mov       bl,9-1
         call      Src1Tah
         inc       bx
         call      Src1Tah
         inc       bx
         call      Src1Tah

         pop       dx
         pop       ax

; ------ test, zda je tah povolen

         or        ch,ch                    ; je tah povolen ?
         jz        Sr4Tah1                  ; tah nen° povolen - dal®° tah

; ------ test, zda byl nalezen lep®° tah

Sr4Tah4:
         cmp       dh,1                     ; je kladnò smàr zmàn ?
         jne       Sr4Tah42                 ; nen° kladnò smàr zmàn

         cmp       cl,ah                    ; je vy®®° ohodnocen° ?
         jl        Sr4Tah5                  ; nen° vy®®° ohodnocen°
         jg        Sr4Tah49                 ; je vy®®° ohodnocen°
         jmp       short Sr4Tah48           ; n†hoda

Sr4Tah42:cmp       cl,ah                    ; je nië®° bodov†n° ?
         jg        Sr4Tah5                  ; nen° nië®° bodov†n°
         jl        Sr4Tah49                 ; je vy®®° bodov†n°

Sr4Tah48:push      ax
         mov       ax,4
         call      Random
         or        ax,ax
         pop       ax
         jnz       Sr4Tah5

Sr4Tah49:mov       ah,cl                    ; novÇ bodov†n°
         mov       dl,al                    ; nalezenò nejlep®° tah

Sr4Tah5: jmp       Sr4Tah11                 ; dal®° tah

; ------ n†vrat registrñ

Sr4Tah9: pop       si
         pop       cx
         ret

Sr4Tah   ENDP

; -----------------------------------------------------------------------------
;                      proveden° tahu v jednom smàru
; -----------------------------------------------------------------------------
; VSTUP: DS:SI=vòchoz° adresa kamene + 1
;        BX=p©°rustek adresy - 1
;        DH=smàr p©°rustku kamenñ (-1 nebo 1)
;        DI=ukl†dac° adresa do bufferu pro £schovu tahñ
;        CH=st©adaá poátu provedenòch krokñ
;        CL=bodovÇ ohodnocen° (rozd°l sk¢re SLEPICE-VEJCE)
;        CLD smàr nahoru
; VùSTUP:CH=novò st©adaá provedenòch krokñ (0=nepovolenò tah)
;        CL=novÇ bodovÇ ohodnocen°
;        DI=nov† ukl†dac° adresa do bufferu pro £schovu tahñ (zvò®eno o 1)
; -----------------------------------------------------------------------------
; zniáenÇ registry: AX, DL
; -----------------------------------------------------------------------------

Src0Tah  PROC      NEAR

; ------ £schova registrñ

         push      si                       ; SI jako posledn°

; ------ nalezen° posledn°ho ku©ete

         mov       ah,-1                    ; á°taá krokñ
         mov       dl,0                     ; poáet platnòch krokñ
Src0Th2: add       si,bx                    ; posun adresy na dal®° pole
         inc       ah                       ; zvò®en° á°taáe krokñ
         lodsb                              ; k†men na pozici
         cmp       al,0                     ; je pr†zdnÇ pole nebo r†m ?
         jle       Src0Th4                  ; konec testu - nic nebo r†m
         cmp       al,2                     ; je ku©e ?
         jne       Src0Th2                  ; nen° ku©e - dal®° k†men
         mov       dl,ah                    ; £schova á°taáe krokñ
         jmp       short Src0Th2            ; £schova pozice ku©ete

; ------ poáet krokñ k proveden°

Src0Th4: mov       ds:[di],dl               ; poáet provedenòch krokñ
         inc       di                       ; zvò®en° adresy v bufferu
         or        dl,dl                    ; je nàjakò k†men ?
         je        Src0Th9                  ; nen° ë†dnò povolenò krok
         add       ch,dl                    ; zvò®en° á°taáe provedenòch krokñ

; ------ proveden° posunu

         pop       si
         push      si                       ; adresa kamene

Src0Th5: add       si,bx                    ; posun adresy na dal®° pole
         lodsb                              ; k†men na pozici
         add       al,dh                    ; posun kamene

         jnz       Src0Th6                  ; bylo vejce
         mov       al,3                     ; korekce na slepici
         add       cl,3+1

Src0Th6: cmp       al,3
         jbe       Src0Th7
         mov       al,1
         sub       cl,3+1

Src0Th7: add       cl,dh                    ; posun bodov†n° o 1

         mov       ds:[si-1],al             ; novò k†men
         dec       dl                       ; á°taá krokñ
         jnz       Src0Th5

; ------ n†vrat registrñ

Src0Th9: pop       si
         ret

Src0Tah  ENDP

; -----------------------------------------------------------------------------
;                      test tahu v jednom smàru
; -----------------------------------------------------------------------------
; VSTUP: DS:SI=vòchoz° adresa kamene + 1
;        BX=p©°rustek adresy - 1
;        DH=smàr p©°rustku kamenñ (-1 nebo 1)
;        CH=st©adaá poátu provedenòch krokñ
;        CL=bodovÇ ohodnocen° (rozd°l sk¢re SLEPICE-VEJCE)
;        CLD smàr nahoru
; VùSTUP:CH=novò st©adaá provedenòch krokñ (0=nepovolenò tah)
;        CL=novÇ bodovÇ ohodnocen°
; -----------------------------------------------------------------------------
; zniáenÇ registry: AX, DL
; -----------------------------------------------------------------------------

Src1Tah  PROC      NEAR

; ------ £schova registrñ

         push      si                       ; SI jako posledn°

; ------ nalezen° posledn°ho ku©ete

         mov       ah,-1                    ; á°taá krokñ
         mov       dl,0                     ; poáet platnòch krokñ
Src1Th2: add       si,bx                    ; posun adresy na dal®° pole
         inc       ah                       ; zvò®en° á°taáe krokñ
         lodsb                              ; k†men na pozici
         cmp       al,0                     ; je pr†zdnÇ pole nebo r†m ?
         jle       Src1Th4                  ; konec testu - nic nebo r†m
         cmp       al,2                     ; je ku©e ?
         jne       Src1Th2                  ; nen° ku©e - dal®° k†men
         mov       dl,ah                    ; £schova á°taáe krokñ
         jmp       short Src1Th2            ; £schova pozice ku©ete

; ------ poáet krokñ k proveden°

Src1Th4: or        dl,dl                    ; je nàjakò k†men ?
         je        Src1Th9                  ; nen° ë†dnò povolenò krok
         add       ch,dl                    ; zvò®en° á°taáe provedenòch krokñ

; ------ test posunu

         pop       si
         push      si                       ; adresa kamene

Src1Th5: add       si,bx                    ; posun adresy na dal®° pole
         lodsb                              ; k†men na pozici
         add       al,dh                    ; posun kamene

         jnz       Src1Th6                  ; bylo vejce
         add       cl,3+1

Src1Th6: cmp       al,3
         jbe       Src1Th7
         sub       cl,3+1

Src1Th7: add       cl,dh                    ; posun bodov†n° o 1

         dec       dl                       ; á°taá krokñ
         jnz       Src1Th5

; ------ n†vrat registrñ

Src1Th9: pop       si
         ret

Src1Tah  ENDP

; -----------------------------------------------------------------------------
;                      n†vrat tahu v jednom smàru
; -----------------------------------------------------------------------------
; VSTUP: DS:SI=vòchoz° adresa kamene + 1
;        BX=p©°rustek adresy - 1
;        DH=smàr p©°rustku kamenñ (-1 nebo 1)
;        CX=poáet krokñ (nesm° bòt = 0)
;        CLD smàr nahoru
; -----------------------------------------------------------------------------
; ZniáenÇ registry: CL, AL
; -----------------------------------------------------------------------------

Ret0Tah  PROC      NEAR

; ------ £schova registrñ

         push      si                       ; SI jako posledn°

; ------ n†vrat tahu

Ret0Th5: add       si,bx                    ; posun adresy na dal®° pole
         lodsb                              ; k†men na pozici
         sub       al,dh                    ; posun kamene
         jnz       Ret0Th6                  ; nebylo vejce
         mov       al,3                     ; korekce na slepici
Ret0Th6: cmp       al,3
         jbe       Ret0Th8
         mov       al,1
Ret0Th8: mov       ds:[si-1],al             ; novò k†men
         loop      Ret0Th5                  ; dal®° krok

; ------ n†vrat registrñ

Ret0Th9: pop       si
         ret

Ret0Tah ENDP

; -----------------------------------------------------------------------------
;        vymaz†n° moënòch tahñ
; -----------------------------------------------------------------------------

ClrMozn  PROC      NEAR

; ------ p©°prava registrñ

         mov       si,offset Pole           ; hrac° pole
         xor       dx,dx                    ; DL=ukazatel kamene

; ------ nalezen° moënÇho tahu

ClrMozn1:cld
         lodsb
         cmp       al,-1
         je        ClrMozn1
         cmp       al,4
         jne       ClrMozn8

; ------ je moënò tah - vymaz†n° pozice

         mov       al,0                     ; pr†zdnÇ pole
         mov       ds:[si-1],al
         call      DispKam                  ; zobrazen° kamene

; ------ p©°prava pro dal®° pole

ClrMozn8:inc       dx
         cmp       dl,8*8
         jne       ClrMozn1
         ret

ClrMozn  ENDP

; -----------------------------------------------------------------------------
;        zobrazen° moënòch tahñ (CY=nen° ë†dnò dal®° moënò tah)
; -----------------------------------------------------------------------------

InitMozn PROC      NEAR

; ------ p©°prava registrñ

         mov       si,offset Pole           ; hrac° pole
         xor       dx,dx                    ; DL=ukazatel kamene, DH=á°taá tahñ

; ------ nalezen° volnÇho pole

InitMoz1:cld
         lodsb
         cmp       al,-1
         je        InitMoz1
         cmp       al,0
         jne       InitMoz8

; ------ test jednotlivòch smàrñ

         push      dx
         mov       ch,0                     ; st©adaá souátñ zmàn

         mov       dx,-10-1-1
         call      Test0Tah
         add       ch,cl

         inc       dx
         call      Test0Tah
         add       ch,cl

         inc       dx
         call      Test0Tah
         add       ch,cl

         mov       dl,-1-1
         call      Test0Tah
         add       ch,cl

         xor       dx,dx
         call      Test0Tah
         add       ch,cl

         mov       dl,10-1-1
         call      Test0Tah
         add       ch,cl

         inc       dx
         call      Test0Tah
         add       ch,cl

         inc       dx
         call      Test0Tah
         add       ch,cl

         pop       dx
         jz        InitMoz8                 ; nic nen°

; ------ je moënò tah - zobrazen° pozice

         inc       dh                       ; á°taá tahñ
         mov       al,4                     ; moënÇ pole
         mov       ds:[si-1],al
         call      DispKam                  ; zobrazen° kamene

; ------ p©°prava pro dal®° pole

InitMoz8:inc       dx
         cmp       dl,8*8
         jne       InitMoz1

         or        dh,dh                    ; je nàjakò tah ?
         jnz       InitMoz9                 ; je nàjakò tah
         stc                                ; p©°znak - nen° dal®° tah
InitMoz9:ret

InitMozn ENDP

; -----------------------------------------------------------------------------
;                      test tahu v jednom smàru
; -----------------------------------------------------------------------------
; VSTUP: DS:SI=vòchoz° adresa kamene + 1
;        DX=smàr - 1
;        CLD smàr nahoru
; VùSTUP:CL=poáet platnòch zmàn
; -----------------------------------------------------------------------------
; zniáenÇ registry: AX
; -----------------------------------------------------------------------------

Test0Tah PROC      NEAR

; ------ £schova registrñ

         push      si

; ------ nalezen° posledn°ho ku©ete

         mov       ah,-1                    ; á°taá krokñ
         mov       cl,0                     ; poáet platnòch krokñ
Test0Th2:add       si,dx                    ; posun adresy na dal®° pole
         inc       ah                       ; zvò®en° á°taáe krokñ
         lodsb                              ; k†men na pozici
         cmp       al,0                     ; je pr†zdnÇ pole nebo r†m ?
         jle       Test0Th4                 ; konec testu - nic nebo r†m
         cmp       al,4
         je        Test0Th4                 ; moënò tah
         cmp       al,2                     ; je ku©e ?
         jne       Test0Th2                 ; nen° ku©e - dal®° k†men
         mov       cl,ah                    ; £schova á°taáe krokñ
         jmp       short Test0Th2           ; £schova pozice ku©ete

; ------ n†vrat registrñ

Test0Th4:pop       si
         ret

Test0Tah ENDP

; -----------------------------------------------------------------------------
;        zobrazen° n†povàdy SI
; -----------------------------------------------------------------------------
;˛
DispHelp PROC      NEAR

         push      ax
         push      bx
         push      cx
         push      dx

         push      si
         mov       si,offset HelpTxtH
         mov       dx,(2*64+6)*256+3*8+1
         mov       ah,12
         call      DispText
         mov       al,ds:[Hrac]
         inc       ax
         mov       ah,14+9*16
         mov       cl,2
         call      DispNum
         mov       al," "
         call      DispChr
         pop       si

         mov       al," "
         cmp       byte ptr ds:[Sound],0
         je        DispHl12
         mov       al,"˚"
DispHl12:mov       byte ptr ds:[HelpTxt1+14+13],al
         mov       byte ptr ds:[HelpTxt2+14+13],al
         mov       byte ptr ds:[HelpTxt3+14+13],al
         mov       al," "
         mov       bx,word ptr ds:[Hrac]
         cmp       byte ptr ds:[bx+Automat1],0
         je        DispHl13
         mov       al,"˚"
DispHl13:mov       byte ptr ds:[HelpTxt1+13],al
         mov       byte ptr ds:[HelpTxt2+13],al

         mov       bx,4                     ; poáet ©†dkñ
         mov       dh,2*64+6+13

DispHlp1:mov       dl,3*8+1
         mov       cx,4
DispHlp2:cld
         mov       ah,14
         lodsb
         cmp       al," "
         jne       DispHl22
         mov       ax,9*256+"€"
DispHl22:call      DispChr
         loop      DispHlp2

         mov       cl,10
DispHlp3:cld
         lodsb
         mov       ah,15
         cmp       al,"˚"
         je        DispHlp4
         mov       ah,10
         cmp       al," "
         jne       DispHlp4
         mov       ax,9*256+"€"
DispHlp4:call      DispChr
         loop      DispHlp3
         add       dh,10

         dec       bx
         jnz       DispHlp1

         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

DispHelp ENDP

; -----------------------------------------------------------------------------
;        zobrazen° informaán°ho okna
; -----------------------------------------------------------------------------

DispInf  PROC      NEAR

; ------ podkladovò obdÇln°k informaán°ho okna

         mov       dx,3*8
         mov       cx,(3*8*8+1)*256 + (40-3*8)
         mov       ah,9
         call      DispBox

; ------ zobrazen° hr†áe 1

         mov       dh,0
         mov       si,offset Hrac1
         call      DispHrac

; ------ zobrazen° hr†áe 2

         mov       dh,64
         mov       si,offset Hrac2
         call      DispHrac

; ------ zobrazen° okna n†povàdy

         mov       dx,(2*64)*256+3*8
         mov       cx,(64+1)*256+(40-3*8)
         mov       ah,0fh
         call      DispHLin
         add       dh,64
         call      DispHLin
         sub       dh,64
         mov       al,10100000b
         call      DispVLin
         mov       ax,40h
         call      DispVLin
         mov       dl,39
         mov       ax,15*256+1
         call      DispVLin

         cmp       byte ptr ds:[Dem],0
         je        DispInf5

         mov       si,offset DemoTxt
         mov       cx,6
         mov       dx,(2*64-5)*256+3*8+5
DispInf2:mov       al,"€"
         mov       ah,14
         call      DispChr
         dec       dl
         cld
         lodsb
         mov       ah,1
         call      DispChr
         loop      DispInf2

DispInf5:
         ret

DispInf  ENDP

; -----------------------------------------------------------------------------
;        zobrazen° okna hr†áe (©†dek DH, obr†zek SI)
; -----------------------------------------------------------------------------

DispHrac PROC      NEAR

; ------ vodorovnÇ okraje

         mov       dl,3*8
         mov       cx,64*256+(40-3*8)
         mov       ah,15
         call      DispHLin
         add       dh,64-2
         call      DispHLin
         add       dh,1
         mov       ah,0
         call      DispHLin
         sub       dh,64-1

; ------ svislÇ okraje

         mov       ax,15*256+80h
         call      DispVLin
         dec       ch
         mov       ax,40h
         call      DispVLin
         dec       ch
         mov       ax,15*256+20h
         call      DispVLin
         mov       al,1
         mov       dl,39
         call      DispVLin

; ------ zobrazen° obr†zku

         mov       dl,3*8
         add       dh,3
         mov       cx,24*256+(40-3*8)
         call      DispObr

; ------ zobrazen° textu

         add       dh,24+8
         mov       dl,3*8+3
         mov       si,offset SkoTxt
         mov       ah,12
         call      DispText
         add       dh,10
         mov       dl,3*8+3
         mov       si,offset VyhryTxt
         call      DispText

; ------ zobrazen° sk¢re a vòher

         call      DispSkor                 ; zobrazen° sk¢re hr†áñ
         call      DispVyh                  ; zobrazen° vòher hr†áñ
         call      DispStav                 ; zobrazen° aktu†ln°ho stavu hr†áñ

         ret

DispHrac ENDP

; -----------------------------------------------------------------------------
;        zobrazen° sk¢re hr†áñ
; -----------------------------------------------------------------------------

DispSkor PROC      NEAR

; ------ zobrazen° sk¢re hr†áe 1

         mov       dh,35
         mov       dl,40-6
         mov       al,ds:[Skore1]
         mov       cl,3
         mov       ah,14+9*16
         call      DispNum

; ------ zobrazen° sk¢re hr†áe 2

         mov       dh,35+64
         mov       dl,40-6
         mov       al,ds:[Skore2]
         mov       cl,3
         mov       ah,14+9*16
         call      DispNum
         ret

DispSkor ENDP

; -----------------------------------------------------------------------------
;        zobrazen° vòher hr†áñ
; -----------------------------------------------------------------------------

DispVyh  PROC      NEAR

; ------ zobrazen° vòher hr†áe 1

         mov       dh,45
         mov       dl,40-6
         mov       al,ds:[Vyhry1]
         mov       cl,3
         mov       ah,14+9*16
         call      DispNum

; ------ zobrazen° vòher hr†áe 2

         mov       dh,45+64
         mov       dl,40-6
         mov       al,ds:[Vyhry2]
         mov       cl,3
         mov       ah,14+9*16
         call      DispNum
         ret

DispVyh  ENDP

; -----------------------------------------------------------------------------
;        zobrazen° stavu hr†áñ
; -----------------------------------------------------------------------------

DispStav PROC      NEAR

; ------ zobrazen° aktivity hr†áe 1

         mov       dh,13
         mov       dl,3*8
         mov       si,offset Kostka
         cmp       byte ptr ds:[Hrac],0
         je        DispSta1
         mov       si,offset Kostka0
DispSta1:mov       cx,16*256+2
         call      DispObr

; ------ zobrazen° automatu hr†áe 1

         mov       dl,3*8+4
         mov       si,offset Pocitac
         cmp       byte ptr ds:[Automat1],0
         jne       DispSta2
         mov       si,offset Pocitac0
DispSta2:mov       cx,16*256+2
         call      DispObr

; ------ zobrazen° aktivity hr†áe 2

         mov       dh,13+64
         mov       dl,3*8
         mov       si,offset Kostka
         cmp       byte ptr ds:[Hrac],0
         jne       DispSta3
         mov       si,offset Kostka0
DispSta3:mov       cx,16*256+2
         call      DispObr

; ------ zobrazen° automatu hr†áe 2

         mov       dl,3*8+4
         mov       si,offset Pocitac
         cmp       byte ptr ds:[Automat2],0
         jne       DispSta4
         mov       si,offset Pocitac0
DispSta4:mov       cx,16*256+2
         call      DispObr
         ret

DispStav ENDP

; -----------------------------------------------------------------------------
;        zobrazen° á°sla AL (barva AH, pozice, DL, linka DH, poáet pozic CL)
; -----------------------------------------------------------------------------

DispNum  PROC      NEAR

; ------ vymaz†n° podkladu

         push      ax
         push      cx
         push      dx

         shr       ah,1
         shr       ah,1
         shr       ah,1
         shr       ah,1                     ; barva podkladu
         mov       al,"€"
DispNum0:call      DispChr
         dec       cl
         jnz       DispNum0

         pop       dx
         pop       cx
         pop       ax

; ------ £schova registrñ

         push      ax
         push      bx
         push      cx

; ------ p©°prava registrñ

         mov       bl,0                     ; á°taá znakñ
         mov       bh,ah                    ; barva textu
         mov       ch,10                    ; dàlitel

; ------ vòpoáet á°sla

DispNum1:mov       ah,0
         div       ch
         push      ax
         inc       bl
         dec       cl
         jz        DispNum3
         cmp       al,0
         jne       DispNum1

; ------ zobrazen° á°sla

         add       dl,cl                    ; p©eskoáen° £vodn°ch mezer
DispNum3:pop       ax
         mov       al,ah
         add       al,"0"
         mov       ah,bh
         call      DispChr
         dec       bl
         jnz       DispNum3

; ------ n†vrat registrñ

         pop       cx
         pop       bx
         pop       ax
         ret

DispNum  ENDP

; *****************************************************************************
;
;                       Obsluha displeje (hardwarovà z†visl†)
;
; *****************************************************************************
;˛

;; -----------------------------------------------------------------------------
;;        zobrazen° tituln°ho obr†zku
;; -----------------------------------------------------------------------------
;
;DispTit  PROC      NEAR
;
;         mov       ax,0a000h
;         mov       es,ax
;         mov       si,offset Titulek
;         cld
;
;; ------ nastaven° z†pisovÇ roviny
;
;         mov       ah,1                     ; z†pisov† rovina
;DispTit1:mov       dx,3c4h
;         mov       al,2
;         out       dx,al
;         inc       dx
;         mov       al,ah
;         out       dx,al
;
;; ------ p©enesen° jednÇ roviny
;
;         xor       di,di
;         mov       cx,320*200/8/2
;         rep       movsw
;
;; ------ p©°prava pro dal®° rovinu
;
;         shl       ah,1
;         cmp       ah,10h
;         jne       DispTit1
;         ret
;
;DispTit  ENDP

; -----------------------------------------------------------------------------
;        zobrazen° obr†zku SI (pozice DL, linka DH, CL=®°©ka, CH=vò®ka)
; -----------------------------------------------------------------------------

DispObr  PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx
         push      si
         push      di
         push      es

; ------ vòpoáet ukl†dac° adresy

         mov       al,40                    ; poáet bajtñ na linku
         mul       dh                       ; p©epoáet linky na adresu
         mov       dh,0
         add       ax,dx
         xchg      ax,di                    ; ukl†dac° adresa poá†dku
         mov       ax,0a000h
         mov       es,ax
         cld

; ------ nastaven° z†pisovÇ roviny

         mov       ah,1                     ; z†pisov† rovina
DispObr1:mov       dx,3c4h
         mov       al,2
         out       dx,al
         inc       dx
         mov       al,ah
         out       dx,al

; ------ p©enesen° obr†zku

         push      cx
         push      di

DispObr2:push      cx
         push      di
         mov       ch,0
         rep       movsb
         pop       di
         pop       cx

         add       di,40
         dec       ch
         jnz       DispObr2

         pop       di
         pop       cx

; ------ p©°prava pro dal®° rovinu

         shl       ah,1
         cmp       ah,10h
         jne       DispObr1

; ------ n†vrat registrñ

         pop       es
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       ax
         ret

DispObr  ENDP

; -----------------------------------------------------------------------------
; zobrazen° vertik†ln° linky (pozice DL, linka DH, maska AL, barva AH, vò®ka CH)
; -----------------------------------------------------------------------------

DispVLin PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx
         push      di
         push      es

; ------ nastaven° barvy linky

         push      ax
         mov       al,ah
         mov       ah,0
         call      Set3CE                   ; nastaven° registru barvy
         mov       ax,1ffh
         call      Set3CE                   ; v®echny roviny podle registru 0
         mov       ax,20fh
         call      Set3C4                   ; nastaven° masky rovin
         pop       ax
         mov       ah,8
         call      Set3CE                   ; nastaven° masky bodu

; ------ vòpoáet ukl†dac° adresy

         mov       al,40                    ; poáet bajtñ na linku
         mul       dh                       ; p©epoáet linky na adresu
         mov       dh,0
         add       ax,dx
         xchg      ax,di                    ; ukl†dac° adresa poá†dku
         mov       ax,0a000h
         mov       es,ax

; ------ zobrazen° linky

         mov       cl,ch
         mov       ch,0
DispVLn1:mov       al,0ffh
         xchg      al,es:[di]
         add       di,40
         loop      DispVLn1

; ------ n†vrat registru barvy

         mov       ax,8ffh
         call      Set3CE
         mov       ax,100h
         call      Set3CE

; ------ n†vrat registrñ

         pop       es
         pop       di
         pop       dx
         pop       cx
         pop       ax
         ret

DispVLin ENDP

; -----------------------------------------------------------------------------
;        zobrazen° horizont†ln° á†ry (pozice DL, linka DH, barva AL, dÇlka CL)
; -----------------------------------------------------------------------------

DispHLin PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx
         push      di
         push      es

; ------ nastaven° barvy linky

         mov       al,ah
         mov       ah,0
         call      Set3CE                   ; nastaven° registru barvy
         mov       ax,1ffh
         call      Set3CE                   ; v®echny roviny podle registru 0
         mov       ax,20fh
         call      Set3C4                   ; nastaven° masky rovin
         mov       ax,8ffh
         call      Set3CE

; ------ vòpoáet ukl†dac° adresy

         mov       al,40                    ; poáet bajtñ na linku
         mul       dh                       ; p©epoáet linky na adresu
         mov       dh,0
         add       ax,dx
         xchg      ax,di                    ; ukl†dac° adresa poá†dku
         mov       ax,0a000h
         mov       es,ax

; ------ zobrazen° linky

         cld
         mov       al,0ffh
         mov       ch,0
         rep       stosb

; ------ n†vrat registru barvy

         mov       ax,100h
         call      Set3CE

; ------ n†vrat registrñ

         pop       es
         pop       di
         pop       dx
         pop       cx
         pop       ax
         ret

DispHLin ENDP

; -----------------------------------------------------------------------------
;        zobrazen° textu ASCIIZ (text DS:SI, pozice DL, linka DH, barva AH)
; -----------------------------------------------------------------------------

DispText PROC      NEAR

DispTxt1:cld
         lodsb
         cmp       al,0
         je        DispTxt2
         call      DispChr
         jmp       short DispTxt1
DispTxt2:ret

DispText ENDP

; -----------------------------------------------------------------------------
;        zobrazen° znaku (pozice DL, linka DH, znak AL, barva AH)
; -----------------------------------------------------------------------------

DispChr  PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx
         push      si
         push      di
         push      es

; ------ nastaven° barvy znaku

         push      ax
         mov       al,ah
         mov       ah,0
         call      Set3CE                   ; nastaven° registru barvy
         mov       ax,1ffh
         call      Set3CE                   ; v®echny roviny podle registru 0
         mov       ax,20fh
         call      Set3C4                   ; nastaven° masky rovin
         pop       ax

; ------ adresa fontu znaku

         mov       ah,9
         mul       ah
         add       ax,offset Font
         xchg      ax,si

; ------ vòpoáet ukl†dac° adresy

         mov       al,40                    ; poáet bajtñ na linku
         mul       dh                       ; p©epoáet linky na adresu
         mov       dh,0
         add       ax,dx
         xchg      ax,di                    ; ukl†dac° adresa poá†dku
         mov       ax,0a000h
         mov       es,ax

; ------ zobrazen° znaku

         cld
         mov       dx,3ceh
         mov       al,8
         out       dx,al
         inc       dx
         mov       cx,9
DispChr1:lodsb
         out       dx,al
         xchg      al,es:[di]
         add       di,40
         loop      DispChr1

; ------ n†vrat registru barvy

         mov       al,0ffh
         out       dx,al
         mov       ax,100h
         call      Set3CE

; ------ n†vrat registrñ

         pop       es
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       ax
         inc       dl
         ret

DispChr  ENDP

; -----------------------------------------------------------------------------
;    zobrazen° obdÇln°ku (pozice DL, linka DH, ®°©ka CL, vò®ka CH, barva AH)
; -----------------------------------------------------------------------------

DispBox  PROC      NEAR

; ------ £schova registrñ

         push      ax
         push      cx
         push      dx
         push      di
         push      es

; ------ nastaven° barvy obdÇln°ku

         mov       al,ah
         mov       ah,0
         call      Set3CE                   ; nastaven° registru barvy
         mov       ax,1ffh
         call      Set3CE                   ; v®echny roviny podle registru 0
         mov       ax,20fh
         call      Set3C4                   ; nastaven° masky rovin
         mov       ax,8ffh
         call      Set3CE

; ------ vòpoáet ukl†dac° adresy

         mov       al,40                    ; poáet bajtñ na linku
         mul       dh                       ; p©epoáet linky na adresu
         mov       dh,0
         add       ax,dx
         xchg      ax,di                    ; ukl†dac° adresa poá†dku
         mov       ax,0a000h
         mov       es,ax

; ------ zobrazen° obdÇln°ku

         cld
         mov       al,0ffh
DispBox1:push      cx
         push      di
         mov       ch,0
         rep       stosb
         pop       di
         pop       cx
         add       di,40
         dec       ch
         jnz       DispBox1

; ------ n†vrat registru barvy

         mov       ax,100h
         call      Set3CE

; ------ n†vrat registrñ

         pop       es
         pop       di
         pop       dx
         pop       cx
         pop       ax
         ret

DispBox  ENDP

; -----------------------------------------------------------------------------
;        nastaven° registru AH portu 3CEh na AL
; -----------------------------------------------------------------------------

Set3CE   PROC      NEAR

         push      dx
         mov       dx,3ceh
         xchg      al,ah
         out       dx,al
         xchg      al,ah
         inc       dx
         out       dx,al
         pop       dx
         ret

Set3CE   ENDP

; -----------------------------------------------------------------------------
;        nastaven° registru AH portu 3C4h na AL
; -----------------------------------------------------------------------------

Set3C4   PROC      NEAR

         push      dx
         mov       dx,3c4h
         xchg      al,ah
         out       dx,al
         xchg      al,ah
         inc       dx
         out       dx,al
         pop       dx
         ret

Set3C4   ENDP

; -----------------------------------------------------------------------------
;                         InitRnd
;                  inicializace gener†toru n†hody
; -----------------------------------------------------------------------------
; VSTUP: DS=datovò segment
; -----------------------------------------------------------------------------

InitRnd  PROC      NEAR

         push      ax
         push      ds
         xor       ax,ax
         mov       ds,ax
         mov       ax,ds:[46ch]             ; á°taá systÇmovÇho áasovaáe
         pop       ds
         mov       word ptr ds:[RandomR],ax ; inicializaán° konstanta
         pop       ax
         ret

InitRnd  ENDP

; -----------------------------------------------------------------------------
;                           Random
;                   gener†tor n†hodnÇho á°sla
; -----------------------------------------------------------------------------
; VSTUP: AX=max. hodnota
;        DS=datovò segment
; VùSTUP: AX=á°slo 0 aë (max. hodnota - 1)
; -----------------------------------------------------------------------------

Random   PROC      NEAR

         push      bx
         push      dx
         or        ax,ax
         jz        Random1
         mov       bx,ax                    ; poëadovanò rozsah
         call      Random0                  ; generov†n° n†hodnÇho á°sla DX:AX
         xchg      ax,dx                    ; AX <- n†hodnÇ á°slo
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
         pop       cx
         pop       bx
         ret

Random0  ENDP

; -----------------------------------------------------------------------------
;        zapnut° zvukovÇho gener†toru (t¢n AL)
; -----------------------------------------------------------------------------

BeepOn   PROC      NEAR

         push      ax
         mov       ah,al
         mov       al,0b6h
         out       [43h],al
         mov       al,ah
         out       [42h],al
         out       [42h],al
         in        al,[61h]
         or        al,ds:[Sound]
         out       [61h],al
         pop       ax
         ret

BeepOn   ENDP

; -----------------------------------------------------------------------------
;        vypnut° zvukovÇho gener†toru
; -----------------------------------------------------------------------------

BeepOff  PROC      NEAR

         push      ax
         in        al,[61h]
         and       al,not 3
         out       [61h],al
         pop       ax
         ret

BeepOff  ENDP

; -----------------------------------------------------------------------------
;        áek†n° po AL impulsñ
; -----------------------------------------------------------------------------

Cekej    PROC      NEAR

         push      ax
         push      cx
         push      ds

         xor       cx,cx
         mov       ds,cx
Cekej1:  mov       cx,ds:[46ch]
Cekej2:  sti
         cmp       cx,ds:[46ch]
         je        Cekej2
         dec       al
         jnz       Cekej1

         pop       ds
         pop       cx
         pop       ax
         ret

Cekej    ENDP

; -----------------------------------------------------------------------------
;        inicializace á°taáe systÇmovÇho áasu
; -----------------------------------------------------------------------------

InitTime PROC      NEAR

         push      ax
         push      ds
         xor       ax,ax
         mov       ds,ax
         mov       ax,ds:[46ch]
         pop       ds
         mov       ds:[Time],ax
         pop       ax
         ret

InitTime ENDP

; -----------------------------------------------------------------------------
;        áten° á°taáe systÇmovÇho áasu -> AX
; -----------------------------------------------------------------------------

GetTime  PROC      NEAR

         push      ds
         xor       ax,ax
         mov       ds,ax
         mov       ax,ds:[46Ch]
         pop       ds
         sub       ax,ds:[Time]
         ret

GetTime  ENDP

; *****************************************************************************
;
;                             Data
;
; *****************************************************************************

OldVMod  db        3                        ; uschovanò videom¢d

Sound    db        3                        ; 3=p©°znak zapnut° zvuku

Time     dw        0                        ; £schova systÇmovÇho áasu

CardTxt  db        'Sorry, program requires EGA or VGA graphics card !',13,10,'$'

; ------ gener†tor n†hody

RandomR  dd        21510d31h                ; promànn† pro gener†tor n†hody
RandomD  dw        8405h                    ; pomocn† konstanta


Hrac     db        0                        ; aktivn° hr†á (0 nebo 1)
         db        0                        ; doplnàn° á°sla hr†áe na slovo

Skore1   db        0                        ; sk¢re hr†áe 1
Skore2   db        0                        ; sk¢re hr†áe 2
Vyhry1   db        0                        ; vòhry hr†áe 1
Vyhry2   db        0                        ; vòhry hr†áe 2
Automat1 db        0                        ; p©°znak automatu hr†áe 1
Automat2 db        1                        ; p©°znak automatu hr†áe 2
Kurzor   db        3*8+3                    ; kurzor
Hry      db        0                        ; á°taá her

Dem      db        0                        ; p©°znak demonstrace

DemoTxt  db        ' DEMO '

HelpTxtH db        'draw player',0

HelpTxt1 db        '   A automat  '
         db        '   S sound    '
         db        '   H help     '
         db        ' ESC break    '

HelpTxt2 db        '   A automat  '
         db        '   S sound    '
         db        '              '
         db        ' ESC break    '

HelpTxt3 db        '              '
         db        '   S sound    '
         db        '              '
         db        ' ESC break    '

HelpTxt4 db        'winning player',0
         db        '   number     '

HelpTxt5 db        '              ',0
         db        '     tied     '

HelpTxt6 db        ' ESC quit game'

Pole     label     byte                     ; hrac° pole (0=nic, 1=vejce, 2=ku©e
                                            ;  3=slepice, 4=moënò tah, -1=hrana)
         db        10 dup(-1)
         db        8 dup(-1, 8 dup(0), -1)
         db        10 dup(-1)

BuffTah  db        6 * 8 dup(0)             ; buffer pro £schovu tahñ
                                            ;   0: (1) poáet zmàn pro smàr -11
                                            ;   1: (1) poáet zmàn pro smàr -10
                                            ;   2: (1) poáet zmàn pro smàr -9
                                            ;   3: (1) poáet zmàn pro smàr -1
                                            ;   4: (1) poáet zmàn pro smàr 1
                                            ;   5: (1) poáet zmàn pro smàr 9
                                            ;   6: (1) poáet zmàn pro smàr 10
                                            ;   7: (1) poáet zmàn pro smàr 11

SkoTxt   db        'Score:',0
VyhryTxt db        ' Wins:',0

         EVEN

	include  EGGS.INC

Code     ENDS
         END       Start
