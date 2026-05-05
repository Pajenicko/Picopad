; Train
; (c) 1993-2024 Miroslav Nemecek

; The image on end of this file was created by screen capture with
; GDemo program (to *.SCR file) and then exported to ASM format with BinS.

;DEBUG    EQU       1                        ; p©¡znak testovac¡ho m¢du

X        EQU       0bah                     ; k¢dovac¡ kl¡‡ hesel

MAXSCEN  EQU       50                       ; maxim ln¡ ‡¡slo sc‚ny

FRSTSCEN EQU       1                        ; inicializa‡n¡ sc‚na

DELKOBR  EQU       (16*16/8)*4              ; d‚lka jednoho obr zku

POCVECI  EQU       18                       ; po‡et vˆc¡

LOK      EQU       1                        ; lokomotiva
LO1      EQU       LOK + 0                  ; lokomotiva VLEVO
LO2      EQU       LOK + 1                  ; lokomotiva NAHORU
LO3      EQU       LOK + 2                  ; lokomotiva VPRAVO
LO4      EQU       LOK + 3                  ; lokomotiva DOL¦

LO5      EQU       LOK + 4                  ; lokomotiva VLEVO
LO6      EQU       LOK + 5                  ; lokomotiva NAHORU
LO7      EQU       LOK + 6                  ; lokomotiva VPRAVO
LO8      EQU       LOK + 7                  ; lokomotiva DOL¦

LO9      EQU       LOK + 8                  ; lokomotiva VLEVO
LOA      EQU       LOK + 9                  ; lokomotiva NAHORU
LOB      EQU       LOK + 10                 ; lokomotiva VPRAVO
LOC      EQU       LOK + 11                 ; lokomotiva DOL¦

SRAZKA   EQU       LOK+12                   ; sr ‘ka (10 f z¡)
SR1      EQU       SRAZKA+0
SR2      EQU       SRAZKA+1
SR3      EQU       SRAZKA+2
SR4      EQU       SRAZKA+3
SR5      EQU       SRAZKA+4
SR6      EQU       SRAZKA+5
SR7      EQU       SRAZKA+6
SR8      EQU       SRAZKA+7
SR9      EQU       SRAZKA+8
SRA      EQU       SRAZKA+9

ZED      EQU       SRAZKA+10                ; zeƒ

VRA      EQU       ZED+1                    ; vrata (6 f z¡)

VAGONY   EQU       VRA+6                    ; vagony (ka‘d˜ vagon 4 smˆry)

VECI     EQU       VAGONY + 4*POCVECI       ; vˆci

KRY      EQU       0  * 3 + VECI            ; 1: krystal
KOR      EQU       1  * 3 + VECI            ; 2: koruna
STO      EQU       2  * 3 + VECI            ; 3: strom
JAB      EQU       3  * 3 + VECI            ; 4: jablko
KRA      EQU       4  * 3 + VECI            ; 5: kr va
TRE      EQU       5  * 3 + VECI            ; 6: t©e¨nˆ
RYB      EQU       6  * 3 + VECI            ; 7: rybn¡k
ZIR      EQU       7  * 3 + VECI            ; 8: ‘irafa
ZMR      EQU       8  * 3 + VECI            ; 9: zmrzlina
DOR      EQU       9  * 3 + VECI            ; 10: dort
POC      EQU       10 * 3 + VECI            ; 11: po‡¡ta‡
AUT      EQU       11 * 3 + VECI            ; 12: auto
BAL      EQU       12 * 3 + VECI            ; 13: bal¢n
BUD      EQU       13 * 3 + VECI            ; 14: bud¡k
SLO      EQU       14 * 3 + VECI            ; 15: slon
VIN      EQU       15 * 3 + VECI            ; 16: v¡no
PEN      EQU       16 * 3 + VECI            ; 17: pen¡ze
LET      EQU       17 * 3 + VECI            ; 18: letadlo

Code     SEGMENT
         ASSUME    cs:Code,ds:Code
         ORG       100h

; ------ test karty

Start:   mov       ah,12h
         mov       bx,7a10h
         int       10h
         cmp       bh,1
         ja        Start10
         cmp       bl,3
         jbe       Start1

Start10: mov       dx,offset CardTxt
         mov       ah,9
         push      cs
         pop       ds
         int       21h
         int       20h


Start1:  mov       ax,0dh
         int       10h
         call      CekInit                  ; inicializace hodin

; ------ demonstrace

Start2: ; call      Clear                    ; vymaz n¡ obrazovky
         mov       al,0
         call      InitScen                 ; inicializace sc‚ny AL (0=DEMO)
         mov       byte ptr ds:[Demon],1    ; je demonstrace
         call      ClearInf
         call      DispScen                 ; zobrazen¡ sc‚ny
         mov       byte ptr ds:[CitTit],0

         mov       si,offset DemoPos
Start23:
         call      TestTime                 ; inicializace ‡¡ta‡e ‡asu
         jc        Start3                   ; nen¡ krok

;         mov       ah,1
;         int       16h
;         jz        Start232
;
;         or        ax,ax
;         jz        Start302
;         cmp       al,27
;         je        Start302
;
;Start232:
         call      IncFaze                  ; zv˜¨en¡ f ze

         call      OpenVrat                 ; otev©en¡ vrat

         cmp       byte ptr ds:[Faze],0
         jne       Start3

         cmp       word ptr ds:[MapVlak+1],11*256 + 9
         jne       Start24

         jmp       Start2

Start24:
         mov       dx,ds:[si]
         inc       si
         inc       si
         call      PosVlak

         mov       al,ds:[MapVlak+1]
         shl       al,1
         sub       al,4
         jbe       Start25
         cmp       al,32
         ja        Start25
         cmp       byte ptr ds:[CitTit],32
         jae       Start25
         mov       ds:[CitTit],al
         call      DispTit
Start25:

Start3:  mov       ah,1
         int       16h
         jz        Start23

Start302:mov       ah,0
         int       16h
         or        ax,ax		; Ctrl+Break
         jz        Start38
         cmp       al,27		; Esc
         jne       Start4

Start38: call      SoundOff
         mov       ax,3
         int       10h
         int       20h

; ------ start sc‚ny

Start4:
         mov       byte ptr ds:[Demon],0    ; nen¡ demonstrace
         mov       al,ds:[AktScen]
         call      InitScen                 ; inicializace sc‚ny AL (0=DEMO)
         call      DispScen
         call      DispInf                  ; zobrazen¡ informa‡n¡ho © dku

Start41: call      FlushKey

Start5:  call      TestTime                 ; inicializace ‡¡ta‡e ‡asu
         jc        Start5                   ; nen¡ krok

         mov       ah,1
         int       16h
         jz        Start532

	cmp	al,0dh		; Enter
	je	Start502
         cmp       ax,3e00h		; F4
         jne       Start530
Start502:mov       ah,0
         int       16h
         jmp       Heslo

Start530:
         or        ax,ax		; Ctrl+Break
         jz        Start531
         cmp       al,27		; Esc
         jne       Start532

Start531:mov       ah,0
         int       16h
         jmp       short Start61

Start532:

         call      IncFaze                  ; zv˜¨en¡ f ze

         call      OpenVrat                 ; otev©en¡ vrat

         cmp       byte ptr ds:[Faze],0
         jne       Start5


STart60: mov       ah,1
         int       16h
         jz        Start69                  ; nen¡ kl vesa

Start603:mov       ah,0
         int       16h

	cmp	al,0dh		; Enter
	je	Start604
         cmp       ax,3e00h		; F4
         jne       Start606
Start604:jmp       Heslo                    ; zad n¡ hesla

Start606:
         or        ax,ax		; Ctrl+Break
         jz        Start61
         cmp       al,27		; Esc
         jne       Start62

Start61: call      SoundOff
         jmp       Start2

Start62: cmp       ah,48h		; Up
         jne       Start63
         mov       dx,0ff00h                ; nahoru
         jmp       short Start652

Start63: cmp       ah,4bh		; Left
         jne       Start64
         mov       dx,0ffh                  ; vlevo
         jmp       short Start652

Start64: cmp       ah,4dh		; Right
         jne       Start65
         mov       dx,1                     ; vpravo
         jmp       short Start652

Start65: cmp       ah,50h		; Down
         jne       Start60
         mov       dx,1*256                 ; dol–

Start652:cmp       dx,word ptr ds:[Smer]
         je        Start60                  ; smˆr je ji‘ nastaven
         mov       ds:[Smer],dx             ; nov˜ smˆr

Start69: mov       dx,ds:[Smer]
         or        dx,dx
         jz        Start6

; ------ test, zda vlak do nˆ‡eho naraz¡

         push      dx
         add       dl,ds:[MapVlak+1]
         add       dh,ds:[MapVlak+2]
         mov       al,20                    ; po‡et pozic
         mul       dh                       ; p©epo‡et © dku na offset
         add       al,dl
         adc       ah,0
         add       ax,offset Pole
         xchg      ax,si                    ; SI <- adresa v poli
         mov       al,ds:[si]               ; prvek na nov‚ pozici
         pop       dx

         cmp       al,0
         je        Start6A
         cmp       al,VECI
         jae       Start6A1
         cmp       al,VRA
         jbe       Start6a2
         cmp       al,VRA+6
         jb        Start6A
Start6a2:jmp       Start8                   ; hav rie

Start6A1:mov       word ptr ds:[AdrSound],offset TabSVec
         mov       word ptr ds:[CitSound],offset(TabSVec0-TabSVec) + 1
         jmp       short Start6a4

Start6A:
         mov       word ptr ds:[AdrSound],offset TabSLok
         mov       word ptr ds:[CitSound],offset(TabSLok0-TabSLok) + 1
;þ
Start6a4:call      PosVlak

         mov       dx,word ptr ds:[MapVlak+1]
         cmp       dx,ds:[PozVrat]
         je        Start7                   ; konec hry

Start6:  jmp       Start5

; ------ £spˆ¨n‚ ukon‡en¡ sc‚ny

Start7:
         mov       word ptr ds:[CitSound],0

         mov       bx,2200
         mov       ax,800
         mov       dx,250
         mov       cx,2
Start711:call      SetSound
         xchg      ax,bx
         call      Cekej
         call      SetSound
         xchg      ax,bx
         call      Cekej
         sub       bx,8
         dec       dx
         jnz       Start711

         call      SoundOff

         call      ClosScen
         call      ClearInf

         inc       byte ptr ds:[AktScen]
         cmp       byte ptr ds:[AktScen],MAXSCEN
         jbe       Start72
         mov       byte ptr ds:[AktScen],1
         jmp       Absol                    ; absolutn¡ v¡tˆz hry

Start72:
         mov       dx,(24/2-1)*256+(40-10)/2
         mov       si,offset ScenTxt
         mov       ah,10
         call      DispTxt

         mov       al,ds:[AktScen]
         mov       ah,0
         mov       ch,14
         call      DispNum

         mov       al," "
         call      DispChr

         mov       dx,(24/2+1)*256+(40-13)/2
         mov       ah,10
         mov       si,offset Hes2Txt
         call      DispTxt

         mov       al,5
         mul       byte ptr ds:[AktScen]
         add       ax,offset TabHesel-5
         xchg      ax,si
         mov       ah,14
         mov       cx,5
Start73: cld
         lodsb
         xor       al,X
         call      DispChr
         loop      Start73

         mov       al," "
         call      DispChr

         call      FlushKey

         mov       ah,0
         int       16h

         mov       al,ds:[AktScen]
         call      InitScen                 ; inicializace sc‚ny AL

         call      OpenScen

         call      DispInf                  ; zobrazen¡ informa‡n¡ho © dku

         jmp       Start41


; ------ hav rie

Start8:  mov       byte ptr ds:[MapVlak],0  ; p©¡znak sr ‘ky

         mov       word ptr ds:[CitVyb],120  ; ‡¡ta‡ v˜buchu

         mov       al,SR1                   ; sr ‘ka
Start80: mov       dx,word ptr ds:[MapVlak+1]
         call      DispObr

Start81:
         cmp       word ptr ds:[CitVyb],0
         je        Start86
         dec       word ptr ds:[CitVyb]
         jnz       Start85
         call      SoundOff
         jmp       short Start86

Start85: push      ax
         mov       bx,ds:[CitVyb]
         mov       ax,420
         sub       ax,ds:[CitVyb]
         shl       ax,1
         shl       ax,1
         shl       ax,1
         shl       ax,1
         mov       bx,word ptr ds:[bx+Start]
         and       bx,0fffh
         add       ax,bx
         call      SetSound
         pop       ax

Start86:
         mov       cx,9
         call      Cekej

         call      TestTime
         jc        Start81

         call      IncFaze

         inc       ax
         cmp       al,SRA+1
         jb        Start80

         mov       al,SR8

         push      ax
         mov       ah,1
         int       16h
         pop       ax
         jz        Start80

         call      SoundOff

Start82: call      FlushKey
Start83: jmp       Start4

; -----------------------------------------------------------------------------
;        celkov‚ ukon‡en¡ hry - absolutn¡ v¡tˆz
; -----------------------------------------------------------------------------
;þ
Absol    PROC      NEAR

         mov       dx,9*256+5
         mov       si,offset Bla1Txt
         mov       ah,14
         call      DispTxt
         mov       dx,10*256+5
         call      DispTxt
         mov       dx,11*256+5
         push      si
         mov       si,offset Bla1Txt
         call      DispTxt
         pop       si
         mov       ah,10
         mov       dx,12*256+5
         call      DispTxt
         mov       dx,13*256+5
         call      DispTxt
         mov       si,offset Bla1Txt
         mov       dx,14*256+5
         call      DispTxt

         call      FlushKey
         mov       ah,0
         int       16h
         jmp       Start2                   ; n vrat k demonstraci

Absol    ENDP

; -----------------------------------------------------------------------------
;        zad n¡ hesla
; -----------------------------------------------------------------------------
;þ
Heslo    PROC      NEAR

         push      ds
         pop       es

; ------ na‡ten¡ aktivn¡ho hesla

         mov       al,5
         mul       byte ptr ds:[AktScen]
         add       ax,offset TabHesel-5
         xchg      ax,si
         mov       cx,5
         mov       di,offset BuffHes
         cld
         rep       movsb

; ------ zobrazen¡ hesla

         mov       di,offset BuffHes        ; ukazatel v bufferu hesla

Heslo2:  mov       dx,24*256+14
         mov       ah,12
         mov       si,offset Hes2Txt
         call      DispTxt

         mov       si,offset BuffHes
         mov       cx,5
Heslo23: mov       ah,14
         cmp       si,di
         jne       Heslo232

         mov       ah,9
         mov       al,0dbh ;"Û"
         call      DispChr
         dec       dx

         mov       ah,14 XOR 9 + 80h

Heslo232:cld
         lodsb
         xor       al,X
         call      DispChr
         loop      Heslo23

; ------ ‡ek n¡ na zad n¡ kl vesy

Heslo24: call      TestTime                 ; inicializace ‡¡ta‡e ‡asu
         jc        Heslo25                  ; nen¡ krok
         call      IncFaze                  ; zv˜¨en¡ f ze
         call      OpenVrat                 ; otev©en¡ vrat

Heslo25: mov       ah,1
         int       16h
         jz        Heslo24
         mov       ah,0
         int       16h

         cmp       al,13
         je        Heslo5

; ------ p©eru¨en¡ zad n¡ ESC (nebo neplatn‚ heslo)

         or        ax,ax
         jz        Heslo27
         cmp       al,27
         jne       Heslo3

Heslo27:
         call      DispInf
         jmp       Start60                  ; p©eru¨en¡ bez dal¨¡ funkce

; ------ kurzor vpravo

Heslo3:  cmp       ax,4d00h
         je        Heslo42

; ------ kurzor vlevo

         cmp       al,8
         je        Heslo31
         cmp       al,7fh
         je        Heslo31
         cmp       ax,5300h
         je        Heslo31
         cmp       ax,4b00h
         jne       Heslo32
Heslo31: cmp       di,offset BuffHes
         jbe       Heslo43
         dec       di
         jmp       short Heslo43

; ------ vlo‘en¡ znaku

Heslo32: cmp	ax,4800h ; up
	jne	Heslo321
         mov       al,ds:[di]
         xor       al,X
	inc	al
	jmp	Heslo323

Heslo321: cmp	ax,5000h ; down
	jne	Heslo323
         mov       al,ds:[di]
         xor       al,X
	dec	al

Heslo323:
         cmp       al,"a"
         jb        Heslo33
         cmp       al,"z"
         ja        Heslo33
         sub       al,32
Heslo33: cmp       al,"A"
         jb        Heslo24
         cmp       al,"Z"
         ja        Heslo24
         xor       al,X
         mov       ds:[di],al

Heslo42: cmp       di,offset BuffHes+4
         jae       Heslo43
	cmp	ah,48h	; up
	je	Heslo43
	cmp	ah,50h	; down
	je	Heslo43
         inc       di
Heslo43: jmp       Heslo2

; ------ ukon‡en¡ zad n¡ hesla ENTER

Heslo5:  mov       si,offset TabHesel
         mov       dx,1                     ; ukazatel ‡¡sla sc‚ny
         cld
Heslo52: mov       di,offset BuffHes
         mov       cx,5
         push      si
         repe      cmpsb
         pop       si
         je        Heslo55
         add       si,5
         inc       dx
         cmp       dx,MAXSCEN
         jbe       Heslo52
         jmp       Heslo27

Heslo55: mov       ds:[AktScen],dl
         jmp       Start4

Heslo    ENDP

; -----------------------------------------------------------------------------
;        uzav©en¡ sc‚ny
; -----------------------------------------------------------------------------

ClosScen PROC      NEAR

         mov       dh,0
         mov       al,ZED
ClosScn1:mov       cx,20
         mov       dl,0
ClosScn2:call      DispObr
         inc       dx
         loop      ClosScn2
         mov       cx,60
         call      Cekej
         inc       dh
         cmp       dh,12
         jne       ClosScn1
         ret

ClosScen ENDP

; -----------------------------------------------------------------------------
;        otev©en¡ sc‚ny
; -----------------------------------------------------------------------------

OpenScen PROC      NEAR

         mov       si,offset Pole+12*20-20
         mov       dh,11
OpenScn1:mov       cx,20
         mov       dl,0
OpenScn2:cld
         lodsb
         call      DispObr
         inc       dx
         loop      OpenScn2
         sub       si,2*20
         mov       cx,60
         call      Cekej
         dec       dh
         jns       OpenScn1
         ret

OpenScen ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ sc‚ny
; -----------------------------------------------------------------------------

DispScen PROC      NEAR

         mov       si,offset Pole
         mov       dh,0
DispScn1:mov       cx,20
         mov       dl,0
DispScn2:cld
         lodsb
         call      DispObr
         inc       dx
         loop      DispScn2
         inc       dh
         cmp       dh,12
         jne       DispScn1
         ret

DispScen ENDP

; -----------------------------------------------------------------------------
;        vymaz n¡ informa‡n¡ho © dku
; -----------------------------------------------------------------------------

ClearInf PROC      NEAR

         mov       dx,24*256
         mov       ax,15*256+" "
         mov       cx,40
ClearIn1:call      DispChr
         loop      ClearIn1
         ret

ClearInf ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ informa‡n¡ho © dku
; -----------------------------------------------------------------------------

DispInf  PROC      NEAR

         call      ClearInf                 ; vymaz n¡ informa‡n¡ho © dku

; ------ £vodn¡ text

         mov       dx,24*256
         mov       ah,10
         mov       si,offset SkorTxt
         call      DispTxt

         mov       dl,40-6-3
         call      DispTxt

         mov       dl,16
         mov       ah,12
         call      DispTxt

         mov       ch,14
         mov       al,ds:[AktScen]
         mov       ah,0
         mov       dl,40-2
         call      DispNum

         call      DispSkor                 ; zobrazen¡ sk¢re
         ret

DispInf  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ sk¢re
; -----------------------------------------------------------------------------

DispSkor PROC      NEAR

         push      ax
         push      cx
         push      dx

         cmp       byte ptr ds:[Demon],0
         jne       DispSko6

         mov       dx,24*256+6
         mov       ch,14
;         mov       cl,5
         mov       ax,ds:[Skore]
         or        ax,ax
         jz        DispSko4
;         jnz       DispSko3
;         mov       cl,6
DispSko3:call      DispNum
DispSko4:mov       al,"0"
         mov       ah,14
;         mov       dl,6+5
         call      DispChr

DispSko6:pop       dx
         pop       cx
         pop       ax
         ret

DispSkor ENDP

; -----------------------------------------------------------------------------
;        otev©en¡ vrat
; -----------------------------------------------------------------------------

OpenVrat PROC      NEAR

         push      ax
         push      cx
         push      dx
         push      si

         cmp       word ptr ds:[CitVeci],0
         jne       OpenVr8

         mov       dx,ds:[PozVrat]
         mov       al,20                    ; po‡et pozic
         mul       dh                       ; p©epo‡et © dku na offset
         add       al,dl
         adc       ah,0
         add       ax,offset Pole
         xchg      ax,si                    ; SI <- adresa v poli
         mov       al,ds:[si]
         cmp       al,VRA
         jb        OpenVr8
         cmp       al,VRA+5
         jae       OpenVr8

         inc       ax
         mov       ds:[si],al               ; nov  f ze vrat
         call      DispObr

OpenVr8: pop       si
         pop       dx
         pop       cx
         pop       ax
         ret

OpenVrat ENDP

; -----------------------------------------------------------------------------
;        zv˜¨en¡ f ze objekt–
; -----------------------------------------------------------------------------

IncFaze  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      cx
         push      dx
         push      si

; ------ obsluha objekt–

         mov       dh,0
         mov       si,offset Pole
         inc       byte ptr ds:[Faze]       ; ‡¡ta‡ f z¡
         cmp       byte ptr ds:[Faze],3
         jb        IncFaze1
         mov       byte ptr ds:[Faze],0
IncFaze1:mov       dl,0
IncFaze2:cld
         lodsb
         cmp       al,VECI
         jae       IncFaze3
         cmp       al,LO1
         jb        IncFaze5
         cmp       al,LOC
         ja        IncFaze5
         cmp       byte ptr ds:[MapVlak],0
         je        IncFaze5
         sub       al,LO1
         and       al,3
         mov       ah,ds:[Faze]
         shl       ah,1
         shl       ah,1
         add       al,ah
         inc       ax
         jmp       short IncFaze4
IncFaze3:inc       ax                       ; zv˜¨en¡ f ze
         cmp       byte ptr ds:[Faze],0
         jne       IncFaze4
         sub       al,3
IncFaze4:mov       ds:[si-1],al
         call      DispObr
IncFaze5:inc       dl
         cmp       dl,20
         jne       IncFaze2
         inc       dh
         cmp       dh,12
         jne       IncFaze1

; ------ n vrat registr–

         pop       si
         pop       dx
         pop       cx
         pop       ax
         ret

IncFaze  ENDP

; -----------------------------------------------------------------------------
;        ‡¡t n¡ ‡asu pro jeden krok (CY=nen¡ krok)
; -----------------------------------------------------------------------------
;þ
TestTime PROC      NEAR

         sti

         push      cx
         mov       cx,1
         call      Cekej
         pop       cx

         cmp       word ptr ds:[CitSound],0
         je        TestTim1

         dec       word ptr ds:[CitSound]
         jnz       TestTim0
TestT05: call      SoundOff
         jmp       short TestTim1

TestTim0:
         push      ax
         push      si
         mov       si,ds:[AdrSound]
         cld
         lodsw
         mov       ds:[AdrSound],si
         call      SetSound

         pop       si
         pop       ax

TestTim1:

         push      ax
         push      ds
         xor       ax,ax
         mov       ds,ax
         mov       ax,ds:[46ch]
         pop       ds
         sub       ax,ds:[LastTime]

IFDEF    DEBUG
         cmp       ax,3                     ; krok
ELSE
         cmp       ax,2                     ; krok
ENDIF

         jb        TestTim3                 ; nen¡ krok
         add       ds:[LastTime],ax         ; zv˜¨en¡ ‡¡ta‡e ‡asu
         clc                                ; p©¡znak kroku
TestTim3:pop       ax
         ret

TestTime ENDP

;; -----------------------------------------------------------------------------
;;        vymaz n¡ obrazovky
;; -----------------------------------------------------------------------------
;
;Clear    PROC      NEAR
;
;; ------ £schova registr–
;
;         push      ax
;         push      cx
;         push      dx
;         push      di
;         push      es
;
;; ------ nastaven¡ z pisov˜ch rovin
;
;         mov       dx,3c4h
;         mov       al,2
;         out       dx,al
;         inc       dx
;         mov       al,0fh
;         out       dx,al
;
;; ------ vymaz n¡ videopamˆti
;
;         mov       ax,0a000h
;         mov       es,ax
;         xor       di,di
;         mov       cx,40*200/2
;         xor       ax,ax
;         rep       stosw
;
;; ------ n vrat registr–
;
;         pop       es
;         pop       di
;         pop       dx
;         pop       cx
;         pop       ax
;         ret
;
;Clear    ENDP

; -----------------------------------------------------------------------------
;        posun vlaku ve smˆru DX (DH=0,1,-1, DL=0,1,-1)
; -----------------------------------------------------------------------------

PosVlak  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      dx
         push      si
         push      di

; ------ p©¡prava registr–

         mov       si,offset MapVlak
         add       dl,ds:[si+1]             ; nov  sou©adnice lokomotivy
         add       dh,ds:[si+2]

; ------ posun sou©adnic objektu

PosVlak2:mov       cx,ds:[si+1]             ; £schova star˜ch sou©adnic
         mov       ds:[si+1],dx             ; nov  sou©adnice objektu

; ------ stanoven¡ nov‚ f ze objektu

         mov       al,ds:[si]               ; b ze objektu
         cmp       cl,-1
         jne       PosVlk22
         add       al,bh
         jmp       short PosVlak4
PosVlk22:mov       ah,dl                    ; nov  pozice
         mov       bh,0
         sub       ah,cl                    ; posun pozice
         je        PosVlak3                 ; pozice se nezmˆnila
         js        PosVlak4                 ; posun vlevo
         mov       bh,2
         add       al,2
         jmp       short PosVlak4           ; posun vpravo
PosVlak3:inc       ax                       ; posun nahoru
         mov       bh,1
         mov       ah,dh                    ; nov˜ © dek
         sub       ah,ch                    ; posun © dku
         js        PosVlak4                 ; je posun nahoru
         add       al,2                     ; jinak posun dol–
         mov       bh,3

; ------ zobrazen¡ objektu na nov‚ pozici

PosVlak4:call      DispObr                  ; zobrazen¡ obr zku

; ------ ulo‘en¡ objektu do mapy

         push      ax
         mov       al,20                    ; po‡et pozic
         mul       dh                       ; p©epo‡et © dku na offset
         add       al,dl
         adc       ah,0
         add       ax,offset Pole
         xchg      ax,di                    ; DI <- adresa v poli
         pop       ax
         xchg      al,ds:[di]               ; ulo‘en¡ objektu do mapy

; ------ p©i zru¨en¡ vˆci vytvo©en¡ nov‚ho vagonu

         sub       al,VECI                  ; byla to vˆc ?
         jb        PosVlak6                 ; nebyla to vˆc

         dec       word ptr ds:[CitVeci]    ; ‡¡t n¡ vˆc¡
         cmp       byte ptr ds:[Demon],0
         jne       PosVla42
         cmp       word ptr ds:[Skore],-1
         je        PosVla41
         inc       word ptr ds:[Skore]
PosVla41:call      DispSkor                 ; zobrazen¡ sk¢re
PosVla42:mov       ah,0
         mov       bl,3
         div       bl                       ; ‡¡slo vˆci
         shl       al,1
         shl       al,1                     ; vagon * 4
         add       al,VAGONY                ; ‡¡slo vagonu
         push      si
PosVlak5:add       si,3
         cmp       byte ptr ds:[si],0
         jne       PosVlak5
         mov       ds:[si],al
         mov       word ptr ds:[si+1],-1
         mov       byte ptr ds:[si+3],0
         pop       si

; ------ p©¡prava pro dal¨¡ objekt

PosVlak6:add       si,3                     ; adresa dal¨¡ho objektu
         mov       dx,cx                    ; star  pozice p©ede¨l‚ho objektu
         mov       al,0
         cmp       ds:[si],al               ; je ji‘ konec vlaku ?
         je        PosVlak7
         jmp       PosVlak2                 ; nen¡ konec - dal¨¡ vagon

; ------ vymaz n¡ posledn¡ho vagonu

PosVlak7:cmp       dl,-1
         je        PosVlak8
         call      DispObr                  ; vymaz n¡ posledn¡ho vagonu
         mov       al,20                    ; po‡et pozic
         mul       dh                       ; p©epo‡et © dku na offset
         add       al,dl
         adc       ah,0
         add       ax,offset Pole
         xchg      ax,di                    ; DI <- adresa v poli
         mov       byte ptr ds:[di],0

; ------ n vrat registr–

PosVlak8:pop       di
         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

PosVlak  ENDP

; -----------------------------------------------------------------------------
;        inicializace sc‚ny AL pro hru
; -----------------------------------------------------------------------------

InitScen PROC      NEAR

         call      CekInit                  ; inicializace hodin

; ------ £schova registr–

         push      ax
         push      cx
         push      dx
         push      si
         push      di

; ------ p©enesen¡ definice sc‚ny

         cld
         mov       ah,0
         mov       cx,12*20                 ; d‚lka definice jedn‚ sc‚ny
         mul       cx                       ; offset definice sc‚ny
         add       ax,offset Sceny          ; adresa definice sc‚ny
         xchg      ax,si                    ; SI <- adresa definice sc‚ny
         mov       di,offset Pole           ; za‡ tek pole
         rep       movsb                    ; p©enos pole

         mov       word ptr ds:[CitVeci],0

; ------ inicializace sc‚ny

         mov       dh,0
         mov       si,offset Pole
InitScn4:mov       dl,0
InitScn5:cld
         lodsb
;         call      DispObr
         cmp       al,VRA
         jne       InitSc52
         mov       ds:[PozVrat],dx          ; pozice vrat
InitSc52:cmp       al,VECI
         jb        InitScn6
         inc       word ptr ds:[CitVeci]
InitScn6:cmp       al,LO1
         jb        InitScn7
         cmp       al,LO4
         ja        InitScn7
         mov       ds:[MapVlak],al          ; typ lokomotivy (smˆr)
         mov       word ptr ds:[MapVlak+1],dx ; sou©adnice lokomotivy
         mov       byte ptr ds:[MapVlak+3],0  ; ozna‡en¡ konce vlaku
InitScn7:inc       dl
         cmp       dl,20
         jne       InitScn5
         inc       dh
         cmp       dh,12
         jne       InitScn4

         mov       byte ptr ds:[MapVlak],LO1 ; b ze lokomotivy
         mov       byte ptr ds:[Faze],0     ; ukazatel f ze
         mov       word ptr ds:[Smer],0

; ------ n vrat registr–

         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       ax
         ret

InitScen ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ obr zku AL na pozici DL, © dek DH
; -----------------------------------------------------------------------------

DispObr  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      cx
         push      dx
         push      si
         push      di
         push      es

; ------ v˜po‡et adresy obr zku

         mov       ah,0
         mov       cl,7                     ; po‡et rotac¡
         shl       ax,cl                    ; offset obr zku
         add       ax,offset Obrazky        ; adresa obr zku
         xchg      ax,si                    ; SI <- adresa obr zku

; ------ adresa k ulo‘en¡ obr zku

         mov       cx,dx                    ; £schova DX
         mov       dl,dh
         mov       dh,0
         mov       ax,16*40                 ; offset © dku
         mul       dx                       ; p©epo‡et © dku na offset
         mov       ch,0
         shl       cx,1                     ; p©epo‡et pozice na offset
         add       ax,cx                    ; adresa ve videopamˆti
         xchg      ax,di                    ; DI <- adresa ve videopamˆti
         mov       ax,0a000h
         mov       es,ax                    ; ES <- adresa ve videopamˆti

; ------ p©¡prava k zobrazen¡ obr zku

         mov       dx,3c4h
         mov       al,2
         out       dx,al                    ; volba registru z pisov˜ch rovin
         mov       ah,1                     ; ukazatel z pisov‚ roviny
         inc       dx
         cld

; ------ zobrazen¡ jedn‚ roviny obr zku

DispObr2:mov       al,ah
         out       dx,al                    ; volba z pisov‚ roviny
         mov       cx,16                    ; po‡et linek
         push      di
DispObr3:movsw                              ; p©enos jedn‚ linky
         add       di,40-2
         loop      DispObr3
         pop       di

; ------ p©¡prava pro dal¨¡ rovinu

         shl       ah,1
         cmp       ah,10h
         jne       DispObr2                 ; dal¨¡ rovina

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
;        zobrazen¡ titulku
; -----------------------------------------------------------------------------

DispTit  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      cx
         push      dx
         push      si
         push      di
         push      es

; ------ p©¡prava k zobrazen¡ titulku

         mov       si,offset Titulek
         mov       ax,0a000h
         mov       es,ax                    ; ES <- adresa ve videopamˆti
         mov       di,9*16*40+4
         mov       dx,3c4h
         mov       al,2
         out       dx,al                    ; volba registru z pisov˜ch rovin
         mov       ah,1                     ; ukazatel z pisov‚ roviny
         inc       dx
         cld

; ------ zobrazen¡ jedn‚ roviny titulku

DispTit2:mov       al,ah
         out       dx,al                    ; volba z pisov‚ roviny
         mov       cx,16                    ; po‡et linek

         push      di
         push      si

DispTit3:push      cx
         push      si
         push      di

         mov       cl,ds:[CitTit]
         rep       movsb                    ; p©enos jedn‚ linky

         pop       di
         pop       si
         pop       cx
         add       si,32
         add       di,40

         loop      DispTit3

         pop       si
         pop       di

; ------ p©¡prava pro dal¨¡ rovinu

         add       si,16*32
         shl       ah,1
         cmp       ah,10h
         jne       DispTit2                 ; dal¨¡ rovina

; ------ n vrat registr–

         pop       es
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       ax
         ret

DispTit  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ ‡¡sla AX (pozice DL, © dek DH, barva CH)
; -----------------------------------------------------------------------------

DispNum  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      si
         push      di

         mov       bx,dx                    ; £schova pozice
         xor       di,di                    ; ‡¡ta‡ znak–

; ------ dek¢dov n¡ ‡¡sla do z sobn¡ku

         mov       si,10
DispNum1:xor       dx,dx
         div       si
         push      dx
         inc       di
         mov       dx,bx
;         dec       cl
;         jz        DispNum3
         or        ax,ax
         jnz       DispNum1

;         mov       al," "
;         mov       ah,0
;DispNum2:call      DispChr
;         dec       cl
;         jnz       DispNum2

; ------ zobrazen¡ ‡¡sla

DispNum3:pop       ax
         add       al,"0"
         mov       ah,ch
         call      DispChr
         dec       di
         jnz       DispNum3

; ------ n vrat registr–

         pop       di
         pop       si
         pop       cx
         pop       bx
         pop       ax
         ret

DispNum  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ textu SI (barva AH, pozice DL, © dek DH)
; -----------------------------------------------------------------------------

DispTxt  PROC      NEAR

DispTxt1:cld
         lodsb
         cmp       al,0
         je        DispTxt2
         call      DispChr
         jmp       short DispTxt1

DispTxt2:ret

DispTxt  ENDP

; -----------------------------------------------------------------------------
;        zobrazen¡ znaku AX (pozice DL, © dek DH)
; -----------------------------------------------------------------------------

DispChr  PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      dx
         push      si
         push      di

; ------ nastaven¡ kurzoru

         push      ax
         mov       bh,0
         mov       ah,2
         int       10h                      ; nastaven¡ kurzoru
         pop       ax

; ------ zobrazen¡ znaku

         mov       bl,ah
         mov       bh,0
         mov       ah,9
         mov       cx,1
         int       10h                      ; zobrazen¡ znaku

; ------ n vrat registr–

         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         inc       dx
         ret

DispChr  ENDP

; -----------------------------------------------------------------------------
;        nastaven¡ zvukov‚ho gener toru na AX
; -----------------------------------------------------------------------------

SetSound PROC      NEAR

         push      ax
         cli
         mov       al,0b6h
         out       [43h],al
         pop       ax
         push      ax
         out       [42h],al                 ; LOW
         xchg      ah,al
         out       [42h],al                 ; HIGH
         in        al,[61h]
         or        al,3
         out       [61h],al
         sti
         pop       ax
         ret

SetSound ENDP

; -----------------------------------------------------------------------------
;        vypnut¡ zvukov‚ho gener toru
; -----------------------------------------------------------------------------

SoundOff PROC      NEAR

         push      ax
         in        al,[61h]
         and       al,not 3
         out       [61h],al
         pop       ax
         ret

SoundOff ENDP

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

; -----------------------------------------------------------------------------
;        vypr zdnˆn¡ bufferu kl vesnice
; -----------------------------------------------------------------------------

FlushKey PROC      NEAR

         push      ax
FlushKe2:mov       ah,1
         int       16h
         jz        FlushKe3
         mov       ah,0
         int       16h
         jmp       short FlushKe2
FlushKe3:pop       ax
         ret

FlushKey ENDP

; *****************************************************************************
;
;                               Data
;
; *****************************************************************************

CardTxt  db        'Sorry, program requires EGA or VGA graphics card !',13,10,'$'

BuffHes  db        '     '                  ; buffer hesla

                                            ; posun p©i demonstraci
DemoPos  db        19 dup(1,0)
         db        8 dup(0,-1)
         db        3 dup( 19 dup(-1,0), 0,1, 19 dup(1,0), 0,1)
         db        19 dup(-1,0)
         db        0,1, 0,1, 0,1
         db        9 dup(1,0), 0,1

SkorTxt  db        'SCORE',0
ScenTxt  db        ' SCENE ',0
HeslTxt  db        'F4 PSWRD',0
Hes2Txt  db        ' pswrd ',0

Bla1Txt  db        '                              ',0
Bla2Txt  db        'C O N G R A T U L A T I O N S!',0
         db        ' You have become the absolute ',0
         db        '     winner of this game!     ',0

; ------ ‡asova‡

         EVEN                               ; za‡¡n  na sud‚ adrese jako 0:46ch
Cit1ms   dw        0                        ; konstanta pro dobu 1 ms

AdrSound dw        0                        ; adresa zvuku
CitSound dw        0                        ; ‡¡ta‡ d‚lky zvuku (0=nen¡)

CitVyb   dw        0                        ; ‡¡ta‡ v˜buchu

TabSLok  dw        166,254,365              ; zvuk lokomotivy
TabSLok0 label     byte

TabSVec  dw        400,600,800,1000,1200,1400,1600,1800,2000,1800,1600,1400,1200,1000,800,600,400,200 ; zvuk vˆci
TabSVec0 label     byte

Smer     dw        0                        ; smˆr pohybu

Demon    db        0                        ; 1=p©¡znak demonstrace

CitTit   db        0                        ; ‡¡ta‡ ¨¡©ky titulku
CitVeci  dw        0                        ; ‡¡ta‡ vˆc¡
PozVrat  dw        0                        ; pozice vrat
Skore    dw        0                        ; ‡¡ta‡ sk¢re

MapVlak  db        3 * 12*20 dup(0)         ; mapa cel‚ho vlaku
                                            ;  0: (1) b ze objektu (0=konec)
                                            ;  1: (1) sou©adnice X
                                            ;  2: (1) sou©adnice Y

LastTime dw        0                        ; uschovan˜ posledn¡ ‡as

Faze     db        0                        ; ‡¡ta‡ f ze

Pole     db        12*20 dup(0)             ; hrac¡ pole

AktScen  db        FRSTSCEN                 ; aktivn¡ sc‚na

TabHesel label     byte                     ; tabulka hesel
         db        'G' XOR X,'O' XOR X,'L' XOR X,'E' XOR X,'M' XOR X ; 1
         db        'K' XOR X,'R' XOR X,'O' XOR X,'N' XOR X,'E' XOR X ; 2
         db        'M' XOR X,'Y' XOR X,'D' XOR X,'L' XOR X,'O' XOR X ; 3
         db        'L' XOR X,'E' XOR X,'D' XOR X,'E' XOR X,'N' XOR X ; 4
         db        'S' XOR X,'T' XOR X,'R' XOR X,'O' XOR X,'P' XOR X ; 5
         db        'L' XOR X,'I' XOR X,'L' XOR X,'I' XOR X,'E' XOR X ; 6
         db        'R' XOR X,'Y' XOR X,'B' XOR X,'K' XOR X,'A' XOR X ; 7
         db        'K' XOR X,'L' XOR X,'A' XOR X,'U' XOR X,'N' XOR X ; 8
         db        'B' XOR X,'R' XOR X,'A' XOR X,'U' XOR X,'N' XOR X ; 9
         db        'W' XOR X,'H' XOR X,'I' XOR X,'T' XOR X,'E' XOR X ; 10
         db        'M' XOR X,'O' XOR X,'U' XOR X,'S' XOR X,'E' XOR X ; 11
         db        'D' XOR X,'R' XOR X,'E' XOR X,'A' XOR X,'M' XOR X ; 12
         db        'I' XOR X,'D' XOR X,'E' XOR X,'A' XOR X,'L' XOR X ; 13
         db        'I' XOR X,'L' XOR X,'U' XOR X,'Z' XOR X,'E' XOR X ; 14
         db        'S' XOR X,'A' XOR X,'I' XOR X,'N' XOR X,'T' XOR X ; 15
         db        'B' XOR X,'E' XOR X,'L' XOR X,'L' XOR X,'S' XOR X ; 16
         db        'T' XOR X,'R' XOR X,'O' XOR X,'J' XOR X,'A' XOR X ; 17
         db        'E' XOR X,'M' XOR X,'O' XOR X,'C' XOR X,'E' XOR X ; 18
         db        'B' XOR X,'A' XOR X,'S' XOR X,'T' XOR X,'L' XOR X ; 19
         db        'I' XOR X,'S' XOR X,'L' XOR X,'A' XOR X,'M' XOR X ; 20
         db        'J' XOR X,'E' XOR X,'A' XOR X,'N' XOR X,'S' XOR X ; 21
         db        'M' XOR X,'E' XOR X,'T' XOR X,'A' XOR X,'L' XOR X ; 22
         db        'M' XOR X,'I' XOR X,'K' XOR X,'R' XOR X,'O' XOR X ; 23
         db        'S' XOR X,'E' XOR X,'N' XOR X,'Z' XOR X,'A' XOR X ; 24
         db        'G' XOR X,'A' XOR X,'L' XOR X,'A' XOR X,'X' XOR X ; 25
         db        'S' XOR X,'T' XOR X,'O' XOR X,'N' XOR X,'E' XOR X ; 26
         db        'S' XOR X,'L' XOR X,'A' XOR X,'V' XOR X,'E' XOR X ; 27
         db        'F' XOR X,'O' XOR X,'R' XOR X,'T' XOR X,'E' XOR X ; 28
         db        'L' XOR X,'U' XOR X,'C' XOR X,'I' XOR X,'E' XOR X ; 29
         db        'N' XOR X,'A' XOR X,'T' XOR X,'U' XOR X,'R' XOR X ; 30
         db        'B' XOR X,'I' XOR X,'E' XOR X,'N' XOR X,'E' XOR X ; 31
         db        'K' XOR X,'A' XOR X,'T' XOR X,'Z' XOR X,'E' XOR X ; 32
         db        'H' XOR X,'Y' XOR X,'D' XOR X,'R' XOR X,'O' XOR X ; 33
         db        'F' XOR X,'A' XOR X,'U' XOR X,'N' XOR X,'A' XOR X ; 34
         db        'U' XOR X,'L' XOR X,'T' XOR X,'R' XOR X,'A' XOR X ; 35
         db        'T' XOR X,'O' XOR X,'D' XOR X,'A' XOR X,'Y' XOR X ; 36
         db        'H' XOR X,'O' XOR X,'R' XOR X,'O' XOR X,'R' XOR X ; 37
         db        'G' XOR X,'A' XOR X,'P' XOR X,'P' XOR X,'A' XOR X ; 38
         db        'R' XOR X,'E' XOR X,'T' XOR X,'A' XOR X,'L' XOR X ; 39
         db        'C' XOR X,'L' XOR X,'O' XOR X,'C' XOR X,'K' XOR X ; 40
         db        'H' XOR X,'O' XOR X,'M' XOR X,'E' XOR X,'R' XOR X ; 41
         db        'B' XOR X,'U' XOR X,'N' XOR X,'N' XOR X,'Y' XOR X ; 42
         db        'F' XOR X,'O' XOR X,'T' XOR X,'O' XOR X,'N' XOR X ; 43
         db        'Q' XOR X,'U' XOR X,'A' XOR X,'C' XOR X,'K' XOR X ; 44
         db        'H' XOR X,'A' XOR X,'F' XOR X,'I' XOR X,'K' XOR X ; 45
         db        'D' XOR X,'I' XOR X,'Z' XOR X,'Z' XOR X,'Y' XOR X ; 46
         db        'S' XOR X,'T' XOR X,'A' XOR X,'R' XOR X,'K' XOR X ; 47
         db        'Z' XOR X,'A' XOR X,'R' XOR X,'A' XOR X,'Z' XOR X ; 48
         db        'D' XOR X,'U' XOR X,'K' XOR X,'E' XOR X,'N' XOR X ; 49
         db        'S' XOR X,'T' XOR X,'O' XOR X,'R' XOR X,'Y' XOR X ; 50

Sceny    label     byte
                                            ; 0: DEMO
db   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
db KRY,  0,  0,  0,KRY,STO,  0,  0,  0,  0,  0,  0,KOR,  0,  0,JAB,  0,  0,  0,JAB
db KRY,  0,  0,  0,KRY,STO,  0,  0,  0,  0,  0,KOR,  0,KOR,  0,JAB,  0,  0,JAB,  0
db KRY,  0,  0,  0,KRY,STO,  0,  0,  0,  0,KOR,  0,  0,  0,KOR,JAB,  0,JAB,  0,  0
db KRY,  0,  0,  0,KRY,STO,  0,  0,  0,  0,KOR,  0,  0,  0,KOR,JAB,JAB,  0,  0,  0
db KRY,  0,  0,  0,KRY,STO,  0,  0,  0,  0,KOR,KOR,KOR,KOR,KOR,JAB,  0,JAB,  0,  0
db   0,KRY,  0,KRY,  0,STO,  0,  0,  0,  0,KOR,  0,  0,  0,KOR,JAB,  0,  0,JAB,  0
db   0,  0,KRY,  0,  0,STO,STO,STO,STO,STO,KOR,  0,  0,  0,KOR,JAB,  0,  0,  0,JAB
db   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
db LO3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
db   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 1: KRYSTAL
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,LO3,  0,  0,  0,  0,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,KRY,KRY,KRY,KRY,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,VRA
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 2: KORUNA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,KRY,  0,KRY,  0,KRY,  0,KRY,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,KOR,  0,KOR,  0,KOR,  0,KOR,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,KOR,KOR,KOR,KOR,KOR,KOR,KOR,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,KOR,KOR,KOR,KOR,KOR,KOR,KOR,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,KOR,KOR,KOR,KOR,KOR,KOR,KOR,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,LO3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 3: STROM
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,KRY,KRY,KRY,  0,  0,  0,  0,ZED,  0,  0,  0,STO,  0,STO,  0,  0,  0,ZED
db ZED,  0,KRY,KOR,KRY,  0,  0,  0,  0,ZED,  0,  0,STO,  0,STO,  0,STO,  0,  0,ZED
db ZED,  0,KRY,KRY,KRY,  0,  0,  0,  0,ZED,  0,  0,  0,STO,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,  0,  0,  0,  0,VRA,  0,  0,STO,  0,STO,  0,STO,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,STO,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,LO3,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 4: JABLKO
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,KRY,  0,KRY,  0,KRY,  0,KRY,  0,KRY,  0,KRY,  0,KRY,  0,KRY,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,LO3,  0,  0,  0,  0,  0,  0,  0,JAB,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,JAB,JAB,JAB,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,JAB,JAB,STO,JAB,JAB,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,ZED,  0,  0,JAB,JAB,STO,ZED,STO,JAB,JAB,  0,  0,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,  0,JAB,JAB,STO,JAB,ZED,JAB,STO,JAB,JAB,  0,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,JAB,JAB,STO,JAB,JAB,JAB,JAB,JAB,STO,JAB,JAB,ZED,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 5: KRVA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,KRA,  0,KRA,  0,KRA,  0,ZED,  0,  0,KRA,  0,KRA,  0,KRA,  0,  0,ZED
db ZED,LO3,  0,  0,KRA,  0,KRA,  0,  0,ZED,  0,  0,  0,KRA,  0,KRA,  0,  0,  0,ZED
db ZED,  0,  0,KRA,  0,KRA,  0,KRA,  0,ZED,  0,  0,KRA,  0,KRA,  0,KRA,  0,  0,ZED
db ZED,  0,  0,  0,KRA,  0,KRA,  0,  0,ZED,  0,  0,  0,KRA,  0,KRA,  0,  0,  0,ZED
db VRA,  0,  0,KRA,  0,KRA,  0,KRA,  0,ZED,  0,  0,KRA,  0,KRA,  0,KRA,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,KOR,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 6: TžE›N‰
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,KOR,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,TRE,TRE,TRE,  0,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,TRE,TRE,TRE,TRE,TRE,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,TRE,TRE,TRE,TRE,TRE,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,LO3,  0,  0,  0,  0,  0,TRE,TRE,KOR,TRE,TRE,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,TRE,TRE,TRE,TRE,TRE,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,TRE,TRE,TRE,TRE,TRE,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,TRE,TRE,TRE,  0,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,KRY,  0,  0,  0,ZED
db VRA,  0,  0,STO,STO,STO,STO,STO,STO,STO,STO,STO,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 7: RYBN‹K
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,KRY,  0,  0,  0,STO,STO,STO,  0,  0,  0,KRA,  0,KRA,  0,  0,ZED
db ZED,  0,  0,  0,ZED,  0,  0,STO,  0,RYB,  0,STO,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,LO3,  0,  0,KRY,  0,  0,STO,RYB,  0,RYB,STO,  0,  0,  0,KRA,  0,KRA,  0,ZED
db ZED,  0,  0,  0,ZED,  0,  0,STO,  0,RYB,  0,STO,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,KRY,  0,  0,STO,RYB,  0,RYB,STO,  0,  0,KRA,  0,KRA,  0,  0,ZED
db ZED,  0,  0,  0,ZED,  0,  0,STO,  0,ZED,  0,STO,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,KRY,  0,  0,  0,STO,ZED,STO,  0,  0,  0,  0,KRA,  0,KRA,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 8: ’IRAFA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,ZED,ZED,ZED,ZED,  0,ZED,ZED,ZED,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,ZED,  0,  0,  0,  0,  0,  0,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,ZED,  0,  0,STO,  0,STO,  0,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,LO3,  0,KRY,  0,ZED,  0,JAB,  0,ZIR,  0,JAB,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,ZED,  0,  0,STO,  0,STO,  0,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,ZED,  0,  0,  0,RYB,  0,  0,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,ZED,  0,STO,  0,  0,  0,STO,  0,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,VRA,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 9: ZMRZLINA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,JAB,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,STO,STO,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,KRY,KRY,  0,  0,ZED,  0,ZMR,ZMR,  0,ZED,  0,  0,KRY,KRY,  0,  0,ZED
db ZED,  0,KRY,KRY,KRY,KRY,  0,ZED,  0,ZMR,ZMR,  0,ZED,  0,KRY,KRY,KRY,KRY,  0,ZED
db ZED,  0,KRY,KRY,KRY,KRY,  0,ZED,  0,ZMR,ZMR,  0,ZED,  0,KRY,KRY,KRY,KRY,  0,ZED
db ZED,  0,  0,KRY,KRY,  0,  0,ZED,  0,ZMR,ZMR,  0,ZED,  0,  0,KRY,KRY,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,ZED,  0,  0,ZED,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,LO1,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 10: DORT
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,STO,  0,  0,  0,ZMR,  0,ZMR,  0,ZMR,  0,  0,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,  0,  0,  0,ZMR,  0,ZMR,  0,  0,  0,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,ZED,  0,  0,  0,KRY,  0,  0,  0,ZED,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,ZED,  0,  0,  0,KOR,  0,  0,  0,ZED,  0,STO,  0,  0,  0,ZED
db ZED,LO3,  0,RYB,  0,ZED,  0,  0,ZED,VRA,ZED,  0,  0,ZED,  0,ZIR,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,ZED,KRA,  0,ZED,DOR,ZED,  0,KRA,ZED,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,ZED,  0,  0,ZED,KRY,ZED,  0,  0,ZED,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,ZED,  0,  0,ZED,KRY,ZED,  0,  0,ZED,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,ZED,  0,  0,ZED,KRY,ZED,  0,  0,ZED,  0,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,STO,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 11: PO€‹TA€
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,RYB,  0,ZED,ZED,  0,RYB,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,  0,POC,POC,  0,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,POC,POC,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,POC,POC,  0,  0,ZED
db ZED,  0,  0,POC,POC,  0,ZED,  0,  0,KOR,KOR,  0,  0,ZED,  0,POC,POC,  0,  0,ZED
db ZED,LO3,  0,POC,  0,  0,  0,VRA,  0,  0,  0,  0,KOR,  0,  0,  0,POC,  0,  0,ZED
db ZED,  0,  0,POC,  0,ZED,STO,ZED,POC,  0,  0,POC,ZED,STO,ZED,  0,POC,  0,  0,ZED
db ZED,  0,  0,POC,  0,ZED,STO,ZED,  0,POC,POC,  0,ZED,STO,ZED,  0,POC,  0,  0,ZED
db ZED,  0,POC,POC,  0,ZED,STO,ZED,  0,POC,POC,  0,ZED,STO,ZED,  0,POC,POC,  0,ZED
db ZED,  0,POC,POC,  0,ZED,STO,ZED,POC,POC,POC,POC,ZED,STO,ZED,  0,POC,POC,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 12: AUTO
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,KRA,  0,ZED
db ZED,  0,KRA,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,KRA,  0,ZED
db ZED,  0,KRA,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,KRA,  0,ZED
db ZED,LO3,KRA,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,KRA,  0,ZED
db ZED,  0,KRA,  0,DOR,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,DOR,  0,KRA,  0,ZED
db ZED,  0,KRA,  0,ZED,ZED,ZED,ZED,ZED,AUT,ZED,ZED,ZED,ZED,ZED,ZED,  0,KRA,  0,ZED
db ZED,  0,KRA,  0,ZED,AUT,AUT,AUT,AUT,  0,AUT,AUT,AUT,AUT,AUT,ZED,  0,KRA,  0,ZED
db ZED,  0,KRA,  0,ZED,AUT,AUT,AUT,AUT,  0,AUT,AUT,AUT,AUT,AUT,ZED,  0,KRA,  0,ZED
db ZED,  0,  0,  0,ZED,AUT,AUT,AUT,AUT,  0,AUT,AUT,AUT,AUT,AUT,ZED,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 13: BAL•N
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZMR,ZMR,ZED,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,JAB,JAB,ZED
db ZED,ZED,ZMR,ZMR,ZMR,ZED,  0,  0,  0,BAL,  0,  0,  0,  0,  0,  0,  0,JAB,JAB,ZED
db ZED,ZED,ZMR,ZMR,ZMR,ZED,  0,  0,BAL,  0,BAL,  0,  0,  0,  0,  0,  0,ZED,ZED,ZED
db ZED,ZED,ZED,ZMR,ZMR,ZED,  0,  0,  0,BAL,  0,ZIR,STO,KOR,  0,  0,  0,  0,  0,ZED
db ZED,LO3,  0,  0,  0,  0,  0,  0,  0,  0,KRA,STO,ZED,ZED,  0,KRY,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,ZIR,STO,ZED,ZED,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,KRA,STO,ZED,ZED,ZED,KRY,  0,KRY,  0,  0,  0,  0,DOR,ZED
db ZED,  0,  0,  0,ZIR,STO,ZED,ZED,ZED,KRY,  0,  0,  0,  0,  0,  0,  0,ZED,ZED,ZED
db ZED,  0,  0,STO,ZED,ZED,ZED,KRY,  0,  0,KRY,  0,KRY,  0,KRY,  0,  0,JAB,JAB,ZED
db ZED,  0,KRA,ZED,ZED,  0,  0,  0,KRY,  0,  0,  0,AUT,AUT,AUT,  0,  0,JAB,JAB,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 14: BUD‹K
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,BUD,BUD,BUD,  0,BUD,  0,BUD,  0,  0,BUD,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,BUD,  0,  0,BUD,  0,BUD,  0,BUD,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,BUD,  0,  0,BUD,  0,BUD,BUD,  0,  0,  0,BUD,BUD,BUD,  0,  0,  0,  0,ZED
db ZED,  0,BUD,  0,  0,BUD,  0,BUD,  0,BUD,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db VRA,LO3,BUD,  0,  0,BUD,  0,BUD,  0,  0,BUD,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,BUD,BUD,BUD,  0,  0,BUD,  0,  0,BUD,  0,BUD,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,BUD,  0,  0,BUD,  0,BUD,  0,BUD,BUD,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,BUD,  0,  0,BUD,BUD,BUD,  0,BUD,  0,BUD,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,BUD,  0,  0,BUD,  0,BUD,  0,BUD,  0,BUD,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 15: SLON
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,KRY,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,KOR,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,SLO,STO,SLO,  0,  0,  0,  0,RYB,STO,RYB,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,STO,SLO,STO,  0,ZED,TRE,  0,STO,RYB,STO,ZED,  0,  0,  0,ZED
db ZED,LO3,  0,  0,VRA,ZED,ZED,ZED,POC,JAB,ZED,AUT,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,ZED,ZMR,JAB,ZED,ZMR,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,STO,ZIR,STO,DOR,ZED,ZMR,DOR,STO,KRA,STO,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZIR,STO,ZIR,DOR,DOR,DOR,DOR,KRA,STO,KRA,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 16: V‹NO
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,ZED,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,ZED,VIN,VIN,VIN,VIN,VIN,VIN,VIN,ZED,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,VIN,VIN,VIN,VIN,VIN,ZED,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,ZED,VIN,VIN,VIN,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,LO3,  0,  0,  0,  0,  0,ZED,VRA,ZED,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,KRY,ZED,KRY,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,KRY,ZED,KRY,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,ZED,ZED,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,KOR,KOR,KOR,KOR,KOR,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 17: PEN‹ZE
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,KRY,KOR,KRY,KOR,AUT,AUT,AUT,AUT,AUT,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,KOR,KRY,KOR,KRY,ZED,ZED,ZED,ZED,PEN,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,  0,ZED
db ZED,KRY,KOR,ZED,KOR,ZED,PEN,PEN,PEN,PEN,ZED,PEN,PEN,PEN,ZED,  0,  0,  0,  0,ZED
db ZED,KOR,KRY,KOR,KRY,ZED,PEN,ZED,ZED,ZED,ZED,PEN,ZED,PEN,ZED,  0,  0,  0,  0,ZED
db ZED,KRY,KOR,KRY,KOR,ZED,PEN,PEN,PEN,PEN,PEN,PEN,ZED,PEN,ZED,  0,  0,  0,  0,ZED
db ZED,LO3,KRY,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,PEN,PEN,ZED,  0,  0,  0,  0,ZED
db ZED,KRY,KOR,KRY,KOR,ZED,PEN,PEN,PEN,PEN,ZED,PEN,PEN,ZED,ZED,  0,  0,  0,  0,ZED
db ZED,KOR,ZED,ZED,KRY,ZED,PEN,ZED,ZED,PEN,PEN,PEN,PEN,PEN,ZED,  0,  0,  0,  0,ZED
db ZED,KRY,KOR,KRY,KOR,ZED,PEN,PEN,PEN,ZED,ZED,ZED,PEN,PEN,ZED,  0,  0,  0,  0,ZED
db ZED,KOR,KRY,KOR,KRY,ZED,PEN,PEN,PEN,PEN,PEN,PEN,PEN,KOR,ZED,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 18: letadlo
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,VRA,  0,  0,  0,  0,  0,ZED
db ZED,  0,DOR,  0,  0,ZED,LET,  0,ZED,  0,ZED,  0,LET,ZED,  0,  0,  0,ZMR,  0,ZED
db ZED,  0,DOR,  0,  0,ZED,  0,  0,ZED,  0,ZED,  0,  0,ZED,  0,  0,ZMR,ZMR,  0,ZED
db ZED,  0,DOR,DOR,  0,ZED,ZED,ZED,  0,  0,  0,ZED,ZED,ZED,  0,ZMR,ZMR,ZMR,  0,ZED
db ZED,  0,DOR,DOR,  0,  0,KRY,  0,  0,ZIR,  0,  0,KRY,  0,ZMR,ZMR,ZMR,ZMR,  0,ZED
db ZED,LO3,DOR,DOR,  0,  0,KRY,  0,  0,SLO,  0,  0,KRY,  0,ZMR,ZMR,ZMR,ZMR,  0,ZED
db ZED,  0,DOR,DOR,  0,ZED,ZED,ZED,  0,  0,  0,ZED,ZED,ZED,  0,ZMR,ZMR,ZMR,  0,ZED
db ZED,  0,DOR,  0,  0,ZED,  0,  0,ZED,  0,ZED,  0,  0,ZED,  0,  0,ZMR,ZMR,  0,ZED
db ZED,  0,DOR,  0,  0,ZED,LET,  0,ZED,  0,ZED,  0,LET,ZED,  0,  0,  0,ZMR,  0,ZED
db ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 19:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,LO3,KRY,KRY,KRY,KRY,KRY,KRY,VRA,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 20:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,KOR,  0,  0,  0,  0,  0,SLO,SLO,SLO,SLO,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,ZED,ZED,  0,  0,  0,  0,ZED,ZED,ZED,ZED,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,KRY,  0,ZED,  0,  0,ZED,STO,ZIR,STO,ZIR,ZED,  0,  0,  0,ZED
db ZED,LO3,  0,  0,  0,  0,  0,  0,ZED,ZED,STO,ZIR,STO,ZIR,STO,ZIR,ZED,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,  0,  0,STO,ZIR,STO,ZIR,STO,ZIR,STO,ZED,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,  0,ZIR,STO,ZIR,STO,ZIR,STO,ZIR,STO,ZED,KRY,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,ZED,ZED,ZIR,STO,ZIR,STO,ZIR,STO,ZIR,VRA,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,ZED,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,ZED
db ZED,TRE,JAB,TRE,JAB,TRE,JAB,ZED,ZED,  0,  0,  0,  0,  0,ZED,ZED,  0,JAB,TRE,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 21:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,STO,STO,STO,STO,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,STO,STO,STO,STO,ZED
db ZED,  0,POC,  0,  0,  0,ZED,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,POC,  0,ZED
db ZED,BUD,  0,DOR,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,  0,  0,  0,DOR,  0,BUD,ZED
db ZED,ZED,ZED,ZED,ZMR,  0,  0,  0,ZED,  0,  0,ZED,  0,  0,  0,ZMR,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,ZED,ZMR,  0,  0,  0,ZED,ZED,  0,  0,  0,ZMR,ZED,  0,  0,  0,ZED
db ZED,KRY,KRY,  0,  0,ZED,ZMR,  0,  0,LO3,  0,  0,  0,ZMR,ZED,  0,  0,KRY,KRY,ZED
db ZED,KRY,ZED,KRY,  0,  0,ZED,ZMR,  0,VIN,VIN,  0,ZMR,ZED,  0,  0,KRY,ZED,KRY,ZED
db ZED,  0,  0,ZED,KRY,  0,  0,ZED,  0,VIN,VIN,  0,ZED,  0,  0,KRY,ZED,  0,  0,ZED
db ZED,  0,KOR,  0,ZED,KRY,  0,  0,ZED,VIN,VIN,ZED,  0,  0,KRY,ZED,  0,KOR,  0,ZED
db ZED,  0,  0,  0,  0,ZED,KRY,  0,  0,VIN,VIN,  0,  0,KRY,ZED,  0,  0,  0,  0,VRA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 22:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,LO3,STO,STO,STO,STO,STO,STO,  0,STO,ZED,STO,  0,STO,STO,STO,STO,STO,STO,ZED
db ZED,  0,STO,STO,STO,STO,STO,STO,STO,STO,ZED,STO,STO,STO,STO,STO,STO,STO,STO,ZED
db ZED,STO,STO,STO,STO,STO,STO,  0,STO,  0,ZED,  0,STO,  0,STO,STO,STO,STO,STO,ZED
db ZED,  0,STO,STO,STO,STO,  0,STO,ZED,ZED,ZED,ZED,ZED,STO,  0,STO,  0,STO,STO,ZED
db ZED,STO,STO,STO,STO,  0,ZED,  0,ZED,  0,  0,  0,ZED,  0,ZED,  0,STO,STO,STO,ZED
db ZED,  0,STO,STO,STO,  0,ZED,  0,ZED,  0,RYB,  0,ZED,  0,ZED,  0,STO,STO,STO,ZED
db ZED,  0,  0,STO,  0,  0,ZED,  0,ZED,  0,  0,  0,ZED,  0,ZED,  0,  0,STO,  0,ZED
db ZED,  0,STO,STO,STO,STO,ZED,  0,ZED,ZED,  0,ZED,ZED,  0,ZED,STO,STO,STO,STO,ZED
db ZED,STO,STO,STO,STO,ZED,ZED,  0,  0,  0,  0,  0,  0,  0,ZED,ZED,STO,STO,STO,ZED
db VRA,  0,STO,  0,STO,  0,ZED,STO,STO,STO,ZIR,STO,STO,STO,ZED,  0,STO,  0,STO,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 23:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,VIN,VIN,VIN,VIN,  0,  0,VIN,VIN,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,VIN,ZED,ZED,ZED,ZED,VIN,  0,VIN,VIN,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,VIN,ZED,ZED,ZED,ZED,ZED,ZED,VIN,VIN,VIN,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,VIN,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VIN,VIN,  0,  0,  0,  0,  0,  0,ZED
db ZED,LO3,VIN,ZED,ZED,BAL,BAL,BAL,ZED,ZED,ZED,ZED,VIN,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,VIN,ZED,ZED,BAL,LET,BAL,ZMR,ZMR,ZMR,ZED,VIN,  0,STO,  0,STO,  0,STO,ZED
db ZED,  0,VIN,ZED,ZED,BAL,BAL,BAL,ZMR,ZMR,ZMR,ZED,VIN,STO,STO,STO,STO,STO,STO,ZED
db ZED,  0,VIN,ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZMR,ZED,VIN,  0,STO,  0,STO,  0,STO,ZED
db ZED,  0,VIN,ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,VIN,  0,STO,  0,STO,  0,STO,ZED
db ZED,  0,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,  0,STO,  0,STO,  0,STO,VRA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 24:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,TRE,  0,  0,ZED,  0,ZED,  0,  0,  0,ZED,  0,ZED,  0,  0,  0,TRE,  0,ZED
db ZED,  0,TRE,  0,  0,ZED,  0,ZED,  0,  0,  0,ZED,  0,ZED,  0,  0,  0,TRE,  0,ZED
db ZED,ZED,ZED,ZED,  0,ZED,  0,ZED,  0,RYB,  0,ZED,  0,ZED,  0,ZED,ZED,ZED,ZED,ZED
db ZED,  0,TRE,  0,  0,ZED,  0,ZED,  0,ZIR,  0,ZED,  0,ZED,  0,  0,  0,TRE,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,  0,ZED,  0,  0,  0,ZED,  0,ZED,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,TRE,  0,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,  0,  0,TRE,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,  0,ZED,ZED,LO4,ZED,ZED,  0,ZED,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,TRE,  0,  0,ZED,  0,  0,JAB,  0,JAB,  0,  0,ZED,  0,  0,  0,TRE,  0,ZED
db ZED,  0,  0,  0,  0,ZED,STO,  0,  0,  0,  0,  0,STO,ZED,  0,  0,  0,  0,  0,ZED
db ZED,  0,TRE,  0,  0,ZED,JAB,JAB,JAB,JAB,JAB,JAB,JAB,ZED,  0,  0,  0,TRE,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 25:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,LO3,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,ZED
db ZED,  0,KOR,  0,KOR,  0,KOR,  0,KOR,  0,  0,KOR,  0,KOR,  0,KOR,  0,KOR,  0,ZED
db ZED,ZED,DOR,DOR,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,KRY,DOR,DOR,ZED,ZED
db ZED,ZED,DOR,DOR,ZED,DOR,DOR,  0,KOR,  0,  0,KOR,  0,DOR,DOR,ZED,DOR,DOR,ZED,ZED
db ZED,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,ZED
db ZED,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,ZED
db ZED,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,ZED
db ZED,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,ZED
db ZED,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,ZED
db ZED,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,DOR,DOR,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 26:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,  0,  0,  0,JAB,  0,TRE,  0,ZED,ZED,ZED,ZED
db ZED,ZED,ZIR,SLO,ZIR,ZED,  0,  0,  0,STO,STO,RYB,VIN,JAB,ZED,TRE,  0,ZED,ZED,ZED
db ZED,ZED,SLO,ZIR,SLO,  0,  0,  0,STO,ZED,ZED,STO,RYB,VIN,JAB,ZED,TRE,  0,ZED,ZED
db ZED,ZED,ZIR,SLO,ZIR,  0,  0,STO,ZED,  0,  0,ZED,STO,RYB,VIN,JAB,ZED,TRE,  0,ZED
db ZED,ZED,SLO,ZIR,SLO,  0,STO,ZED,  0,  0,  0,  0,ZED,STO,RYB,VIN,JAB,ZED,  0,ZED
db ZED,ZED,ZED,ZED,  0,STO,ZED,  0,  0,  0,  0,  0,  0,ZED,STO,RYB,VIN,JAB,  0,ZED
db ZED,  0,  0,  0,STO,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,STO,RYB,VIN,JAB,ZED
db ZED,  0,  0,STO,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED,STO,RYB,VIN,ZED
db ZED,  0,STO,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED,STO,RYB,ZED
db ZED,STO,LO1,ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED,VRA,STO,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 27:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,LO3,KRY,ZED,ZED,  0,KRY,  0,  0,ZED,  0,  0,KRY,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,  0,ZED,  0,ZED,KRY,  0,ZED,ZED,ZED,ZED,ZED,  0,ZED,  0,ZED
db ZED,ZED,ZED,  0,ZED,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,  0,  0,  0,ZED
db ZED,  0,  0,KRY,  0,  0,ZED,  0,ZED,  0,ZED,ZED,  0,ZED,ZED,  0,KRY,  0,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,ZED,KRY,ZED,VRA,ZED,  0,KRY,  0,  0,ZED,  0,ZED,  0,ZED
db ZED,  0,  0,  0,  0,ZED,  0,  0,ZED,KOR,  0,KRY,  0,ZED,KRY,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,  0,ZED,  0,ZED,ZED,  0,ZED,  0,KRY,ZED,  0,ZED,KRY,KRY,  0,ZED
db ZED,  0,  0,  0,  0,ZED,  0,KRY,  0,ZED,  0,KRY,  0,ZED,  0,KRY,  0,  0,ZED,ZED
db ZED,  0,ZED,ZED,  0,ZED,ZED,  0,  0,  0,ZED,  0,  0,ZED,KRY,  0,  0,ZED,  0,ZED
db ZED,  0,KRY,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 28:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,VRA,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,ZIR,ZIR,ZED,  0,  0,  0,  0,  0,  0,ZED,ZIR,ZIR,ZED,  0,  0,ZED
db ZED,  0,ZED,ZIR,ZIR,ZIR,ZIR,ZED,  0,ZED,ZED,  0,ZED,ZIR,ZIR,ZIR,ZIR,ZED,  0,ZED
db ZED,LO3,ZED,ZIR,ZIR,ZIR,  0,  0,  0,SLO,SLO,  0,  0,  0,ZIR,ZIR,ZIR,ZED,  0,ZED
db ZED,  0,ZED,ZIR,ZIR,ZIR,  0,ZIR,SLO,SLO,SLO,SLO,ZED,  0,ZIR,ZIR,ZIR,ZED,  0,ZED
db ZED,  0,ZED,ZIR,ZIR,ZIR,ZIR,ZED,ZED,ZED,ZED,ZED,ZED,ZIR,ZIR,ZIR,ZIR,ZED,  0,ZED
db ZED,  0,  0,ZED,ZIR,ZIR,ZED,  0,  0,  0,  0,  0,  0,ZED,ZIR,ZIR,ZED,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 29:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,  0,ZED
db ZED,  0,  0,ZIR,  0,ZED,  0,KRA,  0,  0,ZED,  0,SLO,  0,ZED,  0,ZIR,  0,  0,ZED
db ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,  0,ZED,ZED,ZED,  0,ZED,ZED,LO4,ZED,  0,ZED,ZED,ZED,  0,ZED,ZED,ZED
db ZED,STO,  0,  0,  0,STO,  0,  0,  0,  0,STO,  0,  0,  0,STO,  0,  0,  0,STO,ZED
db ZED,STO,  0,  0,  0,STO,  0,  0,  0,  0,STO,  0,  0,  0,STO,  0,  0,  0,STO,ZED
db ZED,ZED,ZED,  0,ZED,ZED,ZED,  0,ZED,ZED,VRA,ZED,  0,ZED,ZED,ZED,  0,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,ZED
db ZED,  0,  0,KRA,  0,ZED,  0,SLO,  0,ZED,  0,  0,ZIR,  0,ZED,  0,KRA,  0,  0,ZED
db ZED,  0,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 30:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,ZED
db ZED,  0,  0,ZED,BUD,BUD,BUD,BUD,BUD,ZED,ZED,KRY,KRY,KRY,KRY,KRY,ZED,  0,  0,ZED
db ZED,  0,  0,ZED,RYB,ZED,RYB,RYB,RYB,ZED,ZED,KOR,KOR,KOR,ZED,KOR,ZED,  0,  0,ZED
db ZED,  0,  0,ZED,ZMR,ZED,ZED,ZMR,ZMR,ZED,ZED,JAB,JAB,ZED,ZED,JAB,ZED,  0,  0,ZED
db ZED,  0,  0,ZED,LET,AUT,ZED,ZED,AUT,ZED,ZED,POC,ZED,ZED,POC,POC,ZED,  0,  0,ZED
db ZED,  0,  0,ZED,DOR,DOR,DOR,ZED,DOR,ZED,ZED,KRA,ZED,KRA,KRA,KRA,ZED,  0,  0,ZED
db ZED,  0,  0,ZED,BAL,BAL,BAL,BAL,BAL,ZED,ZED,VIN,VIN,VIN,VIN,VIN,ZED,  0,  0,ZED
db ZED,  0,  0,ZED,ZED,ZED,ZED,STO,STO,ZED,ZED,STO,STO,ZED,ZED,ZED,ZED,  0,  0,ZED
db ZED,LO3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,VRA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 31: (po©ad¡ © dk– 3-5-2-5-3-1-4-5)
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,KRY,  0,KRY,  0,KRY,  0,KRY,STO,STO,KRY,  0,KRY,  0,KRY,  0,KRY,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,KRY,  0,KRY,  0,KRY,  0,KRY,STO,STO,KRY,  0,KRY,  0,KRY,  0,KRY,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,ZED
db ZED,LO3,KRY,  0,KRY,  0,KRY,  0,KRY,STO,STO,KRY,  0,KRY,  0,KRY,  0,KRY,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,KRY,  0,KRY,  0,KRY,  0,KRY,STO,STO,KRY,  0,KRY,  0,KRY,  0,KRY,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,KRY,  0,KRY,  0,KRY,  0,KRY,STO,STO,KRY,  0,KRY,  0,KRY,  0,KRY,  0,ZED
db ZED,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 32:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,ZED,STO,STO,STO,STO,ZED,ZED,STO,STO,STO,STO,ZED,STO,STO,ZED,ZED
db ZED,  0,  0,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,STO,ZED
db ZED,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,ZED
db ZED,STO,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED
db ZED,LO3,STO,ZED,ZED,STO,ZED,ZED,STO,ZED,ZED,STO,ZED,ZED,STO,ZED,ZED,STO,ZED,ZED
db ZED,STO,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED
db ZED,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,VRA
db ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,ZED
db ZED,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED
db ZED,ZED,ZED,STO,STO,STO,STO,ZED,ZED,STO,STO,STO,STO,ZED,ZED,STO,STO,STO,STO,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 33:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,ZMR,ZED,ZED,ZED,ZMR,  0,  0,DOR,DOR,  0,  0,TRE,TRE,TRE,TRE,  0,  0,ZED
db ZED,  0,ZMR,ZED,ZED,ZED,ZMR,  0,DOR,ZED,ZED,DOR,  0,TRE,ZED,ZED,ZED,TRE,  0,ZED
db ZED,  0,  0,ZMR,ZED,ZMR,  0,DOR,ZED,ZED,ZED,ZED,DOR,TRE,ZED,ZED,ZED,TRE,  0,ZED
db ZED,  0,  0,ZMR,ZED,ZMR,  0,DOR,ZED,ZED,ZED,ZED,DOR,TRE,ZED,ZED,ZED,TRE,  0,ZED
db ZED,LO3,  0,  0,ZMR,  0,  0,DOR,ZED,ZED,ZED,ZED,DOR,TRE,ZED,ZED,ZED,TRE,  0,ZED
db ZED,  0,  0,  0,ZMR,  0,  0,DOR,ZED,ZED,ZED,ZED,DOR,TRE,TRE,TRE,TRE,  0,  0,VRA
db ZED,  0,  0,ZMR,ZED,ZMR,  0,DOR,ZED,ZED,ZED,ZED,DOR,TRE,ZED,TRE,  0,  0,  0,ZED
db ZED,  0,  0,ZMR,ZED,ZMR,  0,DOR,ZED,ZED,ZED,ZED,DOR,TRE,ZED,ZED,TRE,  0,  0,ZED
db ZED,  0,ZMR,ZED,ZED,ZED,ZMR,  0,DOR,ZED,ZED,DOR,  0,TRE,ZED,ZED,ZED,TRE,  0,ZED
db ZED,  0,ZMR,ZED,ZED,ZED,ZMR,  0,  0,DOR,DOR,  0,  0,TRE,ZED,ZED,ZED,TRE,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 34:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,LO1,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,VIN,VIN,VIN,VIN,VIN,VIN,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,ZED,VIN,VIN,VIN,VIN,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,VIN,VIN,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,ZED,VIN,VIN,VIN,VIN,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,VIN,VIN,VIN,VIN,VIN,VIN,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,VIN,VIN,VIN,VIN,VIN,VIN,VIN,VIN,ZED,ZED,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 35:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,KOR,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,ZED,VRA,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,KRA,  0,ZIR,ZED,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,ZED,KRA,KRA,  0,ZIR,ZIR,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,LO3,  0,  0,  0,ZED,KRA,KRA,KRA,  0,ZIR,ZIR,ZIR,ZED,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,ZED,KRA,KRA,KRA,  0,ZIR,ZIR,ZIR,ZED,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,ZED,KRA,KRA,  0,ZIR,ZIR,ZED,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,ZED,KRA,  0,ZIR,ZED,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,ZED,  0,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,STO,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 36:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,LO4,ZED,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,ZED
db ZED,ZED,  0,ZED,  0,KOR,  0,ZED,  0,KOR,  0,ZED,  0,KOR,  0,ZED,  0,KOR,  0,ZED
db ZED,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED
db ZED,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED
db ZED,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED
db ZED,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED
db ZED,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED
db ZED,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED,  0,ZED
db ZED,ZED,  0,KOR,  0,ZED,  0,KOR,  0,ZED,  0,KOR,  0,ZED,  0,KOR,  0,ZED,  0,ZED
db ZED,ZED,  0,KRY,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,ZED,  0,KRY,  0,ZED,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED

                                            ; 37:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,ZED,TRE,TRE,TRE,TRE,TRE,TRE,TRE,TRE,TRE,TRE,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,TRE,JAB,JAB,JAB,TRE,TRE,JAB,JAB,JAB,TRE,ZED,  0,  0,  0,ZED
db ZED,  0,KRY,  0,ZED,TRE,JAB,ZED,JAB,TRE,TRE,JAB,ZED,JAB,TRE,ZED,  0,KRY,  0,ZED
db ZED,  0,  0,  0,ZED,JAB,JAB,ZED,JAB,JAB,JAB,JAB,ZED,JAB,JAB,ZED,  0,  0,  0,ZED
db ZED,LO3,KRY,  0,STO,JAB,ZED,ZED,ZED,JAB,JAB,ZED,ZED,ZED,JAB,STO,  0,KRY,  0,VRA
db ZED,  0,  0,  0,ZED,JAB,JAB,ZED,JAB,JAB,JAB,JAB,ZED,JAB,JAB,ZED,  0,  0,  0,ZED
db ZED,  0,KRY,  0,ZED,TRE,JAB,ZED,JAB,TRE,TRE,JAB,ZED,JAB,TRE,ZED,  0,KRY,  0,ZED
db ZED,  0,  0,  0,ZED,TRE,JAB,JAB,JAB,TRE,TRE,JAB,JAB,JAB,TRE,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,TRE,TRE,TRE,TRE,TRE,TRE,TRE,TRE,TRE,TRE,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 38:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,STO,  0,  0,STO,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,LET,  0,  0,  0,STO,ZED,STO,STO,ZED,STO,  0,  0,  0,LET,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,STO,ZED,  0,  0,  0,  0,ZED,STO,  0,  0,  0,  0,  0,ZED
db ZED,LO3,  0,  0,  0,STO,ZED,  0,  0,ZED,STO,  0,  0,ZED,STO,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,STO,ZED,  0,  0,  0,ZED,STO,  0,  0,  0,ZED,STO,  0,  0,  0,ZED
db ZED,  0,  0,STO,ZED,STO,  0,STO,  0,  0,ZED,  0,STO,  0,STO,ZED,STO,  0,  0,ZED
db ZED,  0,STO,ZED,  0,  0,ZED,ZED,STO,STO,ZED,STO,ZED,ZED,  0,  0,ZED,STO,  0,ZED
db ZED,  0,ZED,  0,  0,  0,ZED,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,ZED,STO,VRA
db ZED,ZED,  0,  0,  0,  0,ZED,  0,  0,ZED,  0,  0,  0,ZED,  0,  0,  0,  0,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 39:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,LO3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,POC,POC,POC,POC,POC,POC,ZED,  0,  0,POC,POC,POC,POC,POC,POC,POC,ZED,  0,ZED
db ZED,  0,POC,POC,ZED,  0,POC,POC,ZED,  0,  0,POC,POC,ZED,  0,  0,POC,ZED,  0,ZED
db ZED,  0,POC,POC,ZED,  0,POC,POC,ZED,  0,  0,POC,POC,ZED,  0,  0,POC,ZED,  0,ZED
db ZED,  0,POC,POC,ZED,  0,POC,POC,ZED,  0,  0,POC,POC,ZED,POC,ZED,  0,  0,  0,ZED
db ZED,  0,POC,POC,POC,POC,POC,ZED,  0,  0,  0,POC,POC,POC,POC,ZED,  0,  0,  0,ZED
db ZED,  0,POC,POC,ZED,  0,  0,  0,  0,  0,  0,POC,POC,ZED,POC,ZED,  0,  0,  0,ZED
db ZED,  0,POC,POC,ZED,  0,  0,  0,  0,  0,  0,POC,POC,ZED,  0,  0,  0,  0,  0,ZED
db ZED,  0,POC,POC,ZED,  0,  0,  0,  0,  0,  0,POC,POC,ZED,  0,  0,  0,  0,  0,ZED
db ZED,POC,POC,POC,ZED,ZED,  0,  0,  0,  0,POC,POC,POC,ZED,ZED,  0,  0,  0,  0,VRA
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 40:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,STO,STO,STO,STO,STO,STO,JAB,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,STO,STO,STO,STO,STO,STO,JAB,JAB,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,STO,STO,STO,STO,STO,STO,JAB,JAB,JAB,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,KRA,KRA,KRA,KRA,KRA,KRA,KRA,JAB,JAB,JAB,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,LO3,KRA,KRA,KRA,KRA,KRA,KRA,KRA,JAB,JAB,JAB,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,KRA,KRA,KRA,KRA,KRA,KRA,KRA,JAB,JAB,JAB,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,KRA,KRA,KRA,ZED,KRA,KRA,KRA,JAB,JAB,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,KRA,KRA,KRA,KRA,KRA,KRA,KRA,JAB,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,KRA,KRA,KRA,KRA,KRA,KRA,KRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 41:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,  0,  0,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,  0,  0,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,  0,  0,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,ZIR,  0,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,  0,SLO,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,  0,  0,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,  0,  0,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED,  0,  0,ZED,RYB,ZED,RYB,ZED,RYB,ZED,RYB,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,LO1,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 42:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED,ZED,DOR,VRA,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZMR,ZMR,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,  0,ZMR,ZMR,ZMR,ZMR,  0,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,KRA,ZMR,ZMR,ZIR,ZIR,ZIR,ZIR,ZIR,ZIR,ZMR,ZMR,KRA,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,KRA,ZMR,ZMR,SLO,SLO,SLO,SLO,SLO,SLO,ZMR,ZMR,KRA,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,  0,ZMR,ZMR,ZMR,ZMR,  0,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZMR,ZMR,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,DOR,LO1,ZED,ZED,ZED,ZED,ZED,ZED,ZMR,ZMR,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 43:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,BUD,  0,  0,  0,RYB,ZED,TRE,  0,  0,  0,JAB,  0,  0,  0,  0,ZED
db ZED,  0,  0,ZED,ZED,BUD,  0,ZED,RYB,ZED,TRE,ZED,  0,JAB,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,ZED,ZED,BUD,  0,RYB,ZED,TRE,  0,JAB,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,ZED,ZED,ZED,BUD,RYB,ZED,TRE,JAB,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,LO3,STO,STO,STO,STO,STO,STO,  0,VRA,  0,STO,STO,STO,STO,STO,STO,STO,  0,ZED
db ZED,  0,  0,ZED,ZED,ZED,ZED,JAB,TRE,ZED,RYB,BUD,ZED,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,ZED,ZED,JAB,  0,TRE,ZED,RYB,  0,BUD,ZED,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,ZED,JAB,  0,ZED,TRE,ZED,RYB,ZED,  0,BUD,ZED,ZED,  0,  0,  0,ZED
db ZED,  0,  0,ZED,JAB,  0,ZED,ZED,TRE,ZED,RYB,ZED,ZED,  0,BUD,ZED,  0,  0,  0,ZED
db ZED,  0,  0,JAB,  0,  0,  0,  0,TRE,  0,RYB,  0,  0,  0,  0,BUD,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 44:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,  0,STO,STO,  0,ZED,ZED,ZED,ZED,ZED,  0,STO,STO,  0,ZED,ZED,ZED,ZED,ZED
db ZED,  0,STO,ZED,ZED,STO,ZED,ZED,STO,STO,  0,STO,ZED,ZED,STO,  0,STO,STO,  0,ZED
db ZED,STO,ZED,ZED,ZED,  0,STO,STO,  0,  0,STO,  0,ZED,ZED,  0,STO,  0,  0,STO,ZED
db ZED,STO,ZED,  0,STO,STO,STO,ZED,  0,STO,ZED,STO,ZED,  0,STO,ZED,STO,ZED,  0,VRA
db ZED,LO3,ZED,STO,ZED,ZED,STO,ZED,STO,ZED,ZED,STO,ZED,STO,ZED,ZED,STO,ZED,ZED,ZED
db ZED,ZED,ZED,STO,ZED,ZED,STO,ZED,STO,ZED,ZED,STO,ZED,STO,ZED,ZED,STO,ZED,ZED,ZED
db ZED,ZED,ZED,STO,ZED,STO,  0,ZED,STO,ZED,ZED,STO,ZED,STO,ZED,ZED,STO,ZED,ZED,ZED
db ZED,ZED,ZED,  0,STO,  0,ZED,ZED,STO,ZED,STO,  0,ZED,STO,ZED,STO,  0,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,STO,  0,ZED,ZED,  0,STO,  0,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 45:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,ZMR,ZMR,  0,LO1,  0,  0,DOR,DOR,  0,  0,  0,  0,TRE,TRE,  0,  0,  0,ZED
db ZED,ZMR,ZED,ZED,ZMR,  0,  0,DOR,ZED,ZED,DOR,  0,  0,TRE,ZED,ZED,TRE,  0,  0,ZED
db ZED,ZMR,ZED,ZED,ZMR,  0,  0,DOR,ZED,ZED,DOR,  0,  0,TRE,ZED,ZED,TRE,  0,  0,ZED
db VRA,  0,ZMR,ZMR,  0,  0,  0,  0,DOR,DOR,  0,  0,  0,  0,TRE,TRE,  0,  0,  0,ZED
db ZED,ZED,STO,STO,ZED,ZED,ZED,ZED,STO,STO,ZED,ZED,ZED,ZED,STO,STO,ZED,ZED,ZED,ZED
db ZED,ZED,STO,STO,ZED,ZED,ZED,ZED,STO,STO,ZED,ZED,ZED,ZED,STO,STO,ZED,ZED,ZED,ZED
db ZED,  0,ZMR,ZMR,  0,  0,  0,  0,DOR,DOR,  0,  0,  0,  0,JAB,JAB,  0,  0,  0,ZED
db ZED,ZMR,ZED,ZED,ZMR,  0,  0,DOR,ZED,ZED,DOR,  0,  0,JAB,ZED,ZED,JAB,  0,  0,ZED
db ZED,ZMR,ZED,ZED,ZMR,  0,  0,DOR,ZED,ZED,DOR,  0,  0,JAB,ZED,ZED,JAB,  0,  0,ZED
db ZED,  0,ZMR,ZMR,  0,  0,  0,  0,DOR,DOR,  0,  0,  0,  0,ZED,ZED,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 46:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,LO3,  0,SLO,  0,ZED,KRA,KRA,ZED,  0,ZIR,  0,ZIR,  0,ZIR,  0,ZED,  0,  0,ZED
db ZED,  0,SLO,  0,SLO,ZED,KRA,ZIR,ZED,  0,  0,SLO,  0,SLO,  0,  0,ZED,STO,RYB,ZED
db ZED,  0,  0,SLO,  0,ZED,KRA,KRA,  0,  0,  0,  0,KRA,  0,  0,  0,  0,  0,  0,ZED
db ZED,SLO,  0,  0,  0,ZED,SLO,KRA,KRA,  0,ZIR,  0,  0,  0,ZIR,  0,ZED,ZED,ZED,ZED
db ZED,  0,SLO,  0,  0,ZED,ZED,ZED,ZED,  0,  0,SLO,  0,SLO,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,  0,SLO,  0,SLO,  0,SLO,  0,ZED,ZED,ZED,ZED,SLO,  0,  0,  0,ZED
db ZED,  0,STO,  0,  0,  0,SLO,  0,SLO,  0,  0,ZIR,ZIR,ZIR,ZED,SLO,SLO,  0,  0,ZED
db ZED,RYB,RYB,ZED,SLO,  0,  0,SLO,  0,  0,  0,  0,ZIR,ZIR,ZED,SLO,SLO,SLO,  0,ZED
db VRA,STO,STO,ZED,  0,SLO,  0,  0,SLO,  0,  0,ZED,ZIR,ZIR,ZED,SLO,SLO,SLO,SLO,ZED
db ZED,RYB,RYB,ZED,SLO,  0,SLO,  0,  0,  0,ZIR,ZED,ZIR,ZIR,ZED,SLO,SLO,SLO,SLO,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 47:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,VIN,  0,  0,  0,  0,  0,  0,  0,VIN,  0,  0,  0,  0,  0,ZED
db ZED,  0,ZED,ZED,ZED,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,AUT,AUT,AUT,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,AUT,AUT,AUT,AUT,  0,ZED
db ZED,  0,ZED,ZED,ZED,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,AUT,AUT,AUT,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,AUT,AUT,AUT,AUT,  0,ZED
db ZED,LO3,ZED,ZED,ZED,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,AUT,AUT,AUT,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,AUT,AUT,AUT,AUT,  0,ZED
db ZED,  0,ZED,ZED,ZED,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,ZED,ZED,ZED,ZED,  0,ZED
db ZED,  0,AUT,AUT,AUT,VIN,ZED,AUT,ZED,LET,ZED,AUT,ZED,VIN,AUT,AUT,AUT,AUT,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,VRA,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 48:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,  0,  0,ZED
db ZED,  0,TRE,ZED,JAB,  0,ZED,ZIR,ZIR,ZIR,ZIR,ZIR,ZIR,ZED,  0,JAB,ZED,TRE,  0,ZED
db ZED,  0,TRE,ZED,JAB,  0,ZED,STO,ZED,KRA,KRA,ZED,STO,ZED,  0,JAB,ZED,TRE,  0,ZED
db ZED,  0,TRE,ZED,JAB,  0,ZED,SLO,SLO,ZED,ZED,SLO,SLO,ZED,  0,JAB,ZED,TRE,  0,ZED
db ZED,LO3,ZED,ZED,ZED,  0,ZMR,SLO,SLO,RYB,RYB,SLO,SLO,ZMR,  0,ZED,ZED,ZED,  0,VRA
db ZED,  0,JAB,ZED,TRE,  0,ZED,SLO,SLO,ZED,ZED,SLO,SLO,ZED,  0,TRE,ZED,JAB,  0,ZED
db ZED,  0,JAB,ZED,TRE,  0,ZED,STO,ZED,KRA,KRA,ZED,STO,ZED,  0,TRE,ZED,JAB,  0,ZED
db ZED,  0,JAB,ZED,TRE,  0,ZED,ZIR,ZIR,ZIR,ZIR,ZIR,ZIR,ZED,  0,TRE,ZED,JAB,  0,ZED
db ZED,  0,  0,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 49:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,LO3,  0,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,  0,ZED,STO,ZED,ZED,STO,STO,ZED,STO,STO,ZED,STO,STO,ZED,ZED,STO,ZED,  0,ZED
db ZED,  0,ZED,STO,  0,ZED,ZED,STO,ZED,STO,STO,ZED,STO,ZED,ZED,  0,STO,ZED,  0,ZED
db ZED,  0,ZED,LET,STO,  0,ZED,STO,STO,ZED,ZED,STO,STO,ZED,  0,STO,LET,ZED,  0,ZED
db ZED,  0,  0,ZED,LET,STO,  0,STO,STO,ZED,ZED,STO,STO,  0,STO,LET,ZED,  0,  0,ZED
db ZED,  0,  0,  0,ZED,LET,STO,  0,ZED,STO,STO,ZED,  0,STO,LET,ZED,  0,  0,  0,ZED
db ZED,  0,  0,  0,  0,ZED,LET,STO,ZED,STO,STO,ZED,STO,LET,ZED,  0,  0,  0,  0,ZED
db ZED,  0,KRA,  0,  0,  0,ZED,AUT,AUT,AUT,AUT,AUT,AUT,ZED,  0,  0,  0,KRA,  0,ZED
db ZED,  0,  0,KRA,  0,  0,  0,ZED,ZED,ZED,ZED,ZED,ZED,  0,  0,  0,KRA,  0,  0,ZED
db ZED,  0,  0,  0,  0,  0,  0,  0,  0,VRA,ZED,  0,  0,  0,  0,  0,  0,  0,  0,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED

                                            ; 50:
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED
db ZED,KRY,KOR,STO,JAB,KRA,TRE,RYB,ZIR,ZMR,DOR,POC,AUT,BAL,BUD,SLO,VIN,PEN,LET,ZED
db ZED,KRY,KOR,STO,JAB,ZED,ZED,ZED,ZED,ZMR,DOR,ZED,ZED,ZED,ZED,SLO,VIN,PEN,LET,ZED
db ZED,KRY,KOR,STO,JAB,ZED,TRE,RYB,ZIR,ZMR,DOR,ZED,  0,  0,ZED,SLO,VIN,PEN,LET,ZED
db VRA,KRY,KOR,STO,JAB,ZED,TRE,RYB,ZIR,ZMR,DOR,ZED,  0,  0,ZED,SLO,VIN,PEN,LET,ZED
db ZED,LO3,KOR,STO,JAB,ZED,ZED,ZED,ZED,ZMR,DOR,ZED,  0,  0,ZED,SLO,VIN,PEN,LET,ZED
db ZED,KRY,KOR,STO,JAB,KRA,TRE,RYB,ZED,ZMR,DOR,ZED,  0,  0,ZED,SLO,VIN,PEN,LET,ZED
db ZED,KRY,KOR,STO,JAB,KRA,TRE,RYB,ZED,ZMR,DOR,ZED,  0,  0,ZED,SLO,VIN,PEN,LET,ZED
db ZED,KRY,KOR,STO,JAB,ZED,TRE,RYB,ZED,ZMR,DOR,ZED,  0,  0,ZED,SLO,VIN,PEN,LET,ZED
db ZED,KRY,KOR,STO,JAB,ZED,ZED,ZED,ZED,ZMR,DOR,ZED,ZED,ZED,ZED,SLO,VIN,PEN,LET,ZED
db ZED,KRY,KOR,STO,JAB,KRA,TRE,RYB,ZIR,ZMR,DOR,POC,AUT,BAL,BUD,SLO,VIN,PEN,LET,ZED
db ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED,ZED


	include	TRAIN.INC

Code     ENDS
         END       Start
