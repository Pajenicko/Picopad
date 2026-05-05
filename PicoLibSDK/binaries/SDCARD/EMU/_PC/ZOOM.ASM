
; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
;
;                         Programov˜ segment
;
; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

; Sou©adnice obr zk– se ud vaj¡ s rozli¨en¡m:
;     X = 0 a‘ 159 bod– (tj. 2 jednotky na bajt)
;     Y = 0 a‘ 199 (tj. 1 jednotka na 1 linku)

KORIG    EQU       0 ;4db0h                    ; korekce adres program. segmentu
HI       EQU       256
OBZOR    EQU       56                       ; po‡et linek na obzor
MAXOBJ   EQU       16                       ; maxim ln¡ po‡et objekt– v tabulce
MAXFAZE  EQU       9                        ; max. po‡et f z¡ objektu

bit0     EQU       1
bit1     EQU       2
bit2     EQU       4
bit3     EQU       8
bit4     EQU       10h
bit5     EQU       20h
bit6     EQU       40h
bit7     EQU       80h

Code     SEGMENT
         ASSUME    cs:Code
         ORG       100h

Start    PROC      FAR

; ------ inicializace datov‚ho segmentu

l4eb0:
         ASSUME    ds:Code
         mov       ax,cs

         add       ax,(offset(CodeEnd-Start)+10fh)/16 + (offset(Data2End-Data2Str)+0fh)/16
;         add       ax,233h

         mov       ds,ax
         ASSUME    ds:Data

; ------ inicializace z sobn¡ku

         mov       ax,cs

         add       ax,(offset(CodeEnd-Start)+10fh)/16 + (offset(Data2End-Data2Str)+0fh)/16 + (offset(DataEnd-DataStrt)+0fh)/16 - 0a0h
;         add       ax,0e10h

         cli
         mov       ss,ax
         mov       sp,1000h
         sti

; ------ inicializace segmentu ES (nastaven¡ na videopamˆŸ)

         mov       ax,0b800h
         mov       es,ax

; ------ start programu (korekce segmentu CS)

         mov       ax,cs
         sub       ax,KORIG/16
         push      ax
         mov       ax,offset Start1 + KORIG
         push      ax
         ret

Start    ENDP

         nop
         nop
         nop

; -----------------------------------------------------------------------------
;    vstup znaku z bufferu kl vesnice a p©¡padn‚ p©eru¨en¡ programu
; -----------------------------------------------------------------------------
; VSTUP: DS:BX=adresa v bufferu kl vesnice
; VSTUP:AX=znak z bufferu kl vesnice
; -----------------------------------------------------------------------------

l4ed6    PROC      NEAR

         mov       ax,ds:[bx]               ; znak z bufferu kl vesnice
         and       ah,0ffh                  ; (to je trochu blbost)
         dec       ah                       ; je scan k¢d 1 = kl vesa ESC ?
         jz        l4ee3                    ; je ESC - p©eru¨en¡ programu
         mov       ax,ds:[1eh]              ; znak z bufferu kl vesnice
         ret

l4ed6    ENDP

l4ee3    PROC      FAR

; ------ konec programu

         mov       ax,3                     ; standardn¡ videom¢d 3
         int       10h                      ; n vrat videom¢du
         mov       al,ds:[17h]              ; statut p©esmyka‡– kl vesnice
         and       al,0dfh                  ; vypnut¡ NUM LOCK
         mov       ds:[17h],al              ; nov˜ stav p©esmyka‡–
         mov       ax,cs                    ; CS
         add       ax,KORIG/16              ; n vrat p–vodn¡ho CS
         push      ax                       ; to je segment n vratov‚ adresy
         mov       ax,offset l4efe          ; offset n vratov‚ adresy - INT 20h
         push      ax                       ; offset n vratov‚ adresy
         ret                                ; skok na instrukci INT 20h

         nop
         nop
         nop

l4efe:   int       20h                      ; ukon‡en¡ programu

l4ee3    ENDP

l4f00    db        0fh,8eh,0d0h,0b8h,0,10h,8bh,0e0h ; (???)

; -----------------------------------------------------------------------------
;    start programu
; -----------------------------------------------------------------------------

; ------ inicializace videom¢du

Start1:  mov       ax,4
         sti
         int       10h                      ; inicializace videom¢du 4

         call      l5173                    ; sestaven¡ tabulky adres linek

; ------ inicializace ukazatel– maxim ln¡ho a dosa‘en‚ho sk¢re

         mov       cx,4                     ; d‚lka jedn‚ promˆnn‚
         mov       si,0                     ; po‡ te‡n¡ offset
l4f17:   mov       byte ptr ds:[si+da76e],0 ; nulov n¡ maxim ln¡ho sk¢re
         mov       byte ptr ds:[si+da772],0 ; nulov n¡ dosa‘en‚ho sk¢re
         inc       si                       ; zv˜¨en¡ ukazatele
         loop      l4f17                    ; dal¨¡ bajt sk¢re

; ------ inicializace sc‚ny, p©eru¨en¡ hry

l4f24:   jmp       l5624                    ; inicializace sc‚ny

; -----------------------------------------------------------------------------
;    z kladn¡ cyklus obsluhy hry
; -----------------------------------------------------------------------------

l4f27    PROC      NEAR

; ------ z kladn¡ cyklus hry

         mov       ax,1000h
         mov       sp,ax                    ; z sobn¡k
         call      l6190                    ; vstup z kl vesnice nebo joysticku
         call      l5a0e                    ; posun podkladu p©i posunu rakety
         call      l5195                    ; obsluha posunu zemˆ
         call      l67d0                    ; obsluha hry melodie
         call      l5b80                    ; (?) zobrazen¡ a obsluha v¨ech objekt–
         call      l500d                    ; obsluha pohybu letadla
         call      l5e36                    ; generov n¡ st©el
         call      l60d2                    ; generov n¡ br ny
         call      l5e87                    ; generov n¡ disku (mal‚ UFO)
         call      l55e7                    ; generov n¡ velk‚ho UFO
         call      l6418                    ; obsluha z sah– nep©¡tele st©elami
         call      l6347                    ; ‡¡t n¡ a zobrazen¡ sk¢re
         call      l4f61                    ; ‡¡t n¡ a zobrazen¡ paliva
         call      l54bf                    ; generov n¡ bomb velk‚ho UFO
         call      l553a                    ; generov n¡ bomb br ny
         call      l53f8                    ; generov n¡ kosmick‚ lodi a bomb
         call      l53b0                    ; generov n¡ nov‚ hvˆzdy (sc‚na X.3)

;         push      ds
;         xor       ax,ax
;         mov       ds,ax
;         mov       ax,ds:[46ch]
;cccc:    sti
;         cmp       ax,ds:[46ch]
;         je        cccc
;         pop       ds

;         sti                                ; p©eru¨en¡ povoleno
;         mov       dx,3dah                  ; stavov˜ registr videokarty
;wait11:  in        al,dx                    ; ‡ten¡ stavov‚ho registru
;         test      al,8                     ; je vertik ln¡ impuls ?
;         jnz       wait11                  ; ‡ek n¡ na konec synchroimpulsu
;wait12:  in        al,dx                    ; ‡ten¡ stavov‚ho registru
;         test      al,8                     ; je vertik ln¡ impuls ?
;         jz        wait12                  ; ‡ek n¡ na vertik ln¡ impuls

;wait13:  in        al,dx                    ; ‡ten¡ stavov‚ho registru
;         test      al,8                     ; je vertik ln¡ impuls ?
;         jnz       wait13                  ; ‡ek n¡ na konec synchroimpulsu
;wait14:  in        al,dx                    ; ‡ten¡ stavov‚ho registru
;         test      al,8                     ; je vertik ln¡ impuls ?
;         jz        wait14                  ; ‡ek n¡ na vertik ln¡ impuls


         jmp       l4f27                    ; nov˜ cyklus

l4f27    ENDP

; -----------------------------------------------------------------------------
;    obsluha indikace paliva
; -----------------------------------------------------------------------------

; ------ test, zda zbylo nˆjak‚ palivo

l4f61    PROC      NEAR

         mov       al,ds:[da74e]            ; z soba paliva (bajt 2)
         or        al,ds:[da74d]            ; z soba paliva (bajt 1)
         or        al,ds:[da74c]            ; z soba paliva (bajt 0)
         jnz       l4f6f                    ; zbylo nˆjak‚ palivo
l4f6e:   ret

; ------ sn¡‘en¡ z soby paliva

l4f6f:   mov       al,ds:[da758]            ; rychlost letu (30 a‘ 120)
         xor       al,0ffh
         inc       al                       ; negace rychlosti
         mov       ah,0
         mul       byte ptr ds:[d0018]      ; rychlost £bytku paliva
         sub       word ptr ds:[da74c],ax   ; sn¡‘en¡ z soby paliva
         jnc       l4f6e                    ; nen¡ p©enos
         sbb       byte ptr ds:[da74e],0    ; p©enos HIGH
         jnc       l4f94                    ; nen¡ p©enos
         mov       word ptr ds:[da74c],0    ; vynulov n¡ z soby paliva
         mov       byte ptr ds:[da74e],0

; ====== zde se vol  zobrazen¡ paliva p©i inicializaci

; ------ vymaz n¡ ukazatele paliva

l4f94:   mov       dl,4                     ; po‡et videolinek
         mov       si,34                    ; ‡¡slo po‡ te‡n¡ linky
l4f99:   mov       bx,si                    ; ‡¡slo videolinky
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa linky ve videopamˆti
         add       bx,7                     ; + po‡ te‡n¡ pozice
         mov       cx,66                    ; d‚lka ukazatele
         mov       al,0                     ; ‡ern  barva
l4fa9:   mov       es:[bx],al               ; vymaz n¡
         inc       bx
         loop      l4fa9                    ; dal¨¡ bajt
         inc       si                       ; ukazatel ‡¡sla linky
         dec       dl                       ; ‡¡ta‡ linek k zobrazen¡
         jnz       l4f99                    ; zobrazen¡ dal¨¡ linky

; ------ stanoven¡ d‚lky ukazatele paliva

         mov       al,ds:[da74e]            ; ukazatel paliva
         cmp       al,80h                   ; p©ekro‡ena d‚lka ?
         jb        l4fbd                    ; d‚lka OK
         mov       al,7fh                   ; omezen¡ mno‘stv¡ paliva
l4fbd:   mov       ah,0
         mov       word ptr ds:[da716],ax   ; d‚lka ukazatele paliva

; ------ zobrazen¡ ukazatele paliva

         mov       dl,2                     ; po‡et linek k zobrazen¡
         mov       si,35                    ; po‡ te‡n¡ linka
l4fc7:   mov       bx,si                    ; ‡¡slo videolinky
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa videolinky
         add       bx,8                     ; + po‡ te‡n¡ pozice
         mov       al,0aah                  ; purpurov  barva
         mov       cx,word ptr ds:[da716]   ; d‚lka ukazatele paliva
         shr       cx,1                     ; d‚lka ukazatele paliva / 2
         jz        l4fe2                    ; nen¡ palivo
l4fdc:   mov       es:[bx],al               ; vymaz n¡ bajtu
         inc       bx
         loop      l4fdc                    ; dal¨¡ bajt na lince
l4fe2:   test      byte ptr ds:[da716],1    ; lich  pozice ?
         jz        l4fee                    ; sud  pozice
         mov       al,0a0h                  ; polovina pozice
         mov       es:[bx],al               ; posledn¡ bajt
l4fee:   inc       si                       ; zv˜¨en¡ ukazatele videolinky
         dec       dl                       ; ‡¡ta‡ linek k zobrazen¡
         jnz       l4fc7                    ; dal¨¡ linka

; ------ hl ¨en¡ o nedostatku paliva

l4ff3:   cmp       byte ptr ds:[da74e],16   ; je jestˆ dost paliva ?
         jae       l500c                    ; je dost paliva
         mov       si,offset d0019          ; text - m lo paliva
         call      l5a61                    ; zobrazen¡ textu DS:SI
         cmp       byte ptr ds:[da74e],6    ; je velmi m lo paliva ?
         jae       l500c                    ; palivo OK
         mov       al,6                     ; ‡¡slo melodie - palivo do¨lo
         call      l680e                    ; zvukov  indikace - nen¡ palivo
l500c:   ret

l4f61    ENDP

; -----------------------------------------------------------------------------
;        obsluha pohybu letadla
; -----------------------------------------------------------------------------

l500d    PROC      NEAR

         call      l50af                    ; vymaz n¡ letadla se st¡nem

; ------ rozli¨en¡ povel– pro smˆr vlevo/vpravo

         test      byte ptr ds:[da736],80h  ; povel vpravo ?
         jz        l5026                    ; vpravo
         test      byte ptr ds:[da736],10h  ; povel vlevo ?
         jz        l503a                    ; vlevo
         mov       byte ptr ds:[da740],1    ; jinak smˆr p©¡m˜
         jmp       short l504b
         nop

; ------ letadlo vpravo

l5026:   mov       byte ptr ds:[da740],2    ; smˆr pohybu letadla vpravo
         mov       al,ds:[da759]            ; poloha letadla horizont lnˆ X
         add       al,5                     ; zv˜¨en¡ pozice letadla
         cmp       al,186                   ; maxim ln¡ pozice
         ja        l504b                    ; je ji‘ prav˜ okraj
         mov       ds:[da759],al            ; nov  pozice letadla X
         jmp       short l504b
         nop

; ------ letadlo vlevo

l503a:   mov       byte ptr ds:[da740],0    ; smˆr pohybu letadla vlevo
         mov       al,ds:[da759]            ; poloha letadla X
         sub       al,5                     ; sn¡‘en¡ pozice letadla
         cmp       al,40                    ; minim ln¡ pozice 40
         jb        l504b                    ; je ji‘ lev˜ okraj
         mov       ds:[da759],al            ; nov  pozice letadla X

; ------ rozli¨en¡ povel– dol–/nahoru

l504b:   test      byte ptr ds:[da736],4    ; povel nahoru ?
         jz        l5065                    ; je povel nahoru
         test      byte ptr ds:[da736],8    ; povel dol– ?
         jnz       l5097                    ; nen¡ povel dol–

; ------ povel dol– - sn¡‘en¡ rychlosti

         mov       al,ds:[da75a]            ; poloha letadla vertik lnˆ Y
         add       al,5                     ; posun letadla dol–
         cmp       al,104                   ; maxim ln¡ linka 104
         jae       l5087                    ; je ji‘ spodn¡ okraj - zpomalen¡
         jmp       short l506e
         nop

; ------ povel nahoru - zv˜¨en¡ rychlosti

l5065:   mov       al,ds:[da75a]            ; poloha letadla vertik lnˆ Y
         sub       al,5                     ; posun letadla nahoru
         cmp       al,79                    ; maxim ln¡ linka 79
         jb        l5074                    ; je ji‘ horn¡ okraj - zrychlen¡
l506e:   mov       byte ptr ds:[da75a],al   ; nov  vertik ln¡ poloha letadla Y
         jmp       short l5097
         nop

; ------ zrychlen¡ letu

l5074:   inc       byte ptr ds:[da758]      ; zv˜¨en¡ rychlosti letu
         cmp       byte ptr ds:[da758],120  ; maxim ln¡ rychlost 120
         jbe       l5097                    ; rychlost OK
         mov       byte ptr ds:[da758],120  ; omezen¡ rychlosti
         jmp       short l5097
         nop

; ------ zpomalen¡ letu

l5087:   dec       byte ptr ds:[da758]      ; sn¡‘en¡ rychlosti letu
         mov       al,ds:[da758]            ; rychlost letu
         cmp       al,30                    ; minim ln¡ rychlost 30
         jae       l5097                    ; OK
         mov       al,30
         mov       ds:[da758],al            ; omezen¡ rychlosti

; ------ zobrazen¡ letadla na nov‚ pozici

l5097:   call      l509b                    ; zobrazen¡ letadla
         ret

l500d    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ letadla (se st¡nem)
; -----------------------------------------------------------------------------

l509b    PROC      NEAR

         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jnz       l50a8                    ; nen¡ zobrazena zemˆ
         call      l50c2                    ; p©¡prava k zobrazen¡ st¡nu
         call      l5232                    ; zobrazen¡ st¡nu
l50a8:   call      l50d3                    ; p©¡prava k zobrazen¡ letadla
         call      l5232                    ; zobrazen¡ letadla
         ret

l509b    ENDP

; -----------------------------------------------------------------------------
;        vymaz n¡ letadla (se st¡nem)
; -----------------------------------------------------------------------------

l50af    PROC      NEAR

         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jnz       l50bc                    ; nen¡ zobrazena zemˆ
         call      l50c2                    ; p©¡prava k vymaz n¡ st¡nu letadla
         call      l5287                    ; vymaz n¡ st¡nu
l50bc:   call      l50d3                    ; p©¡prava k vymaz n¡ letadla
         call      l5287                    ; vymaz n¡ letadla
                                            ; (zde chyb¡ RET !)

l50af    ENDP

; -----------------------------------------------------------------------------
;    p©¡prava k zobrazen¡/vymaz n¡ st¡nu letadla
; -----------------------------------------------------------------------------

l50c2    PROC      NEAR

         mov       al,3                     ; obr zek - st¡n letadla
         mov       ds:[da732],al            ; ‡¡slo obr zku k zobrazen¡
         mov       al,ds:[da759]            ; poloha letadla horizont lnˆ X
         mov       ds:[da733],al            ; pozice k zobrazen¡ st¡nu X
         mov       byte ptr ds:[da734],124  ; ‡¡slo linky k zobrazen¡ st¡nu Y
         ret

l50c2    ENDP

; -----------------------------------------------------------------------------
;    p©¡prava k zobrazen¡ letadla
; -----------------------------------------------------------------------------

l50d3    PROC      NEAR

         mov       al,ds:[da740]            ; f ze zobrazen¡ letadla (sklon)
         mov       ds:[da732],al            ; ‡¡slo obr zku k zobrazen¡
         mov       al,ds:[da759]            ; poloha letadla horizont lnˆ X
         mov       ds:[da733],al            ; pozice k zobrazen¡ letadla
         mov       al,ds:[da75a]            ; poloha letadla vertik lnˆ Y
         mov       ds:[da734],al            ; ‡¡slo linky k zobrazen¡ letadla
         ret

l50d3    ENDP

; -----------------------------------------------------------------------------
;    £vodn¡ zobrazen¡ sc‚ny (pozad¡)
; -----------------------------------------------------------------------------

l50e6    PROC      NEAR

; ------ zobrazen¡ oblohy v pozad¡ (56 linek)

         mov       si,0                     ; ukazatel ‡¡sla linky
         mov       ax,5555h                 ; modrozelen  barva
l50ec:   mov       bx,ds:[si+da4b0]         ; adresa videolinky
         mov       cx,40                    ; d‚lka videolinky (slov)
l50f3:   mov       es:[bx],ax               ; ulo‘en¡ barvy
         inc       bx
         inc       bx
         loop      l50f3                    ; dal¨¡ slovo na © dku
         inc       si
         inc       si                       ; ukazatel ‡¡sla linky
         cmp       si,OBZOR*2               ; je posledn¡ linka ?
         jne       l50ec                    ; dal¨¡ linka

; ------ zobrazen¡ poho©¡ v pozad¡ (10 linek)

         mov       si,45*2                  ; po‡ te‡n¡ linka * 2
         mov       di,0                     ; ukazatel v obr zku
l5107:   mov       bx,ds:[si+da4b0]         ; adresa videolinky
         mov       cx,80                    ; po‡et bajt– na linku
l510e:   mov       al,ds:[di+da0e8]         ; obr zek poho©¡ v d lce
         mov       es:[bx],al               ; ulo‘en¡ bajtu
         inc       di
         inc       bx
         loop      l510e                    ; dal¨¡ bajt na © dku
         inc       si
         inc       si
         cmp       si,55*2
         jne       l5107                    ; dal¨¡ linka obr zku

; ------ test, zda se zobraz¡ tov rna v d lce (kromˆ prvn¡ sekce)

         mov       al,ds:[da76b]            ; ‡¡slo sc‚ny
         and       al,0fch                  ; ‡¡slo sekce (bez ‡¡sla podsc‚ny)
         jz        l5172                    ; je prvn¡ sekce - nen¡ tov rna

; ------ ur‡en¡ adresy obr zku tov rny

         mov       di,4                     ; offset adresy pro sc‚nu 12 a v¡ce
         cmp       al,12                    ; je sc‚na 12 ?
         jnc       l5137                    ; je sc‚na 12 nebo v¡ce
         mov       ah,0                     ; AX = ‡¡slo sc‚ny
         shr       ax,1                     ; ‡¡slo sc‚ny / 2
         sub       ax,2                     ; (‡¡slo sc‚ny-1) / 2
         mov       di,ax                    ; offset adresy 0 nebo 2

; ------ p©enos definice obr zku tov rny do pracovn¡ tabulky ukazatel–

l5137:   mov       si,0                     ; ukazatel v pracovn¡ tabulce param.
         mov       cx,4                     ; po‡et parametr– k p©enosu
l513d:   mov       ax,word ptr ds:[di+d0000] ; parametr k p©enosu
         mov       word ptr ds:[si+da716],ax ; ulo‘en¡ parametru
         add       si,2                     ; offset k ukl d n¡ parametr–
         add       di,6                     ; adresa dal¨¡ho parametru
         loop      l513d                    ; p©enos dal¨¡ho parametru

; ------ zobrazen¡ tov rny

         mov       si,word ptr ds:[da716]   ; po‡ te‡n¡ ‡¡slo videolinky
         mov       di,word ptr ds:[da718]   ; adresa obr zku
l5155:   mov       bx,ds:[si+da4b0]         ; adresa videolinky
         add       bx,word ptr ds:[da71a]   ; po‡ te‡n¡ pozice obr zku
         mov       cx,ds:[da71c]            ; ¨¡©ka obr zku (bajt– na linku)
l5161:   mov       al,ds:[di]               ; bajt k zobrazen¡
         mov       es:[bx],al               ; ulo‘en¡ do videopamˆti
         inc       di
         inc       bx
         loop      l5161                    ; dal¨¡ bajt na lince
         add       si,2                     ; zv˜¨en¡ ukazatele videolinek
         cmp       si,55*2                  ; posledn¡ linka ?
         jne       l5155                    ; nen¡ posledn¡ linka

l5172:   ret

l50e6    ENDP

; -----------------------------------------------------------------------------
;    sestaven¡ tabulky adres videolinek
; -----------------------------------------------------------------------------

l5173    PROC      NEAR

         mov       cx,200                   ; po‡et videolinek
         mov       si,0                     ; ukazatel v tabulce linek
l5179:   mov       ax,si                    ; ‡¡slo linky * 2
         shr       ax,1                     ; ‡¡slo linky
         shr       ax,1                     ; linka / 2
         imul      byte ptr ds:[da714]      ; adresa linky/2
         test      si,2                     ; je to sud  linka ?
         jz        l518c
         add       ax,2000h                 ; korekce adresy linky
l518c:   mov       ds:[si+da4b0],ax         ; ulo‘en¡ adresy linky
         inc       si
         inc       si                       ; zv˜¨en¡ ukazatele v tabulce
         loop      l5179                    ; dal¨¡ linka
         ret

l5173    ENDP

; -----------------------------------------------------------------------------
;    obsluha posunu zemˆ
; -----------------------------------------------------------------------------

l5195    PROC      NEAR

; ------ test, zda se zemˆ zobrazuje

         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jz        l519d                    ; je zobrazena
         ret

; ------ ur‡en¡ barvy linky zemˆ podle ‡¡sla sc‚ny

l519d:   mov       bl,ds:[da76b]            ; ‡¡slo sc‚ny (0 a‘ 19)
         mov       bh,0
         shr       bx,1
         shr       bx,1                     ; sc‚na / 4
         db        81h,0e3h,3,0
;         and       bx,3
         mov       al,ds:[bx+d0024]         ; tabulka barev linek
         mov       ds:[d0028],al            ; aktu ln¡ barva linek

; ------ adresa v tabulce linek p©edchoz¡ f ze

         mov       ah,0
         mov       al,ds:[da753]            ; p©edchoz¡ f ze v tabulce
         shl       al,1
         shl       al,1
         shl       al,1
         mov       si,ax                    ; offest v tabulce linek

; ------ posun relativn¡ho ukazatele ubˆhl‚ vzd lenosti

         mov       ah,0
         mov       al,ds:[da758]            ; rychlost letu
         mov       dh,0
         mov       dl,ds:[da754]            ; relativn¡ uletˆn  vzd lenost
         add       ax,dx                    ; posun pozad¡
         mov       ds:[da754],al            ; f ze

; ------ v˜po‡et nov‚ f ze v tabulce adres linek

         mov       cl,5                     ; po‡et rotac¡
         shr       ax,cl
         shr       dx,cl
         sub       al,dl                    ;
         add       al,ds:[da753]            ; + star  f ze
         cmp       al,13
         jb        l51e1
         sub       al,13                    ; oprava f ze
l51e1:   mov       ah,0
         mov       ds:[da753],al

; ------ nov  adresa v tabulce linek

         shl       al,1
         shl       al,1
         shl       al,1
         mov       di,ax                    ; adresa nov˜ch linek
         mov       cx,8                     ; po‡et linek k zobrazen¡

; ------ vymaz n¡ star‚ linky

l51f1:   mov       al,ds:[si+da408]         ; ‡¡slo star‚ linky
         cmp       al,0ffh
         je        l5203                    ; neplatn  linka
         add       al,OBZOR                 ; + po‡ te‡n¡ linka zemˆ
         call      l521b                    ; adresa videolinky AL
         mov       al,0                     ; ‡ern  barva
         call      l5226                    ; vymaz n¡ videolinky bajtem AL

; ------ zobrazen¡ nov‚ linky

l5203:   mov       al,ds:[di+da408]         ; ‡¡slo nov‚ linky
         cmp       al,0ffh                  ; zobraz¡ se linka ?
         je        l5216                    ; linka se nezobraz¡
         add       al,OBZOR                 ; + po‡ te‡n¡ linka zemˆ
         call      l521b                    ; adresa videolinky AL
         mov       al,ds:[d0028]            ; barva k zobrazen¡ videolinky
         call      l5226                    ; vymaz n¡ videolinky bajtem AL

; ------ p©¡prava pro dal¨¡ linku

l5216:   inc       di                       ; ukazatel nov‚ linky
         inc       si                       ; ukazatel star‚ linky
         loop      l51f1
         ret

l5195    ENDP

; -----------------------------------------------------------------------------
;    adresa videolinky AL
; -----------------------------------------------------------------------------

l521b    PROC      NEAR

         mov       bh,0
         mov       bl,al                    ; ‡¡slo videolinky
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa videolinky
         ret

l521b    ENDP

; -----------------------------------------------------------------------------
;    vymaz n¡ videolinky zemˆ bajtem AL
; -----------------------------------------------------------------------------

l5226    PROC      NEAR

         push      cx
         mov       cx,80                    ; d‚lka videolinky
l522a:   mov       es:[bx],al               ; vymaz n¡ bajtu
         inc       bx
         loop      l522a                    ; dal¨¡ bajt
         pop       cx
         ret

l5226    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ obr zku
; -----------------------------------------------------------------------------

l5232    PROC      NEAR

; ------ p©¡prava k zobrazen¡ obr zku

         call      l52d5                    ; p©¡prava k zobrazen¡/vymaz n¡ obr.
         jc        l5238                    ; obr zek se zobraz¡ OK
         ret

; ------ p©¡prava k zobrazen¡ jedn‚ linky obr zku

l5238:   mov       bh,0
         mov       bl,ds:[da718]            ; ukazatel linky k zobrazen¡
         add       bl,OBZOR                 ; + po‡ te‡n¡ linka obzoru
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa linky ve videopamˆti
         mov       byte ptr ds:[da71b],0    ; korekce pozice na slovo
         add       bx,word ptr ds:[da71a]   ; p©i‡ten¡ po‡ te‡n¡ pozice obr zku
         mov       si,ds:[da72a]            ; adresa masky obr zku
         mov       di,ds:[da72c]            ; adresa obr zku k zobrazen¡

; ------ zobrazen¡ jedn‚ linky obr zku

         mov       ch,0
         mov       cl,ds:[da72f]            ; omezen  ¨¡©ka obr zku (bajt–)
l525e:   mov       al,es:[bx]               ; p–vodn¡ bajt z obrazovky
         and       al,ds:[si]               ; maskov n¡ maskou obr zku
         or        al,ds:[di]               ; p©id n¡ obr zku
         mov       es:[bx],al               ; ulo‘en¡ nov‚ho obr zku
         inc       bx                       ; ukazatel adresy videopamˆti
         inc       si                       ; ukazatel masky obr zku
         inc       di                       ; ukazatel obr zku
         loop      l525e                    ; dal¨¡ bajt na lince

; ------ p©¡prava k zobrazen¡ dal¨¡ linky

         dec       byte ptr ds:[da731]      ; ‡¡ta‡ linek k zobrazen¡
         jz        l5286                    ; konec
         mov       ah,0
         mov       al,ds:[da726]            ; ¨¡©ka cel‚ho obr zku (bajt–)
         add       ds:[da72a],ax            ; zv˜¨en¡ adresy masky obr zku
         add       ds:[da72c],ax            ; zv˜¨en¡ adresy obr zku
         inc       byte ptr ds:[da718]      ; zv˜¨en¡ ‡¡sla linky
         jmp       short l5238              ; zobrazen¡ dal¨¡ linky
l5286:   ret

l5232    ENDP

; -----------------------------------------------------------------------------
;        vymaz n¡ obr zku
; -----------------------------------------------------------------------------

l5287    PROC      NEAR

; ------ p©¡prava k vymaz n¡ obr zku

         call      l52d5                    ; p©¡prava k zobrazen¡/vymaz n¡ obr.
         jc        l528d                    ; obr zek se vyma‘e OK
         ret

; ------ p©¡prava k vymaz n¡ jedn‚ linky obr zku

l528d:   mov       bh,0
         mov       bl,ds:[da718]            ; ukazatel linky k vymaz n¡
         add       bl,OBZOR                 ; + po‡ te‡n¡ linka obzoru
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa linky ve videopamˆti
         mov       byte ptr ds:[da71b],0    ; korekce pozice na sloco
         add       bx,word ptr ds:[da71a]   ; p©i‡ten¡ po‡ te‡n¡ pozice obr zku
         mov       si,ds:[da72a]            ; adresa masky zobrazovan‚ho obr zku

; ------ vymaz n¡ jedn‚ linky obr zku

         mov       ch,0
         mov       cl,ds:[da72f]            ; omezen  ¨¡©ka obr zku (bajt–)
l52af:   mov       al,es:[bx]               ; p–vodn¡ bajt z obrazovky
         and       al,ds:[si]               ; maskov n¡ obr zku maskou
         mov       es:[bx],al               ; ulo‘en¡ nov‚ho bajtu
         inc       bx                       ; ukazatel ve videopamˆti
         inc       si                       ; ukazatel masky obr zku
         loop      l52af                    ; dal¨¡ bajt na lince

; ------ p©¡prava k vymaz n¡ dal¨¡ linky

         dec       byte ptr ds:[da731]      ; ‡¡ta‡ linek k vymaz n¡
         jz        l52d4                    ; konec
         mov       ah,0
         mov       al,ds:[da726]            ; ¨¡©ka cel‚ho obr zku (bajt–)
         add       ds:[da72a],ax            ; zv˜¨en¡ adresy masky obr zku
         add       ds:[da72c],ax            ; zv˜¨en¡ adresy obr zku
         inc       byte ptr ds:[da718]      ; zv˜¨en¡ ‡¡sla linky
         jmp       l528d                    ; vymaz n¡ dal¨¡ linky
l52d4:   ret

l5287    ENDP

; -----------------------------------------------------------------------------
;    p©¡prava k zobrazen¡/vymaz n¡ obr zku
; -----------------------------------------------------------------------------

l52d5    PROC      NEAR

; ------ kontrola sou©adnic

         cmp       byte ptr ds:[da734],144  ; max. ‡¡slo linky obr zku 144
         jae       l52e3                    ; velk‚ ‡¡slo linky
         cmp       byte ptr ds:[da733],208  ; max. pozice 208
         jb        l52e5                    ; pozice OK
l52e3:   clc                                ; p©¡znak - nezobraz¡ se
         ret

; ------ offset v tabulce definic obr zk–

l52e5:   mov       al,ds:[da732]            ; ‡¡slo obr zku
         mov       ah,0
         shl       ax,1
         shl       ax,1
         shl       ax,1                     ; ‡¡slo obr zku * 8
         mov       bx,ax                    ; offset v tabulce definic obr zk–

; ------ rozmˆry obr zku

         mov       al,byte ptr ds:[bx+d0030]; v˜¨ka obr zku
         mov       ds:[da721],al            ; v˜¨ka obr zku (linek)
         mov       al,byte ptr ds:[bx+d0030+1] ; ¨¡©ka obr zku
         mov       ds:[da722],al            ; ¨¡©ka obr zku (bajt–)

; ------ offset adresy obr zku (sud  nebo lich  po‡ te‡n¡ pozice)

         test      byte ptr ds:[da733],1    ; je lich  pozice ?
         jz        l530e                    ; je sud  pozice
         mov       ax,ds:[bx+d0030+4]       ; adresa pro lichou pozici
         jmp       short l5312
         nop
l530e:   mov       ax,ds:[bx+d0030+2]       ; adresa pro sudou pozici

; ------ adresa obr zku k zobrazen¡

l5312:   mov       dx,offset d0300          ; tabulka obr zk–
         add       dx,ax
         mov       ds:[da72c],dx            ; adresa zobrazovan‚ho obr zku

; ------ adresa masky obr zku k zobrazen¡

         mov       dx,offset d51f4          ; tabulka masek
         add       dx,ax
         mov       ds:[da72a],dx            ; adresa masky zobrazovan‚ho obr zku

; ------ ukazatel ‡¡sla linky k zobrazen¡ obr zku

         mov       al,ds:[da734]            ; ‡¡slo linky k zobrazen¡ obr zku
         mov       ds:[da718],al            ; ukazatel ‡¡sla linky k zobrazen¡

; ------ pozice k zobrazen¡ obr zku

         mov       al,ds:[da733]            ; pozice k zobrazen¡ obr zku
         shr       al,1                     ; p©evod sou©adnice na bajty
         mov       word ptr ds:[da71a],ax   ; offset po‡ tku zobrazovan‚ho obr zku

; ------ po‡et linek k zobrazen¡ obr zku

         mov       al,ds:[da721]            ; v˜¨ka obr zku
         mov       ds:[da731],al            ; ‡¡ta‡ linek k zobrazen¡ obr zku

; ------ omezen¡ po‡tu linek, je-li obr zek p©¡li¨ n¡zko

         add       al,ds:[da734]             ; ‡¡slo posledn¡ linky obr zku
         clc
         sbb       al,144                   ; maxim ln¡ linka
         jc        l5345                    ; ‡¡slo linky je OK
         sub       ds:[da731],al            ; p©i p©ete‡en¡ omezen¡ velikosti

; ------ ¨¡©ka obr zku k zobrazen¡ (po‡et bajt–)

l5345:   mov       al,ds:[da722]            ; ¨¡©ka obr zku (v bajtech)
         mov       ds:[da726],al            ; ¨¡©ka obr zku k zobrazen¡
         mov       ds:[da72f],al            ; omezen  ¨¡©ka obr zku k zobrazen¡

; ------ omezen¡ ¨¡©ky obr zku, je-li p©¡li¨ vpravo

         mov       al,ds:[da71a]            ; offset po‡ tku zobrazovan‚ho obr zku
         add       al,ds:[da722]            ; v˜po‡et posledn¡ho bajtu obr zku
         mov       ds:[da722],al            ; posledn¡ bajt obr zku
         cmp       al,104                   ; maxim ln¡ pozice obr zku
         jb        l5362                    ; ¨¡©ka obr zku je OK
         sub       al,104                   ; p©ete‡en¡ ¨¡©ky obr zku
         sub       ds:[da72f],al            ; zmen¨en¡ ¨¡©ky obr zku
l5362:   mov       byte ptr ds:[da72f+1],0

; ------ kontrola, zda je obr zek p©¡li¨ vlevo

         cmp       byte ptr ds:[da71a],24   ; offset po‡ tku zobrazovan‚ho obr zku
         jnc       l5392                    ; obr zek nen¡ p©¡li¨ vlevo
         cmp       byte ptr ds:[da722],25   ; je konec p©¡li¨ vlevo ?
         jae       l5377                    ; nen¡ p©¡li¨ vlevo
         clc                                ; p©¡znak - nezobraz¡ se
         ret

; ------ oprava po‡ tku obr zku

l5377:   mov       al,24
         sub       al,ds:[da71a]            ; offset po‡ tku zobraz. obr zku
         mov       ah,0
         add       ds:[da72a],ax            ; adresa masky zobrazovan‚ho obr zku
         add       ds:[da72c],ax            ; adresa zobrazovan‚ho obr zku
         sub       ds:[da72f],al            ; ¨¡©ka v˜©ezu zobrazovan‚ho obr zku
         mov       byte ptr ds:[da71a],0    ; offset po‡ tku zobrazovan‚ho obr zku
         stc                                ; p©¡znak - zobraz¡ se
         ret

l5392:   sub       byte ptr ds:[da71a],24   ; oprava pozice po‡ tku
         stc                                ; p©¡znak - zobraz¡ se
         ret

l52d5    ENDP

; -----------------------------------------------------------------------------
;        (zapomenut  procedura - m  to b˜t vstup z kl vesnice)
; -----------------------------------------------------------------------------

l5399    PROC      NEAR

         sti
l539a:   mov       ah,1
         int       10h
         jz        l53a7
         mov       ax,0
         int       10h
         jmp       short l539a
l53a7:   ret

l5399    ENDP

         db        8 dup(0)

; -----------------------------------------------------------------------------
;    vygenerov n¡ nov‚ hvˆzdy (4. podsc‚na)
; -----------------------------------------------------------------------------

l53b0    PROC      NEAR

; ------ test, zda jsou hvˆzdy obsluhov ny

         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jnz       l53b8                    ; nen¡ zobrazena zemˆ
l53b7:   ret

l53b8:   inc       byte ptr ds:[da74a]      ; ‡¡ta‡ obsluhy hvˆzd
         test      byte ptr ds:[da74a],1
         jz        l53b7

; ------ zalo‘en¡ definice nov‚ hvˆzdy

         mov       di,9                     ; ‡¡slo objektu = hvˆzda
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l53b7                    ; tabulka je pln 

; ------ sou©adnice X hvˆzdy

         call      l6160                    ; gener tor n hodn‚ho ‡¡sla
         and       al,7fh                   ; pozice 0 a‘ 127
         add       al,40h                   ; + po‡ tek 64 = pozice 64 a‘ 191
         mov       ds:[si+da688+1],al         ; pozice objektu X

; ------ generov n¡ ‡¡sla pohybu hvˆzdy

l53d6:   call      l6160                    ; gener tor n hodn‚ho ‡¡sla (bajt)
         and       al,7                     ; ‡¡slo 0 a‘ 7
         cmp       al,5                     ; je ‡¡slo OK ?
         ja        l53d6                    ; je velk‚ ‡¡slo - znovu
                                            ;   zde je ‡¡slo 0 a‘ 5
         add       al,19                    ; + po‡ tek = 19 a‘ 24 (=vpravo)
         test      byte ptr ds:[si+da688+1],80h ; je lev  ‡ st ?
         jnz       l53ea                    ; je prav  ‡ st
         add       al,6                     ; korekce vlevo = 25 a‘ 30 (=vlevo)

l53ea:   call      l614a                    ; za©azen¡ objektu do tabulky pohyb–
         mov       byte ptr ds:[si+da688+2],54 ; sou©adnice objekty Y (linka)
         mov       byte ptr ds:[si+da688+5],38h
         ret

l53b0    ENDP

; -----------------------------------------------------------------------------
;    generov n¡ kosmick‚ lodi a bomb
; -----------------------------------------------------------------------------

l53f8    PROC      NEAR

; ------ test, zda je po‘adov no generov n¡ kosmick‚ lodi

         test      byte ptr ds:[da769],4    ; je mo‘n‚ generovat loƒ ?
         jnz       l5400                    ; nen¡ po‘adov no generov n¡ lodi
l53ff:   ret

l5400:   cmp       byte ptr ds:[da763],1    ; po‡et zbyl˜ch bran k proletˆn¡
         jne       l53ff
         and       byte ptr ds:[da769],0f7h ; zru¨en¡ po‘adavku generov n¡ lodi

; ------ nalezen¡ kosmick‚ lodi v tabulce

         mov       si,0                     ; po‡ tek tabulky
         mov       cx,10h                   ; po‡et polo‘ek v tabulce
l5412:   cmp       byte ptr ds:[si+da688],6 ; typ objektu = kosmick  loƒ ?
         je        l5459                    ; nalezena kosmick  loƒ
         add       si,8
         loop      l5412

; ------ vygenerov n¡ kosmick‚ lodi

         mov       di,6                     ; kosmick  loƒ
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l53ff                    ; nen¡ voln‚ m¡sto v tabulce

; ------ generov n¡ pohybu kosmick‚ lodi

         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jz        l5450                    ; je zobrazena
         call      l6160                    ; gener tor n hodn‚ho ‡¡sla
         test      al,80h
         jnz       l5439
         mov       al,16
         jmp       short l543b
         nop

l5439:   mov       al,15
l543b:   call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ parametry popisova‡e objektu

         mov       byte ptr ds:[si+da688+1],80h ; pozice objektu X
         mov       byte ptr ds:[si+da688+2],90h ; linka objektu Y
         mov       al,ds:[da762]
         mov       ds:[si+da688+5],al
         ret

; ------ generov n¡ pohybu kosmick‚ lodi, je-li zobrazena zemˆ

l5450:   call      l6160                    ; gener tor n hodn‚ho ‡¡sla
         and       al,3                     ; ‡¡slo 0 a‘ 3
         add       al,3                     ; ‡¡slo 3 a‘ 6
         jmp       short l543b

; ------

l5459:   test      byte ptr ds:[si+da688+7],10h
         jnz       l5461
l5460:   ret

; ------ ‡¡ta‡ pro generov n¡ bomb

l5461:   cmp       byte ptr ds:[da749],0    ; je ji‘ mo‘n‚ generovat bomby ?
         jz        l546d                    ; je ji‘ mo‘n‚
         dec       byte ptr ds:[da749]      ; ‡¡ta‡ generov n¡ bomby
         ret

l546d:   mov       ax,si                    ; offset definice kosmick‚ lodi
         mov       ds:[da721],al            ; £schova offsetu definice
         mov       al,ds:[da768]            ; rychlost generov n¡ bomb lodi
         mov       ds:[da749],al            ; ‡¡ta‡ pro generov n¡ bomb lodi

; ------ vygenerov n¡ popisova‡e bomby

         cmp       byte ptr ds:[si+da688+3],2 ; velikost objektu
         jb        l5460                    ; mal  velikost
         mov       di,4                     ; objekt = bomba
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l5460

         mov       al,12
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ kopie parametr– kosmick‚ lodi do parametr– bomby (sou©adnice, ...)

         mov       bl,ds:[da721]            ; offset definice kosmick‚ lodi
         mov       bh,0
         mov       al,ds:[bx+da688+3]         ; velikost kosmick‚ lodi
         mov       ds:[si+da688+3],al         ; velikost objektu
         mov       bl,al                    ; velikost objektu
         mov       al,ds:[bx+da776]
         mov       bl,ds:[da721]            ; offset definice kosmick‚ lodi
         add       al,ds:[bx+da688+1]         ; pozice kosmick‚ lodi X
         mov       ds:[si+da688+1],al         ; pozice bomby X
         mov       al,ds:[bx+da688+2]         ; sou©adnice kosmick‚ lodi Y
         mov       ds:[si+da688+2],al         ; sou©adnice bomby Y
         mov       byte ptr ds:[si+da688+5],20h
         mov       al,3
         call      l680e                    ; zvukov  indikace generov n¡ bomby
         ret

l53f8    ENDP

; -----------------------------------------------------------------------------
;    generov n¡ bomb velk‚ho UFO
; -----------------------------------------------------------------------------

l54bf    PROC      NEAR

         test      byte ptr ds:[da769],80h  ; po‘adavek generovat bomby UFO ?
         jz        l54d1
         cmp       byte ptr ds:[da747],0    ; ‡¡ta‡ prodlevy pro generov n¡ bomby
         je        l54d2                    ; je mozn‚ generov n¡
         dec       byte ptr ds:[da747]      ; ‡¡ta‡ prodlevy pro generov n¡ bomby
l54d1:   ret

; ------ nalezen¡ objektu - velk‚ UFO

l54d2:   mov       si,10h
l54d5:   cmp       byte ptr ds:[si+da688],3 ; typ objektu = velk‚ UFO
         jz        l54e8                    ; nalezeno velk‚ UFO
l54dc:   add       si,8
         cmp       si,80h
         jne       l54d5
         jmp       short l5533              ; konec - UFO nenalezeno
         nop

; ------ test, zda vyvohovuje pozice

l54e8:   cmp       byte ptr ds:[si+da688+1],28h ; min. pozice objektu 40 ?
         jb        l54dc                    ; p©¡li¨ vlevo
         cmp       byte ptr ds:[si+da688+1],0d7h ; max. pozice 215 ?
         jnc       l54dc                    ; p©¡li¨ vpravo

; ------ vygenerov n¡ definice bomby velk‚ho UFO

         mov       ax,si
         mov       ds:[da735],al            ; £schova offsetu definice UFO
         mov       di,4                     ; objekt = bomba
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l54d1

         mov       al,12
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ generov n¡ parametr– bomby z parametr– UFO

         mov       al,ds:[da735]            ; offset definice UFO
         mov       ah,0
         mov       di,ax
         mov       al,ds:[di+da688+1]         ; pozice objektu X
         add       al,4
         mov       ds:[si+da688+1],al         ; pozice objektu X
         mov       al,ds:[di+da688+2]         ; sou©adnice objektu Y
         mov       ds:[si+da688+2],al         ; sou©adnice objektu Y
         mov       al,ds:[di+da688+3]         ; velikost objektu
         mov       ds:[si+da688+3],al         ; velikost objektu
         mov       byte ptr ds:[si+da688+5],80h
         mov       al,3
         call      l680e                    ; zvukov  signalizace

l5533:   mov       al,ds:[da766]            ; rychlost generov n¡ bomb UFO
         mov       ds:[da747],al            ; ‡¡ta‡ pro generov n¡ dal¨¡ bomby
         ret

l54bf    ENDP

; -----------------------------------------------------------------------------
;    generov n¡ bomb br ny
; -----------------------------------------------------------------------------

l553a    PROC      NEAR

; ------ test, zda m  b˜t generov na bomba br ny

         test      byte ptr ds:[da769],60h  ; po‘adavek generov n¡ bomb br ny
         jz        l554c
         cmp       byte ptr ds:[da748],0    ; ‡¡ta‡ generov n¡ bomb br ny
         je        l554d
         dec       byte ptr ds:[da748]
l554c:   ret

; ------ nalezen¡ definice br ny

l554d:   mov       si,10h
l5550:   cmp       byte ptr ds:[si+da688],1 ; objekt = sloup
         je        l5567                    ; je br na (sloup)
l5557:   add       si,8
         cmp       si,80h
         jne       l5550
l5560:   mov       al,ds:[da767]            ; rychlost generov n¡ bomb br ny
         mov       ds:[da748],al            ; ‡¡ta‡ pro generov ¤i dal¨¡ bomby
         ret

; ------ test, zda je br na vzd len 

l5567:   mov       ax,si
         mov       ds:[da735],al            ; £schova offsetu definice br ny
         cmp       byte ptr ds:[si+da688+3],7 ; velikost objektu
         jnc       l5557                    ; je p©¡li¨ vzd len  br na

; ------ generov n¡ pohybu bomby

         call      l6160                    ; gener tor n hodn‚ho ‡¡sla
         shr       al,1                     ;
         jnc       l55d4

         test      byte ptr ds:[da769],20h
         jz        l5557
         test      byte ptr ds:[si+da688+7],8
         jnz       l558d
l5588:   mov       al,0eh
         jmp       short l558f
         nop
l558d:   mov       al,0dh
l558f:   mov       ds:[da734],al            ; ‡¡slo linky k zobrazen¡ obr zku

; ------ vygenerov n¡ bomby z br ny

         mov       di,8                     ; bomba br ny
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l5560

; ------ generov n¡ parametr– bomby podle parametr– br ny

         mov       al,ds:[da734]            ; ‡¡slo linky k zobrazen¡ obr zku
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡
         mov       al,ds:[da735]            ; offset definice br ny
         mov       ah,0
         mov       di,ax
         mov       al,ds:[di+da688+1]         ; pozice objektu X
         mov       ds:[si+da688+1],al         ; pozice objektu X
         mov       al,ds:[di+da688+2]         ; sou©adnice objektu Y
         add       al,10h
         mov       ds:[si+da688+2],al         ; sou©adnice objektu Y
         mov       al,ds:[di+da688+3]         ; velikost objektu
         mov       ds:[si+da688+3],al         ; velikost objektu
         mov       byte ptr ds:[si+da688+5],80h
         mov       al,4
         call      l680e                    ; zvukov  signalizace
         mov       al,ds:[da735]            ; offset definice br ny
         mov       ah,0
         mov       si,ax
         jmp       short l5557              ; dal¨¡ objekt

l55d4:   test      byte ptr ds:[da769],40h
         jnz       l55de
         jmp       l5557                    ; dal¨¡ objekt
l55de:   test      byte ptr ds:[si+da688+7],8
         jnz       l5588
         jmp       short l558d

l553a    ENDP

; -----------------------------------------------------------------------------
;    vygenerov n¡ velk‚ho UFO
; -----------------------------------------------------------------------------

l55e7    PROC      NEAR

; ------ test, zda m  b˜t vygenerov no velk‚ UFO

         test      byte ptr ds:[da769],10h  ; povoleno generov n¡ velk‚ho UFO ?
         jz        l55f9                    ; nen¡ povoleno generov n¡ UFO
         cmp       byte ptr ds:[da744],0    ; ‡¡ta‡ prodlevy generov n¡ UFO
         je        l55fa                    ; je OK
         dec       byte ptr ds:[da744]      ; ‡¡t n¡ prodlevy UFO
l55f9:   ret

; ------ vygenerov n¡ velk‚ho UFO

l55fa:   mov       di,3                     ; velk‚ UFO
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l55f9                    ; tabulka objekt– pln 

; ------ vygenerov n¡ pohybu velk‚ho UFO

         call      l6160                    ; gener tor n hody
         and       al,0ah                   ; ‡¡slo pohybu 0, 2, 8, 10
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ parametry UFO

         mov       byte ptr ds:[si+da688+3],8 ; velikost objektu (vzd len‚)
         call      l6160                    ; gener tor n hody
         mov       ds:[si+da688+1],al       ; pozice objektu X
         mov       al,ds:[da761]
         mov       ds:[si+da688+5],al

; ------ p©¡prava pro generov n¡ dal¨¡ho UFO

         mov       al,ds:[da760]            ; rychlost generov n¡ UFO
         mov       ds:[da744],al            ; ‡¡ta‡ prodlevy p©ed dal¨¡m UFO
         ret

l55e7    ENDP

; -----------------------------------------------------------------------------
;    inicializace programu, ‡ek n¡ na zah jen¡ hry
; -----------------------------------------------------------------------------

l5624    PROC      NEAR

; ------ vypnut¡ zvukov‚ho gener toru

         in        al,[61h]
         and       al,0fch
         out       [61h],al                 ; vypnut¡ zvukov‚ho gener toru

; ------ nastaven¡ barevn‚ palety modr‚

         mov       al,30h
         mov       dx,3d9h                  ; registr palet CGA
         out       dx,al                    ; nastaven¡ registru palet CGA

; ------ vymaz n¡ videopamˆti

         call      l59fe                    ; vymaz n¡ videopamˆti

; ------ porovn n¡, zda je dosa‘en‚ sk¢re vy¨¨¡ ne‘ maxim ln¡ sk¢re

         mov       cx,4                     ; d‚lka sk¢re
         mov       si,0                     ; ukazatel v tabulce sk¢re
l5639:   mov       al,ds:[si+da772]         ; dosa‘en‚ sk¢re (8 ‡¡slic BCD)
         cmp       al,ds:[si+da76e]         ; je vy¨¨¡ ne‘ maxim ln¡ sk¢re ?
         ja        l5648                    ; dosa‘en‚ sk¢re je vy¨¨¡
         jb        l5659                    ; dosa‘en‚ sk¢re je ni‘¨¡ ne‘ maxim.
         inc       si                       ; zv˜¨en¡ ukazatele v tabulce
         loop      l5639                    ; dal¨¡ bajt sk¢re

; ------ dosa‘en‚ sk¢re je vy¨¨¡ ne‘ maxim ln¡ - kopie do maxim ln¡ho sk¢re

l5648:   mov       cx,4                     ; d‚lka sk¢re
         mov       si,0                     ; ukazatel v tabulce
l564e:   mov       al,ds:[si+da772]         ; dosa‘en‚ sk¢re (8 ‡¡slic BCD)
         mov       ds:[si+da76e],al         ; kopie do maxim ln¡ho sk¢re
         inc       si                       ; zv˜¨en¡ ukazatele
         loop      l564e                    ; dal¨¡ bajt sk¢re

; ------ test, zda je nˆjak‚ maxim ln¡ sk¢re (zda ji‘ za‡ala nˆjak  hra)

l5659:   mov       al,ds:[da76e]            ; maxim ln¡ sk¢re - 1. bajt
         or        al,ds:[da76f]            ; je dosa‘eno nˆjak‚ho sk¢re ?
         or        al,ds:[da770]
         or        al,ds:[da771]
         jz        l5684                    ; nen¡ je¨tˆ ‘ dn‚ sk¢re

; ------ zobrazen¡ dosa‘en‚ho a maxim ln¡ho sk¢re (pokud nˆjak‚ sk¢re je)

         mov       si,offset daa32          ; text "SCORE:"
         call      l5a61                    ; zobrazen¡ textu DS:SI
         mov       di,offset da772          ; sk¢re v BCD tvaru (8 BCD ‡¡slic)
         inc       di                       ; bez nejni‘¨¡ho © du
         call      l5b39                    ; zobrazen¡ ‡¡sla BCD 6 ‡¡slic
         mov       si,offset daa3b          ; text "HIGH:"
         call      l5a61                    ; zobrazen¡ textu DS:SI
         mov       di,offset da76e          ; maxim ln¡ sk¢re v BCD tvaru
         inc       di                       ; bez nejni‘¨¡ho © du
         call      l5b39                    ; zobrazen¡ ‡¡sla BCD 6 ‡¡slic

; ------ inicializace registr– pro novou hru

l5684:   mov       byte ptr ds:[da76c],8    ; rychlost st©¡len¡
         mov       byte ptr ds:[da76a],3    ; po‡et ‘ivot–
         mov       byte ptr ds:[da76b],0    ; ‡¡slo sc‚ny (0 a‘ 19)
         mov       word ptr ds:[da7d0],0ffh ;
         mov       byte ptr ds:[da772],0    ; dosa‘en‚ sk¢re - ‡¡slice 6 a 7
         mov       byte ptr ds:[da773],0    ; dosa‘en‚ sk¢re - ‡¡slice 4 a 5
         mov       byte ptr ds:[da774],0    ; dosa‘en‚ sk¢re - ‡¡slice 2 a 3
         mov       byte ptr ds:[da775],0    ; dosa‘en‚ sk¢re - ‡¡slice 0 a 1
         mov       byte ptr ds:[da746],0    ; sk¢re p©i posledn¡m p©id n¡ ‘ivota
         mov       byte ptr ds:[da73e],10h  ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru
         mov       byte ptr ds:[da73f],0ffh ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne

; ------ zobrazen¡ obr zku "BUCK ROGERS"

         mov       si,offset db1d0          ; tituln¡ obr zek
         mov       dx,62                    ; po‡et linek obr zku
         mov       di,20                    ; po‡ te‡n¡ linka (ukazatel linek)
l56c5:   mov       cx,59                    ; po‡et bajt– na linku
         mov       bx,ds:[di+da4b0]         ; adresa linky
         add       bx,10                    ; posun linky na pozici
l56cf:   mov       al,ds:[si]               ; bajt k zobrazen¡
         mov       es:[bx],al               ; ulo‘en¡ do videopamˆti
         inc       si                       ;
         inc       bx
         loop      l56cf                    ; dal¨¡ bajt obr zku
         inc       di
         inc       di                       ; posun ukazatele v tabulce
         dec       dx                       ; ‡¡ta‡ linek k zobrazen¡
         jnz       l56c5                    ; zobrazen¡ dal¨¡ linky

; ------ zobrazen¡ licen‡n¡ch informac¡ "Copyright"

         mov       si,offset da9f6          ; text "Copyright"
         call      l5a61                    ; zobrazen¡ textu DS:SI
         mov       si,offset daa07          ; licen‡n¡ informace
         call      l5a61                    ; zobrazen¡ textu DS:SI

; ------ vypr zdnˆn¡ bufferu kl vesnice

         sti
l56ea:   mov       ah,1
         int       16h                      ; test kl vesy
         jz        l56f6                    ; nen¡ ‘ dn  kl vesa
         mov       ah,0
         int       16h                      ; zru¨en¡ znaku
         jmp       short l56ea              ; test dal¨¡ho znaku kl vesy

; ------ synchonizace na za‡ tek impulsu joysticku A (pro test, zda je joystick)

l56f6:   mov       dx,201h                  ; port joysticku
         cli                                ; z kaz p©eru¨en¡
         out       dx,al                    ; inicializace portu
l56fb:   in        al,dx                    ; ‡ten¡ stavu joysticku
         and       al,3                     ; sou©adnice
         cmp       al,3                     ; za‡ tek impulsu obou sou©adnic ?
         je        l5710                    ; je za‡ tek impulsu sou©adnic
         inc       byte ptr ds:[da8dc]      ; ‡¡ta‡ pr–chod– testu joysticku
         jnz       l56fb                    ; nen¡ je¨tˆ TIME-OUT
         mov       byte ptr ds:[da8dd],1    ; p©¡znak, ‘e nen¡ joystick
         jmp       short l5727
         nop

; ------ mˆ©en¡ doby impulsu joysticku A

l5710:   mov       cx,10000                 ; maxim ln¡ doba pro mˆ©en¡
l5713:   in        al,dx                    ; ‡ten¡ stavu portu joysticku
         test      al,3                     ; konec impulsu 1 obou sou©adnic ?
         jz        l5722                    ; konec impulsu 1 obou sou©adnic
         loop      l5713                    ; dal¨¡ mˆ©en¡ doby
         mov       byte ptr ds:[da8dd],1    ; p©¡znak, ‘e nen¡ joystick
         jmp       short l5727              ;
         nop
l5722:   mov       byte ptr ds:[da8dd],0    ; p©¡znak, ‘e je joystick

; ------ inicializace tabulky hvˆzd

l5727:   sti                                ; p©eru¨en¡ opˆt povoleno
         mov       word ptr ds:[da7ce],0    ; ukazatel v tabulce hesla
l572e:   mov       di,0                     ; ukazatel v tabulce adres hvˆzd
         mov       si,0                     ; ukazatel v tabulce definic hvˆzd
         mov       cx,20h                   ; po‡et hvˆzd
l5737:   call      l58ea                    ; inicializace jedn‚ hvˆzdy
         mov       word ptr ds:[di+da780],2028h ; adresa star‚ hvˆzdy - mimo
         add       si,8                     ; posun adresy v tabulce hvˆzd
         inc       di                       ; posun adresy v tabulce adres
         inc       di
         loop      l5737                    ; dal¨¡ hvˆzda

; ------ ‡ek n¡ na stisk tla‡¡tka joysticku (divn‚ - je to nefunk‡n¡)

         mov       si,0
l574a:   cmp       byte ptr ds:[da8dd],0    ; je joystick ?
         jmp       short l5764              ; nen¡ (m  b˜t asi JE)

         mov       dx,201h                  ; port joysticku
         out       dx,al                    ; inicializace joysticku
         in        al,dx                    ; ‡ten¡ stavu joysticku
         and       al,30h                   ; ‡ten¡ tla‡¡tek joysticku A
         cmp       al,30h                   ; jsou tla‡¡tka A povolena ?
         je        l5764                    ; jsou povolena
         mov       byte ptr ds:[da75b],1    ; p©¡znak ovl d n¡ joystickem
         jmp       l591f                    ; inicializace nov‚ sc‚ny

l5764:   mov       byte ptr ds:[da8dc],1    ; ‡¡ta‡ pr–chod– testu joysticku

; ------ test, zda byla stisknuta kl vesa, zru¨en¡ bufferu kl vesnice

         cli
         push      ds
         mov       ax,40h
         mov       ds,ax
         mov       bx,ds:[1ah]              ; ‡tec¡ adresa z bufferu kl vesnice
         cmp       bx,ds:[1ch]              ; je nˆco v bufferu ?
         mov       byte ptr ds:[1ch],1eh    ; zru¨en¡ obsahu bufferu
         mov       byte ptr ds:[1ah],1eh    ; zru¨en¡ obsahu bufferu
         sti
         je        l57ef                    ; nen¡ nic v bufferu kl vesnice

; ------ vstup znaku z kl vesnice

         call      l4ed6                    ; vstup znaku z kl vesnice+p©eru¨en¡
         and       ax,0ffdfh                ; znak - p©evod na velk‚ p¡smeno
         pop       ds                       ; n vrat DS
         mov       byte ptr ds:[da75b],0    ; p©¡znak ovl d n¡ kl vesnic¡

; ------ test, zda je stisknuta kl vesa hesla

         mov       di,ds:[da7ce]            ; ukazatel v tabulce hesla
         cmp       ax,ds:[di+da7c4]         ; je to kl vesa hesla ?
         jne       l57ec                    ; nen¡ heslo - start hry
         inc       di
         inc       di
         mov       ds:[da7ce],di            ; ukazatel v tabulce hesla
         cmp       di,10                    ; je ji‘ cel‚ heslo ?
         jne       l57f0                    ; nen¡ je¨tˆ cel‚ heslo

; ------ vymaz n¡ v¨ech hvˆzd

         mov       dl,0                     ; bajt k vymaz n¡ hvˆzdy
         mov       di,0                     ; offset v tabulce
         mov       cx,20h                   ; po‡et hvˆzd v tabulce
l57ae:   mov       bx,ds:[di+da780]         ; star  adresa hvˆzdy
         mov       es:[bx],dl               ; vymaz n¡ star‚ hvˆzdy
         inc       di
         inc       di
         loop      l57ae                    ; dal¨¡ hvˆzda

; ------ zobrazen¡ obr zku po zad n¡ hesla (tv ©)

         mov       di,offset dc1e0          ; obr zek po zad n¡ hesla
         mov       word ptr ds:[da7ce],0bah ; ukazatel v tabulce hesla
         mov       dx,41                    ; po‡et linek obr zku
l57c5:   mov       bx,ds:[da7ce]            ; ukazatel ‡¡sla linek obr zku
         mov       bx,ds:[bx+da4b0]         ; p©evod na adresu ve videopamˆti
         add       bx,37                    ; po‡ te‡n¡ pozice obr zku
         mov       cx,10                    ; po‡et bajt– na linku
l57d3:   mov       al,ds:[di]               ; bajt k zobrazen¡
         mov       es:[bx],al               ; zobrazen¡ bajtu
         inc       di
         inc       bx
         loop      l57d3                    ; dal¨¡ bajt na lince
         dec       dx                       ; ‡¡ta‡ linek
         jnz       l57e2                    ; dal¨¡ linka
         jmp       l572e                    ; pokra‡ov n¡ v obsluze hvˆzd

l57e2:   inc       word ptr ds:[da7ce]      ; zv˜¨en¡ ‡¡sla linky obr zku
         inc       word ptr ds:[da7ce]      ; zv˜¨en¡ ‡¡sla linky obr zku
         jmp       short l57c5              ; dal¨¡ linka

l57ec:   jmp       l591f                    ; inicializace nov‚ sc‚ny

; ------ p©¡rustek sou©adnice hvˆzdy ve smˆru X

l57ef:   pop       ds
l57f0:   mov       byte ptr ds:[da8da],0    ; zru¨en¡ p©¡znaku zmˆny pozice
         mov       al,ds:[si+da7d6+3]       ; p©¡rustek zlomku pozice X
         add       ds:[si+da7d6+5],al       ; zv˜¨en¡ zlomku pozice X
         jnc       l583e                    ; nen¡ zmˆna pozice X
         mov       byte ptr ds:[da8da],1    ; 1=p©¡znak zmˆny pozice hvˆzdy
         mov       cl,4
         shr       al,cl
         and       al,0eh
         jnz       l580e
         mov       al,2
l580e:   add       al,ds:[si+da7d6+3]       ; zv˜¨en¡ zlomku sou©adnice X
         jc        l5818
         mov       ds:[si+da7d6+3],al       ; nov˜ zlomek X

; ------ rozli¨en¡, zda je posun vlevo nebo vpravo

l5818:   test      byte ptr ds:[si+da7d6+3],1 ; je smˆr vpravo ?
         jz        l5830                    ; je smˆr vpravo

; ------ sn¡‘en¡ sou©adnice hvˆzdy X smˆrem vlevo

         cmp       byte ptr ds:[si+da7d6],0 ; je ji‘ lev˜ okraj ?
         jnz       l5829                    ; nen¡ je¨tˆ lev˜ okraj
         jmp       l58e5                    ; generov n¡ novˆ hvˆzdy
l5829:   dec       byte ptr ds:[si+da7d6]   ; sn¡‘en¡ pozice X
         jmp       short l583e
         nop

; ------ zv˜¨en¡ sou©adnice hvˆzdy X smˆrem vpravo

l5830:   cmp       byte ptr ds:[si+da7d6],79 ; je p©ekro‡en prav˜ okraj ?
         jne       l583a                    ; nen¡ je¨tˆ p©ekro‡en
         jmp       l58e5                    ; generov n¡ nov‚ hvˆzdy
l583a:   inc       byte ptr ds:[si+da7d6]   ; zv˜¨en¡ pozice X

; ------ p©¡rustek sou©adnice hvˆzdy ve zmˆru Y

l583e:   mov       al,ds:[si+da7d6+4]       ; zlomkov˜ p©¡rustek
         add       ds:[si+da7d6+6],al       ; zv˜¨en¡ zlomku
         jnc       l5881                    ; nen¡ zmˆna sou©adnice Y
         mov       byte ptr ds:[da8da],1    ; 1=p©¡znak zmˆny pozice hvˆzdy
         mov       cl,4
         shr       al,cl
         and       al,0eh
         jnz       l5857
         mov       al,2
l5857:   add       al,ds:[si+da7d6+4]
         jc        l5861
         mov       ds:[si+da7d6+4],al

; ------ rozli¨en¡, zda je smˆr pohybu nahoru nebo dol–

l5861:   test      byte ptr ds:[si+da7d6+4],1 ; je smˆr dol– ?
         jz        l5876                    ; je smˆr dol–

; ------ zv˜¨en¡ sou©adnice hvˆzdy Y smˆrem nahoru

         cmp       byte ptr ds:[si+da7d6+2],0 ; je ji‘ horn¡ okraj ?
         jz        l58e5                    ; je horn¡ okraj - dal¨¡ hvˆzda
         dec       byte ptr ds:[si+da7d6+2] ; sn¡‘en¡ sou©adnice hvˆzdy Y
         jmp       short l5881
         nop

; ------ zv˜¨en¡ sou©adnice hvˆzdy Y smˆrem dol–

l5876:   cmp       byte ptr ds:[si+da7d6+2],99 ; je ji‘ spodn¡ okraj ?
         jz        l58e5                    ; konec - nov  hvˆzda
         inc       byte ptr ds:[si+da7d6+2] ; zv˜¨en¡ sou©adnice hvˆzdy Y

; ------ test, zda byla zmˆna pozice hvˆzdy (=zda se hvˆzda m  zobrazit)

l5881:   cmp       byte ptr ds:[da8da],0    ; byla zmˆna pozice hvˆzdy ?
         jz        l58db                    ; nebyla zmˆna pozice hvˆzdy

; ------ adresa k zobrazen¡ hvˆzdy

         mov       bl,ds:[si+da7d6+2]       ; ‡¡slo videolinky Y hvˆzdy / 2
         mov       bh,0
         shl       bx,1                     ; ‡¡slo videolinky * 2
         shl       bx,1                     ; ‡¡slo linky * 4
         mov       bx,ds:[bx+da4b0]         ; adresa linky ve videopamˆti
         mov       al,ds:[si+da7d6]         ; pozice hvˆzdy X
         mov       ah,0
         add       bx,ax                    ; adresa k zobrazen¡ hvˆzdy

; ------ test, zda je na nov‚ pozici ‡ern‚ pozad¡ (= zda se zobraz¡)

         mov       dl,es:[bx]               ; p–vodn¡ obsah displeje
         cmp       dl,0                     ; je pozad¡ (= ‡ern  barva) ?
         jne       l58cf                    ; je nˆjak˜ obr zek - nezobraz¡ se

; ------ barva hvˆzdy

         mov       dl,ds:[si+da7d6+3]       ; obr zek hvˆzdy
         and       dl,3                     ; maska posledn¡ho bodu
         cmp       dl,0                     ; byl posledn¡ bod v bajtu ?
         jz        l58b4                    ; byl posledn¡ bod
         mov       dl,3                     ; b¡l  barva

; ------ zobrazen¡ hvˆzdy na nov‚ pozici, p©¡prava ke zru¨en¡ star‚ pozice

l58b4:   mov       es:[bx],dl               ; zobrazen¡ hvˆzdy
         mov       di,si                    ; ukazatel v tabulce hvˆzd
         shr       di,1
         shr       di,1
         mov       ax,ds:[di+da780]         ; adresa star‚ hvˆzdy
         mov       ds:[di+da780],bx         ; £schova adresy nov‚ hvˆzdy

; ------ vymaz n¡ star‚ hvˆzdy

l58c5:   mov       bx,ax                    ; adresa ve videopamˆti
         mov       dl,0                     ; ‡ern  barva
         mov       es:[bx],dl               ; vymaz n¡ star‚ hvˆzdy
         jmp       short l58db
         nop

; ------ p©¡prava k vymaz n¡ star‚ pozice hvˆzdy

l58cf:   mov       di,si                    ; ukazatel v tabulce hvˆzd
         shr       di,1
         shr       di,1
         mov       ax,ds:[di+da780]         ; adresa star‚ hvˆzdy
         jmp       short l58c5

; ------ obsluha dal¨¡ hvˆzdy

l58db:   add       si,8                     ; zv˜¨en¡ ukazatele v tabulce hvˆzd
         and       si,0ffh                  ; zarovn n¡ (celkem 20h hvˆzd)
         jmp       l574a                    ; obsluha dal¨¡ hvˆzdy

; ------ vygenerov n¡ nov‚ hvˆzdy

l58e5:   call      l58ea                    ; generov n¡ nov‚ hvˆzdy
         jmp       short l58db              ; obsluha dal¨¡ hvˆzdy

l5624    ENDP

; -----------------------------------------------------------------------------
;        generov n¡ jedn‚ hvˆzdy
; -----------------------------------------------------------------------------

l58ea    PROC      NEAR

; ------ po‡ te‡n¡ © dek a pozice hvˆzdy

         mov       byte ptr ds:[si+da7d6],40 ; pozice hvˆzdy X
         mov       byte ptr ds:[si+da7d6+1],0
         mov       byte ptr ds:[si+da7d6+2],50 ; pozice hvˆzdy Y (=linka/2)

; ------ p©¡rustek zlomku pozice X

         call      l6160                    ; gener tor n hody
         and       al,3fh                   ;
         or        al,6
         mov       ds:[si+da7d6+3],al       ; p©¡rustek zlomku X

; ------ p©¡rustek zlomku linky Y

         call      l6160                    ; gener tor n hody
         and       al,3fh
         or        al,6
         mov       ds:[si+da7d6+4],al       ; p©¡rustek zlomku Y

; ------ zlomky sou©adnic pozice hvˆzdy

         mov       byte ptr ds:[si+da7d6+5],0 ; zlomek sou©adnice X
         mov       byte ptr ds:[si+da7d6+6],0 ; zlomek sou©adnice Y
         mov       byte ptr ds:[si+da7d6+7],0
         ret

l58ea    ENDP

; -----------------------------------------------------------------------------
;        start nov‚ sc‚ny
; -----------------------------------------------------------------------------

l591f    PROC      NEAR

; ------ zobrazen¡ textu o pou‘it¡ kl vesnice/joysticku

         cmp       byte ptr ds:[da75b],0    ; obsluha kl vesnic¡ ?
         jne       l592c                    ; nen¡ kl vesnice
         mov       si,offset daa54          ; text "using keyboard"
         jmp       short l592f
         nop
l592c:   mov       si,offset daa43          ; text "using joystick"
l592f:   call      l5a61                    ; zobrazen¡ textu DS:SI

; ------ prodleva po zobrazen¡ textu

         mov       cx,500                   ; d‚lka prodlevy
         mov       al,0
l5937:   inc       al
         jnz       l5937
         loop      l5937

; ------ kalibrace joysticku

         cmp       byte ptr ds:[da75b],0    ; je kl vesnice ?
         je        l5953                    ; je kl vesnice
         cmp       byte ptr ds:[da8db],0    ; je joystick kalibrov n ?
         jne       l5953                    ; byl ji‘ kalibrov n
         call      l6850                    ; kalibrace joysticku
         mov       byte ptr ds:[da8db],1    ; p©¡znak kalibrace joysticku

; ------ omezen¡ ‡¡sla sc‚ny

l5953:   cmp       byte ptr ds:[da76b],20   ; ‡¡slo sc‚ny (maxim lnˆ 19)
         jb        l595f                    ; ‡¡slo sc‚ny OK
         sub       byte ptr ds:[da76b],4    ; ‡¡slo sc‚ny na posledn¡ sekci

; ------ inicializace defini‡n¡ tabulky sc‚ny

l595f:   mov       al,14                    ; d‚lka tabulky sc‚ny
         mul       byte ptr ds:[da76b]      ; ‡¡slo sc‚ny -> offset v tabulce
         add       ax,offset da8de          ; adresa definice sc‚ny
         mov       di,0                     ; ukazatel v defini‡n¡ tabulce
         mov       si,ax                    ; adresa definice sc‚ny
         mov       cl,14                    ; d‚lka definice sc‚ny
         mov       ch,0
l5971:   mov       al,ds:[si]
         mov       ds:[di+da75c],al         ; ulo‘en¡ do defini‡n¡ tabulky
         inc       si
         inc       di
         loop      l5971                    ; dal¨¡ bajt

; ------ nov  sekce - palivo na maximum

         mov       al,ds:[da76b]            ; ‡¡slo sc‚ny
         and       al,3                     ; je prvn¡ podsc‚na ?
         jnz       l5991                    ; nen¡ nov  sc‚na
         mov       byte ptr ds:[da74e],120  ; z soba paliva - bajt 2
         mov       byte ptr ds:[da74c],0    ; z soba paliva - bajt 0
         mov       byte ptr ds:[da74d],0    ; z soba paliva - bajt 1

; ------ zobrazen¡ £vodu k sc‚nˆ a inicializa‡n¡ zobrazen¡ sc‚ny

l5991:   mov       byte ptr ds:[da73f],0ffh ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne
         jmp       short l599e
         nop
l5999:   mov       byte ptr ds:[da73f],0    ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne
l599e:   call      l59ed                    ; inicializa‡n¡ zobrazen¡ sc‚ny

; ------ inicializace polohy letadla

         mov       byte ptr ds:[da75a],92   ; poloha letadla vertik lnˆ Y
         mov       byte ptr ds:[da759],112  ; poloha letadla horizont lnˆ X

; ------ zobrazen¡ po‡tu ‘ivot– a zobrazen¡ ukazatele paliva

         call      l62c0                    ; zobrazen¡ po‡tu ‘ivot–
         call      l4f94                    ; zobrazen¡ zbyl‚ho paliva

; ------ inicializace ukazatel– pro novou sc‚nu (podsc‚nu)

         mov       al,30                    ; v˜choz¡ rychlost
         mov       ds:[da758],al            ; rychlost letu (30 a‘ 120)
         mov       byte ptr ds:[da757],0
         mov       byte ptr ds:[da745],0
         mov       byte ptr ds:[da756],1
         mov       byte ptr ds:[da755],0    ; posun podkladu p©i posunu rakety
         mov       byte ptr ds:[da754],0    ; nov  f ze v tabulce linek
         mov       byte ptr ds:[da753],0    ; p©edchoz¡ f ze v tabulce linek
         mov       byte ptr ds:[da743],0

; ------ vymaz n¡ tabulky objekt–

         mov       si,0                     ; ukazatel v tabulce objekt–
         mov       cx,8*MAXOBJ              ; d‚lka tabulky objekt–
l59df:   mov       byte ptr ds:[si+da688],0 ; zru¨en¡ objektu z tabulky
         inc       si
         loop      l59df                    ; dal¨¡ bajt tabulky

; ------ zobrazen¡ celkov‚ho po‡tu bran k proletˆn¡

         call      l5db0                    ; zobrazen¡ po‡tu zbyl˜ch bran/disk–
         jmp       l4f27                    ; z kladn¡ cyklus hry

l591f    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ £vodu k sc‚nˆ a inicializa‡n¡ zobrazen¡ sc‚ny
; -----------------------------------------------------------------------------

l59ed    PROC      NEAR

         call      l59fe                    ; vymaz n¡ videopamˆti
         call      l5a92                    ; zobrazen¡ £vodu k sc‚nˆ
         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jnz       l59fd                    ; nen¡ zobrazena zemˆ
         call      l50e6                    ; zobrazen¡ pozad¡ sc‚ny
l59fd:   ret

l59ed    ENDP

; -----------------------------------------------------------------------------
;    vymaz n¡ videopamˆti (vyma‘e 4000h bajt–)
; -----------------------------------------------------------------------------

l59fe    PROC      NEAR

         mov       cx,2000h                 ; d‚lka videopamˆti (slov)
         mov       ax,0                     ; nulovac¡ slovo
l5a04:   mov       bx,cx                    ; ukazatel ve videopamˆti
         shl       bx,1                     ; offset ve videopamˆti
         mov       es:[bx],ax
         loop      l5a04
         ret

l59fe    ENDP

; -----------------------------------------------------------------------------
;        obsluha posunu podkladu p©i posunu rakety
; -----------------------------------------------------------------------------

l5a0e    PROC      NEAR

; ------ zrychlen¡ posunu podkladu

         mov       al,ds:[da75c]            ; zrychlen¡ posunu podkladu X
         shr       al,1                     ; je zrychlen¡ = 0 ?
         jnz       l5a17                    ; je nˆjak‚ zrychlen¡
         mov       al,1                     ; omezen¡ na 1
l5a17:   mov       dl,al

; ------ rozli¨en¡ smˆru posunu

         test      byte ptr ds:[da736],80h  ; povel vpravo ?
         jz        l5a44                    ; posun vpravo
         test      byte ptr ds:[da736],10h  ; povel vlevo ?
         jz        l5a52                    ; posun vlevo

; ------ smˆr p©¡m˜ - zpomalen¡ posunu

         mov       al,ds:[da755]            ; posun podkladu p©i posunu rakety
         test      al,80h                   ; je z porn˜ posun ?
         jz        l5a39                    ; je kladn˜ posun
         add       al,dl                    ; zmen¨en¡ rychlosti smˆrem k +
         test      al,80h                   ; p©ete‡en¡ p©es 0 ?
         jnz       l5a5d                    ; nen¡ p©ete‡en¡ p©es 0
         mov       al,0                     ; omezen¡ na 0
         jmp       short l5a5d
         nop
l5a39:   sub       al,dl                    ; zmen¨en¡ rychlosti smˆrem k -
         test      al,80h                   ; p©ete‡en¡ ‡¡sla ?
         jz        l5a5d                    ; nen¡ p©ete‡en¡ ‡¡sla
         mov       al,0                     ; omezen¡ na 0
         jmp       short l5a5d
         nop

; ------ posun vpravo

l5a44:   mov       al,ds:[da755]            ; posun podkladu p©i posunu rakety
         sub       al,ds:[da75c]            ; zrychlen¡ posunu podkladu X
         jno       l5a5d                    ; nen¡ p©ete‡en¡
         mov       al,80h                   ; omezen¡ rychlosti
         jmp       short l5a5d
         nop

; ------ posun vlevo

l5a52:   mov       al,ds:[da755]            ; posun podkladu p©i posunu rakety
         add       al,ds:[da75c]            ; zrychlen¡ posunu podkladu X
         jno       l5a5d                    ; nen¡ p©ete‡en¡
         mov       al,7fh                   ; omezen¡ rychlosti
l5a5d:   mov       ds:[da755],al            ; posun podkladu p©i posunu rakety
         ret

l5a0e    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ textu DS:SI (1. slovo = pozice a © dek)
; -----------------------------------------------------------------------------

l5a61    PROC      NEAR

; ------ vypnut¡ kurzoru

         mov       ah,1
         mov       ch,60h
         int       10h                      ; nastaven¡ kurzoru - vypnut¡

; ------ nastaven¡ v˜choz¡ho © dku a pozice kurzoru

         mov       ah,2
         mov       dl,ds:[si]               ; pozice
         inc       si
         mov       dh,ds:[si]               ; © dek
         mov       bh,0                     ; str nka 0
         int       10h                      ; nastaven¡ pozice kurzoru

; ------ zobrazen¡ znaku textu

         mov       ah,9                     ; funkce zobrazen¡ znaku
         mov       bh,0                     ; str nka 0
         mov       cx,1                     ; 1 znak k zobrazen¡
         inc       si
         mov       al,ds:[si]               ; znak k zobrazen¡
         mov       bl,0fh                   ; barva textu
l5a7e:   cmp       al,0ffh                  ; je konec textu ?
         je        l5a91                    ; konec textu
         int       10h                      ; zobrazen¡ znaku

; ------ nastaven¡ dal¨¡ pozice kurzoru

         inc       dl                       ; zv˜¨en¡ pozice na © dku
         mov       ah,2
         int       10h                      ; nastaven¡ pozice kurzoru
         inc       si
         mov       al,ds:[si]               ; dal¨¡ znak k zobrazen¡
         mov       ah,9
         jmp       short l5a7e              ; zobrazen¡ dal¨¡ho znaku textu
l5a91:   ret

l5a61    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ £vodu k sc‚nˆ (pouze pro podsc‚nu 0)
; -----------------------------------------------------------------------------

l5a92    PROC      NEAR

; ------ test, zda se zobrazuje £vod ke sc‚nˆ

         cmp       byte ptr ds:[da73f],0    ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne
         jne       l5a9a                    ; £vod ke sc‚nˆ se zobrazuje
         ret

; ------ vymaz n¡ videopamˆti

l5a9a:   call      l59fe                    ; vymaz n¡ videopamˆti

; ------ zobrazen¡ textu "ENTERING SECTOR"

         mov       si,offset daa20          ; text "ENTERING SECTOR"
         call      l5a61                    ; zobrazen¡ textu

; ------ nastaven¡ pozice kurzoru pro zobrazen¡ ‡¡sla sekce

         mov       ah,2
         mov       dh,10                    ; © dek k zobrazen¡ ‡¡sla sc‚ny
         mov       dl,18                    ; pozice k zobrazen¡ ‡¡sla sc‚ny
         mov       bh,0                     ; str nka 0
         sti
         int       10h                      ; nastaven¡ kurzoru

; ------ zobrazen¡ ‡¡sla sekce

         mov       al,ds:[da73e]            ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru
         daa                                ; korekce ‡¡sla sc‚ny
         mov       cl,4                     ; po‡et rotac¡
         clc
         shr       al,cl                    ; ‡¡slo sekce
         add       al,"0"                   ; korekce na ‡¡slici ASCII
         mov       bl,0fh                   ; barva k zobrazen¡ znaku
         call      l5b2d                    ; zobrazen¡ znaku na pozici kurzoru

; ------ zobrazen¡ oddˆlovac¡ te‡ky

         mov       ah,2
         inc       dl                       ; n sleduj¡c¡ pozice
         int       10h                      ; nastaven¡ kurzoru
         mov       al,"."                   ; oddˆlovac¡ te‡ka
         call      l5b2d                    ; zobrazen¡ znaku na pozici kurzoru

; ------ zobrazen¡ ‡¡sla podsc‚ny

         mov       ah,2
         inc       dl                       ; zv˜¨en¡ pozice na © dku
         int       10h                      ; nastaven¡ kurzoru
         mov       al,ds:[da73e]            ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru
         daa                                ; korekce ‡¡sla
         and       al,0fh                   ; ‡¡slo podsc‚ny
         add       al,"0"                   ; korekce na ‡¡slici ASCII
         call      l5b2d                    ; zobrazen¡ znaku na pozici kurzoru

; ------ p©¡prava ke generov n¡ uvodn¡ho t¢nu p©i startu sc‚ny

         mov       word ptr ds:[da7c0],200  ; po‡et krok– £vodn¡ho t¢nu
         mov       word ptr ds:[da7c2],3000 ; po‡ te‡n¡ t¢n £vodn¡ho t¢nu
         cli

; ------ generov n¡ klesaj¡c¡ slo‘ky t¢nu

l5ae7:   mov       si,ds:[da7c2]            ; dˆlic¡ konstanta t¢nu
         mov       cx,800h                  ; d‚lka t¢nu
         call      l5b18                    ; t¢n (konstanta SI, d‚lka CX)

; ------ generov n¡ rostouc¡ slo‘ky t¢nu

         mov       si,10000                 ; v˜choz¡ konstanta pro 2. slo‘ku
         sub       si,ds:[da7c2]            ; rozd¡l - rostouc¡ slo‘ka
         mov       cx,800h                  ; d‚lka t¢nu
         call      l5b18                    ; t¢n (konstanta SI, d‚lka CX)

; ------ p©¡prava pro dal¨¡ krok t¢nu

         mov       ax,ds:[da7c2]            ; dˆlic¡ konstanta t¢nu
         add       ax,20h                   ; zv˜¨en¡ dˆlic¡ konstanty
         mov       ds:[da7c2],ax            ; nov  dˆlic¡ konstanta
         dec       word ptr ds:[da7c0]      ; ‡¡ta‡ krok– t¢nu
         jnz       l5ae7                    ; generov n¡ dal¨¡ho kroku t¢nu
         sti

; ------ vypnut¡ zvukov‚ho gener toru

         in        al,[61h]
         and       al,0fch
         out       [61h],al                 ; vypnut¡ zvukov‚ho gener toru

; ------ vymaz n¡ videopamˆti

         call      l59fe                    ; vymaz n¡ videopamˆti
         ret

l5a92    ENDP

; -----------------------------------------------------------------------------
;    t¢n (konstanta SI, d‚lka CX)
; -----------------------------------------------------------------------------

l5b18    PROC      NEAR

; ------ zapnut¡ v˜stupu na reproduktor

         in        al,[61h]
         or        al,3                     ; zapnut¡ v˜stupu
         out       [61h],al                 ; zapnut¡ v˜stupu na reproduktor

; ------ nastaven¡ dˆlic¡ konstanty SI gener toru

         mov       al,0b6h
         out       [43h],al                 ; povel pro nastaven¡ ‡¡ta‡e
         mov       ax,si
         out       [42h],al
         mov       al,ah
         out       [42h],al

; ------ prodleva

l5b2a:   loop      l5b2a                    ; prodleva
         ret

l5b18    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ znaku na pozici kurzoru
; -----------------------------------------------------------------------------

l5b2d    PROC      NEAR

         push      ax
         push      cx
         mov       ah,9
         mov       cx,1
         int       10h                      ; zobrazen¡ znaku
         pop       cx
         pop       ax
         ret

l5b2d    ENDP

; -----------------------------------------------------------------------------
; zobrazen¡ ‡¡sla BCD 6 ‡¡slic (DS:DI=ukazatel ‡¡sla, DX=pozice, kurzor nastaven)
; -----------------------------------------------------------------------------

l5b39    PROC      NEAR

; ------ zobrazen¡ vy¨¨¡ho znaku ‡¡sla

         mov       cx,3                     ; po‡et p r– ‡¡sel
l5b3c:   mov       al,ds:[di]               ; vy¨¨¡ ‡¡slice
         shr       al,1
         shr       al,1
         shr       al,1
         shr       al,1                     ; p©¡prava vy¨¨¡ tetr dy bajtu
         add       al,30h                   ; korekce na znak ASCII
         call      l5b2d                    ; zobrazen¡ znaku na pozici kurzoru

; ------ nastaven¡ nov‚ pozice kurzoru

         mov       ah,2
         inc       dl                       ; zv˜¨en¡ pozice na © dku
         int       10h                      ; nastaven¡ nov‚ pozice kurzoru

; ------ zobrazen¡ ni‘¨¡ ‡¡slice ‡¡sla

         mov       al,ds:[di]               ; ‡¡slo
         and       al,0fh                   ; ni‘¨¡ tetr da
         add       al,30h                   ; korekce na znak ASCII
         call      l5b2d                    ; zobrazen¡ znaku na pozici kurzoru

; ------ nastaven¡ pozice kurzoru

         mov       ah,2
         inc       dl                       ; zv˜¨en¡ pozice kurzoru
         int       10h                      ; nastaven¡ pozice kurzoru
         inc       di                       ; zv˜¨en¡ ukazatele v textu
         loop      l5b3c                    ; dal¨¡ dvojice ‡¡slic
         ret

l5b39    ENDP

         db        12 dup(0)

; ------ adresy obsluh

l5b70    label     word
         dw        offset l5c63 + KORIG     ; 0
         dw        offset l5c5a + KORIG     ; 1
         dw        offset l5c43 + KORIG     ; 2
         dw        offset l5c72 + KORIG     ; 3
         dw        offset l5c7c + KORIG     ; 4
         dw        offset l5c51 + KORIG     ; 5
         dw        offset l5cf7 + KORIG     ; 6
         dw        offset l5d97 + KORIG     ; 7

; -----------------------------------------------------------------------------
;    zobrazen¡ a obsluha pohybu v¨ech objekt–
; -----------------------------------------------------------------------------

l5b80    PROC      NEAR

; ------ p©¡prava k obsluze v¨ech objekt–

         mov       ax,0
         mov       di,0                     ; ukazatel v tabulce objekt–
         mov       cx,MAXOBJ                ; po‡et objekt–
         mov       byte ptr ds:[da71e],0ffh ; linka nalezen‚ho objektu
         mov       byte ptr ds:[da71f],0    ; p©¡znak nalezen¡ objektu k zobr.

; ------ nalezen¡ nejvzd lenˆj¨¡ho objektu k zobrazen¡

l5b93:   cmp       byte ptr ds:[di+da688],0 ; je nˆjak˜ objekt ?
         je        l5bbb                    ; nen¡ ‘ dn˜ objekt
         test      byte ptr ds:[di+da688+7],80h ; byl objekt ji‘ obslou‘en ?
         jnz       l5bbb                    ; byl ji‘ obslou‘en
         mov       byte ptr ds:[da71f],0ffh ; p©¡znak nalezen¡ objektu k zobr.
         mov       al,ds:[da71e]            ; linka dosud nalezen‚ho objektu
         cmp       al,ds:[di+da688+2]       ; je tento objekt vzd lenˆj¨¡ ?
         jb        l5bbb                    ; nen¡ vzd lenˆj¨¡
         mov       al,ds:[di+da688+2]       ; linka Y nov‚ho objektu
         mov       ds:[da71e],al            ; £schova linky objektu
         mov       ax,di                    ; offset definice objektu
         mov       ds:[da720],al            ; £schova offsetu objektu
l5bbb:   add       di,8                     ; adresa dal¨¡ho objektu
         loop      l5b93                    ; dal¨¡ objekt

; ------ test, zda byl nalezen nˆjak˜ objekt k zobrazen¡

         cmp       byte ptr ds:[da71f],0    ; byl nalezen nˆjak˜ objekt ?
         jne       l5bd8                    ; byl nalezen nˆjak˜ obejkt

; ------ jsou ji‘ v¨echny objekty - nulov n¡ v¨ech p©¡znak– zobrazen¡ objekt–

         mov       di,0                     ; offset v tabulce objekt–
         mov       cx,MAXOBJ                ; po‡et objekt– v tabulce
l5bcd:   and       byte ptr ds:[di+da688+7],7fh ; nulov n¡ p©¡znaku zobrazen¡
         add       di,8                     ; adresa dal¨¡ho objektu
         loop      l5bcd                    ; dal¨¡ objekt
         ret

; ------ vymaz n¡ star‚ho obr zku objektu

l5bd8:   mov       al,ds:[da720]            ; offset objektu k zobrazen¡
         mov       ah,0
         mov       di,ax                    ; offset definice objektu
         or        byte ptr ds:[di+da688+7],80h ; p©¡znak zobrazen¡ objektu
         call      l5f51                    ; p©¡prava k zobrazen¡ objektu
         jnc       l5bec                    ; objekt nebyl zobrazen
         call      l5287                    ; vymaz n¡ star‚ho obr zku objektu

; ------ obsluha pohybu objektu

l5bec:   mov       al,ds:[da720]            ; offset definice objektu k zobraz.
         mov       ah,0
         mov       si,ax                    ; offset definice objektu
         call      l5f7b                    ; obsluha pohybu objektu
         jc        l5c0a                    ; objekt byl zru¨en

; ------ zobrazen¡ objektu (na nov‚ pozici)

         mov       al,ds:[da720]            ; offset definice objektu
         mov       ah,0
         mov       di,ax                    ; offset definice objektu
         call      l5f51                    ; p©¡prava k zobrazen¡ objektu
         jnc       l5c07                    ; objekt se nebude zobrazovat
         call      l5232                    ; zobrazen¡ obr zku objektu
l5c07:   jmp       l5b80                    ; zobrazen¡ dal¨¡ho objektu

; ------ objekt byl zru¨en - zru¨en¡ objektu z tabulky

l5c0a:   mov       al,ds:[da720]            ; offset definice objektu
         mov       ah,0
         mov       di,ax                    ; offset definice objektu
         mov       byte ptr ds:[di+da688],0 ; zru¨en¡ objektu z tabulky
         jmp       l5b80                    ; zobrazen¡ dal¨¡ho objektu

l5b80    ENDP

; -----------------------------------------------------------------------------
;        obsluha pohybu objekt– (interpretace vnit©n¡ho jazyka)
; -----------------------------------------------------------------------------
; bit 7 = 0: zmˆna sou©adnic
;                            bit 0 a‘ bit 6 = p©¡rustek sou©adnice Y
;     n sleduje stavov˜ bajt pro X a velikost:
;                            bit 0: 1=zv˜¨en¡ p©¡rustku X; 0=sn¡‘en¡ p©¡rustku X
;                            bit 1: 1=zmen¨en¡ objektu; 0=zvˆt¨en¡ objektu
;                            bit 2: 1=smˆr posunu Y dol–, 0=smˆr nahoru
;                            bit 3: 1=smˆr posunu X vpravo, 0=smˆr vlevo
;                            bit 4: 1=zmˆna p©¡rustku sou©adnice X
;                            bit 5: 1=zmˆna velikosti objektu
;                            bit 6: 1=m  b˜t posun ve smˆru Y (smˆr bit 2)
;                            bit 7: 1=m  b˜t posun ve smˆru X (smˆr bit 3)
; bit 7 = 1: ©¡dic¡ povel
;            bit 0 a‘ bit 6 = povel:
;                  0 = nastaven¡ nov‚ho offsetu ukazatele akc¡ (n sleduje slovo offsetu)
;                  1 = nastaven¡ typu objektu (n sleduje bajt typu objektu)
;                  2 = konec pohybu
;                  3 = vol n¡ podprogramu (£schova sou‡asn‚ho ukazatele, n sleduje slovo)
;                  4 = n vrat z podprogramu (n vrat sou‡asn‚ho ukazatele)
;                  5 = nastaven¡ p©¡rustku sou©adnice X (n sleduje bajt p©¡rustku X)
;                  6 = test proletˆn¡ rakety branou
;                  7 = generov n¡ nov‚ho pohybu objektu 17 nebo 18
; -----------------------------------------------------------------------------

l5c19    PROC      NEAR

; ------ skok na obsluhu objektu

         inc       word ptr ds:[di+da640]   ; zv˜¨en¡ ukazatele akc¡ objekt–
l5c1d:   mov       bx,ds:[di+da640]         ; adresa pohyb–
         mov       bl,ds:[bx]               ; typ pohybu
         test      bl,80h
         jz        l5c8e                    ; je zmˆna sou©adnic
l5c28:   and       bl,7fh                   ; ‡¡slo objektu
         cmp       bl,8
         jae       l5c28                    ; ???
         shl       bl,1
         mov       bh,0
         mov       ax,cs:[bx+l5b70 + KORIG] ; adresa obsluhy objektu
         mov       bl,ds:[da720]            ; offset definice objektu
         mov       bh,0
         mov       si,bx                    ; offset definice objektu
         jmp       ax                       ; skok na obsluhu pohybu

; ------ 2: konec pohybu

l5c43:   cmp       byte ptr ds:[si+da688],1 ; typ objektu = sloup ?
         jne       l5c4f                    ; nen¡ to sloup
         mov       byte ptr ds:[da745],0    ; p©¡znak konce pohybu sloupu
l5c4f:   stc
         ret

; ------ 5: nastaven¡ p©¡rustku sou©adnice X (n sleduje bajt p©¡rustku X)

l5c51:   call      l5f42                    ; dal¨¡ bajt z tabulky akc¡
         mov       ds:[si+da688+5],al       ; p©¡rustek sou©adnice X
         jmp       short l5c1d

; ------ 1: nastaven¡ typu objektu (n sleduje bajt typu objektu)

l5c5a:   call      l5f42                    ; dal¨¡ bajt z tabulky akc¡
         mov       ds:[si+da688],al         ; nastaven¡ typu objektu
         jmp       short l5c1d

; ------ 0: nastaven¡ nov‚ho offsetu ukazatele akc¡ (n sleduje slovo offsetu)

l5c63:   call      l5f42                    ; dal¨¡ bajt z tabulky akc¡
         mov       bx,ds:[di+da640]         ; tabulka akc¡ objekt–
         mov       ah,ds:[bx]
         mov       ds:[di+da640],ax         ; tabulka akc¡ objekt–
         jmp       short l5c1d

; ------ 3: vol n¡ podprogramu (£schova sou‡asn‚ho ukazatele, n sleduje slovo)

l5c72:   mov       ax,ds:[di+da640]         ; tabulka akc¡ objekt–
         mov       ds:[di+da660],ax         ; tabulka £schovy adres akc¡ objekt–
         jmp       short l5c63

; ------ 4: n vrat z podprogramu (n vrat sou‡asn‚ho ukazatele)

l5c7c:   mov       ax,ds:[di+da660]         ; tabulka £schovy adres akc¡ objekt–
         mov       ds:[di+da640],ax         ; tabulka akc¡ objekt–
         inc       word ptr ds:[di+da640]   ; zv˜¨en¡ ukazatele akce
         inc       word ptr ds:[di+da640]   ; zv˜¨en¡ ukazatele akce
         jmp       short l5c19


; ====== zmˆna sou©adnic objektu (bit 7 = 0)

; ------ nastaven¡ p©¡rustku Y

l5c8e:   mov       ds:[si+da688+6],bl       ; p©¡rustek sou©adnice Y

; ------ p©¡znakov‚ slovo objektu (a zmˆna sou©adnic X)

         inc       word ptr ds:[di+da640]   ; tabulka akc¡ objekt–
         mov       bx,ds:[di+da640]         ; tabulka akc¡ objekt–
         mov       al,ds:[bx]               ; p©¡znaky
         mov       ds:[da717],al            ; p©¡znaky objektu

; ------ test, zda je zmˆna velikosti objektu

         test      al,20h                   ; po‘aduje se zmˆna velikosti ?
         jz        l5cc9                    ; nen¡ zmˆna velikosti
         test      byte ptr ds:[da717],2    ; je zmen¨en¡ objektu ?
         jz        l5cbb                    ; je zvˆt¨en¡ objektu

; ------ zmen¨en¡ velikosti objektu

         mov       al,ds:[si+da688+3]       ; velikost objektu
         inc       al                       ; zmen¨en¡ objektu
         cmp       al,10                    ; maxim ln¡ velikost
         jae       l5cc9                    ; je ji‘ maxim ln¡ velikost
         mov       ds:[si+da688+3],al       ; velikost objektu
         jmp       short l5cc9
         nop

; ------ zvˆt¨en¡ velikosti objektu

l5cbb:   mov       al,ds:[si+da688+3]         ; velikost objektu
         dec       al
         cmp       al,0ffh
         jz        l5cc9
         mov       ds:[si+da688+3],al         ; velikost objektu

; ------ test, zda je zmˆna rychlosti X

l5cc9:   test      byte ptr ds:[da717],10h  ; je zmˆna p©¡rustku X ?
         jz        l5ce6                    ; nen¡
         test      byte ptr ds:[da717],1    ; je sn¡‘en¡ p©¡rustku X ?
         jz        l5ce8                    ; je sn¡‘en¡ p©¡rustku X

; ------ zv˜¨en¡ p©¡rustku X

         mov       al,ds:[si+da688+5]       ; p©¡rustek X
         clc
         adc       al,8                     ; zv˜¨en¡ p©¡rustku X
         jnc       l5ce2
         mov       al,0ffh                  ; omezen¡
l5ce2:   mov       ds:[si+da688+5],al       ; nov˜ p©¡rustek X
l5ce6:   clc
         ret

; ------ sn¡‘en¡ p©¡rustku X

l5ce8:   mov       al,ds:[si+da688+5]       ; p©¡rustek X
         clc
         sbb       al,8                     ; sn¡‘en¡
         jz        l5cf3
         jnc       l5ce2
l5cf3:   mov       al,1                     ; omezen¡ p©¡rustku
         jmp       short l5ce2

; ------ 6: test proletˆn¡ rakety branou

l5cf7:   cmp       byte ptr ds:[da745],0
         jnz       l5d0a
         mov       al,ds:[si+da688+1]         ; pozice objektu X
         or        al,1
         mov       ds:[da745],al
         jmp       l5c19                    ; dal¨¡ krok pohybu

; ------ nalezen¡ br ny v tabulce objekt–

l5d0a:   push      di
         mov       di,0
         mov       cx,10h
l5d11:   cmp       byte ptr ds:[di+da688],1 ; typ objektu = sloup ?
         jne       l5d26
         cmp       di,si
         je        l5d26                    ; je to stejn˜ sloup
         mov       al,ds:[di+da688+1]         ; pozice objektu X
         mov       ds:[da745],al
         jmp       short l5d2f
         nop

l5d26:   add       di,8
         loop      l5d11
         pop       di
         jmp       short l5d80
         nop

; ------ test, zda letadlo proletˆlo branou

l5d2f:   pop       di
         mov       al,ds:[da759]            ; poloha letadla horizont lnˆ X
         add       al,8                     ; rezerva
         cmp       al,ds:[si+da688+1]         ; pozice objektu X
         jb        l5d44
         cmp       al,ds:[da745]
         jb        l5d4a
         jmp       short l5d80
         nop
l5d44:   cmp       al,ds:[da745]
         jb        l5d80
l5d4a:   mov       ds:[da686],si
         mov       ds:[da684],di

; ------ zv˜¨en¡ sk¢re po proletˆn¡ branou

         mov       ax,500h                  ; sk¢re za proletˆn¡ branou
         call      l63b2                    ; zv˜¨en¡ sk¢re o AX

; ------ sn¡‘en¡ po‡tu zbyl˜ch bran

         cmp       byte ptr ds:[da739],0    ; p©¡znak, ‘e se m  prol‚tat branami
         jne       l5d68
         dec       byte ptr ds:[da763]      ; sn¡‘en¡ ‡¡ta‡e bran
         jnz       l5d68                    ; nejsou je¨tˆ v¨echny br ny
         jmp       l64dc                    ; nov  sc‚na
l5d68:   call      l5db0                    ; zobrazen¡ po‡tu zbyl˜ch bran
         mov       al,8
         call      l680e                    ; zvukov  signalizace - br na

; ------ obsluha objektu

         mov       di,ds:[da684]
         mov       si,ds:[da686]
l5d78:   mov       byte ptr ds:[da745],0
         jmp       l5c19

l5d80:   mov       ds:[da684],di
         mov       ds:[da686],si
         mov       al,7
         call      l680e                    ; zvukov  signalizace
         mov       di,ds:[da684]
         mov       si,ds:[da686]
         jmp       short l5d78

; ------ 7: generov n¡ nov‚ho pohybu objektu 17 nebo 18

l5d97:   call      l6160                    ; gener tor n hody
         test      al,80h
         jnz       l5da3
         mov       al,12h
         jmp       short l5da5
         nop

l5da3:   mov       al,11h
l5da5:   call      l614a                    ; za©azen¡ objektu do tabulky akc¡
         or        byte ptr ds:[si+da688+7],10h
         jmp       l5c19

l5c19    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ po‡tu zbyl˜ch bran k proletˆn¡/disk– k post©¡len¡
; -----------------------------------------------------------------------------

l5db0    PROC      NEAR

; ------ ur‡en¡ barvy pozad¡ pro vymaz n¡ pr zdn‚ pozice

         mov       dh,055h                  ; modrozelen 
         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jz        l5dbb                    ; je zobrazena zemˆ
         mov       dh,0                     ; jinak ‡ern  barva

; ------ stanoven¡ po‡tu zbyl˜ch bran/disk– k zobrazen¡

l5dbb:   mov       si,23                    ; po‡ te‡n¡ linka k zobrazen¡
         mov       di,0                     ; ukazatel v obr zku disku
         mov       dl,ds:[da763]            ; po‡et zbyl˜ch bran/disk–
         cmp       dl,20                    ; je m‚nˆ bran/disk– ne‘ 20 ?
         jb        l5dd7                    ; je m‚nˆ bran ne‘ 20
         mov       byte ptr ds:[da716],20   ; omezen¡ po‡tu bran/disk– na 20
         mov       byte ptr ds:[da717],0    ; nezb˜v  ‘ dn  pozice
         jmp       short l5de4
         nop
l5dd7:   mov       ds:[da716],dl            ; po‡et bran/disk– k proletˆn¡
         mov       byte ptr ds:[da717],20   ; celkov˜ po‡et bran/disk– = 20
         sub       ds:[da717],dl            ; po‡et zbyl˜ch pozic k vymaz n¡

; ------ p©¡prava k zobrazen¡ jedn‚ linky

l5de4:   mov       bx,si                    ; ‡¡slo videolinky
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa ve videopamˆti

; ------ zobrazen¡ jedn‚ linky bran

         mov       dl,ds:[da716]            ; po‡et pozic k zobrazen¡
l5df0:   mov       cx,3                     ; po‡et bajt– na linku
l5df3:   mov       al,ds:[di+da470]         ; bajt obr zku
         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jz        l5e00                    ; je zobrazena
         xor       al,55h                   ; zmˆna barvy
l5e00:   mov       es:[bx],al               ; ulo‘en¡ bajtu
         inc       di                       ; ukazatel obr zku
         inc       bx                       ; adresa ve videopamˆti
         loop      l5df3                    ; dal¨¡ bajt na © dku
         sub       di,3                     ; n vrat adresy obr zku
         dec       dl                       ; ‡¡ta‡ pozic k zobrazen¡
         jnz       l5df0                    ; zobrazen¡ dal¨¡ pozice

; ------ vymaz n¡ jedn‚ linky zbyl˜ch pozic

         cmp       byte ptr ds:[da717],0    ; zbyly nˆjak‚ pozice k vymaz n¡ ?
         jz        l5e28                    ; nezbyla ‘ dn  pozice k vymaz n¡
         mov       dl,ds:[da717]            ; po‡et pozic k vymaz n¡
l5e19:   mov       cx,3                     ; po‡et bajt– na linku
         mov       al,dh                    ; barva pozad¡
l5e1e:   mov       es:[bx],al               ; zobrazen¡ bajtu
         inc       bx                       ; adresa ve videopamˆti
         loop      l5e1e                    ; dal¨¡ bajt
         dec       dl                       ; ‡¡ta‡ pozic k vymaz n¡
         jnz       l5e19                    ; vymaz n¡ dal¨¡ pozice

; ------ p©¡prava pro dal¨¡ linku

l5e28:   add       di,3                     ; zv˜¨en¡ offsetu v obr zku
         inc       si                       ; zv˜¨en¡ ‡¡sla linky
         cmp       si,31                    ; je ji‘ posledn¡ linka ?
         jne       l5de4                    ; nen¡ - dal¨¡ linka
         ret

l5db0    ENDP


l5e32    db        0                        ; sou©adnice p©i generov n¡ disk–
         db        25h
         db        4ah
         db        6fh

; -----------------------------------------------------------------------------
;    generov n¡ st©el
; -----------------------------------------------------------------------------

l5e36    PROC      NEAR

; ------ test, zda m–‘e b˜t dal¨¡ st©ela

         test      byte ptr ds:[da736],20h  ; st©¡len¡ ?
         jnz       l5e49                    ; nen¡ st©¡len¡
         cmp       byte ptr ds:[da741],0    ; m–‘e b˜t dal¨¡ st©ela ?
         je        l5e4f                    ; m–‘e b˜t dal¨¡ st©ela
         dec       byte ptr ds:[da741]      ; ‡¡ta‡ prodlevy mezi st©elami
         ret
l5e49:   mov       byte ptr ds:[da741],0    ; zru¨en¡ ‡¡ta‡e prodlevy st©el
         ret

; ------ vytvo©en¡ popisova‡e objektu

l5e4f:   mov       di,5                     ; ‡¡slo objektu = st©ela
         mov       si,0                     ; po‡ te‡n¡ offset v tabulce
         call      l5f17                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l5e86                    ; nen¡ voln  polo‘ka popisova‡e

; ------ pozice st©ely X

         mov       al,ds:[da759]            ; poloha letadla horizont lnˆ X
         add       al,8                     ; pozice objektu = st©ed letadla
         mov       ds:[si+da688+1],al       ; pozice st©ely X

; ------ poloha st©ely Y

         mov       al,ds:[da75a]            ; poloha letadla vertik lnˆ Y
         sub       al,3                     ; linka objektu = nad letadlem
         mov       ds:[si+da688+2],al       ; sou©adnice st©ely Y

; ------ ostatn¡ parametry objektu

         mov       byte ptr ds:[si+da688+5],200 ; p©¡rustek sou©adnice X
         mov       byte ptr ds:[si+da688+3],5 ; velikost objektu = 5
         mov       al,0                     ; ‡¡slo pohybu - st©ela
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ p©¡prava pro p©¡¨t¡ st©elu

         mov       al,ds:[da76c]            ; rychlost st©¡len¡
         mov       ds:[da741],al            ; prodleva mezi st©elami

; ------ zvukov  indikace st©ely

         mov       al,1                     ; ‡¡slo melodie - st©¡len¡
         call      l680e                    ; zvukov  indikace st©¡len¡
l5e86:   ret

l5e36    ENDP

; -----------------------------------------------------------------------------
;    generov n¡ disku
; -----------------------------------------------------------------------------

l5e87    PROC      NEAR

; ------ test, zda je povoleno generov n¡ disku

         test      byte ptr ds:[da769],8    ; povoleno generov n¡ disku ?
         jz        l5eb6                    ; nepo‘aduje se generov n¡ disku
         test      byte ptr ds:[da769],4    ; je povolena pouze jedna skupina ?
         jz        l5eab                    ; je mo‘n‚ v¡ce disk–

; ------ test, zda je ji‘ generov n disk (pokud je povolena pouze 1 skupina)

         mov       di,0                     ; ukazatel v tabulce objekt–
l5e98:   cmp       byte ptr ds:[di+da688],2 ; nalezen disk ?
         je        l5eb6                    ; je ji‘ generov n - nebude dal¨¡
         add       di,8                     ; dal¨¡ objekt
         cmp       di,8*MAXOBJ              ; jsou ji‘ v¨echny objekty ?
         jne       l5e98                    ; dal¨¡ objekt
         jmp       short l5eb7              ; disk nenalezen - generov n¡ disku
         nop

; ------ ‡¡ta‡ pro generov n¡ dal¨¡ho disku

l5eab:   cmp       byte ptr ds:[da743],0    ; je ji‘ ‡as pro dal¨¡ disk ?
         je        l5eb7                    ; m–‘e b˜t dal¨¡ disk
         dec       byte ptr ds:[da743]      ; ‡¡t n¡ ‡¡ta‡e generov n¡ disku
l5eb6:   ret

; ------ stanoven¡ po‡tu disk– k vygenerov n¡

l5eb7:   call      l6160                    ; gener tor n hody
         and       al,3                     ; 1 a‘ 4 disky
         mov       ds:[da735],al            ; po‡et disk– k vygenerov n¡ - 1

; ------ stanoven¡ pozice X disku

l5ebf:   call      l6160                    ; gener tor n hody
         add       al,30                    ; po‡ te‡n¡ sou©adnice X
         cmp       al,180                   ; maxim ln¡ sou©adnice X
         ja        l5ebf                    ; nepovolen  sou©adnice - znovu
         mov       ds:[da734],al            ; po‡ te‡n¡ pozice vygener. disku X

; ------ stanoven¡ ‡¡sla smˆru pohybu disku

         call      l6160                    ; gener tor n hody
         and       al,3                     ; 0 a‘ 3
         add       al,3                     ; 3 a‘ 6
         mov       ds:[da733],al            ; ‡¡slo smˆru pohybu

; ------ vygenerov n¡ jednoho disku

l5ed5:   mov       di,2                     ; objekt = disk
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l5eb6

; ------ vygenerov n¡ pohybu disku

         mov       al,ds:[da733]            ; snˆr pohybu disku
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ pozice disku

         mov       al,ds:[da734]            ; v˜choz¡ pozice disku X
         mov       ds:[si+da688+1],al       ; pozice objektu X

; ------ prodleva a sou©adnice Y disku

         mov       al,ds:[da735]            ; po‡et disk– k vygenerov n¡ - 1
         mov       ah,0
         mov       di,ax                    ; po‡et disk– k vygenerov n¡ - 1
         mov       al,cs:[di+l5e32 + KORIG]
         mov       ds:[si+da688+6],al
         add       al,144
         mov       ds:[si+da688+2],al         ; sou©adnice objektu Y
         mov       al,ds:[da75f]
         mov       ds:[si+da688+5],al

; ------ dal¨¡ disk

         dec       byte ptr ds:[da735]      ; po‡et vygenerovan˜ch disk–
         jns       l5ed5                    ; dal¨¡ disk
         mov       al,ds:[da75e]            ; rychlost generov n¡ disk–
         mov       ds:[da743],al            ; ‡¡ta‡ pro generov n¡ dal¨¡ho disku
         ret

l5e87    ENDP

; -----------------------------------------------------------------------------
;    vlo‘en¡ objektu do tabulky objekt– (CY=nenalezena voln  polo‘ka)
; -----------------------------------------------------------------------------

l5f14    PROC      NEAR

         mov       si,10h                   ; od polo‘ky 2

; ====== sem se sk ‡e se zad n¡m po‡ tku hled n¡ SI

; ------ nalezen¡ voln‚ polo‘ky v tabulce

l5f17:   cmp       si,8*MAXOBJ              ; je konec tabulky ?
         jae       l5f29                    ; konec tabulky
         cmp       byte ptr ds:[si+da688],0 ; je polo‘ka voln  ?
         je        l5f2b                    ; nalezena voln  polo‘ka
         add       si,8                     ; zv˜¨en¡ ukazatele v tabulce
         jmp       short l5f17              ; dal¨¡ polo‘ka
l5f29:   stc                                ; p©¡znak, ‘e tabulka je ji‘ pln 
         ret

; ------ inicializace popisova‡e objektu

l5f2b:   mov       ax,di                    ; ‡¡slo objektu
         mov       ds:[si+da688],al         ; typ objektu
         mov       cx,7                     ; po‡et bajt– popisova‡e k vymaz n¡
         inc       si
l5f35:   mov       byte ptr ds:[si+da688],0 ; vymaz n¡ bajtu polo‘ky
         inc       si
         loop      l5f35                    ; dal¨¡ bajt
         sub       si,8                     ; adresa popisova‡e
         clc                                ; p©¡znak nalezen¡ polo‘ky
         ret

l5f14    ENDP

; -----------------------------------------------------------------------------
;        dal¨¡ bajt z tabulky akc¡ objekt–
; -----------------------------------------------------------------------------

l5f42    PROC      NEAR

         push      bx
         mov       bx,ds:[di+da640]         ; tabulka akc¡ objekt–
         inc       bx
         mov       al,ds:[bx]               ; dal¨¡ bajt z tabulky akc¡
         inc       bx
         mov       ds:[di+da640],bx         ; tabulka akc¡ objekt–
         pop       bx
         ret

l5f42    ENDP

; -----------------------------------------------------------------------------
;    p©¡prava k zobrazen¡/vymaz n¡ objektu (DI=offset definice objektu)
; -----------------------------------------------------------------------------

l5f51    PROC      NEAR

; ------ test, zda je objekt p©¡li¨ daleko

         cmp       byte ptr ds:[di+da688+3],MAXFAZE ; je objekt viditeln˜ ?
         jne       l5f5a                    ; je viditeln˜
         clc                                ; p©¡znak, ‘e objekt se nezobraz¡
         ret

; ------ stanoven¡ ‡¡sla obr zku k zobrazen¡

l5f5a:   mov       al,ds:[di+da688]         ; typ objektu
         mov       ah,0
         mul       byte ptr ds:[da715]      ; * po‡et f z¡ na objekt
         add       al,ds:[di+da688+3]       ; + f ze objektu -> ‡¡slo obr zku
         mov       ds:[da732],al            ; ‡¡slo obr zku k zobrazen¡

; ------ stanoven¡ sou©adnic obr zku k zobrazen¡

         mov       al,ds:[di+da688+1]       ; pozice objektu X
         mov       ds:[da733],al            ; pozice k zobrazen¡ obr zku
         mov       al,ds:[di+da688+2]       ; linka objektu Y
         mov       ds:[da734],al            ; ‡¡slo linky k zobrazen¡ obr zku
         stc                                ; p©¡znak, ‘e se obr zek zobraz¡
         ret

l5f51    ENDP

; -----------------------------------------------------------------------------
;        Obsluha pohybu objekt– (SI=offset definice objektu)
; -----------------------------------------------------------------------------

l5f7b    PROC      NEAR

; ------ ukazatel v tabulce akc¡ objekt–

         mov       di,si                    ; offset v tabulce objekt–
         shr       di,1
         shr       di,1                     ;
         mov       word ptr ds:[da71a],di   ; offset v tabulce akc¡

; ------

l5f85:   cmp       byte ptr ds:[si+da688+6],0 ; p©¡rustek Y - pohybuje se ?
         jne       l5f92                    ; objekt se pohybuje
         call      l5c19                    ; obsluha objektu
         jnc       l5f85
         ret

; ------ rychlost pohybu st©ely

l5f92:   cmp       byte ptr ds:[si+da688],5 ; typ objektu = st©ela ?
         jnz       l5fa1
         mov       byte ptr ds:[da718],0    ; rychlost pohybu st©ely minim ln¡
         jmp       short l5fb5
         nop

; ------ stanoven¡ rychlosti pohybu (vzd len‚ objekty se pohybuj¡ pomaleji)

l5fa1:   mov       al,9
         sub       al,ds:[si+da688+3]         ; velikost objektu
         mov       ah,0
         mul       byte ptr ds:[da758]      ; rychlost letu (30 a‘ 120)
         mov       ds:[da718],ah            ; rychlost pohybu objektu
         shl       byte ptr ds:[da718],1    ; rychlost pohybu objektu

l5fb5:   mov       di,word ptr ds:[da71a]   ; offset po‡ tku zobrazovan‚ho obr zku
         mov       al,ds:[si+da688+4]
         mov       ds:[da717],al            ;
         mov       cl,4
         shr       al,cl
         mov       ds:[da716],al            ; p©¡rustek

         mov       al,ds:[da717]
         mov       ah,0
         mov       bl,ds:[si+da688+5]       ; p©¡rustek sou©adnice X
         mov       bh,0
         add       ax,bx
         mov       ds:[si+da688+4],al

         shr       ax,cl                    ; /16
         add       al,ds:[da718]            ; rychlost pohybu objektu
         sub       al,ds:[da716]
l5fe2:   mov       ds:[da716],al            ; p©¡rustek

         mov       di,word ptr ds:[da71a]   ; offset po‡ tku zobrazovan‚ho obr zku
         mov       bx,ds:[di+da640]         ; tabulka akc¡ objekt–
         mov       al,ds:[bx]
         mov       ds:[da719],al            ; parametry pohybu

         mov       al,ds:[da716]            ; p©¡rustek ve smˆru Y
         cmp       al,0
         je        l6029
         clc
         sbb       al,ds:[si+da688+6]       ; p©¡rustek sou©adnice Y
         jnc       l6010
         xor       al,0ffh                  ; negace
         add       al,1
         mov       ds:[si+da688+6],al       ; p©¡rustek sou©adnice Y
         call      l609b                    ; posun objektu ve smˆru X nebo Y
         jnc       l6029
         jmp       l6099
l6010:   mov       ds:[da718],al            ; rychlost pohybu objektu
         mov       al,ds:[si+da688+6]       ; p©¡rustek sou©adnice Y
         mov       ds:[da716],al            ; p©¡rustek ve smˆru Y
         call      l609b                    ; posun objektu ve smˆru X nebo Y
         jc        l6099
         call      l5c19                    ; obsluha pohybu objekt–
         jc        l6099
         mov       al,ds:[da718]            ; rychlost pohybu objektu
         jmp       short l5fe2

l6029:   cmp       byte ptr ds:[si+da688],7 ; typ objektu = v˜buch
         jz        l6037
         cmp       byte ptr ds:[si+da688],4 ; typ objektu = bomba lodi
         jnc       l6097

; ------ v˜buch

l6037:   mov       al,ds:[si+da688+3]         ; velikost objektu
         mov       ah,0
         mov       di,ax
         cmp       di,9
         jz        l6097

         mov       al,ds:[di+da709]
         mov       ds:[da716],al            ; p©¡rustek

         mov       al,ds:[da755]            ; posun podkladu p©i posunu rakety
         mov       dl,al
         test      al,80h
         jz        l6058
         xor       al,0ffh
         add       al,1
l6058:   shr       al,1
         dec       byte ptr ds:[da716]      ; p©¡rustek
         jnz       l6058
         test      dl,80h
         jz        l6069
         xor       al,0ffh
         add       al,1
l6069:   mov       dl,al
         clc
         add       ds:[si+da688+1],al         ; pozice objektu X
         jc        l6092
         test      dl,80h
         jz        l6097
l6077:   cmp       byte ptr ds:[si+da688],1 ; typ objektu =
         jnz       l6099
         cmp       byte ptr ds:[da745],0
         jz        l6099
         mov       al,7
         call      l680e                    ; zvukov  signalizace
         mov       byte ptr ds:[da745],0
         jmp       short l6099
         nop
l6092:   test      dl,80h
         jz        l6077
l6097:   clc
         ret
l6099:   stc
         ret

l5f7b    ENDP

; -----------------------------------------------------------------------------
;        posun objektu ve smˆru X nebo Y
; -----------------------------------------------------------------------------
; VSTUP: SI=ukazatel definice objektu
;        [da716] = p©¡rustek
;        [da719] = parametry
;                     bit 7: 1=m  b˜t posun ve smˆru X
;                     bit 6: 1=m  b˜t posun ve smˆru Y
;                     bit 3: 1=smˆr vpravo, 0=smˆr vlevo
;                     bit 2: 1=smˆr dol–, 0=smˆr nahoru
; -----------------------------------------------------------------------------

l609b    PROC      NEAR

         call      l60a9                    ; posun ve smˆru X
         jc        l60c4
         inc       si
         call      l60a9                    ; posun ve smˆru Y
         jc        l60c4
         dec       si
l60a7:   clc
         ret

l609b    ENDP

; -----------------------------------------------------------------------------
;        posun objektu v dan‚m smˆru
; -----------------------------------------------------------------------------

l60a9    PROC      NEAR

; ------ test, zda je posun objektu

         rol       byte ptr ds:[da719],1    ; m  b˜t posun obj. v dan‚m smˆru ?
         jnc       l60a7                    ; nen¡ posun objektu
         test      byte ptr ds:[da719],10h  ; je smˆr vpravo (dol–) ?
         jz        l60c6                    ; je smˆr vlevo (nahoru)

; ------ posun objektu vpravo (dol–)

         mov       al,ds:[si+da688+1]       ; pozice objektu X (Y)
         add       al,ds:[da716]            ; p©¡rustek
         mov       ds:[si+da688+1],al       ; pozice objektu X (Y)
         jnc       l60a7                    ; operace OK
l60c4:   stc
         ret

; ------ posun objektu vlevo (nahoru)

l60c6:   mov       al,ds:[da716]
         clc
         sbb       ds:[si+da688+1],al       ; pozice objektu X (Y)
         jnc       l60a7
         jmp       short l60c4

l60a9    ENDP

; -----------------------------------------------------------------------------
;    generov n¡ nov‚ br ny
; -----------------------------------------------------------------------------

l60d2    PROC      NEAR

; ------ test, zda m  b˜t vygenerov na nov  br na

         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jnz       l60f9                    ; nen¡ zemˆ - nejsou br ny
         cmp       byte ptr ds:[da742],0    ; ‡¡ta‡ generov n¡ dal¨¡ br ny
         jnz       l60fa                    ; nen¡ je¨tˆ dal¨¡ br na

; ------ vygenerov n¡ nov‚ br ny

         mov       di,1                     ; objekt = sloup
         call      l5f14                    ; vygenerov n¡ lev‚ho sloupu
         jc        l60f9                    ; buffer objekt– pln˜
         mov       bx,si                    ; £schova definice sloupu
         mov       di,1                     ; objekt = sloup
         call      l5f14                    ; vygenerov n¡ prav‚ho sloupu
         jnc       l6100                    ; vygenerov n¡ OK
         mov       si,bx                    ; adresa lev‚ho sloupu
         mov       byte ptr ds:[si+da688],0 ; opˆt zru¨en¡ lev‚ho sloupu
l60f9:   ret

; ------ ‡¡t n¡ prodlevy pro dal¨¡ br nu

l60fa:   dec       byte ptr ds:[da742]      ; ‡¡ta‡ pro generov n¡ dal¨¡ br ny
         jmp       short l60f9              ; konec

; ------ generov n¡ pozice X prav‚ho sloupu

l6100:   call      l6160                    ; gener tor n hory
         cmp       al,200                   ; pozice 200 ?
         jae       l6100                    ; p©¡li¨ velk  pozice - znovu
         mov       ds:[si+da688+1],al       ; pozice prav‚ho sloupu X

; ------ generov n¡ pozice X lev‚ho sloupu

         xchg      si,bx                    ; definice lev‚ho sloupu
         clc
         sbb       al,ds:[da765]            ; ¨¡©ka br ny
         jc        l6100                    ; br na p©¡li¨ vlevo - znovu
         cmp       al,50                    ; minim ln¡ pozice
         jbe       l6100                    ; n¡zk  pozice - znovu
         mov       ds:[si+da688+1],al       ; pozice lev‚ho sloupu X

; ------ parametry br ny

         mov       byte ptr ds:[si+da688+7],8 ; smˆr pohybu st©el vlevo
         mov       byte ptr ds:[si+da688+3],9 ; velikost objektu - dosud nen¡
         mov       byte ptr ds:[bx+da688+3],9 ; velikost objektu - dosud nen¡
         mov       byte ptr ds:[si+da688+5],32 ; p©¡rustek sou©adnice
         mov       byte ptr ds:[bx+da688+5],32 ; p©¡rustek sou©adnice

; ------ definov n¡ pohybu br ny

         mov       ax,1                     ; pohyb lev‚ho sloupu
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡
         xchg      si,bx
         mov       ax,2                     ; prav  br na
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ ‡¡ta‡ pro generov n¡ dal¨¡ br ny

         mov       al,ds:[da75d]            ; rychlost generov n¡ bran
         mov       ds:[da742],al            ; ‡¡ta‡ pro generov n¡ dal¨¡ br ny
         ret

l60d2    ENDP

; -----------------------------------------------------------------------------
;        Za©azen¡ objektu do tabulky pohyb–
;        (SI=polo‘ka v tabulce objekt–, AL=‡¡slo pohybu)
; -----------------------------------------------------------------------------

l614a    PROC      NEAR

         push      si
         mov       di,si                    ; offset definice objektu
         shr       di,1
         shr       di,1                     ; ‡¡slo objektu * 2
         mov       ah,0
         mov       si,ax                    ; ‡¡slo pohybu
         shl       si,1
         mov       ax,ds:[si+dad92]         ; adresa definice pohybu
         mov       ds:[di+da640],ax         ; tabulka pohyb– objekt–
         pop       si

l614a    ENDP

; -----------------------------------------------------------------------------
;    gener tor n hodn‚ho ‡¡sla (bajt)
; -----------------------------------------------------------------------------

l6160    PROC      NEAR

         push      bx
         inc       word ptr ds:[da680]      ; zv˜¨en¡ ukazatele v programu
         cmp       word ptr ds:[da680],offset l680e + KORIG ; maxim ln¡ adresa
         ja        l6175                    ; p©ekro‡ena maxim ln¡ adresa
         cmp       word ptr ds:[da680],offset l4eb0 + KORIG ; minim ln¡ adresa
         ja        l617c                    ; adresa je OK
l6175:   mov       bx,offset l4eb0 + KORIG  ; po‡ tek programu
         mov       ds:[da680],bx            ; ukazatel gener toru
l617c:   mov       bx,ds:[da680]            ; adresa v programu
         mov       al,cs:[bx]               ; bajt z programu
         add       al,ds:[dad90]            ; korekce n hodn‚ho ‡¡sla
         add       al,0efh                  ; dal¨¡ korekce
         mov       ds:[dad90],al            ; nov  korekce pro p©¡¨tˆ
         pop       bx
         ret

l6160    ENDP

         dw        0

; -----------------------------------------------------------------------------
;    vstup ovl d n¡ z kl vesnice nebo joysticku
; -----------------------------------------------------------------------------

l6190    PROC      NEAR

; ------ test, zda zbylo nˆjak‚ palivo

         mov       al,ds:[da74c]            ; z soba paliva
         or        al,ds:[da74d]
         or        al,ds:[da74e]
         jnz       l61a0                    ; je je¨tˆ nˆjak‚ palivo
         jmp       l627a                    ; do¨lo palivo - zpomalen¡

; ------ rozli¨en¡, zda je ovl d n¡ kl vesnic¡ nebo joystickem

l61a0:   cmp       byte ptr ds:[da75b],0    ; je ovl d n¡ kl vesnic¡ ?
         jne       l61aa                    ; je ovl d n¡ joystickem
         jmp       l6231                    ; je ovl d n¡ kl vesnic¡

; ------ test p©eru¨en¡ hry (kl vesou ESC)

l61aa:   call      l628a                    ; test p©eru¨en¡ hry

; ------ ‡ek n¡ na za‡ tek impuls–

         mov       dx,201h                  ; port joysticku
         cli
         out       dx,al                    ; inicializace joysticku
l61b2:   in        al,dx
         and       al,3
         cmp       al,3
         jne       l61b2                    ; ‡ek n¡ na za‡ tek impuls–

; ------ mˆ©en¡ v˜chylky X

         mov       ah,0
         mov       cx,0ffh                  ; ‡¡ta‡ d‚lky impuls–
l61be:   in        al,dx                    ; vstup z joysticku
         or        al,ah                    ; p©¡znak konce mˆ©en¡
         test      al,1                     ; je konec impulsu X ?
         jnz       l61d1                    ; nen¡ nebo je konec
         mov       ds:[da716],cl            ; namˆ©en  doba X
         or        ah,1                     ; p©¡znak ukon‡en¡ mˆ©en¡ X
         cmp       ah,3                     ; je konec mˆ©en¡ ?
         jz        l61e3                    ; je konec mˆ©en¡

; ------ mˆ©en¡ v˜chylky Y

l61d1:   test      al,2                     ; je konec impulsu Y ?
         jnz       l61e1                    ; je konec impulsu Y
         mov       ds:[da717],cl            ; namˆ©en  doba Y
         or        ah,2                     ; p©¡znak ukon‡en¡ mˆ©en¡ Y
         cmp       ah,3                     ; je konec mˆ©en¡ ?
         jz        l61e3                    ; konec mˆ©en¡
l61e1:   loop      l61be                    ; dal¨¡ mˆ©en¡

; ------ nahoru, zv˜¨en¡ rychlosti

l61e3:   sti
         mov       byte ptr ds:[da736],0ffh ; inicializace - ‘ dn˜ povel
         mov       ah,ds:[dc3d9]            ; horn¡ poloha joysticku
         cmp       ds:[da717],ah            ; je nad horn¡ polohou ?
         jb        l61f8                    ; nen¡ nad horn¡ polohou
         and       byte ptr ds:[da736],0fbh ; povel nahoru, zv˜¨en¡ rychlosti

; ------ dol–, sn¡‘en¡ rychlosti

l61f8:   mov       ah,ds:[dc3da]            ; doln¡ poloha joysticku
         cmp       ds:[da717],ah            ; je pod doln¡ polohou ?
         ja        l6207                    ; nen¡ pod doln¡ polohou
         and       byte ptr ds:[da736],0f7h ; povel dol–, sn¡‘en¡ rychlosti

; ------ vpravo

l6207:   mov       ah,ds:[dc3db]            ; prav  poloha joysticku
         cmp       ds:[da716],ah            ; je prav  poloha ?
         ja        l6216                    ; nen¡ vpravo
         and       byte ptr ds:[da736],7fh  ; povel vpravo

; ------ vlevo

l6216:   mov       ah,ds:[dc3dc]            ; lev  poloha joysticku
         cmp       ds:[da716],ah            ; je lev  poloha ?
         jb        l6225                    ; nen¡ vlevo
         and       byte ptr ds:[da736],0efh ; povel vlevo

; ------ st©¡len¡

l6225:   and       al,30h                   ; p©¡znak tla‡¡tek
         cmp       al,30h                   ; je st©¡len¡ ?
         je        l6230                    ; nen¡ st©¡len¡
         and       byte ptr ds:[da736],0dfh ; p©¡znak st©¡len¡
l6230:   ret

; ------ zapnut¡ p©esmyka‡e NUM LOCK

l6231:   or        byte ptr ds:[da736],20h  ; zru¨en¡ p©¡znaku st©¡len¡
         push      ds
         mov       ax,40h
         mov       ds,ax                    ; DS <- 40h
         or        byte ptr ds:[17h],20h    ; zapnut¡ p©esmyka‡e NUM LOCK
         pop       ds

; ------ vstup znaku z kl vesnice

         sti
         mov       ah,1
         int       16h                      ; test stavu kl vesnice
         jz        l6279                    ; nen¡ stisknuta kl vesa
         mov       ah,0
         int       16h                      ; vstup znaku z kl vesnice

; ------ nahoru, zv˜¨en¡ rychlosti

         mov       dl,0fbh                  ; bit 2 - zv˜¨en¡ rychlosti
         cmp       ah,48h ;ax,4838h                 ; kl vesa "8"
         je        l6275

; ------ dol–, sn¡‘en¡ rychlosti

         mov       dl,0f7h                  ; bit 3 - sn¡‘en¡ rychlosti
         cmp       ah,50h ;ax,5032h                 ; kl vesa "2"
         je        l6275

; ------ vpravo

         mov       dl,7fh                   ; bit 7 - vpravo
         cmp       ah,4dh ;ax,4d36h                 ; kl vesa "6"
         je        l6275

; ------ vlevo

         mov       dl,0efh                  ; bit 4 - vlevo
         cmp       ah,4bh ;ax,4b34h                 ; kl vesa "4"
         je        l6275

; ------ st©¡len¡

         mov       dl,0dfh                  ; bit 5 - st©¡len¡
	 cmp	al,13
	je	l6275
         cmp       al,20h ;ax,3920h                 ; mezern¡k
         je        l6275

; ------ jinak test p©eru¨en¡ hry

         call      l6295                    ; test p©eru¨en¡ nebo zastaven¡ hry
         mov       dl,0ffh                  ; povel - ‘ dn  funkce
l6275:   mov       ds:[da736],dl            ; povel
l6279:   ret

; ------ zpomalen¡ - do¨lo palivo

l627a:   mov       al,0f7h                  ; povel dol–, sn¡‘en¡ rychlosti
         mov       ds:[da736],al            ; povel
         cmp       byte ptr ds:[da75a],66h  ; poloha letadla vertik lnˆ Y
         jae       l6287
         ret

l6287:   jmp       l6551                    ; v˜buch letadla

l6190    ENDP

; -----------------------------------------------------------------------------
;    test p©eru¨en¡ nebo pozastaven¡ hry
; -----------------------------------------------------------------------------

l628a    PROC      NEAR

; ------ vstup znaku z kl vesnice

         sti
         mov       ah,1
         int       16h                      ; test stavu kl vesnice
         jz        l62b2
         mov       ah,0
         int       16h                      ; vstup znaku z kl vesnice

; ------ test, zda je p©eru¨en¡ hry kl vesou ESC

l6295:   cmp       ax,11bh                  ; je kl vesa ESC ?
         jne       l629d                    ; nen¡ ESC
         jmp       l4f24                    ; je ESC - p©eru¨en¡ sc‚ny

; ------ zastaven¡ hry kl vesou ENTER

l629d:   ;cmp       ax,1c0dh                 ; je kl vesa ENTER ?
         ;jne       l62b2                    ; nen¡ ENTER
;         sti
;l62a3:   mov       ah,1
;         int       16h                      ; test stavu kl vesnice
;         mov       cx,64h
;l62aa:   loop      l62aa
;         jz        l62a3                    ; ‡ek n¡ na stisk kl vesy
;         mov       ah,0
;         int       16h                      ; vstup znaku z kl vesnice
l62b2:   ret

l628a    ENDP

         db        13 dup(0)

; -----------------------------------------------------------------------------
;    zobrazen¡ po‡tu ‘ivot–
; -----------------------------------------------------------------------------

l62c0    PROC      NEAR

; ------ ur‡en¡ barvy pozad¡ pro vymaz n¡ voln‚ pozice

         mov       dh,55h                   ; barva pozad¡ modrozelen 
         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jz        l62cb                    ; zobrazena zemˆ
         mov       dh,0                     ; barva pozad¡ ‡ern 

; ------ stanoven¡ po‡tu ‘ivot– k zobrazen¡

l62cb:   mov       si,10                    ; ‡¡slo videolinky k zobrazen¡
         mov       di,0                     ; ukazatel v obr zku ‘ivota
         mov       al,ds:[da76a]            ; po‡et ‘ivot–
         cmp       al,5                     ; je v¡ce ne‘ 5 ?
         jb        l62e5                    ; je m‚nˆ ne‘ 5 ‘ivot–

; ------ omezen¡ po‡tu ‘ivot– na 5

         mov       byte ptr ds:[da716],5    ; omezen¡ po‡tu ‘ivot–
         mov       byte ptr ds:[da717],0    ; nezb˜v  voln  pozice
         jmp       short l62f1
         nop

; ------ po‡et ‘ivot– je men¨¡ ne‘ 5

l62e5:   mov       ds:[da716],al            ; po‡et ‘ivot– k zobrazen¡
         mov       byte ptr ds:[da717],5    ; celkov˜ po‡et pozic
         sub       ds:[da717],al            ; po‡et zbyl˜ch pozic k vymaz n¡

; ------ p©¡prava k zobrazen¡ jedn‚ linky ‘ivot–

l62f1:   mov       bx,si                    ; ‡¡slo videolinky k zobrazen¡
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa ve videopamˆti
         add       bx,50                    ; po‡ te‡n¡ pozice k zobrazen¡

; ------ zobrazen¡ zb˜vaj¡c¡ch ‘ivot– (1 linka)

         mov       dl,ds:[da716]            ; po‡et ‘ivot– k zobrazen¡
         cmp       dl,0                     ; je nˆjak˜ ‘ivot ?
         je        l6323                    ; nezb˜v  z dn˜ ‘ivot
l6305:   mov       cx,6                     ; po‡et bajt– na linku
l6308:   mov       al,ds:[di+da488]         ; bajt z obr zku letadla
         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jz        l6315                    ; je zobrazena zemˆ
         xor       al,55h                   ; jinak zru¨en¡ barvy podkladu
l6315:   mov       es:[bx],al               ; ulo‘en¡ bajtu obr zku
         inc       di
         inc       bx
         loop      l6308                    ; dal¨¡ bajt na lince
         sub       di,6                     ; n vrat ukazatele v obr zku
         dec       dl                       ; ‡¡ta‡ pozic k zobrazen¡
         jnz       l6305                    ; zobrazen¡ dal¨¡ pozice

; ------ vymaz n¡ zbyl˜ch pozic ‘ivot– (1 linka)

l6323:   cmp       byte ptr ds:[da717],0    ; po‡et pozic k vymaz n¡
         jz        l633d                    ; nezb˜v  ‘ dn  voln  pozice
         mov       dl,ds:[da717]            ; po‡et pozic k vymaz n¡
l632e:   mov       cx,6                     ; d‚lka jedn‚ pozice
         mov       al,dh                    ; barva podkladu
l6333:   mov       es:[bx],al               ; vymaz n¡ podkladu
         inc       bx
         loop      l6333                    ; dal¨¡ bajt
         dec       dl                       ; ‡¡ta‡ pozic k vymaz n¡
         jnz       l632e                    ; vymaz n¡ dal¨¡ pozice

; ------ p©¡prava pro dal¨¡ linku

l633d:   add       di,6                     ; zv˜¨en¡ adresy v obr zku
         inc       si                       ; ‡¡ta‡ linek
         cmp       si,16                    ; je ji‘ posledn¡ linka ?
         jne       l62f1                    ; zobrazen¡ dal¨¡ linky
         ret

l62c0    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ sk¢re
; -----------------------------------------------------------------------------

l6347    PROC      NEAR

; ------ zv˜¨en¡ sk¢re o uletˆnou dr hu

         mov       cl,6
         mov       al,ds:[da758]            ; rychlost letu
         mov       ah,0
         mov       dl,ds:[da738]            ; ‡¡ta‡ p©¡rustku zlomku sk¢re
         mov       dh,0
         add       ax,dx                    ; zv˜¨en¡ zlomku sk¢re
         mov       ds:[da738],al            ; ‡¡ta‡ p©¡rustku zlomku sk¢re
         shr       ax,cl                    ; nov˜ p©¡rustek sk¢re
         call      l63b2                    ; zv˜¨en¡ sk¢re o AX

; ------ test, zda bude zv˜¨en¡ po‡tu ‘ivot– (zv˜¨en¡ sk¢re o 2000)

         mov       al,ds:[da773]            ; sk¢re - © d stovky
         sub       al,ds:[da746]            ; rozd¡l od posledn¡ho zv˜¨en¡
         das
         cmp       al,2
         jb        l6384                    ; nen¡ rozd¡l 2000

; ------ zv˜¨en¡ po‡tu ‘ivot–

         mov       al,9                     ; ‡¡slo melodie
         call      l680e                    ; zvukov  signalizace
         inc       byte ptr ds:[da76a]      ; po‡et ‘ivot–
         jnz       l6379                    ; nen¡ p©ete‡en¡
         dec       byte ptr ds:[da76a]      ; po‡et ‘ivot– (omezen¡)
l6379:   mov       al,ds:[da773]            ; sk¢re - © d stovek
         and       al,0feh                  ; zaokrouhlen¡
         mov       ds:[da746],al            ; sk¢re p©i posledn¡m p©id n¡ ‘ivota
         call      l62c0                    ; zobrazen¡ nov‚ho po‡tu ‘ivot–

; ------ zobrazen¡ sk¢re

l6384:   mov       di,0                     ; ukazatel ‡¡slic
         mov       si,1                     ; linka k zobrazen¡ ‡¡sla
l638a:   mov       bx,di
         shl       bx,1
         shl       bx,1
         inc       bx                       ; pozice ‡¡slice * 5 = adresa
         rcr       di,1                     ; ukazatel / 2
         mov       al,ds:[di+da773]         ; ‡¡slice k zobrazen¡
         rcl       di,1                     ; n vrat ukazatele
         test      di,1                     ; je to lich  ‡¡slice ?
         jnz       l63a6                    ; je to lich  ‡¡slice
         mov       cl,4
         shr       al,cl                    ; rotace ‡¡slice na pozici
         jmp       short l63a8
         nop
l63a6:   and       al,0fh                   ; ‡¡slice k zobrazen¡
l63a8:   call      l63d7                    ; zobrazen¡ ‡¡slice AL (adresa BX)
         inc       di
         cmp       di,6
         jne       l638a
         ret

l6347    ENDP

; -----------------------------------------------------------------------------
;    zv˜¨en¡ sk¢re o AL
; -----------------------------------------------------------------------------

l63b2    PROC      NEAR

         add       al,ds:[da775]
         daa
         mov       ds:[da775],al
         mov       al,ah
         adc       al,ds:[da774]
         daa
         mov       ds:[da774],al
         mov       al,ds:[da773]
         adc       al,0
         daa
         mov       ds:[da773],al
         mov       al,ds:[da772]            ; dosa‘en‚ sk¢re (8 ‡¡slic BCD)
         adc       al,0
         daa
         mov       ds:[da772],al            ; dosa‘en‚ sk¢re (8 ‡¡slic BCD)
         ret

l63b2    ENDP

; -----------------------------------------------------------------------------
;    zobrazen¡ ‡¡slice AL (adresa BX)
; -----------------------------------------------------------------------------

l63d7    PROC      NEAR

; ------ £schova registr–

         push      ax
         push      bx
         push      cx
         push      dx
         push      si
         push      di

; ------ p©¡prava registr–

         mov       word ptr ds:[da716],bx   ; adresa k zobrazen¡ ‡¡slice
         mul       byte ptr ds:[da714]      ; po‡et bajt– na ‡¡slici = adresa
         mov       di,ax                    ; adresa ‡¡slice
         mov       dl,20                    ; po‡et linek k zobrazen¡ ‡¡slice

; ------ zobrazen¡ ‡¡slice

l63e9:   mov       bx,si                    ; linka k zobrazen¡ ‡¡slice
         shl       bx,1
         mov       bx,ds:[bx+da4b0]         ; adresa videolinky
         add       bx,word ptr ds:[da716]   ; + offset ‡¡slice
         mov       cx,4                     ; po‡et bajt– na linku
l63f8:   mov       al,ds:[di+daa70]
         test      byte ptr ds:[da769],2    ; zobrazena zemˆ ?
         jz        l6405                    ; je zobrazena zemˆ
         xor       al,55h                   ; zru¨en¡ barvy pozad¡
l6405:   mov       es:[bx],al
         inc       di
         inc       bx
         loop      l63f8
         inc       si
         dec       dl                       ; ‡¡ta‡ linek
         jnz       l63e9                    ; dal¨¡ linka

; ------ n vrat registr–

         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

l63d7    ENDP

; -----------------------------------------------------------------------------
;    obsluha z sah– nep©¡tele st©elami
; -----------------------------------------------------------------------------

l6418    PROC      NEAR

; ------ nalezen¡ definice st©ely

         mov       si,0                     ; ukazatel v tabulce objekt–
l641b:   cmp       byte ptr ds:[si+da688],5 ; typ objektu = st©ela ?
         je        l642f                    ; nalezena st©ela
l6422:   add       si,8                     ; adresa dal¨¡ho objektu
         cmp       si,8*MAXOBJ              ; jsou ji‘ v¨echny objekty ?
         jne       l641b                    ; nejsou - dal¨¡ objekt
         jmp       l64f2                    ; jsou ji‘ v¨echny objekty
l642e:   ret

; ------ £schova sou©adnice st©ely

l642f:   mov       ax,si                    ; definice st©ely
         mov       ds:[da735],al            ; £schova offsetu definice st©ely
         mov       al,ds:[si+da688+1]       ; pozice st©ely X
         mov       ds:[da728],al            ; pozice st©ely X (=pozice obr zku)
         mov       al,ds:[si+da688+2]       ; sou©adnice st©ely Y
         sub       al,ds:[da76d]            ; st©ed st©ely Y
         mov       ds:[da729],al            ; sou©adnice st©ely Y (=© dek obr.)

; ------ £schova rozmˆr– st©ely

         call      l66a3                    ; £schova rozmˆr– test. objektu SI
         mov       al,ds:[da721]            ; v˜¨ka testovan‚ho objektu Y
         add       al,ds:[da76d]            ; st©ed st©ely ve smˆru Y
         mov       ds:[da726],al            ; rozmˆr st©ely Y
         mov       al,ds:[da722]            ; ¨¡©ka testovan‚ho objektu X
         mov       ds:[da727],al            ; rozmˆr st©ely X

; ------ nalezen¡ nep© tel v defini‡n¡ tabulce

         mov       si,0                     ; offset v tabulce objekt–
l645c:   mov       al,ds:[si+da688]         ; typ objektu
         cmp       al,2                     ; je disk ?
         je        l6486                    ; je disk
         cmp       al,3                     ; je velk‚ UFO ?
         je        l6486                    ; je velk‚ UFO
         cmp       al,6                     ; je kosmick  loƒ ?
         je        l647e                    ; je kosmick  loƒ
l646c:   add       si,8                     ; adresa dal¨¡ho objektu
         cmp       si,8*MAXOBJ              ; jsou ji‘ v¨echny objekty ?
         jne       l645c                    ; nejsou v¨echny - dal¨¡ objekt

; ------ p©¡prava pro dal¨¡ st©elu

l6475:   mov       al,ds:[da735]            ; offset definice st©ely
         mov       ah,0
         mov       si,ax                    ; offset definice st©ely
         jmp       short l6422              ; test dal¨¡ st©ely

; ------ kosmick  loƒ - test z sahu st©elou

l647e:   call      l6660                    ; test z sahu lodi st©elou
         jnc       l646c                    ; nen¡ z sah - dal¨¡ objekt
         jmp       l65d6                    ; z sah lodi

; ------ disk (mal‚ UFO), velk‚ UFO - test z sahu st©elou

l6486:   call      l6660                    ; test z sahu objektu st©elou
         jnc       l646c                    ; nen¡ z sah - dal¨¡ objekt

; ------ zv˜¨en¡ sk¢re o zasa‘en˜ objekt (disk nebo UFO)

         mov       ah,ds:[si+da688]         ; typ objektu
         mov       al,0
         call      l63b2                    ; zv˜¨en¡ sk¢re o AX (o objekt)

; ------ vygenerov n¡ pohybu - v˜buch

         mov       byte ptr ds:[si+da688+6],0
         mov       al,7                     ; pohyb - v˜buch disku, UFO
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡

; ------ zru¨en¡ definice st©ely

         mov       al,ds:[da735]            ; offset definice st©ely
         mov       ah,0
         mov       si,ax                    ; offset definice st©ely
         mov       byte ptr ds:[si+da688+6],0

; ------ povolen¡ generov n¡ dal¨¡ho disku

         mov       al,8
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡
         test      byte ptr ds:[da769],4    ; je pouze jedna skupina UFO ?
         jz        l64c5                    ; nen¡ pouze jedna skupina UFO
         cmp       byte ptr ds:[da763],1    ; po‡et zbyl˜ch bran k proletˆn¡
         jne       l64c5                    ; je je¨tˆ v¡ce UFO k post©¡len¡
         and       byte ptr ds:[da769],0f7h ; povolen¡ generov n¡ dal¨¡ho disku
         jmp       short l64d5
         nop

; ------ z sah disku - sn¡‘en¡ po‡tu zbyl˜ch disk– k sest©elen¡

l64c5:   cmp       byte ptr ds:[da739],0    ; prol‚t  se branami ?
         jne       l64d5                    ; prol‚t  se branami
         dec       byte ptr ds:[da763]      ; po‡et zbyl˜ch bran k proletˆn¡
         jz        l64dc                    ; nezbyl ‘ dn˜ disk k
         call      l5db0                    ; zobrazen¡ po‡tu zbyl˜ch bran
l64d5:   mov       al,0                     ; ‡¡slo melodie
         call      l680e                    ; zvukov  signalizace = z sah disku
         jmp       short l6475

l6418    ENDP

; -----------------------------------------------------------------------------
;    dal¨¡ sc‚na (po proletˆn¡ v¨emi branami)
; -----------------------------------------------------------------------------

l64dc    PROC      NEAR

         inc       byte ptr ds:[da76b]      ; zv˜¨en¡ ‡¡sla sc‚ny
         mov       byte ptr ds:[da73f],0ffh ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne
         inc       byte ptr ds:[da73e]      ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru
         nop
         nop
         nop
         jmp       l5953

l64dc    ENDP

l64ef:   ret

l64f0:   nop
         ret

; -----------------------------------------------------------------------------
;    test srazen¡ rakety s nep© teli
; -----------------------------------------------------------------------------

l64f2    PROC      NEAR

; ------

         mov       al,ds:[da759]            ; poloha letadla horizont lnˆ X
         mov       ds:[da728],al
         mov       al,ds:[da75a]            ; poloha letadla vertik lnˆ Y
         mov       ds:[da729],al
         mov       byte ptr ds:[da726],0fh
         mov       byte ptr ds:[da727],1ah
         mov       si,0
l650b:   cmp       byte ptr ds:[si+da688+3],0 ; velikost objektu
         jz        l651c
l6512:   add       si,8
         cmp       si,80h
         jne       l650b
         ret

l651c:   mov       al,ds:[si+da688]         ; typ objektu
         cmp       al,0
         je        l6512
         cmp       al,5
         je        l6512
         cmp       al,7
         je        l6512
         cmp       al,9
         je        l6512

l6530:   call      l6660                    ; test sr ‘ky dvou objekt–
         jnc       l6512
         mov       byte ptr ds:[si+da688+5],0
         mov       cx,10h
         mov       si,0
l6540:   cmp       byte ptr ds:[si+da688],1 ; typ objektu
         jne       l654c
         mov       byte ptr ds:[si+da688+5],0
l654c:   add       si,8
         loop      l6540

; ====== v˜buch letadla (sem se sk ‡e t‚‘ pokud dojde palivo)

l6551:   call      l5b80
         mov       di,7
         mov       si,0
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l6551

; ------ zni‡en¡ raketu sr ‘kou s nep©¡telem

         mov       al,ds:[da759]            ; poloha letadla horizont lnˆ X
         mov       ds:[si+da688+1],al         ; pozice objektu X
         mov       al,ds:[da75a]            ; poloha letadla vertik lnˆ Y
         mov       ds:[si+da688+2],al         ; sou©adnice objektu Y
         mov       al,9
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡
         mov       byte ptr ds:[da755],0    ; posun podkladu p©i posunu rakety
         mov       byte ptr ds:[da758],0    ; rychlost letu (30 a‘ 120)
         mov       byte ptr ds:[da739],3ah  ; po‡et krok– p©i v˜buchu rakety
         mov       al,2
         call      l680e                    ; zvukov  indikace

; ------ zobrazen¡ nov‚ho po‡tu ‘ivot– a sk¢re

         dec       byte ptr ds:[da76a]      ; po‡et ‘ivot–
         call      l62c0                    ; zobrazen¡ po‡tu ‘ivot–
         call      l50af                    ; vymaz n¡ letadla se st¡nem
         call      l6347                    ; zobrazen¡ sk¢re

; ------ cyklus v˜buchu rakety

l6593:   call      l5b80                    ; zobrazen¡ v¨ech objekt–
         call      l67d0                    ; obsluha hry melodie
         call      l5195                    ; obsluha posunu zemˆ
         mov       cx,15000
l659f:   loop      l659f                    ; prodleva
         dec       byte ptr ds:[da739]      ; ‡¡ta‡ krok– v˜buchu rakety
         jnz       l6593                    ; dal¨¡ krok

; ------ test, zda byly ji‘ v¨echny ‘ivoty

         cmp       byte ptr ds:[da76a],0    ; po‡et ‘ivot–
         je        l65d2                    ; v¨echny ‘ivoty - konec hry

; ------ test, zda zbylo je¨tˆ nˆjak‚ palivo

         mov       al,ds:[da74c]            ; z soba paliva - bajt 0
         or        al,ds:[da74d]            ; z soba paliva - bajt 1
         or        al,ds:[da74e]            ; z soba paliva - bajt 2
         jne       l65c9                    ; zb˜v  nˆjak‚ palivo

; ------ palivo do¨lo - zah jen¡ nov‚ podsc‚ny (sc‚na z–st v )

         and       byte ptr ds:[da76b],0fch ; ‡¡slo sc‚ny
         and       byte ptr ds:[da73e],0f0h ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru
         jmp       l5953
l65c8:   ret

l65c9:   mov       byte ptr ds:[da73f],0    ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne
         jmp       l5999
l65d1:   ret

l65d2:   jmp       l4f24
l65d5:   ret

l64f2    ENDP

; -----------------------------------------------------------------------------
;        z sah kosmick‚ lodi st©elou
; -----------------------------------------------------------------------------

l65d6    PROC      NEAR

         test      byte ptr ds:[si+da688+7],10h
         jnz       l6600
         mov       al,ds:[si+da688+3]         ; velikost objektu
         mov       ah,0
         mov       di,ax
         cmp       di,6
         jae       l6600

         mov       al,ds:[di+db1be]
         add       al,ds:[si+da688+1]         ; pozice objektu X
         sub       al,ds:[da728]
         jnc       l65fc

         xor       al,0ffh
         add       al,1
l65fc:   cmp       al,4
         jc        l6628

l6600:   mov       al,ds:[da735]
         mov       ah,0
         mov       si,ax
         mov       byte ptr ds:[si+da688+6],0
         mov       byte ptr ds:[si+da688+5],18h
         call      l6160                    ; gener tor n hory
         and       al,7                     ; 0 a‘ 7
         add       al,31                    ; 31 a‘ 38
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡
         or        byte ptr ds:[si+da688+7],10h
         mov       al,5
         call      l680e                    ; zvukov  signalizace
         jmp       l6475

l6628:   call      l66d6                    ; v˜buch nep© telsk‚ kosmick‚ lodi

; ------ zv˜¨en¡ ‡¡sla sc‚ny

l662b:   mov       byte ptr ds:[da73f],0ffh ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne
         mov       al,ds:[da73e]            ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru
         and       al,0f0h
         add       al,10h
         cmp       al,0a0h
         jne       l663d
         mov       al,0
l663d:   mov       ds:[da73e],al            ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru

; ------ prodleva

         mov       cx,03e8h
         mov       al,0
l6645:   dec       al
         jne       l6645
         loop      l6645
         nop
         nop

; ------ zv˜¨en¡ sk¢re

         mov       si,14h                   ; po‡et zv˜¨en¡ sk¢re za sc‚nu
l6650:   mov       ax,1000h                 ; sk¢re za dal¨¡ sc‚nu
         call      l63b2                    ; zv˜¨en¡ sk¢re o AX
         dec       si
         jnz       l6650
         inc       byte ptr ds:[da76b]      ; ‡¡slo sc‚ny
         jmp       l5953                    ; start nov‚ sc‚ny

l65d6    ENDP

; -----------------------------------------------------------------------------
;        test sr ‘ky dvou objekt–
; -----------------------------------------------------------------------------

l6660    PROC      NEAR

; ------ kontrola vzd lenosti dvou objekt– Y

         call      l66a3                    ; £schova rozmˆr– test. objektu SI
         mov       al,ds:[si+da688+2]       ; sou©adnice objektu Y
         clc
         sbb       al,ds:[da729]            ; odchylka od sou©adnice Y
         jnc       l667b                    ; odchylka je kladn 
         xor       al,0ffh
         add       al,1                     ; negace odchylky
         cmp       al,ds:[da721]            ; kontrola vzd lenosti objektu Y
         jae       l66a1                    ; objekt je p©¡li¨ vzd len˜
         jmp       short l6681
         nop
l667b:   cmp       al,ds:[da726]            ; kontrola vzd lenosti
         jae       l66a1                    ; objekt je p©¡li¨ vzd len˜

; ------ kontrola vzd lenosti dvou objekt– X

l6681:   mov       al,ds:[si+da688+1]       ; pozice objektu X
         clc
         sbb       al,ds:[da728]            ; odchylka od sou©adnice X
         jnc       l6699                    ; odchylka kladn 
         xor       al,0ffh
         add       al,1                     ; negace odchylky
         cmp       al,ds:[da722]            ;
         jae       l66a1
         jmp       short l669f
         nop
l6699:   cmp       al,ds:[da727]
         jae       l66a1
l669f:   stc
         ret
l66a1:   clc
         ret

l6660    ENDP

; -----------------------------------------------------------------------------
;        £schova rozmˆr– testovan‚ho objektu SI
; -----------------------------------------------------------------------------

l66a3    PROC      NEAR

; ------ adresa definice objektu v tabulce obr zk–

         mov       al,ds:[si+da688]         ; typ objektu
         mov       ah,0
         mul       byte ptr ds:[da715]      ; * max. po‡et f z¡ na objekt
         add       al,ds:[si+da688+3]       ; velikost objektu = offset objektu
         mov       bx,ax                    ; offset objektu
         mov       cl,3                     ; po‡et rotac¡
         shl       bx,cl                    ; offset * 8 = offset v tabulce

; ------ £schova rozmˆr– objektu

         mov       al,byte ptr ds:[bx+d0030] ; v˜¨ka objektu Y
         mov       ds:[da721],al            ; v˜¨ka testovan‚ho objektu Y
         cmp       byte ptr ds:[bx+d0030+1],2 ; je minim ln¡ ¨¡©ka objektu 2 ?
         ja        l66ca                    ; ¨¡©ka objektu je OK
         mov       al,1                     ; omezen¡ ¨¡©ky objektu na 1
         jmp       short l66d0
         nop
l66ca:   mov       al,byte ptr ds:[bx+d0030+1] ; ¨¡©ka testovan‚ho objektu
         sub       al,2                     ;
l66d0:   shl       al,1                     ; ¨¡©ka objektu * 2
         mov       ds:[da722],al            ; ¨¡©ka testovan‚ho objektu X
         ret

l66a3    ENDP

; -----------------------------------------------------------------------------
;    v˜buch nep© telsk‚ kosmick‚ lodi
; -----------------------------------------------------------------------------

l66d6    PROC      NEAR

         mov       al,10
         call      l680e                    ; zvukov  indikace
         mov       di,si
         call      l5f51                    ; p©¡prava k zobrazen¡ objektu
         mov       al,ds:[da732]            ; ‡¡slo obr zku k zobrazen¡
         mov       ds:[db1c7],al            ; ‡¡slo obr zku k zobrazen¡
         mov       al,ds:[da733]            ; pozice X k zobrazen¡ obr zku
         mov       ds:[db1c8],al            ; pozice X k zobrazen¡ obr zku
         mov       al,ds:[da734]            ; ‡¡slo linky Y k zobrazen¡ obr zku
         mov       ds:[db1c9],al            ; ‡¡slo linky Y k zobrazen¡ obr zky
         mov       byte ptr ds:[da758],56   ; rychlost letu (30 a‘ 120)
         mov       byte ptr ds:[da73b],15   ; po‡et v˜buch– k vygenerov n¡
         mov       byte ptr ds:[si+da688],0 ; zru¨en¡ objektu kosmick‚ lodi

; ------ £schova parametr– objektu

         mov       ah,0
         mov       al,ds:[si+da688+3]         ; velikost objektu
         mov       di,ax
         mov       al,ds:[si+da688+1]         ; pozice objektu X
         add       al,ds:[di+db1be]
         mov       ds:[da73c],al
         mov       al,ds:[si+da688+2]         ; sou©adnice objektu Y
         mov       ds:[da73d],al

; ------ vygenerov n¡ objektu - v˜buch

l671b:   mov       di,7                     ; objekt = v˜buch
         call      l5f14                    ; vlo‘en¡ objektu do tabulky objekt–
         jc        l6762

; ------ parametry v˜buchu

         mov       byte ptr ds:[si+da688+5],20h
         mov       al,ds:[da73c]            ; pozice X
         mov       ds:[si+da688+1],al         ; pozice objektu X
         mov       al,ds:[da73d]            ; pozice Y
         mov       ds:[si+da688+2],al         ; sou©adnice objektu Y
         mov       byte ptr ds:[si+da688+3],3 ; velikost objektu

         mov       al,7
         call      l614a                    ; za©azen¡ objektu do tabulky akc¡
         dec       byte ptr ds:[da73b]
         jz        l677b
         mov       al,10h
         sub       al,ds:[da73b]
         shl       al,1
         mov       ah,0
         mov       di,ax
         mov       al,ds:[di+db19e]
         add       ds:[da73c],al
         mov       al,ds:[di+db19f]
         add       ds:[da73d],al

; ------ cyklick  obsluha v˜buchu

l6762:   call      l5b80                    ; obsluha v¨ech objekt–
         call      l67d0                    ; obsluha hry melodie
         call      l6190                    ; vstup z kl vesnice nebo joysticku
         call      l500d                    ; ovl d n¡ pohybu letadla

; ------ prodleva

         mov       cx,14h
         mov       al,0
l6773:   dec       al
         jnz       l6773
         loop      l6773
         jmp       short l671b              ; dal¨¡ obsluha v˜buchu

; ------ konec v˜buchu

l677b:   mov       al,0bh
         call      l680e                    ; zvukov  indikace
         mov       al,ds:[db1c7]
         mov       ds:[da732],al            ; ‡¡slo obr zku k zobrazen¡
         mov       al,ds:[db1c8]
         mov       ds:[da733],al
         mov       al,ds:[db1c9]
         mov       ds:[da734],al            ; ‡¡slo linky k zobrazen¡ obr zku
         call      l5287                    ; vymaz n¡ kosmick‚ lodi

; ------ ‡ek n¡, a‘ budou v¨echny objekty zru¨eny

l6795:   mov       si,0
l6798:   cmp       byte ptr ds:[si+da688],0
         jnz       l67a9
         add       si,8
         cmp       si,80h
         jne       l6798
         ret                                ; v¨echny objekty ji‘ zru¨eny

; ------ prodleva

l67a9:   mov       cx,14h
         mov       al,0
l67ae:   dec       al
         jnz       l67ae
         loop      l67ae

; ------ obsluha objekt–

         call      l5b80                    ; obsluha v¨ech objekt–
         call      l67d0                    ; obsluha hry melodie
         call      l6190                    ; vstup z kl vesnice nebo joysticku
         call      l500d                    ; ovl d n¡ pohybu letadla
         jmp       short l6795              ; test dal¨¡ho objektu

l66d6    ENDP

         db        14 dup(0)

; -----------------------------------------------------------------------------
;    obsluha hry melodie
; -----------------------------------------------------------------------------

l67d0    PROC      NEAR

; ------ £schova registr–

         push      bx
         push      cx

; ------ ‡¡t n¡ d‚lky t¢nu

         cmp       word ptr ds:[dc064],0    ; je konec t¢nu ?
         je        l680b                    ; je konec t¢nu
         dec       word ptr ds:[dc064]      ; ‡¡ta‡ d‚lky t¢nu
         jnz       l680b

; ------ nastaven¡ frekvence nov‚ho t¢nu

         mov       bx,ds:[dc060]            ; ukazatel melodie
         mov       ax,ds:[bx]               ; frekvence t¢nu
         out       [42h],al
         mov       al,ah
         out       [42h],al

; ------ nastaven¡ d‚lky t¢nu

         mov       ax,ds:[bx+2]             ; d‚lka t¢nu
         mov       ds:[dc064],ax            ; ‡¡ta‡ d‚lky t¢nu (0=konec)

; ------ posun ukazatele melodie

         add       bx,4                     ; zv˜¨en¡ adresy
         mov       ds:[dc060],bx            ; nov  adresa
         cmp       word ptr ds:[dc064],0    ; je konec melodie ?
         jne       l680b                    ; nen¡ je¨tˆ konec melodie

; ------ vypnut¡ zvukov‚ho gener toru

         mov       word ptr ds:[dc062],0    ; priorita = ‘ dn  melodie
         in        al,[61h]
         and       al,0fch                  ; vypnut¡ zvuk. gener toru
         out       [61h],al

; ------ n vrat registr–

l680b:   pop       cx
         pop       bx
         ret

l67d0    ENDP

; -----------------------------------------------------------------------------
;    Zapnut¡ melodie
; -----------------------------------------------------------------------------
; VSTUP: AL=‡¡slo melodie
;                 0=z sah disku
;                 1=st©¡len¡
;                 2=v˜buch rakety (letadla)
;                 3=vygenerovan  bomba
;                 4=vygenerovan  bomba br ny
;                 5=v˜buch
;                 6=doch z¡ palivo
;                 7=v˜buch nep©¡tele
;                 8=proletˆn¡ branou
;                 9=dal¨¡ ‘ivot p©i zv˜¨en¡ sk¢re o 2000
;                10=v˜buch nep© telsk‚ kosmick‚ lodi
;                11=konec v˜buchu nep© telsk‚ kosmick‚ lodi
; -----------------------------------------------------------------------------

l680e    PROC      NEAR

; ------ £schova registr–

         push      bx
         push      cx

; ------ adresa po‘adovan‚ melodie

         mov       ah,0
         shl       ax,1                     ; ‡¡slo melodie * 2
         mov       bx,ax                    ; offset adresy melodie
         mov       bx,ds:[bx+dc066]         ; adresa melodie

; ------ stanoven¡ priority melodie

         mov       ax,ds:[bx]               ; priorita po‘adovan‚ melodie
         cmp       ax,ds:[dc062]            ; m  vy¨¨¡ prioritu ?
         jb        l6842                    ; m  ni‘¨¡ prioritu - ignoruje se

; ------ zapnut¡ zvukov‚ho v˜stupu

         in        al,[61h]
         or        al,3                     ; zapnut¡ zvukov‚ho v˜stupu
         out       [61h],al

; ------ nastaven¡ frekvence prvn¡ho t¢nu

         mov       al,0b6h
         out       [43h],al                 ; ©¡dic¡ slovo dˆli‡ky
         mov       ax,ds:[bx+2]             ; dˆlic¡ konstanta
         out       [42h],al
         mov       al,ah
         out       [42h],al                 ; nastaven¡ frekvence

; ------ nastaven¡ d‚lky t¢nu

         mov       ax,ds:[bx+4]             ; d‚lka prvn¡ho t¢nu
         mov       ds:[dc064],ax            ; d‚lka t¢nu

; ------ nastaven¡ ukazatele melodie (adresa)

         add       bx,6                     ; adresa dal¨¡ho t¢nu
         mov       ds:[dc060],bx            ; adresa dal¨¡ho t¢nu

; ------ n vrat registr–

l6842:   pop       cx
         pop       bx
         ret

l680e    ENDP

         db        11 dup(0)

; -----------------------------------------------------------------------------
;    kalibrace joysticku
; -----------------------------------------------------------------------------

l6850    PROC      NEAR

; ------ zobrazen¡ v˜zvy k nastaven¡ joysticku do st©edn¡ polohy

         call      l59fe                    ; vymaz n¡ videopamˆti
         mov       si,offset dc380          ; text "JOYSTICK CALIBRATION"
         call      l5a61                    ; zobrazen¡ textu
         mov       si,offset dc397          ; text "Adjust ..."
         call      l5a61                    ; zobrazen¡ textu
         mov       si,offset dc3be          ; text "and press ..."
         call      l5a61                    ; zobrazen¡ textu

; ------ ‡ek n¡ na stisk tla‡¡tka joysticku

         mov       dx,201h                  ; port joysticku
         out       dx,al
l6869:   in        al,dx                    ; ‡ten¡ stavu joysticku
         and       al,30h
         cmp       al,30h                   ; je nˆco stisknuto ?
         je        l6869                    ; ‡ek n¡ na stisk tla‡¡tka

; ------ ‡ek n¡ na povolen¡ tla‡¡tek joysticku

         mov       dx,201h                  ; port joysticku
         cli
         out       dx,al
l6875:   in        al,dx                    ; ‡ten¡ stavu joysticku
         and       al,3
         cmp       al,3                     ; je nˆco stisknuto ?
         jne       l6875                    ; ‡ek n¡ na povolen¡ tla‡¡tek

; ------ mˆ©en¡ d‚lky impulsu X

         mov       ah,0                     ; p©¡znak ukon‡en¡ kalibrace
         mov       cx,0ffh                  ; maxim ln¡ doba mˆ©en¡
l6881:   in        al,dx                    ; ‡ten¡ stavu joysticku
         or        al,ah                    ; maskov n¡ koncem mˆ©en¡
         test      al,1                     ; je dosa‘eno konce impulsu X ?
         jnz       l6894                    ; nen¡ je¨tˆ konec impulsu X
         mov       ds:[da716],cl            ; namˆ©en  doba X
         or        ah,1                     ; p©¡znak ukon‡en¡ mˆ©en¡ X
         cmp       ah,3                     ; je ji‘ konec mˆ©en¡ ?
         jz        l68a6                    ; je konec mˆ©en¡

; ------ mˆ©en¡ d‚lky impulsu Y

l6894:   test      al,2                     ; je dosa‘eno konce impulsu Y ?
         jnz       l68a4                    ; nen¡ konec impulsu Y
         mov       ds:[da717],cl            ; namˆ©en  doba Y
         or        ah,2                     ; p©¡znak ukon‡en¡ mˆ©en¡ Y
         cmp       ah,3                     ; je ji‘ konec mˆ©en¡ ?
         jz        l68a6                    ; je ji‘ konec mˆ©en¡
l68a4:   loop      l6881                    ; dal¨¡ mˆ©en¡

; ------ inicializace krajn¡ch poloh joysticku X

l68a6:   mov       al,ds:[da716]            ; namˆ©en  doba X
         mov       ds:[dc3db],al            ; prav  poloha joysticku
         mov       ds:[dc3dc],al            ; lev  poloha joysticku
         mov       ah,0
         div       byte ptr ds:[dc3dd]      ; v˜po‡et odchylky joysticku
         add       ds:[dc3dc],al            ; lev  poloha joysticku
         sub       ds:[dc3db],al            ; prav  poloha joysticku

; ------ inicializace krajn¡ch poloh joysticku Y

         mov       al,ds:[da717]            ; namˆ©en  doba Y
         mov       ds:[dc3d9],al            ; horn¡ poloha joysticku
         mov       ds:[dc3da],al            ; doln¡ poloha joysticku
         mov       ah,0
         div       byte ptr ds:[dc3dd]      ; v˜po‡et odchylky joysticku
         add       ds:[dc3d9],al            ; horn¡ poloha joysticku
         sub       ds:[dc3da],al            ; doln¡ poloha joysticku

; ------ opˆt vymaz n¡ videopamˆti

         call      l59fe                    ; vymaz n¡ videopamˆti
         ret

l6850    ENDP

CodeEnd  label     byte                     ; konec programov‚ho segmentu

Code     ENDS

; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
;
;              datov˜ segment - zapomenut  kopie (nepou‘¡v  se)
;
; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

Data2    SEGMENT   PARA

Data2Str label     byte

.XLIST

db 05Ah,000h,05Ah,000h,04Eh,000h,0E0h,0C3h,058h,0C4h,034h,0C5h,022h,000h,01Eh,000h ;0000
db 014h,000h,00Ch,000h,016h,000h,028h,000h,00Eh,010h,004h,04Ch,04Fh,057h,020h,046h ;0010
db 055h,045h,04Ch,0FFh,055h,0AAh,0FFh,0FFh,000h,000h,000h,000h,000h,000h,000h,000h ;0020
db 00Fh,00Fh,000h,000h,0E1h,000h,000h,000h,00Fh,00Fh,0C2h,001h,0A3h,002h,000h,000h ;0030
db 00Fh,00Fh,084h,003h,065h,004h,000h,000h,005h,00Fh,046h,005h,091h,005h,000h,000h ;0040
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;0050
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;0060
db 000h,000h,000h,000h,000h,000h,000h,000h,028h,007h,0DCh,005h,033h,009h,000h,000h ;0070
db 020h,006h,0F4h,006h,04Bh,00Ah,000h,000h,01Ah,005h,0B4h,007h,00Bh,00Bh,000h,000h ;0080
db 016h,005h,036h,008h,08Dh,00Bh,000h,000h,00Fh,004h,0A4h,008h,0FBh,00Bh,000h,000h ;0090
db 00Dh,003h,0E0h,008h,037h,00Ch,000h,000h,009h,003h,007h,009h,05Eh,00Ch,000h,000h ;00A0
db 005h,003h,022h,009h,079h,00Ch,000h,000h,001h,002h,031h,009h,088h,00Ch,000h,000h ;00B0
db 010h,00Bh,08Ah,00Ch,09Ah,00Eh,000h,000h,00Dh,009h,03Ah,00Dh,04Ah,00Fh,000h,000h ;00C0
db 00Ah,007h,0AFh,00Dh,0BFh,00Fh,000h,000h,007h,006h,0F5h,00Dh,005h,010h,000h,000h ;00D0
db 005h,004h,01Fh,00Eh,02Fh,010h,000h,000h,004h,003h,033h,00Eh,043h,010h,000h,000h ;00E0
db 003h,003h,03Fh,00Eh,04Fh,010h,000h,000h,002h,002h,048h,00Eh,058h,010h,000h,000h ;00F0
db 001h,001h,04Ch,00Eh,05Ch,010h,000h,000h,02Eh,009h,0E6h,025h,05Bh,02Ah,000h,000h ;0100
db 018h,006h,084h,027h,0F9h,02Bh,000h,000h,015h,005h,014h,028h,089h,02Ch,000h,000h ;0110
db 011h,005h,07Dh,028h,0F2h,02Ch,000h,000h,00Dh,004h,0D2h,028h,047h,02Dh,000h,000h ;0120
db 00Ch,003h,006h,029h,07Bh,02Dh,000h,000h,008h,003h,02Ah,029h,09Fh,02Dh,000h,000h ;0130
db 005h,002h,042h,029h,0B7h,02Dh,000h,000h,004h,002h,04Ch,029h,0C1h,02Dh,000h,000h ;0140
db 00Dh,006h,054h,029h,0C9h,02Dh,000h,000h,00Bh,005h,0A2h,029h,017h,02Eh,000h,000h ;0150
db 009h,005h,0D9h,029h,04Eh,02Eh,000h,000h,007h,004h,006h,02Ah,07Bh,02Eh,000h,000h ;0160
db 007h,004h,022h,02Ah,097h,02Eh,000h,000h,005h,003h,03Eh,02Ah,0B3h,02Eh,000h,000h ;0170
db 003h,002h,04Dh,02Ah,0C2h,02Eh,000h,000h,003h,002h,053h,02Ah,0C8h,02Eh,000h,000h ;0180
db 001h,002h,059h,02Ah,0CEh,02Eh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;0190
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;01A0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;01B0
db 005h,007h,04Dh,00Eh,05Dh,010h,000h,000h,003h,007h,070h,00Eh,080h,010h,000h,000h ;01C0
db 002h,007h,085h,00Eh,095h,010h,000h,000h,001h,007h,093h,00Eh,0A3h,010h,000h,000h ;01D0
db 029h,01Bh,0FCh,035h,008h,046h,000h,000h,029h,01Bh,0FCh,035h,008h,046h,000h,000h ;01E0
db 01Fh,015h,04Fh,03Ah,05Bh,04Ah,000h,000h,015h,00Eh,0DAh,03Ch,0E6h,04Ch,000h,000h ;01F0
db 00Ch,008h,000h,03Eh,00Ch,04Eh,000h,000h,008h,007h,060h,03Eh,06Ch,04Eh,000h,000h ;0200
db 006h,006h,098h,03Eh,0A4h,04Eh,000h,000h,004h,005h,0BCh,03Eh,0C8h,04Eh,000h,000h ;0210
db 003h,004h,0D0h,03Eh,0DCh,04Eh,000h,000h,030h,01Bh,0AAh,010h,048h,01Bh,000h,000h ;0220
db 020h,015h,0BAh,015h,058h,020h,000h,000h,018h,00Fh,05Ah,018h,0F8h,022h,000h,000h ;0230
db 010h,009h,0C2h,019h,060h,024h,000h,000h,00Eh,007h,052h,01Ah,0F0h,024h,000h,000h ;0240
db 00Ch,006h,0B4h,01Ah,052h,025h,000h,000h,008h,005h,0FCh,01Ah,09Ah,025h,000h,000h ;0250
db 006h,004h,024h,01Bh,0C2h,025h,000h,000h,004h,003h,03Ch,01Bh,0DAh,025h,000h,000h ;0260
db 00Dh,006h,054h,029h,0C9h,02Dh,000h,000h,00Bh,005h,0A2h,029h,017h,02Eh,000h,000h ;0270
db 009h,005h,0D9h,029h,04Eh,02Eh,000h,000h,007h,004h,006h,02Ah,07Bh,02Eh,000h,000h ;0280
db 007h,004h,022h,02Ah,097h,02Eh,000h,000h,005h,003h,03Eh,02Ah,0B3h,02Eh,000h,000h ;0290
db 003h,002h,04Dh,02Ah,0C2h,02Eh,000h,000h,003h,002h,053h,02Ah,0C8h,02Eh,000h,000h ;02A0
db 001h,002h,059h,02Ah,0CEh,02Eh,000h,000h,003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h ;02B0
db 003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h,003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h ;02C0
db 003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h,003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h ;02D0
db 003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h,003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h ;02E0
db 003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h,003h,002h,0E8h,04Eh,0EEh,04Eh,000h,000h ;02F0
db 000h,000h,000h,000h,000h,000h,000h,000h,015h,040h,000h,000h,000h,000h,000h,000h ;0300
db 000h,000h,000h,000h,001h,055h,055h,040h,000h,000h,000h,000h,000h,000h,000h,000h ;0310
db 000h,000h,001h,054h,001h,040h,000h,000h,001h,040h,000h,000h,000h,000h,000h,000h ;0320
db 000h,000h,000h,001h,040h,000h,000h,014h,000h,000h,000h,000h,000h,000h,001h,040h ;0330
db 000h,000h,001h,040h,000h,001h,040h,000h,000h,000h,000h,000h,000h,000h,014h,000h ;0340
db 000h,003h,0D4h,001h,057h,0C0h,000h,000h,000h,000h,000h,000h,000h,001h,040h,000h ;0350
db 003h,0D7h,0FFh,0D4h,000h,000h,000h,000h,000h,000h,000h,000h,003h,0D5h,040h,017h ;0360
db 0FFh,0D7h,0FCh,000h,000h,000h,055h,000h,000h,000h,000h,000h,017h,0FFh,0D5h,056h ;0370
db 0AAh,0BFh,0D5h,055h,055h,000h,000h,000h,000h,000h,000h,03Fh,0D7h,0FFh,0D6h,0AAh ;0380
db 097h,0D5h,054h,000h,000h,000h,000h,000h,000h,017h,0FEh,0AAh,095h,056h,0AAh,0BFh ;0390
db 0D4h,000h,000h,000h,000h,000h,000h,015h,057h,0D6h,0AAh,097h,0FFh,0D7h,0FCh,000h ;03A0
db 000h,000h,000h,000h,000h,055h,055h,057h,0FEh,0AAh,095h,043h,0FFh,0C0h,000h,000h ;03B0
db 000h,000h,000h,055h,000h,000h,000h,03Fh,0D7h,0FCh,000h,000h,000h,000h,000h,000h ;03C0
db 000h,000h,000h,000h,000h,000h,003h,0FFh,0C0h,000h,000h,000h,000h,000h,000h,000h ;03D0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,054h,000h,000h,000h,000h,000h ;03E0
db 000h,000h,000h,000h,000h,000h,015h,055h,054h,000h,000h,000h,000h,000h,000h,000h ;03F0
db 000h,000h,000h,000h,015h,040h,014h,000h,000h,000h,014h,000h,000h,000h,000h,000h ;0400
db 000h,000h,000h,000h,000h,014h,000h,000h,001h,040h,000h,000h,000h,000h,000h,000h ;0410
db 014h,000h,000h,000h,014h,000h,000h,014h,000h,000h,000h,000h,000h,000h,000h,001h ;0420
db 040h,000h,000h,03Dh,040h,015h,07Ch,000h,000h,000h,000h,000h,000h,000h,000h,014h ;0430
db 000h,000h,03Dh,07Fh,0FDh,040h,000h,000h,000h,000h,000h,000h,000h,000h,03Dh,054h ;0440
db 001h,07Fh,0FDh,07Fh,0C0h,000h,000h,005h,050h,000h,000h,000h,000h,001h,07Fh,0FDh ;0450
db 055h,06Ah,0ABh,0FDh,055h,055h,050h,000h,000h,000h,000h,000h,003h,0FDh,07Fh,0FDh ;0460
db 06Ah,0A9h,07Dh,055h,040h,000h,000h,000h,000h,000h,001h,07Fh,0EAh,0A9h,055h,06Ah ;0470
db 0ABh,0FDh,040h,000h,000h,000h,000h,000h,001h,055h,07Dh,06Ah,0A9h,07Fh,0FDh,07Fh ;0480
db 0C0h,000h,000h,000h,000h,000h,005h,055h,055h,07Fh,0EAh,0A9h,054h,03Fh,0FCh,000h ;0490
db 000h,000h,000h,000h,005h,050h,000h,000h,003h,0FDh,07Fh,0C0h,000h,000h,000h,000h ;04A0
db 000h,000h,000h,000h,000h,000h,000h,000h,03Fh,0FCh,000h,000h,000h,000h,000h,000h ;04B0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;04C0
db 000h,000h,000h,000h,000h,001h,055h,055h,055h,055h,040h,000h,000h,000h,000h,000h ;04D0
db 000h,000h,000h,000h,000h,000h,001h,040h,000h,000h,000h,000h,000h,000h,000h,000h ;04E0
db 000h,001h,040h,000h,000h,001h,040h,000h,000h,001h,040h,000h,000h,000h,000h,000h ;04F0
db 000h,014h,000h,000h,001h,040h,000h,000h,014h,000h,000h,000h,000h,000h,000h,000h ;0500
db 001h,040h,000h,003h,0C0h,000h,001h,040h,000h,000h,000h,000h,000h,000h,000h,003h ;0510
db 0D5h,041h,053h,0C5h,041h,057h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,017h ;0520
db 0FFh,0D7h,0D7h,0FFh,0D4h,000h,000h,000h,000h,000h,000h,000h,000h,001h,07Fh,0D7h ;0530
db 0FFh,0FFh,0D7h,0FDh,040h,000h,000h,000h,000h,000h,000h,001h,057h,0FEh,0AAh,0BFh ;0540
db 0FEh,0AAh,0BFh,0D5h,040h,000h,000h,000h,055h,055h,055h,057h,0D6h,0AAh,097h,0D6h ;0550
db 0AAh,097h,0D5h,055h,055h,055h,000h,000h,000h,055h,057h,0FEh,0AAh,0BFh,0FEh,0AAh ;0560
db 0BFh,0D5h,055h,000h,000h,000h,000h,000h,000h,000h,03Fh,0D7h,0FFh,0FFh,0D7h,0FCh ;0570
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,003h,0FFh,0C0h,003h,0FFh,0C0h,000h ;0580
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;0590
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;05A0
db 000h,000h,000h,000h,000h,000h,000h,015h,055h,055h,055h,054h,000h,000h,000h,000h ;05B0
db 000h,000h,000h,000h,000h,000h,000h,000h,014h,000h,000h,000h,000h,000h,000h,000h ;05C0
db 0A6h,08Bh,0D8h,0B1h,003h,0D3h,0E3h,08Ah,087h,030h,000h,0A2h,021h,0A7h,080h,0BFh ;05D0
db 031h,000h,002h,077h,005h,0B0h,001h,0EBh,007h,090h,08Ah,087h,031h,000h,02Ch,002h ;05E0
db 0D0h,0E0h,0A2h,022h,0A7h,0C3h,0B0h,00Ah,0E8h,033h,001h,08Bh,0FEh,0E8h,071h,0F8h ;05F0
db 0A0h,032h,0A7h,0A2h,0C7h,0B1h,0A0h,033h,0A7h,0A2h,0C8h,0B1h,0A0h,034h,0A7h,0A2h ;0600
db 0C9h,0B1h,0C6h,006h,058h,0A7h,038h,0C6h,006h,03Bh,0A7h,00Fh,0C6h,084h,088h,0A6h ;0610
db 000h,0B4h,000h,08Ah,084h,08Bh,0A6h,08Bh,0F8h,08Ah,084h,089h,0A6h,002h,085h,0BEh ;0620
db 0B1h,0A2h,03Ch,0A7h,08Ah,084h,08Ah,0A6h,0A2h,03Dh,0A7h,0BFh,007h,000h,0E8h,0F3h ;0630
db 0F7h,072h,03Fh,0C6h,084h,08Dh,0A6h,020h,0A0h,03Ch,0A7h,088h,084h,089h,0A6h,0A0h ;0640
db 03Dh,0A7h,088h,084h,08Ah,0A6h,0C6h,084h,08Bh,0A6h,003h,0B0h,007h,0E8h,00Ah,0FAh ;0650
db 0FEh,00Eh,03Bh,0A7h,074h,035h,0B0h,010h,02Ah,006h,03Bh,0A7h,0D0h,0E0h,0B4h,000h ;0660
db 08Bh,0F8h,08Ah,085h,09Eh,0B1h,000h,006h,03Ch,0A7h,08Ah,085h,09Fh,0B1h,000h,006h ;0670
db 03Dh,0A7h,0E8h,01Bh,0F4h,0E8h,068h,000h,0E8h,025h,0FAh,0E8h,09Fh,0E8h,0B9h,014h ;0680
db 000h,0B0h,000h,0FEh,0C8h,075h,0FCh,0E2h,0FAh,0EBh,0A0h,0B0h,00Bh,0E8h,08Eh,000h ;0690
db 0A0h,0C7h,0B1h,0A2h,032h,0A7h,0A0h,0C8h,0B1h,0A2h,033h,0A7h,0A0h,0C9h,0B1h,0A2h ;06A0
db 034h,0A7h,0E8h,0F2h,0EAh,0BEh,000h,000h,080h,0BCh,088h,0A6h,000h,075h,00Ah,083h ;06B0
db 0C6h,008h,081h,0FEh,080h,000h,075h,0F0h,0C3h,0B9h,014h,000h,0B0h,000h,0FEh,0C8h ;06C0
db 075h,0FCh,0E2h,0FAh,0E8h,0C9h,0F3h,0E8h,016h,000h,0E8h,0D3h,0F9h,0E8h,04Dh,0E8h ;06D0
db 0EBh,0D3h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;06E0
db 053h,051h,083h,03Eh,064h,0C0h,000h,074h,032h,0FFh,00Eh,064h,0C0h,075h,02Ch,08Bh ;06F0
db 01Eh,060h,0C0h,08Bh,007h,0E6h,042h,08Ah,0C4h,0E6h,042h,08Bh,047h,002h,0A3h,064h ;0700
db 0C0h,083h,0C3h,004h,089h,01Eh,060h,0C0h,083h,03Eh,064h,0C0h,000h,075h,00Ch,0C7h ;0710
db 006h,062h,0C0h,000h,000h,0E4h,061h,024h,0FCh,0E6h,061h,059h,05Bh,0C3h,053h,051h ;0720
db 0B4h,000h,0D1h,0E0h,08Bh,0D8h,08Bh,09Fh,066h,0C0h,08Bh,007h,03Bh,006h,062h,0C0h ;0730
db 072h,020h,0E4h,061h,00Ch,003h,0E6h,061h,0B0h,0B6h,0E6h,043h,08Bh,047h,002h,0E6h ;0740
db 042h,08Ah,0C4h,0E6h,042h,08Bh,047h,004h,0A3h,064h,0C0h,083h,0C3h,006h,089h,01Eh ;0750
db 060h,0C0h,059h,05Bh,0C3h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;0760
db 0E8h,0ABh,0F1h,0BEh,080h,0C3h,0E8h,008h,0F2h,0BEh,097h,0C3h,0E8h,002h,0F2h,0BEh ;0770
db 0BEh,0C3h,0E8h,0FCh,0F1h,0BAh,001h,002h,0EEh,0ECh,024h,030h,03Ch,030h,074h,0F9h ;0780
db 0BAh,001h,002h,0FAh,0EEh,0ECh,024h,003h,03Ch,003h,075h,0F9h,0B4h,000h,0B9h,0FFh ;0790
db 000h,0ECh,00Ah,0C4h,0A8h,001h,075h,00Ch,088h,00Eh,016h,0A7h,080h,0CCh,001h,080h ;07A0
db 0FCh,003h,074h,012h,0A8h,002h,075h,00Ch,088h,00Eh,017h,0A7h,080h,0CCh,002h,080h ;07B0
db 0FCh,003h,074h,002h,0E2h,0DBh,0A0h,016h,0A7h,0A2h,0DBh,0C3h,0A2h,0DCh,0C3h,0B4h ;07C0
db 000h,0F6h,036h,0DDh,0C3h,000h,006h,0DCh,0C3h,028h,006h,0DBh,0C3h,0A0h,017h,0A7h ;07D0
db 0A2h,0D9h,0C3h,0A2h,0DAh,0C3h,0B4h,000h,0F6h,036h,0DDh,0C3h,000h,006h,0D9h,0C3h ;07E0
db 028h,006h,0DAh,0C3h,0E8h,027h,0F1h,0C3h,000h,000h,000h,000h,000h,000h,000h,000h ;07F0

.LIST

Data2End label     byte

Data2    ENDS

; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
;
;                            Datov˜ segment
;
; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


Data     SEGMENT   PARA

DataStrt label     byte                     ; za‡ tek datov‚ho segmentu

; ------ definice k zobrazen¡ tov rny v pozad¡ sc‚ny

                                          ;* po‡ te‡n¡ videolinka * 2
d0000    dw        45*2                     ; sc‚na 4 a‘ 7 (10 linek)
         dw        45*2                     ; sc‚na 8 a‘ 11 (10 linek)
         dw        39*2                     ; sc‚na 12 a v¡ce (16 linek)

                                          ;* adresa obr zku tov rny
d0006    dw        dc3e0                    ; sc‚na 4 a‘ 7
         dw        dc458                    ; sc‚na 8 a‘ 11
         dw        dc534                    ; sc‚na 12 a v¡ce
                                            ; dc7b4 konec

                                          ;* po‡ te‡n¡ pozice obr zku
d000c    dw        34                       ; sc‚na 4 a‘ 7
         dw        30                       ; sc‚na 8 a‘ 11
         dw        20                       ; sc‚na 12 a v¡ce

                                          ;* ¨¡©ka obr zku tov rny (bajt–)
d0012    dw        12                       ; sc‚na 4 a‘ 7
         dw        22                       ; sc‚na 8 a‘ 11
         dw        40                       ; sc‚na 12 a v¡ce


d0018    db        0eh                      ; rychlost £bytku paliva
d0019    db        10h,4,'LOW FUEL',0ffh    ; text

d0024    db        55h,0aah,0ffh,0ffh       ; tab. barvy linek podle ‡¡sla sc‚ny
d0028    db        0                        ; aktu ln¡ barva linek
         db        7 dup(0)

                                          ;* definice obr zk–
                                            ; (ka‘d  definice 8 bajt–)
                                            ;   0: (1) v˜¨ka Y (po‡et linek)
                                            ;   1: (1) ¨¡©ka X
                                            ;   2: (2) offset obr zku - sud 
                                            ;   4: (2) offset obr zku - lich 
                                            ;   6: (2) 0
d0030    label     word

                                          ;* 0: letadlo
         dw        0f0fh,0,0e1h,0
         dw        0f0fh,1c2h,2a3h,0
         dw        0f0fh,384h,465h,0
         dw        0f05h,546h,591h,0
         dw        0,0,0,0
         dw        0,0,0,0
         dw        0,0,0,0
         dw        0,0,0,0
         dw        0,0,0,0

                                          ;* 1:
d0078    dw        728h,5dch,933h,0
         dw        620h,6f4h,0a4bh,0
         dw        51ah,7b4h,0b0bh,0
         dw        516h,836h,0b8dh,0
         dw        40fh,8a4h,0bfbh,0
         dw        30dh,8e0h,0c37h,0
         dw        309h,907h,0c5eh,0
         dw        305h,922h,0c79h,0
         dw        201h,931h,0c88h,0

                                          ;* 2:
d00c0    dw        0b10h,0c8ah,0e9ah,0
         dw        90dh,0d3ah,0f4ah,0
         dw        70ah,0dafh,0fbfh,0
         dw        607h,0df5h,1005h,0
         dw        405h,0e1fh,102fh,0
         dw        304h,0e33h,1043h,0
         dw        303h,0e3fh,104fh,0
         dw        202h,0e48h,1058h,0
         dw        101h,0e4ch,105ch,0

                                          ;* 3:
d0108    dw        92eh,25e6h,2a5bh,0
         dw        618h,2784h,2bf9h,0
         dw        515h,2814h,2c89h,0
         dw        511h,287dh,2cf2h,0
         dw        40dh,28d2h,2d47h,0
         dw        30ch,2906h,2d7bh,0
         dw        308h,292ah,2d9fh,0
         dw        205h,2942h,2db7h,0
         dw        204h,294ch,2dc1h,0

                                          ;* 4:
d0150    dw        60dh,2954h,2dc9h,0
         dw        50bh,29a2h,2e17h,0
         dw        509h,29d9h,2e4eh,0
         dw        407h,2a06h,2e7bh,0
         dw        407h,2a22h,2e97h,0
         dw        305h,2a3eh,2eb3h,0
         dw        203h,2a4dh,2ec2h,0
         dw        203h,2a53h,2ec8h,0
         dw        201h,2a59h,2eceh,0

                                          ;* 5: st©ela
d0198    dw        0,0,0,0                  ; 0 (nepou‘¡v  se)
         dw        0,0,0,0                  ; 1 (nepou‘¡v  se)
         dw        0,0,0,0                  ; 2 (nepou‘¡v  se)
         dw        0,0,0,0                  ; 3 (nepou‘¡v  se)
         dw        0,0,0,0                  ; 4 (nepou‘¡v  se)
         dw        705h,0e4dh,105dh,0       ; 5 prvn¡ poloha st©ely
         dw        703h,0e70h,1080h,0       ; 6
         dw        702h,0e85h,1095h,0       ; 7
         dw        701h,0e93h,10a3h,0       ; 8

                                          ;* 6:
d01e0    dw        1b29h,35fch,4608h,0
         dw        1b29h,35fch,4608h,0
         dw        151fh,3a4fh,4a5bh,0
         dw        0e15h,3cdah,4ce6h,0
         dw        80ch,3e00h,4e0ch,0
         dw        708h,3e60h,4e6ch,0
         dw        606h,3e98h,4ea4h,0
         dw        504h,3ebch,4ec8h,0
         dw        403h,3ed0h,4edch,0

                                          ;* 7:
d0228    dw        1b30h,10aah,1b48h,0
         dw        1520h,15bah,2058h,0
         dw        0f18h,185ah,22f8h,0
         dw        910h,19c2h,2460h,0
         dw        70eh,1a52h,24f0h,0
         dw        60ch,1ab4h,2552h,0
         dw        508h,1afch,259ah,0
         dw        406h,1b24h,25c2h,0
         dw        304h,1b3ch,25dah,0

                                          ;* 8:
d0270    dw        60dh,2954h,2dc9h,0
         dw        50bh,29a2h,2e17h,0
         dw        509h,29d9h,2e4eh,0
         dw        407h,2a06h,2e7bh,0
         dw        407h,2a22h,2e97h,0
         dw        305h,2a3eh,2eb3h,0
         dw        203h,2a4dh,2ec2h,0
         dw        203h,2a53h,2ec8h,0
         dw        201h,2a59h,2eceh,0

                                          ;* 9:
d02b8    dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0
         dw        203h,4ee8h,4eeeh,0

.XLIST
INCLUDE  ZOOM.INC                         ; obr zky objekt–
.LIST

da0e8    label     byte                     ; obr zek poho©¡ v pozad¡
                                            ;  10 linek po 80 bajtech

.XLIST
db 055h,055h,0D5h,055h,055h,055h,055h,055h                                         ;A0E8
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;A0F0
db 055h,055h,055h,055h,055h,055h,05Dh,055h,055h,07Fh,055h,055h,055h,055h,055h,055h ;A100
db 055h,05Dh,055h,07Fh,055h,055h,055h,055h,055h,055h,055h,055h,057h,055h,055h,0F5h ;A110
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,05Fh,055h,055h ;A120
db 055h,055h,055h,055h,055h,055h,07Dh,055h,055h,057h,0F5h,07Fh,055h,055h,057h,055h ;A130
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;A140
db 055h,055h,055h,055h,055h,055h,07Eh,0D5h,057h,0EBh,0D5h,055h,055h,055h,055h,055h ;A150
db 055h,0EFh,057h,0BBh,0D5h,055h,055h,055h,055h,055h,055h,055h,07Bh,0E6h,0D7h,0FDh ;A160
db 055h,055h,055h,055h,055h,055h,055h,057h,0D5h,055h,055h,055h,055h,07Fh,0D5h,055h ;A170
db 055h,055h,055h,055h,07Dh,055h,0FFh,055h,055h,05Fh,0FDh,0BAh,095h,055h,05Fh,0D5h ;A180
db 055h,055h,055h,05Dh,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,057h ;A190
db 055h,055h,055h,055h,055h,055h,0FAh,0F5h,06Fh,0BAh,0E5h,055h,055h,055h,055h,055h ;A1A0
db 056h,0FEh,0DEh,0BFh,0BDh,055h,055h,055h,055h,055h,055h,055h,0BBh,0EFh,0AFh,0FBh ;A1B0
db 095h,055h,055h,055h,055h,055h,055h,06Ah,0F5h,055h,055h,055h,055h,0FFh,0FDh,055h ;A1C0
db 055h,055h,055h,057h,0BBh,057h,0BFh,095h,055h,07Ah,0EFh,0ABh,0B5h,055h,0EFh,0E5h ;A1D0
db 055h,055h,055h,0FBh,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,05Fh ;A1E0
db 0D5h,055h,055h,055h,055h,057h,0AFh,0ADh,0AAh,0AAh,0BDh,055h,055h,055h,055h,055h ;A1F0
db 05Fh,0ABh,0AAh,0AFh,0EAh,095h,055h,055h,055h,055h,055h,06Bh,0EFh,0BAh,0AEh,0AEh ;A200
db 0F9h,055h,055h,055h,055h,055h,055h,0BEh,0EEh,055h,055h,057h,057h,0BEh,0FBh,0D5h ;A210
db 055h,055h,055h,07Fh,0AFh,09Eh,0EBh,0F5h,055h,0AAh,0ABh,0AAh,0A9h,05Ah,0ABh,0A9h ;A220
db 055h,055h,05Eh,0AEh,095h,055h,055h,055h,055h,05Ah,095h,055h,055h,055h,069h,07Bh ;A230
db 0FDh,055h,055h,056h,0AEh,0BEh,0ABh,0AAh,0AAh,0AAh,0AAh,095h,055h,055h,055h,055h ;A240
db 06Ah,0AAh,0EAh,0AAh,0BBh,0A9h,055h,055h,055h,055h,055h,0AAh,0AAh,0AAh,0ABh,0BBh ;A250
db 0EEh,095h,055h,055h,057h,095h,056h,0ABh,0BBh,0D5h,055h,05Fh,09Ah,0AEh,0AAh,0E9h ;A260
db 055h,055h,056h,0BAh,0FAh,0ABh,0AAh,0FDh,056h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A270
db 055h,055h,06Ah,0AAh,0A5h,055h,055h,055h,055h,06Ah,0A5h,055h,055h,06Ah,0AAh,0AAh ;A280
db 0EBh,095h,055h,05Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A9h,055h,055h,055h,05Ah ;A290
db 0AAh,0AAh,0AAh,0AAh,0AEh,0AAh,055h,055h,055h,055h,06Ah,0AAh,0AAh,0AAh,0AAh,0EAh ;A2A0
db 0BEh,0A9h,055h,055h,05Ah,0A5h,05Ah,0AAh,0AAh,0A5h,055h,0AAh,0AAh,0AAh,0AAh,0AAh ;A2B0
db 055h,055h,06Ah,0AFh,0AAh,0AAh,0AAh,0AAh,05Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A2C0
db 0A5h,055h,0AAh,0AAh,0AAh,055h,055h,055h,055h,0AAh,0A9h,055h,055h,0AAh,0AAh,0AAh ;A2D0
db 0AAh,0A9h,055h,06Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,095h,055h,055h,0AAh ;A2E0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A5h,055h,055h,05Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A2F0
db 0AAh,0AAh,095h,055h,06Ah,0A9h,06Ah,0AAh,0AAh,0A9h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A300
db 0A5h,056h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,06Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A310
db 0AAh,056h,0AAh,0AAh,0AAh,095h,05Ah,055h,056h,0AAh,0AAh,0A5h,05Ah,0AAh,0AAh,0AAh ;A320
db 0AAh,0AAh,055h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A9h,055h,05Ah,0AAh ;A330
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,095h,056h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A340
db 0AAh,0AAh,0A5h,055h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A350
db 0AAh,05Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A360
db 0AAh,0AAh,0AAh,0AAh,0AAh,0A5h,0AAh,0A5h,05Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A370
db 0AAh,0AAh,096h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,095h,06Ah,0AAh ;A380
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A9h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A390
db 0AAh,0AAh,0AAh,096h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A3A0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A3B0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A3C0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A3D0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A3E0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;A3F0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh                                         ;A400
.LIST

da408    label     byte                     ; tabulka ‡¡sel linek zemˆ
                                            ;  (13 f z¡ po 8 link ch)
         db        4,11,20,31,47,72,106,255
         db        4,11,20,32,48,74,109,255
         db        5,12,21,33,50,76,112,255
         db        5,12,21,34,52,78,115,255
         db        1,6,13,22,35,54,80,118
         db        1,6,13,23,36,56,82,121
         db        1,7,14,24,37,58,85,124
         db        2,7,14,25,38,60,88,127
         db        2,8,15,26,39,62,91,130
         db        2,8,16,27,40,64,94,133
         db        3,9,17,28,41,66,97,136
         db        3,9,18,29,43,68,100,139
         db        3,10,19,30,45,70,103,143

da470    label     byte                     ; obr zek br ny/disku k proletˆn¡
                                            ;   8 linek po 3 bajtech

db 055h,0FFh,055h,057h,03Ch,0D5h,05Eh,0C0h,035h,07Bh,0EEh,03Dh,0EFh,0BFh,08Fh,05Ah ;A470
db 80h,25h,56h,0,0d5h,55h,0bfh,55h

da488    label     byte                     ; obr zek ‘ivota (letadlo)
                                            ;   6 linek po 6 bajtech
db 55h,55h,0,0,55h,55h,55h,45h
db 54h,15h,51h,55h,55h,51h,40h,1,45h,55h,55h,0,0FCh,3Fh,0,55h
db 40h,3,0ABh,0EAh,0C0h,1,55h,50h,0FCh,3Fh,5,55h

         db        0,0,0,0

da4b0    dw        200 dup(0)               ; tabulka adres videolinek

da640    dw        16 dup(0)                ; tabulka adres akc¡ objekt–
da660    dw        16 dup(0)                ; tabulka £schovy adres akc¡ objekt–

da680    dw        0                        ; ukazatel gener toru n hody
         dw        0
da684    dw        0
da686    dw        0

da688    db        MAXOBJ*8 dup(0)          ; tabulka definic objekt–
                                            ;  0: (1) typ objektu (0=nic)
                                            ;          0 = nic
                                            ;          1 = raketa
                                            ;          2 = disk
                                            ;          3 =
                                            ;          4 = velk‚ UFO
                                            ;          5 = st©ela
                                            ;          6 = kosmick  loƒ
                                            ;          7 =
                                            ;          8 =
                                            ;          9 =
                                            ;  1: (1) pozice objektu X
                                            ;  2: (1) sou©adnice objektu Y
                                            ;  3: (1) velikost objektu (f ze)
                                            ;  4: (1)
                                            ;  5: (1) p©¡rustek sou©adnice X
                                            ;  6: (1) p©¡rustek sou©adnice Y
                                            ;  7: (1) bit 3: 1=smˆr pohybu vlevo
                                            ;         bit 7: 1=objekt obslou‘en


         db        0
da709    db        2,3,3,4,4,4,5,5,5,0,0    ; tabulka velikost¡ objekt–
da714    db        80                       ; po‡et bajt– na videolinku
da715    db        MAXFAZE                  ; max. po‡et f z¡ na objekt

da716    db        0                        ; d‚lka ukazatele paliva,
                                            ; po‡et zivot– k zobrazen¡,
                                            ; po‡ te‡n¡ linka obr zku tov rny*2

da717    db        0                        ; po‡ te‡n¡ linka obr zku HIGH,
                                            ; po‡et zbyl˜ch pozic ‘ivot– k vymaz n¡


da718    db        0                        ; adresa obr zku tov rny, ukazatel
                                            ; ‡¡sla linky k zobrazen¡ obr zku
da719    db        0

da71a    db        0                        ; po‡ te‡n¡ pozice obr zku tov rny,
                                            ; po‡ te‡n¡ offset obr zku k zobraz.
da71b    db        0                        ; korekce polo‘ky na slovo

da71c    dw        0                        ; ¨¡©ka obr zku tov rny (bajt–/linku)

; ------ obsluha zobrazen¡ objekt–

da71e    db        0                        ; linka nalezen‚ho objektu k obsluze
da71f    db        0                        ; 0ffh=p©¡znak nalezen¡ objektu k obsluze
da720    db        0                        ; £schova offsetu objektu


da721    db        0                        ; v˜¨ka obr zku (po‡et linek),
                                            ;  v˜¨ka testovan‚ho objektu Y
da722    db        0                        ; ¨¡©ka obr zku (po‡et bajt–)
                                            ;  ¨¡©ka testovan‚ho objektu X
         db        0
         db        0
         db        0
da726    db        0                        ; ¨¡©ka cel‚ho obr zku (bajt–),
                                            ;  rozmˆr testovan‚ st©ely Y
da727    db        0                        ; rozmˆr testovan‚ st©ely X
da728    db        0                        ; pozice obr zku X, pozice st©ely
da729    db        0                        ; sou©adnice obr zku Y, poz.Y st©ely
da72a    dw        0                        ; adresa masky obr zku k zobrazen¡
da72c    dw        0                        ; adresa obr zku k zobrazen¡

         db        0
da72f    db        0                        ; omezen  ¨¡©ka obr zku (bajt–)
         db        0                        ; (doplnˆk pro p©evod na slovo)

da731    db        0                        ; ‡¡ta‡ linek obr zku k zobrazen¡
da732    db        0                        ; ‡¡slo obr zku k zobrazen¡
                                            ;   3=st¡n letadla
da733    db        0                        ; pozice k zobrazen¡ obr zku X,
                                            ;   vygenerovan˜ smˆr pohybu disku
da734    db        0                        ; linka k zobrazen¡ obr zku Y,
                                            ;   pozice vygenerovan‚ho disku X
da735    db        0                        ; £schova offsetu definice UFO,
                                            ;   £schova offsetu definice st©ely,
                                            ;   po‡et vygenerovan˜ch disk–
da736    db        0                        ; povel z kl vesnice
                                            ;   bit 2: nahoru, zv˜¨en¡ rychlosti
                                            ;   bit 3: dol–, sn¡‘en¡ rychlosti
                                            ;   bit 4: vlevo
                                            ;   bit 5: st©¡len¡
                                            ;   bit 7: vpravo
da737    db        0
da738    db        0                        ; ‡¡ta‡ p©¡rustku zlomku sk¢re
da739    db        0                        ; p©¡znak, ‘e se m  prol‚tat branami
da73a    db        0
da73b    db        0                        ; po‡et v˜buch– k vygenerov n¡
da73c    db        0
da73d    db        0
da73e    db        0                        ; ‡¡slo sc‚ny a podsc‚ny v BCD tvaru
da73f    db        0                        ; 0ffh=zobraz¡ se £vod sc‚ny; 0=ne
da740    db        0                        ; smˆr pohybu letadla
                                            ;     (0=vlevo, 1=p©¡mo, 2=vpravo)
da741    db        0                        ; ‡¡ta‡ prodlevy mezi st©elami
da742    db        0                        ; ‡¡ta‡ pro generov n¡ dal¨¡ br ny
da743    db        0                        ; ‡¡ta‡ pro generov n¡ dal¨¡ho disku
da744    db        0                        ; ‡¡ta‡ prodlevy pro generov n¡ UFO
da745    db        0
da746    db        0                        ; sk¢re p©i posledn¡m p©id n¡ ‘ivota
da747    db        0                        ; ‡¡ta‡ pro generov n¡ bomb UFO
da748    db        0                        ; ‡¡ta‡ pro generov n¡ bomb br ny
da749    db        0                        ; ‡¡ta‡ pro generov n¡ bomb lodi
da74a    db        0                        ; ‡¡ta‡ obsluhy hvˆzd

;         db        90h                      ; = EVEN
         EVEN                               ; (90h)

da74c    db        0                        ; z soba paliva - bajt 0
da74d    db        0                        ; z soba paliva - bajt 1
da74e    db        0                        ; z soba paliva - bajt 2

         db        0
         db        0
         db        0
         db        0
da753    db        0                        ; f ze v tabulce linek
da754    db        0                        ; relativn¡ uletˆn  vzd lenost
da755    db        0                        ; posun podkladu p©i posunu rakety
da756    db        0
da757    db        0
da758    db        0                        ; rychlost letu (30 a‘ 120)
da759    db        0                        ; poloha letadla horizont lnˆ X
da75a    db        0                        ; poloha letadla vertik lnˆ Y
da75b    db        0                        ; ovl d n¡: 1=joystick, 0=kl vesnice

; ------ definice aktu ln¡ sc‚ny

da75c    db        0                        ; zrychlen¡ posunu podkladu X
da75d    db        0                        ; rychlost generov n¡ bran
da75e    db        0                        ; rychlost generov n¡ disk–
da75f    db        0
da760    db        0                        ; rychlost generov n¡ velk‚ho UFO
da761    db        0
da762    db        0
da763    db        0                        ; po‡et zbyl˜ch bran/disk– k prolet.
         db        0
da765    db        0                        ; ¨¡©ka br ny (po‡et pozic X)
da766    db        0                        ; rychlost generov n¡ bomb UFO
da767    db        0                        ; rychlost generov n¡ bomb br ny
da768    db        0                        ; rychlost generov n¡ bomb lodi
da769    db        0                        ; parametry
                                            ;   bit 1: 1=nen¡ zobrazena zemˆ
                                            ;   bit 2: 1=pouze 1 skupina disk–
                                            ;   bit 3: 1=mo‘n‚ generov n¡ disku
                                            ;   bit 4: 1=mo‘n‚ generov n¡ UFO

da76a    db        0                        ; po‡et ‘ivot– (init. 3)
da76b    db        0                        ; ‡¡slo sc‚ny (0 a‘ 19)
da76c    db        0                        ; rychlost st©¡len¡ (init. 8)
da76d    db        0                        ; st©ed st©ely ve smˆru Y

                                          ;* maxim ln¡ sk¢re (8 ‡¡slic BCD)
da76e    db        0                        ; nejvy¨¨¡ 2 ‡¡slice sk¢re (=0)
da76f    db        0
da770    db        0
da771    db        0                        ; nejni‘¨¡ 2 ‡¡slice sk¢re

                                          ;* dosa‘en‚ sk¢re (8 ‡¡slic BCD)
da772    db        0                        ; nejvy¨¨¡ 2 ‡¡slice sk¢re (=0)
da773    db        0
da774    db        0
da775    db        0                        ; nejni‘¨¡ 2 ‡¡slice sk¢re

da776    db        1ch,17h,11h,0eh,7,4,2,1,0,0
da780    dw        20h dup(0)               ; £schova adres hvˆzd ve videopamˆti

da7c0    dw        0                        ; ‡¡ta‡ krok– £vodn¡ho t¢nu
da7c2    dw        0                        ; dˆlic¡ konstanta £vodn¡ho t¢nu

                                          ;* tabulka kl ves hesla ("^KULAS")
da7c4    dw        250bh                    ; ^K
         dw        1655h                    ; U
         dw        264ch                    ; L
         dw        1e41h                    ; A
         dw        1f53h                    ; S

da7ce    dw        0                        ; ukazatel v tabulce hesla

da7d0    db        0
         db        0
         db        30h,36h,34h,39h

da7d6    db        20h dup(8 dup(0))        ; tabulka definic hvˆzd
                                            ;   0: sou©adnice X (0 a‘ 79)
                                            ;   1:
                                            ;   2: sou©adnice Y (0 a‘ 99)
                                            ;   3: p©¡rustek zlomku X
                                            ;   4: p©¡rustek zlomku Y
                                            ;   5: zlomek sou©adnice X
                                            ;   6: zlomek sou©adnice Y
                                            ;   7:

; da8d6                                     ; (to je asi nesmysl)
         db        0c0h
         db        30h
         db        0ch
         db        3

da8da    db        0                        ; 1=p©¡znak zmˆny pozice hvˆzdy
da8db    db        0                        ; 1=p©¡znak kalibrace joysticku
da8dc    db        0                        ; ‡¡ta‡ pr–chod– testu joysticku
da8dd    db        0                        ; 1=p©¡znak, ‘e nen¡ joystick

da8de    label     byte                     ; tabulka definic sc‚n
         db        5,20h,0,0,0,0,0,0ah,38h,22h,0,0,0,0                ; 0 (1.0)
         db        5,20h,60h,30h,0,0,0,0fh,38h,22h,0,0,0,8            ; 1 (1.1)
         db        5,20h,60h,30h,38h,20h,0,14h,38h,22h,0,0,0,18h      ; 2 (1.2)
         db        5,0,20h,38h,0,0,60h,0ah,38h,0,0,0,8,0eh            ; 3 (1.3)
         db        5,2ch,0,0,0,0,0,0fh,3ch,1eh,0,20h,0,20h            ; 4 (2.0)
         db        5,2eh,58h,38h,0,0,0,14h,3ch,1eh,0,28h,0,28h        ; 5 (2.1)
         db        5,2eh,50h,38h,30h,28h,0,19h,3ch,1eh,38h,28h,0,0b8h ; 6 (2.2)
         db        5,0,20h,48h,0,0,60h,0ah,3ch,0,0,0,6,0eh            ; 7 (2.3)
         db        5,28h,0,0,0,0,0,14h,48h,16h,0,18h,0,20h            ; 8 (3.0)
         db        5,2ah,50h,3ch,30h,30h,0,19h,48h,1ah,0,20h,0,38h    ; 9 (3.1)
         db        5,2ah,48h,3ch,28h,30h,0,1eh,48h,1ah,28h,20h,0,0b8h ; 10 (3.2)
         db        5,0,20h,4ch,0,0,60h,0ah,48h,0,0,0,4,0eh            ; 11 (3.3)
         db        5,24h,80h,30h,0,0,0,19h,50h,0eh,20h,10h,0,28h      ; 12 (4.0)
         db        5,26h,40h,30h,20h,40h,0,1eh,50h,16h,18h,18h,0,0b8h ; 13 (4.1)
         db        5,26h,30h,30h,20h,40h,0,23h,50h,16h,10h,18h,0,0b8h ; 14 (4.2)
         db        5,0,20h,40h,0,0,60h,0ah,40h,0,0,0,4,0eh            ; 15 (4.3)
         db        5,20h,60h,50h,0,0,0,1eh,50h,0ah,0,10h,0,28h        ; 16 (5.0)
         db        5,22h,20h,50h,20h,40h,0,23h,54h,12h,10h,10h,0,0b8h ; 17 (5.1)
         db        5,22h,20h,50h,10h,50h,0,1eh,54h,12h,8,10h,0,0b8h   ; 18 (5.2)
         db        5,0,20h,60h,0,0,70h,0ah,40h,0,0,0,4,0eh            ; 19 (5.3)

da9f6    db        0dh,16h,'COPYRIGHT 1984',0ffh       ; text
daa07    db        9,17h,'SEGA ENTERPRISES, INC.',0ffh ; text - licen‡n¡ inform.
daa20    db        0ch,8,'ENTERING SECTOR',0ffh        ; text
daa32    db        3,0,'SCORE:',0ffh                   ; text
daa3b    db        1ah,0,'HIGH:',0ffh                  ; text
daa43    db        0dh,0bh,'USING JOYSTICK',0ffh       ; text
daa54    db        0dh,0bh,'USING KEYBOARD',0ffh       ; text
         db        11 dup(0)
daa70    label     byte                                ; obr zky ‡¡slic
.XLIST
db 054h,000h,001h,055h,043h,0FFh,0FCh,015h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;AA70
db 03Fh,0C0h,03Fh,0C5h,03Fh,015h,04Fh,0C5h,03Fh,015h,04Fh,0C5h,03Fh,015h,04Fh,0C5h ;AA80
db 03Fh,015h,04Fh,0C5h,03Fh,015h,04Fh,0C5h,03Fh,015h,04Fh,0C5h,03Fh,015h,04Fh,0C5h ;AA90
db 03Fh,015h,04Fh,0C5h,03Fh,015h,04Fh,0C5h,03Fh,015h,04Fh,0C5h,03Fh,0C0h,03Fh,0C5h ;AAA0
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,043h,0FFh,0FCh,015h,054h,000h,001h,055h ;AAB0
db 055h,050h,001h,055h,055h,04Fh,0F1h,055h,055h,03Fh,0F1h,055h,054h,0FFh,0F1h,055h ;AAC0
db 050h,00Fh,0F1h,055h,055h,04Fh,0F1h,055h,055h,04Fh,0F1h,055h,055h,04Fh,0F1h,055h ;AAD0
db 055h,04Fh,0F1h,055h,055h,04Fh,0F1h,055h,055h,04Fh,0F1h,055h,055h,04Fh,0F1h,055h ;AAE0
db 055h,04Fh,0F1h,055h,055h,04Fh,0F1h,055h,055h,04Fh,0F1h,055h,050h,03Fh,0FCh,005h ;AAF0
db 053h,0FFh,0FFh,0C5h,053h,0FFh,0FFh,0C5h,053h,0FFh,0FFh,0C5h,050h,000h,000h,005h ;AB00
db 050h,000h,000h,055h,04Fh,0FFh,0FFh,015h,03Fh,0F3h,0FFh,0C5h,03Fh,0C4h,0FFh,0C5h ;AB10
db 000h,004h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h ;AB20
db 055h,053h,0FFh,015h,055h,04Fh,0FCh,055h,055h,03Fh,0F1h,055h,054h,0FFh,0C5h,055h ;AB30
db 053h,0FFh,015h,055h,04Fh,0FCh,055h,055h,03Fh,0F1h,055h,055h,03Fh,0F0h,000h,005h ;AB40
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,000h,000h,000h,005h ;AB50
db 000h,000h,000h,055h,03Fh,0FFh,0FFh,005h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;AB60
db 000h,003h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h ;AB70
db 050h,003h,0FFh,0C5h,053h,0FFh,0FFh,015h,050h,003h,0FFh,0C5h,055h,054h,0FFh,0C5h ;AB80
db 055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h,000h,003h,0FFh,0C5h ;AB90
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,005h,000h,000h,000h,055h ;ABA0
db 055h,055h,000h,005h,055h,054h,0FFh,0C5h,055h,053h,0FFh,0C5h,055h,04Fh,0FFh,0C5h ;ABB0
db 055h,03Fh,0FFh,0C5h,054h,0FFh,0FFh,0C5h,053h,0F0h,0FFh,0C5h,04Fh,0C4h,0FFh,0C5h ;ABC0
db 03Fh,0C0h,0FFh,0C1h,03Fh,0FFh,0FFh,0F1h,03Fh,0FFh,0FFh,0F1h,03Fh,0FFh,0FFh,0F1h ;ABD0
db 03Fh,0FFh,0FFh,0F1h,000h,000h,000h,001h,055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h ;ABE0
db 055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,054h,000h,005h ;ABF0
db 000h,000h,000h,005h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;AC00
db 03Fh,0F0h,000h,005h,03Fh,0F1h,055h,055h,03Fh,0F1h,055h,055h,03Fh,0FCh,005h,055h ;AC10
db 03Fh,0FFh,0F0h,055h,03Fh,0FFh,0FFh,005h,040h,000h,0FFh,0C5h,055h,055h,03Fh,0C5h ;AC20
db 055h,055h,04Fh,0C5h,055h,055h,04Fh,0C5h,055h,055h,03Fh,0C5h,000h,000h,03Fh,0C5h ;AC30
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,015h,03Fh,0FFh,0F0h,055h,000h,000h,005h,055h ;AC40
db 050h,000h,000h,015h,04Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;AC50
db 03Fh,0FCh,0FFh,0C5h,03Fh,0F1h,000h,005h,03Fh,0F1h,055h,055h,03Fh,0F1h,055h,055h ;AC60
db 03Fh,0F0h,000h,055h,03Fh,0FFh,0FFh,015h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;AC70
db 03Fh,0FFh,0FFh,0C5h,03Fh,0C3h,0FFh,0C5h,03Fh,014h,0FFh,0C5h,03Fh,0C3h,0FFh,0C5h ;AC80
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,04Fh,0FFh,0FFh,015h,050h,000h,000h,055h ;AC90
db 000h,000h,000h,005h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;ACA0
db 000h,000h,0FFh,0C5h,055h,054h,0FFh,0C5h,055h,053h,0FFh,015h,055h,04Fh,0FCh,055h ;ACB0
db 055h,03Fh,0F1h,055h,054h,0FFh,0C5h,055h,053h,0FFh,015h,055h,04Fh,0FCh,055h,055h ;ACC0
db 03Fh,0F1h,055h,055h,03Fh,0F1h,055h,055h,03Fh,0F1h,055h,055h,03Fh,0F1h,055h,055h ;ACD0
db 03Fh,0F1h,055h,055h,03Fh,0F1h,055h,055h,03Fh,0F1h,055h,055h,000h,001h,055h,055h ;ACE0
db 050h,000h,000h,055h,04Fh,0FFh,0FFh,015h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;ACF0
db 03Fh,0F0h,0FFh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0C5h ;AD00
db 04Fh,0F0h,0FFh,015h,053h,0FFh,0FCh,055h,053h,0FFh,0FCh,055h,04Fh,0F0h,0FFh,015h ;AD10
db 03Fh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0C5h,03Fh,0F0h,0FFh,0C5h ;AD20
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,04Fh,0FFh,0FFh,015h,050h,000h,000h,055h ;AD30
db 050h,000h,000h,055h,04Fh,0FFh,0FFh,015h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;AD40
db 03Fh,0C3h,0FFh,0C5h,03Fh,014h,0FFh,0C5h,03Fh,0C3h,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h ;AD50
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,04Fh,0FFh,0FFh,0C5h,050h,000h,0FFh,0C5h ;AD60
db 055h,054h,0FFh,0C5h,055h,054h,0FFh,0C5h,000h,004h,0FFh,0C5h,03Fh,0F3h,0FFh,0C5h ;AD70
db 03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,03Fh,0FFh,0FFh,0C5h,040h,000h,000h,015h ;AD80
.LIST

dad90    db        0                        ; korekce n hodn‚ho ‡¡sla

;         db        90h                      ; = EVEN
         EVEN

dad92    label     word                     ; tabulka adres pohyb– objekt–
.XLIST
         dw        dade0-1                  ; 0 st©ela (UFO)
         dw        dadf3-1                  ; 1 lev˜ sloup br ny
         dw        dae2b-1                  ; 2 prav˜ sloup br ny (UFO)
         dw        dae65-1                  ; 3 kosmick  loƒ 0 (je zemˆ), disk 0
         dw        dae6d-1                  ; 4 kosmick  loƒ 1 (je zemˆ), disk 1
         dw        dae75-1                  ; 5 kosmick  loƒ 2 (je zemˆ), disk 2
         dw        dae7d-1                  ; 6 kosmick  loƒ 3 (je zemˆ), disk 3

         dw        dae83-1                  ; 7 v˜buch disku, UFO
         dw        dae9d-1                  ; 8 v˜buch disku, UFO
         dw        dae8b-1                  ; 9 v˜buch rakety
         dw        dae9e-1                  ; 10 velk‚ UFO
         dw        daec0-1                  ; 11
         dw        daee2-1                  ; 12 bomba kosmick‚ lodi, UFO
         dw        daeef-1                  ; 13 bomba br ny (vlevo)
         dw        daef4-1                  ; 14 bomba br ny (vpravo)

         dw        daef9-1                  ; 15 kosmick  loƒ 0 (nen¡ zemˆ)
         dw        daf30-1                  ; 16 kosmick  loƒ 1 (nen¡ zemˆ)
         dw        daf69-1                  ; 17 ... dal¨¡ pohyb
         dw        daf80-1                  ; 18 ... dal¨¡ pohyb

         dw        daf97-1                  ; 19 hvˆzda vpravo 0
         dw        daf9c-1                  ; 20 hvˆzda vpravo 1
         dw        dafa3-1                  ; 21 hvˆzda vpravo 2
         dw        dafaa-1                  ; 22 hvˆzda vpravo 3
         dw        dafaf-1                  ; 23 hvˆzda vpravo 4
         dw        dafb6-1                  ; 24 hvˆzda vpravo 5

         dw        dafbd-1                  ; 25 hvˆzda vlevo 0
         dw        dafc2-1                  ; 26 hvˆzda vlevo 1
         dw        dafc9-1                  ; 27 hvˆzda vlevo 2
         dw        dafd0-1                  ; 28 hvˆzda vlevo 3
         dw        dafd5-1                  ; 29 hvˆzda vlevo 4
         dw        dafdc-1                  ; 30 hvˆzda vlevo 5

         dw        dafe3-1                  ; 31 ?
         dw        daff2-1                  ; 32 ?
         dw        db001-1                  ; 33 ?
         dw        db010-1                  ; 34 ?
         dw        db01f-1                  ; 35 ?
         dw        db024-1                  ; 36 ?
         dw        db033-1                  ; 37 ?
         dw        db042-1                  ; 38 ?

; ------ akce objekt–

; bit 7 = 0:  bit 0 a‘ bit 6 = p©¡rustek sou©adnice Y
;     n sleduje stavov˜ bajt:
;                            bit 0: 1=zv˜¨en¡ p©¡rustku X; 0=sn¡‘en¡ p©¡rustku X
;                            bit 1: 1=zmen¨en¡ objektu; 0=zvˆt¨en¡ objektu
;                            bit 2: 1=smˆr posunu Y dol–, 0=smˆr nahoru
;                            bit 3: 1=smˆr posunu X vpravo, 0=smˆr vlevo
;                            bit 4: 1=zmˆna p©¡rustku sou©adnice X
;                            bit 5: 1=zmˆna velikosti objektu
;                            bit 6: 1=m  b˜t posun ve smˆru Y (smˆr bit 2)
;                            bit 7: 1=m  b˜t posun ve smˆru X (smˆr bit 3)
; bit 7 = 1:  bit 0 a‘ bit 6 = povel
;                  0 = nastaven¡ nov‚ho offsetu ukazatele akc¡ (n sleduje slovo offsetu)
;                  1 = nastaven¡ typu objektu (n sleduje bajt typu objektu)
;                  2 = konec pohybu - zru¨en¡ objektu
;                  3 = vol n¡ podprogramu (£schova sou‡asn‚ho ukazatele, n sleduje slovo)
;                  4 = n vrat z podprogramu (n vrat sou‡asn‚ho ukazatele)
;                  5 = nastaven¡ p©¡rustku sou©adnice X (n sleduje bajt p©¡rustku X)
;                  6 = test proletˆn¡ rakety branou
;                  7 = generov n¡ nov‚ho pohybu objektu 17 nebo 18

dade0    label     byte                     ; 0: st©ela

         db        24                       ; rychlost Y
         db        bit6                     ; posun ve smˆru Y nahoru
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        dadec                    ; .... adresa
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        dadec                    ; .... adresa
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        dadec                    ; .... adresa
         db        bit7 + 2                 ; konec pohybu - zru¨en¡ objektu

dadec    label     byte
         db        bit4                     ;
         db        72h
         db        4,40h                    ; p©¡rustek Y, posun Y nahoru
         db        4,40h                    ; p©¡rustek Y, posun Y nahoru
         db        bit7 + 4                 ; n vrat z podprogramu


dadf3    label     byte                     ; 1: lev˜ sloup br ny
         db        2                        ; rychlost Y
         db        bit2+bit5+bit6           ; zmen¨en¡, posun dol–
         db        1                        ; rychlost Y
         db        bit2+bit5+bit6           ; zmen¨en¡, posun dol–
         db        1
         db        bit2+bit6+bit7           ; posun dol– vlevo
         db        3
         db        bit2+bit6                ; posun dol–
         db        1
         db        bit2+bit6+bit7           ; posun dol– vlevo
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db179                    ; ... (adresa)
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db179                    ; ... (adresa)
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db179                    ; ... (adresa)
         db        2
         db        bit2+bit6                ; posun dol–
         db        1
         db        bit2+bit5+bit6           ; zmen¨en¡, posun dol–
         db        1
         db        bit2+bit6+bit7           ; posun dol– vlevo
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db180                    ; ... (adresa)
         db        2
         db        bit2+bit6                ; posun dol–
         db        1
         db        bit2+bit6                ; posun dol–
         db        1
         db        bit2+bit6+bit7           ; posun dol– vlevo
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db179                    ; ... (adresa)
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db184                    ; ... (adresa)
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db179                    ; ... (adresa)
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db180                    ; ... (adresa)
         db        bit7 + 6                 ; test proletˆn¡ rakety branou
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db179                    ; ... (adresa)
         db        bit7 + 3                 ; vol n¡ podprogramu
         dw        db180                    ; ... (adresa)
         db        40
         db        bit2+bit6+bit7           ; posun dol– vlevo
         db        bit7 + 2                 ; konec pohybu - zru¨en¡ sloupu


dae2b    label     byte                     ; 2: prav˜ sloup br ny

db 002h,064h,001h,064h,001h ;AE20
db 0CCh,003h,044h,001h,0CCh,083h,089h,0B1h,083h,089h,0B1h,083h,089h,0B1h,002h,044h ;AE30
db 001h,064h,001h,0CCh,083h,090h,0B1h,002h,044h,001h,044h,001h,0CCh,083h,089h,0B1h ;AE40
db 083h,094h,0B1h,083h,089h,0B1h,083h,090h,0B1h,086h,083h,089h,0B1h,083h,090h,0B1h ;AE50
db 028h,0CCh,082h,070h,040h


dae65    label     byte                     ; 3: kosmick  loƒ 0 (je zemˆ), disk 0
db 083h,029h,0B1h,083h,040h,0B1h,070h,040h

dae6d    label     byte                     ; 4: kosmick  loƒ 1 (je zemˆ), disk 1
db 083h,029h,0B1h ;AE60
db 083h,068h,0B1h,070h,040h

dae75    label     byte                     ; 5: kosmick  loƒ 2 (je zemˆ), disk 2
db 083h,051h,0B1h,083h,068h,0B1h,070h,040h

dae7d    label     byte                     ; 6: kosmick  loƒ 3 (je zemˆ), disk 3
db 083h,051h,0B1h ;AE70
db 083h,040h,0B1h

dae83    label     byte                     ; 7: v˜buch disku, UFO
db 081h,007h,085h,010h,005h,000h,005h,020h

dae8b    label     byte                     ; 9 v˜buch rakety
db 085h,010h,005h,0A8h,005h ;AE80
db 022h,005h,022h,005h,0AAh,005h,022h,005h,022h,005h,022h,005h,022h

dae9d    label     byte                     ; 8: v˜buch disku, UFO
db 082h

dae9e    label     byte                     ; 10: velk‚ UFO
db 004h,0C4h ;AE90
db 004h,0E4h,001h,020h,083h,01Ah,0B1h,010h,0C4h,001h,020h,083h,08Fh,0B0h,010h,0CCh ;AEA0
db 008h,0ECh,001h,020h,083h,0DCh,0B0h,020h,0C4h,001h,020h,083h,051h,0B0h,07Fh,0CCh ;AEB0

daec0    label     byte                     ; 11:
db 004h,0CCh,004h,0ECh,001h,020h,083h,0AEh,0B0h,010h,0CCh,001h,020h,083h,0FBh,0B0h ;AEC0
db 010h,0C4h,008h,0E4h,001h,020h,083h,070h,0B0h,020h,0CCh,001h,020h,083h,0BDh,0B0h ;AED0
db 07Fh,0C4h

daee2    label     byte                     ; 12: bomba kosmick‚ lodi, UFO
db 083h,0E8h,0AEh,080h,0E2h,0AEh,004h,0C4h,004h,064h,008h,064h,084h

daeef    label     byte                     ; 13: bomba br ny (vlevo)
         db 07Fh ;AEE0
         db 080h
         db        bit7 + 0
         dw        daeef


daef4    label     byte
         db 07Fh,088h                           ; 14: bomba br ny (vpravo)
         db        bit7 + 0
         dw        daef4

daef9    label     byte                     ; 15: kosmick  loƒ 0 (nen¡ zemˆ)
db 008h,040h,010h,0BAh,008h,040h,008h ;AEF0
db 0C0h,048h,080h,008h,040h,010h,0B2h,008h,040h,008h,0C8h,048h,0BAh,008h,0C8h,004h ;AF00
db 050h,004h,0C0h,010h,0A2h,002h,0C0h,002h,0FAh,008h,080h,002h,0C8h,002h,072h,002h ;AF10
db 080h,002h,0C0h,002h,0EAh,002h,080h,002h,0E2h,008h,088h,008h,080h,008h,088h,087h ;AF20

daf30    label     byte                     ; 16: kosmick  loƒ 1 (nen¡ zemˆ)
db 008h,040h,010h,0C0h,010h,0B2h,008h,040h,008h,0C8h,048h,088h,008h,040h,010h,0BAh ;AF30
db 008h,040h,008h,0C0h,048h,0B2h,008h,0C0h,004h,050h,004h,0C8h,010h,0AAh,002h,0C8h ;AF40
db 002h,0F2h,008h,088h,002h,0C0h,002h,072h,002h,088h,002h,0C8h,002h,0E2h,002h,088h ;AF50
db 002h,0EAh,008h,080h,008h,088h,008h,080h,087h

daf69    label     byte                     ; 17: ... dal¨¡ pohyb
db 002h,0ECh,010h,0A0h,004h,0FDh,010h ;AF60
db 088h,004h,0E4h,020h,080h,008h,0FDh,020h,0A8h,008h,0E4h,040h,0A0h,07Fh,0DDh,082h ;AF70

daf80    label     byte                     ; 18: ... dal¨¡ pohyb
db 002h,0E4h,010h,0A8h,004h,0F5h,010h,080h,004h,0ECh,020h,088h,008h,0F5h,020h,0A0h ;AF80
db 008h,0ECh,040h,0A8h,07Fh,0D5h,082h

daf97    label     byte                     ; 19: hvˆzda vpravo 0
db 07Fh,040h
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        daf97                    ; nov  adresa pohybu

daf9c    label     byte                     ; 20: hvˆzda vpravo 1
db 001h,040h,001h,0C8h ;AF90
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        daf9c                    ; nov  adresa pohybu



dafa3    label     byte                     ; 21: hvˆzda vpravo 2
db 001h,088h,001h,0C8h
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafa3

dafaa    label     byte                     ; 22: hvˆzda vpravo 3
db 07Fh,088h
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafaa

dafaf    label     byte                     ; 23: hvˆzda vpravo 4
db 001h ;AFA0
db 088h,001h,0CCh
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafaf


dafb6    label     byte                     ; 24: hvˆzda vpravo 5
db 001h,044h,001h,0CCh
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafb6


dafbd    label     byte                     ; 25: hvˆzda vlevo 0
db 07Fh,044h    ;AFB0
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafbd


dafc2    label     byte                     ; 26: hvˆzda vlevo 1
db 001h,044h,001h,0C4h
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafc2


dafc9    label     byte                     ; 27: hvˆzda vlevo 2
db 001h,080h,001h,0C4h
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafc9


dafd0    label     byte                     ; 28: hvˆzda vlevo 3
db 07Fh,080h
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafd0


dafd5    label     byte                     ; 29: hvˆzda vlevo 4
db 001h,080h,001h,0C0h
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafd5


dafdc    label     byte                     ; 30: hvˆzda vlevo 5
db 001h,040h,001h,0C0h ;AFD0
         db        bit7 + 0                 ; povel pro opakov n¡ pohybu
         dw        dafdc


dafe3    label     byte                     ; 31 ?
db 081h,004h,083h,0EBh,0AFh,080h,0E3h,0AFh,004h,0C0h,004h,060h,008h ;AFE0
db 060h,084h

daff2    label     byte                     ; 32 ?
db 081h,004h,083h,0FAh,0AFh,080h,0F2h,0AFh,004h,0C0h,004h,0E8h,008h,0E8h ;AFF0
db 084h

db001    label     byte                     ; 33 ?
db 081h,004h,083h,009h,0B0h,080h,001h,0B0h,004h,088h,004h,0A8h,008h,0A8h,084h ;B000

db010    label     byte                     ; 34 ?
db 081h,004h,083h,018h,0B0h,080h,010h,0B0h,004h,0CCh,004h,0ECh,008h,0ECh,084h

db01f    label     byte                     ; 35 ?
db 081h ;B010
db 004h,080h,0E2h,0AEh

db024    label     byte                     ; 36 ?
db 081h,004h,083h,02Ch,0B0h,080h,024h,0B0h,004h,0C4h,004h,0E4h ;B020
db 008h,0E4h,084h

db033    label     byte                     ; 37 ?
db 081h,004h,083h,03Bh,0B0h,080h,033h,0B0h,004h,080h,004h,0A0h,008h ;B030
db 0A0h,084h

db042    label     byte                     ; 38 ?
db 081h,004h,083h,04Ah,0B0h,080h,042h,0B0h,004h,0C0h,004h,0E4h,008h,0E4h ;B040
db 084h,004h,0C8h,00Ah,040h,009h,0C8h,004h,040h,00Bh,0C8h,003h,088h,002h,0C8h,007h ;B050
db 0A8h,002h,0CCh,003h,088h,00Bh,0CCh,004h,044h,009h,0CCh,00Ah,044h,004h,0CCh,084h ;B060
db 003h,0C8h,004h,040h,005h,0C8h,004h,040h,002h,0C8h,002h,040h,009h,0C8h,009h,0A8h ;B070
db 009h,0CCh,002h,044h,002h,0CCh,004h,044h,005h,0CCh,004h,044h,003h,0CCh,084h,002h ;B080
db 0C8h,003h,040h,002h,0C8h,002h,040h,003h,0C8h,002h,040h,005h,0C8h,006h,0A8h,005h ;B090
db 0CCh,002h,044h,003h,0CCh,002h,044h,002h,0CCh,003h,044h,002h,0CCh,084h,002h,0C8h ;B0A0
db 002h,040h,004h,0C8h,004h,088h,004h,0CCh,002h,044h,002h,0CCh,084h,004h,0C0h,00Ah ;B0B0
db 040h,009h,0C0h,004h,040h,00Bh,0C0h,003h,080h,002h,0C0h,007h,0A0h,002h,0C4h,003h ;B0C0
db 080h,00Bh,0C4h,004h,044h,009h,0C4h,00Ah,044h,004h,0C4h,084h,003h,0C0h,004h,040h ;B0D0
db 005h,0C0h,004h,040h,002h,0C0h,002h,040h,009h,0C0h,009h,0A0h,009h,0C4h,002h,044h ;B0E0
db 002h,0C4h,004h,044h,005h,0C4h,004h,044h,003h,0C4h,084h,002h,0C4h,003h,040h,002h ;B0F0
db 0C0h,002h,040h,003h,0C0h,002h,040h,005h,0C0h,006h,0A0h,005h,0C4h,002h,044h,003h ;B100
db 0C4h,002h,044h,002h,0C4h,003h,044h,002h,0C4h,084h,002h,0C0h,002h,040h,004h,0C0h ;B110
db 004h,080h,004h,0C4h,002h,044h,002h,0C4h,084h,010h,0C8h,010h,0C8h,010h,0EAh,010h ;B120
db 062h,010h,062h,010h,072h,010h,072h,010h,072h,008h,072h,008h,062h,010h,080h,084h ;B130
db 008h,064h,008h,075h,010h,075h,010h,0FDh,010h,0FDh,010h,0ECh,010h,064h,030h,0E4h ;B140
db 082h,010h,0C0h,010h,0C0h,010h,0E2h,010h,062h,010h,062h,010h,072h,010h,072h,010h ;B150
db 072h,008h,072h,008h,062h,010h,088h,084h,008h,064h,008h,075h,010h,075h,010h,0F5h ;B160
db 010h,0F5h,010h,0E4h,010h,064h,030h,0ECh,082h                                    ;B170

db179    db        003h,064h,001h,0C4h,080h,084h,0B1h ;B170
db180    db        003h,044h,001h,0C4h
db184    db        003h,044h,001h,0C4h,084h,003h,064h,001h,0CCh,080h,094h,0B1h ;B180
db 003h,044h,001h,0CCh,003h,044h,001h,0CCh,084h,000h,000h,000h,000h,000h           ;B190
.LIST

db19e    db        0                        ; tabulka
db19f    db        0,0,4,0,4,0,0f8h,8,4,0f0h,0,0,0fch,10h,8,0,0f0h,0f8h,10h
         db        8,4,0e0h,0,0,0fch,20h,8,0e0h,0f2h,20h,0f8h

db1be    db        1ah,1ah,0ch,7,3,2,1,0,0  ; tabulka
db1c7    db        0                        ; ‡¡slo obr zku k zobrazen¡
db1c8    db        0                        ; pozice obr zku k zobrazen¡ X
db1c9    db        0                        ; linka Y k zobrazen¡ obr zku
         db        6 dup(0)

db1d0    label     byte                     ; tituln¡ obr zek
         ; (70 bajt– na konci obr zku je asi nadbyte‡n˜ch - nezobraz¡ se)
.XLIST
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;B1D0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;B1E0
db 000h,002h,0AAh,0A8h,000h,000h,000h,02Ah,0AAh,0AAh,000h,000h,000h,00Ah,0AAh,0AAh ;B1F0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,02Ah,0AAh,0AAh ;B200
db 0AAh,0A0h,0AAh,0AAh,0AAh,002h,0AAh,0AAh,0A8h,000h,0AAh,0AAh,0A8h,002h,0AAh,0AAh ;B210
db 080h,0AAh,0A0h,000h,00Ah,0AAh,0AAh,0AAh,0AAh,0AAh,000h,000h,0AAh,0AAh,0AAh,0A0h ;B220
db 000h,002h,0AAh,0AAh,0AAh,0A0h,000h,002h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A0h ;B230
db 000h,000h,0AAh,0A8h,000h,000h,000h,000h,0AAh,0AAh,0AAh,0AAh,0A0h,0AAh,0AAh,0AAh ;B240
db 002h,0AAh,0AAh,0A8h,02Ah,0AAh,0AAh,0AAh,082h,0AAh,0AAh,082h,0AAh,0A8h,000h,00Ah ;B250
db 0AAh,0AAh,0AAh,0AAh,0AAh,080h,00Ah,0AAh,0AAh,0AAh,0AAh,000h,02Ah,0AAh,0AAh,0AAh ;B260
db 0AAh,000h,02Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,000h,00Ah,0AAh,0A8h,000h ;B270
db 000h,000h,002h,0AAh,0AAh,0AAh,0AAh,0A8h,0AAh,0AAh,0AAh,002h,0AAh,0AAh,0A8h,0AAh ;B280
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,08Ah,0BFh,0AAh,000h,00Ah,0AAh,0AAh,0AAh,0AAh,0AAh ;B290
db 0A8h,02Ah,0AAh,0FFh,0EAh,0AAh,0A2h,0AAh,0AFh,0FFh,0FAh,0AAh,0AAh,0AAh,0BFh,0FFh ;B2A0
db 0FAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A0h,02Ah,0AAh,0AAh,000h,000h,000h,00Ah,0AFh,0FFh ;B2B0
db 0FFh,0FAh,0A8h,0AFh,0FFh,0EAh,002h,0AFh,0FFh,0EAh,0AAh,0BFh,0FFh,0FFh,0ABh,0FFh ;B2C0
db 0FAh,0AAh,0BBh,0EAh,080h,00Ah,0BFh,0FFh,0FFh,0FFh,0FAh,0AAh,0AAh,0BFh,0EAh,0FFh ;B2D0
db 0AAh,0AAh,0AAh,0FEh,0AAh,0BFh,0EAh,0AAh,0ABh,0FAh,0AAh,0BEh,0FFh,0FFh,0FFh,0FFh ;B2E0
db 0EAh,0A0h,0AAh,0BFh,0AAh,000h,000h,000h,02Ah,0BEh,0AAh,0AAh,0BFh,0AAh,0AEh,0AAh ;B2F0
db 0EAh,002h,0AEh,0AAh,0EAh,0ABh,0FAh,0AAh,0ABh,0EBh,0AAh,0BAh,0AAh,0FAh,0FAh,0A0h ;B300
db 00Ah,0BAh,0AAh,0AAh,0AAh,0BEh,0AAh,0ABh,0FAh,0AAh,0ABh,0FAh,0AAh,0AFh,0EAh,0AAh ;B310
db 0AAh,0FAh,0AAh,0AFh,0AAh,0AAh,0AFh,0EAh,0AAh,0AAh,0AAh,0FAh,0AAh,0ABh,0FBh,0EAh ;B320
db 080h,000h,000h,0AAh,0FAh,0AAh,0AAh,0ABh,0EAh,0AEh,0AAh,0EAh,002h,0AEh,0AAh,0EAh ;B330
db 0AFh,0AAh,0AAh,0AAh,0FBh,0AAh,0BAh,0ABh,0EAh,0BEh,0A8h,00Ah,0BAh,0AAh,0AAh,0AAh ;B340
db 0AFh,0AAh,0AFh,0AAh,0AAh,0AAh,0BEh,0AAh,0BEh,0AAh,0AAh,0ABh,0EAh,0AAh,0FEh,0AAh ;B350
db 0AAh,0ABh,0EAh,0AAh,0AAh,0AAh,0BEh,0AAh,0AFh,0AAh,0FAh,080h,000h,002h,0ABh,0EAh ;B360
db 0AAh,0AAh,0AAh,0FAh,0AEh,0AAh,0EAh,002h,0AEh,0AAh,0EAh,0FEh,0AAh,0AAh,0AAh,0BFh ;B370
db 0AAh,0BAh,0AFh,0AAh,0FAh,0A0h,00Ah,0BAh,0AAh,0AAh,0AAh,0ABh,0EAh,0BEh,0AAh,0AAh ;B380
db 0AAh,0AFh,0AAh,0FAh,0AAh,0FFh,0FFh,0AAh,0ABh,0EAh,0AAh,0AAh,0AAh,0EAh,0AAh,0AAh ;B390
db 0AAh,0AFh,0AAh,0BEh,0AAh,0BAh,080h,000h,00Ah,0AFh,0AAh,0FFh,0FAh,0AAh,0BEh,0AEh ;B3A0
db 0AAh,0EAh,002h,0AEh,0AAh,0EBh,0EAh,0AAh,0FFh,0FEh,0AFh,0AAh,0BAh,0BEh,0ABh,0EAh ;B3B0
db 0A0h,00Ah,0BAh,0ABh,0FFh,0EAh,0AAh,0FBh,0FAh,0AFh,0FFh,0FAh,0ABh,0EBh,0EAh,0AFh ;B3C0
db 0EAh,0BEh,0AAh,0AFh,0AAh,0AFh,0FFh,0FAh,0EAh,0AFh,0FFh,0EAh,0ABh,0EAh,0FAh,0AAh ;B3D0
db 0FAh,080h,000h,02Ah,0BEh,0AAh,0EAh,0BFh,0AAh,0AFh,0AEh,0AAh,0EAh,002h,0AEh,0AAh ;B3E0
db 0EFh,0AAh,0AFh,0EAh,0AFh,0ABh,0AAh,0BAh,0FAh,0AFh,0AAh,080h,00Ah,0BAh,0ABh,0AAh ;B3F0
db 0FAh,0AAh,0BBh,0AAh,0BEh,0AAh,0BEh,0AAh,0FFh,0AAh,0BEh,0AAh,0AAh,0AAh,0AEh,0AAh ;B400
db 0BEh,0AAh,0BEh,0EAh,0AEh,0AAh,0FEh,0AAh,0EBh,0EAh,0ABh,0EAh,080h,000h,0AAh,0FEh ;B410
db 0AAh,0EAh,0ABh,0EAh,0ABh,0EEh,0AAh,0EAh,002h,0AEh,0AAh,0FEh,0AAh,0FEh,0AAh,0ABh ;B420
db 0EBh,0AAh,0BBh,0EAh,0BEh,0AAh,000h,00Ah,0BAh,0ABh,0AAh,0BEh,0AAh,0BFh,0AAh,0FAh ;B430
db 0AAh,0AFh,0AAh,0BEh,0AAh,0FAh,0AAh,0AAh,0AAh,0BEh,0ABh,0FAh,0AAh,0AFh,0EAh,0AEh ;B440
db 0AAh,0AEh,0AAh,0EBh,0AAh,0AFh,0AAh,080h,000h,00Ah,0AEh,0AAh,0E8h,0AAh,0EAh,0AAh ;B450
db 0EEh,0AAh,0EAh,002h,0AEh,0AAh,0EAh,0ABh,0EAh,0AAh,0AAh,0FFh,0AAh,0BBh,0AAh,0FAh ;B460
db 0A8h,000h,00Ah,0BAh,0ABh,0A2h,0AEh,0AAh,0BAh,0ABh,0EAh,0AAh,0ABh,0EAh,0AAh,0ABh ;B470
db 0EAh,080h,02Ah,0AAh,0BAh,0ABh,0AAh,0AAh,0AAh,0EAh,0AEh,082h,0AEh,0AAh,0EFh,0AAh ;B480
db 0BEh,0AAh,000h,000h,002h,0AEh,0AAh,0E8h,00Ah,0EAh,0AAh,0EEh,0AAh,0EAh,002h,0AEh ;B490
db 0AAh,0EAh,0AFh,0AAh,000h,02Ah,0ABh,0AAh,0BFh,0ABh,0EAh,0A0h,000h,00Ah,0BAh,0ABh ;B4A0
db 0A0h,0AEh,0AAh,0BAh,0ABh,0AAh,000h,0AAh,0EAh,0AAh,0AFh,0AAh,000h,000h,0AAh,0FAh ;B4B0
db 0AFh,0A8h,000h,0AAh,0EAh,0AEh,080h,0AEh,0AAh,0EEh,0AAh,0FAh,0A8h,000h,000h,002h ;B4C0
db 0AEh,0AAh,0E8h,00Ah,0EAh,0AAh,0EEh,0AAh,0EAh,002h,0AEh,0AAh,0EAh,0AEh,0A8h,000h ;B4D0
db 00Ah,0ABh,0AAh,0AAh,0ABh,0AAh,080h,000h,00Ah,0BAh,0ABh,0A0h,0AEh,0AAh,0BAh,0ABh ;B4E0
db 0A8h,000h,02Ah,0EAh,0AAh,0AEh,0A8h,02Ah,0AAh,0AAh,0EAh,0AEh,0A0h,000h,02Ah,0EAh ;B4F0
db 0AEh,082h,0AEh,0AAh,0EEh,0AAh,0FAh,0A0h,000h,000h,002h,0AFh,0FFh,0E8h,00Ah,0FFh ;B500
db 0FFh,0FFh,0FFh,0EAh,002h,0AFh,0FFh,0FFh,0FEh,0A0h,000h,000h,0ABh,0FFh,0FFh,0FFh ;B510
db 0AAh,000h,000h,00Ah,0BFh,0FFh,0A2h,0BFh,0FFh,0FFh,0FFh,0A8h,000h,02Ah,0FFh,0FFh ;B520
db 0FEh,0A0h,02Ah,0AAh,0ABh,0FFh,0FEh,0AAh,0AAh,0AAh,0FFh,0FEh,08Ah,0BFh,0FFh,0FFh ;B530
db 0FFh,0EAh,080h,000h,000h,002h,0AEh,0AAh,0E8h,00Ah,0EAh,0AAh,0EEh,0AAh,0EAh,002h ;B540
db 0AEh,0AAh,0EAh,0AEh,0A0h,000h,000h,0ABh,0AAh,0AAh,0BEh,0A8h,000h,000h,00Ah,0BAh ;B550
db 0ABh,0AAh,0FAh,0ABh,0BAh,0ABh,0A8h,000h,02Ah,0EAh,0AAh,0AEh,0A0h,02Ah,0AAh,0ABh ;B560
db 0AAh,0AEh,0AAh,0AAh,0AAh,0EAh,0AEh,0AAh,0FAh,0ABh,0BAh,0AAh,0EAh,000h,000h,000h ;B570
db 002h,0AFh,0FFh,0E8h,00Ah,0FFh,0FFh,0FFh,0FFh,0EAh,002h,0AFh,0FFh,0FFh,0FEh,0A0h ;B580
db 000h,000h,0ABh,0FFh,0FFh,0FAh,0A8h,000h,000h,00Ah,0BFh,0FFh,0ABh,0FFh,0FFh,0BFh ;B590
db 0FFh,0A8h,000h,02Ah,0FFh,0FFh,0FEh,0A0h,02Ah,0FFh,0FBh,0FFh,0FFh,0FFh,0FFh,0FAh ;B5A0
db 0FFh,0FEh,0ABh,0FFh,0FFh,0BFh,0FFh,0EAh,000h,000h,000h,002h,0AEh,0AAh,0E8h,02Bh ;B5B0
db 0EAh,0AAh,0EEh,0AAh,0EAh,002h,0AEh,0AAh,0EAh,0AEh,0A0h,000h,000h,0ABh,0AAh,0AAh ;B5C0
db 0BEh,0AAh,000h,000h,00Ah,0BAh,0ABh,0AFh,0AAh,0BEh,0BAh,0ABh,0A8h,000h,02Ah,0EAh ;B5D0
db 0AAh,0AEh,0A0h,02Ah,0EAh,0BBh,0AAh,0AAh,0AAh,0AAh,0BAh,0EAh,0AEh,0AEh,0AAh,0BEh ;B5E0
db 0BAh,0AAh,0EAh,000h,000h,000h,002h,0AFh,0FFh,0E8h,0ABh,0FFh,0FFh,0FFh,0FFh,0EAh ;B5F0
db 002h,0AFh,0FFh,0FFh,0FEh,0A0h,000h,000h,0ABh,0FFh,0FFh,0FFh,0EAh,080h,000h,00Ah ;B600
db 0BFh,0FFh,0FFh,0FFh,0FAh,0BFh,0FFh,0AAh,000h,0AAh,0FFh,0FFh,0FEh,0A0h,02Ah,0FFh ;B610
db 0FBh,0FFh,0FFh,0FFh,0FFh,0FAh,0FFh,0FFh,0FFh,0FFh,0FAh,0BFh,0FFh,0EAh,080h,000h ;B620
db 000h,002h,0AEh,0AAh,0EAh,0AFh,0AAh,0AAh,0EEh,0AAh,0EAh,00Ah,0AEh,0AAh,0EAh,0AEh ;B630
db 0A0h,000h,00Ah,0ABh,0AAh,0BAh,0AAh,0FAh,0A0h,000h,00Ah,0BAh,0AAh,0AAh,0ABh,0EAh ;B640
db 0BAh,0ABh,0AAh,002h,0ABh,0EAh,0AAh,0AEh,0A8h,02Ah,0EAh,0BBh,0AAh,0AAh,0AAh,0AAh ;B650
db 0BAh,0EAh,0AAh,0AAh,0AFh,0AAh,0BEh,0AAh,0FAh,0A0h,000h,000h,002h,0AFh,0FFh,0EAh ;B660
db 0AFh,0FFh,0FFh,0FFh,0FFh,0EAh,08Ah,0AFh,0FFh,0FFh,0FEh,0A8h,000h,02Ah,0ABh,0FFh ;B670
db 0FEh,0AAh,0BEh,0A8h,000h,00Ah,0BFh,0FFh,0FFh,0FFh,0AAh,0BFh,0FFh,0EAh,0AAh,0AFh ;B680
db 0FFh,0FFh,0FEh,0A8h,02Ah,0FFh,0FBh,0FFh,0FFh,0FFh,0FFh,0FAh,0FFh,0FFh,0FFh,0FEh ;B690
db 0AAh,0AFh,0FFh,0FAh,0A8h,000h,000h,002h,0AEh,0AAh,0FFh,0FEh,0AAh,0ABh,0EEh,0AAh ;B6A0
db 0FAh,0AAh,0BEh,0AAh,0EAh,0AFh,0AAh,0AAh,0AAh,0ABh,0AAh,0BBh,0AAh,0AFh,0AAh,000h ;B6B0
db 00Ah,0BAh,0ABh,0FEh,0ABh,0AAh,0AEh,0AAh,0FAh,0AAh,0BEh,0AAh,0AAh,0AFh,0AAh,02Ah ;B6C0
db 0EAh,0BAh,0EAh,0BEh,0AAh,0AAh,0AAh,0EAh,0AFh,0EAh,0AEh,0AAh,0AEh,0AAh,0BEh,0A8h ;B6D0
db 000h,000h,002h,0AEh,0AAh,0AAh,0AAh,0AAh,0AFh,0AEh,0AAh,0BAh,0AAh,0FAh,0AAh,0FAh ;B6E0
db 0ABh,0EAh,0AAh,0AAh,0FFh,0AAh,0BAh,0EAh,0ABh,0EAh,080h,00Ah,0BAh,0ABh,0AFh,0ABh ;B6F0
db 0EAh,0AFh,0AAh,0BEh,0AAh,0FAh,0AAh,0FEh,0ABh,0EAh,0AAh,0EAh,0BAh,0FAh,0AEh,0AAh ;B700
db 0AAh,0AAh,0EAh,0AEh,0FAh,0AFh,0AAh,0AFh,0AAh,0AEh,0A8h,000h,000h,002h,0AEh,0AAh ;B710
db 0AAh,0AAh,0AAh,0BEh,0AEh,0AAh,0BEh,0AFh,0EAh,0AAh,0FEh,0AAh,0FEh,0AAh,0BFh,0EAh ;B720
db 0AAh,0BAh,0BAh,0AAh,0FAh,0A0h,00Ah,0BAh,0ABh,0ABh,0EAh,0FAh,0ABh,0AAh,0AFh,0FFh ;B730
db 0EAh,0ABh,0EFh,0AAh,0FAh,0AAh,0EAh,0BAh,0BAh,0AEh,0A0h,000h,0AAh,0EAh,0AEh,0BEh ;B740
db 0ABh,0EAh,0ABh,0AAh,0AFh,0AAh,000h,000h,002h,0AEh,0AAh,0AAh,0AAh,0AAh,0BEh,0AEh ;B750
db 0AAh,0AFh,0FEh,0AAh,0AAh,0EEh,0AAh,0AFh,0FFh,0FAh,0AAh,0AAh,0BAh,0AEh,0AAh,0BEh ;B760
db 0A0h,00Ah,0BAh,0ABh,0AAh,0FAh,0BEh,0ABh,0EAh,0AAh,0AAh,0AAh,0AFh,0ABh,0EAh,0BEh ;B770
db 0AAh,0EAh,0BAh,0BAh,0AFh,0AAh,00Ah,0AAh,0EAh,0AEh,0AFh,0AAh,0FAh,0ABh,0EAh,0ABh ;B780
db 0EAh,000h,000h,002h,0AEh,0AAh,0BFh,0FFh,0AAh,0AFh,0AFh,0AAh,0AAh,0AAh,0FEh,0AAh ;B790
db 0EFh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0BAh,0ABh,0AAh,0AEh,0A8h,00Ah,0BAh,0ABh,0AAh ;B7A0
db 0BEh,0AFh,0AAh,0FAh,0AAh,0AAh,0AAh,0BEh,0AAh,0EAh,0AFh,0EAh,0EAh,0BAh,0BEh,0ABh ;B7B0
db 0EAh,0AAh,0FFh,0EAh,0AEh,0ABh,0AAh,0BEh,0AAh,0EAh,0AAh,0FAh,080h,000h,002h,0AEh ;B7C0
db 0AAh,0FAh,0ABh,0FAh,0ABh,0EBh,0EAh,0AAh,0ABh,0EEh,0AAh,0EBh,0EAh,0AAh,0AAh,0AAh ;B7D0
db 0AAh,0AAh,0BAh,0AAh,0EAh,0AEh,0A8h,00Ah,0BAh,0ABh,0AAh,0AFh,0ABh,0EAh,0BEh,0AAh ;B7E0
db 0AAh,0AAh,0FAh,0AAh,0FAh,0AAh,0FFh,0EAh,0BAh,0AEh,0AAh,0FEh,0AFh,0EAh,0EAh,0AEh ;B7F0
db 0ABh,0EAh,0AFh,0AAh,0FAh,0AAh,0BAh,080h,000h,002h,0AEh,0AAh,0EAh,0AAh,0BEh,0AAh ;B800
db 0FAh,0FAh,0AAh,0BFh,0AEh,0AAh,0EAh,0FEh,0AAh,0AAh,0AAh,0FFh,0AAh,0BAh,08Ah,0BAh ;B810
db 0BEh,0A0h,00Ah,0BAh,0ABh,0A8h,0ABh,0EAh,0FAh,0AFh,0AAh,0AAh,0AFh,0EAh,0AAh,0BEh ;B820
db 0AAh,0AAh,0AAh,0BAh,0AFh,0AAh,0AFh,0FEh,0AAh,0EAh,0AEh,0AAh,0FAh,0ABh,0EAh,0BAh ;B830
db 0AAh,0BAh,0A0h,000h,002h,0AEh,0AAh,0EAh,00Ah,0AFh,0AAh,0BAh,0BFh,0ABh,0FAh,0AEh ;B840
db 0AAh,0EAh,0AFh,0EAh,0AAh,0FFh,0EBh,0AAh,0BAh,082h,0AFh,0FAh,080h,00Ah,0BAh,0ABh ;B850
db 0A8h,02Ah,0FFh,0FEh,0ABh,0FFh,0FFh,0FEh,0AAh,0AAh,0AFh,0EAh,0AAh,0AAh,0BAh,0ABh ;B860
db 0EAh,0AAh,0AAh,0AAh,0EAh,0AEh,0AAh,0BEh,0AAh,0FAh,0BEh,0AAh,0BEh,0A0h,000h,002h ;B870
db 0AEh,0AAh,0E8h,000h,0ABh,0AAh,0BAh,0ABh,0FFh,0AAh,0AFh,0FFh,0EAh,0AAh,0FFh,0FFh ;B880
db 0EAh,0ABh,0FFh,0FAh,080h,0ABh,0EAh,000h,00Ah,0BFh,0FFh,0A8h,00Ah,0AAh,0AAh,0AAh ;B890
db 0AAh,0AAh,0AAh,0AAh,02Ah,0AAh,0FEh,0AAh,0AAh,0BAh,0AAh,0FEh,0AAh,0AAh,0BFh,0FFh ;B8A0
db 0FEh,0AAh,0AFh,0AAh,0BEh,0AFh,0AAh,0AEh,0A0h,000h,002h,0AEh,0AAh,0E8h,000h,02Bh ;B8B0
db 0AAh,0BEh,0AAh,0AAh,0AAh,02Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,080h ;B8C0
db 02Ah,0A8h,000h,00Ah,0AAh,0AAh,0A8h,002h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A0h,00Ah ;B8D0
db 0AAh,0AFh,0FAh,0AAh,0BAh,0AAh,0AFh,0FAh,0ABh,0FAh,0AAh,0AAh,0A2h,0ABh,0EAh,0AFh ;B8E0
db 0ABh,0AAh,0AEh,0A0h,000h,002h,0AEh,0AAh,0E8h,000h,02Bh,0AAh,0AEh,0AAh,0AAh,0A8h ;B8F0
db 02Ah,0AAh,0AAh,00Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,080h,00Ah,0A0h,000h,00Ah,0AAh ;B900
db 0AAh,0A8h,000h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,080h,000h,0AAh,0AAh,0BFh,0FFh,0FAh ;B910
db 08Ah,0AAh,0BFh,0FFh,0AAh,0AAh,0AAh,0A0h,0AAh,0FFh,0FFh,0EBh,0AAh,0AEh,0A0h,000h ;B920
db 002h,0AEh,0AAh,0E8h,000h,02Bh,0AAh,0AEh,0A2h,0AAh,000h,02Ah,0AAh,0AAh,000h,0AAh ;B930
db 0AAh,0A8h,002h,0AAh,0AAh,080h,002h,080h,000h,00Ah,0AAh,0AAh,0A8h,000h,02Ah,0AAh ;B940
db 0AAh,00Ah,0AAh,0A8h,000h,000h,00Ah,0AAh,0AAh,0AAh,0AAh,082h,0AAh,0AAh,0AAh,0AAh ;B950
db 0AAh,0AAh,0A0h,02Ah,0AAh,0AAh,0ABh,0AAh,0AEh,0A0h,000h,002h,0AEh,0AAh,0E8h,000h ;B960
db 02Bh,0AAh,0AEh,0A0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;B970
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;B980
db 000h,000h,0AAh,0AAh,0AAh,0AAh,080h,0AAh,0AAh,0AAh,0AAh,080h,000h,000h,00Ah,0AAh ;B990
db 0AAh,0ABh,0AAh,0AEh,0A0h,000h,002h,0AEh,0AAh,0E8h,000h,02Bh,0AAh,0AEh,0A0h,000h ;B9A0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;B9B0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ah,0AAh,0AAh ;B9C0
db 0AAh,080h,002h,0AAh,0AAh,080h,000h,000h,000h,002h,0AAh,0AAh,0ABh,0AAh,0AEh,0A0h ;B9D0
db 000h,002h,0AEh,0AAh,0E8h,000h,02Bh,0AAh,0AEh,0A0h,000h,000h,000h,000h,000h,000h ;B9E0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;B9F0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BA00
db 000h,000h,000h,000h,000h,000h,000h,0ABh,0AAh,0AEh,0A0h,000h,002h,0AEh,0AAh,0E8h ;BA10
db 000h,0ABh,0AAh,0BEh,0A0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BA20
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BA30
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BA40
db 000h,000h,0ABh,0AAh,0BEh,0A0h,000h,002h,0AEh,0AAh,0E8h,002h,0AFh,0AAh,0BAh,0A0h ;BA50
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BA60
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BA70
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0ABh,0AAh,0BAh ;BA80
db 0A0h,000h,002h,0AEh,0AAh,0E8h,00Ah,0BEh,0AAh,0FAh,0A0h,000h,02Ah,0AAh,0AAh,0AAh ;BA90
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BAA0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BAB0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0A0h,000h,000h,0ABh,0AAh,0BAh,0A0h,000h,002h,0AEh,0AAh ;BAC0
db 0EAh,0AAh,0EAh,0AAh,0EAh,080h,000h,00Ah,0ABh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ;BAD0
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ;BAE0
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0AAh ;BAF0
db 080h,000h,000h,0AFh,0AAh,0BAh,080h,000h,002h,0AEh,0AAh,0EAh,0AFh,0EAh,0ABh,0EAh ;BB00
db 080h,000h,002h,0ABh,000h,000h,000h,055h,050h,050h,000h,015h,000h,054h,004h,015h ;BB10
db 054h,015h,055h,040h,000h,000h,000h,000h,000h,000h,001h,055h,055h,055h,001h,055h ;BB20
db 050h,005h,055h,040h,054h,000h,054h,000h,000h,003h,0AAh,000h,000h,002h,0AEh,0AAh ;BB30
db 0FAh,080h,000h,002h,0AEh,0AAh,0FFh,0FEh,0AAh,0ABh,0AAh,000h,000h,000h,0ABh,0F0h ;BB40
db 000h,000h,050h,050h,050h,000h,051h,040h,055h,004h,014h,000h,000h,050h,000h,000h ;BB50
db 000h,000h,000h,000h,000h,001h,000h,005h,050h,005h,040h,054h,015h,001h,050h,055h ;BB60
db 001h,054h,000h,000h,03Fh,0A8h,000h,000h,002h,0AEh,0AAh,0EAh,080h,000h,002h,0AEh ;BB70
db 0AAh,0AAh,0AAh,0AAh,0BFh,0AAh,000h,000h,000h,00Ah,0BCh,000h,000h,050h,050h,050h ;BB80
db 001h,051h,050h,051h,044h,015h,054h,000h,050h,000h,015h,055h,054h,055h,055h,050h ;BB90
db 000h,000h,055h,040h,005h,000h,014h,014h,000h,050h,051h,045h,014h,000h,000h,0FAh ;BBA0
db 080h,000h,000h,002h,0BEh,0AAh,0EAh,000h,000h,002h,0AEh,0AAh,0AAh,0AAh,0AAh,0FAh ;BBB0
db 0A8h,000h,000h,000h,00Ah,0AFh,0F0h,000h,055h,050h,050h,001h,040h,050h,050h,054h ;BBC0
db 014h,000h,000h,050h,000h,015h,000h,054h,054h,000h,000h,000h,005h,054h,000h,005h ;BBD0
db 000h,014h,014h,000h,050h,050h,054h,014h,000h,03Fh,0EAh,080h,000h,000h,00Ah,0BAh ;BBE0
db 0ABh,0EAh,000h,000h,002h,0AEh,0AAh,0AAh,0AAh,0BFh,0EAh,0A0h,000h,000h,000h,002h ;BBF0
db 0AAh,0C0h,000h,050h,000h,050h,001h,055h,050h,050h,014h,015h,054h,000h,050h,000h ;BC00
db 015h,000h,054h,055h,055h,000h,000h,015h,040h,001h,005h,040h,054h,015h,001h,050h ;BC10
db 050h,010h,014h,000h,00Eh,0AAh,000h,000h,000h,00Ah,0FAh,0ABh,0AAh,000h,000h,002h ;BC20
db 0AFh,0FFh,0FFh,0FFh,0FAh,0AAh,080h,000h,000h,000h,000h,00Ah,0FCh,000h,050h,000h ;BC30
db 055h,041h,040h,050h,050h,004h,015h,054h,000h,050h,000h,015h,055h,054h,054h,000h ;BC40
db 000h,001h,055h,055h,055h,001h,055h,050h,005h,055h,040h,050h,000h,014h,000h,0FEh ;BC50
db 080h,000h,000h,000h,02Ah,0EAh,0AFh,0A8h,000h,000h,002h,0AAh,0AAh,0AAh,0AAh,0AAh ;BC60
db 0AAh,000h,000h,000h,000h,000h,002h,0AFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ;BC70
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ;BC80
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0EAh,000h,000h,000h,000h,0ABh ;BC90
db 0EAh,0AEh,0A8h,000h,000h,002h,0AAh,0AAh,0AAh,0AAh,0AAh,0A0h,000h,000h,000h,000h ;BCA0
db 000h,002h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BCB0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BCC0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,000h,000h,000h,000h,0AFh,0AAh,0BEh,0A0h,000h,000h ;BCD0
db 002h,0AAh,0AAh,0AAh,0AAh,0AAh,080h,000h,000h,000h,000h,000h,000h,02Ah,0AAh,0AAh ;BCE0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BCF0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BD00
db 0A0h,000h,000h,000h,002h,0BEh,0AAh,0BAh,0A0h,000h,000h,000h,000h,000h,000h,000h ;BD10
db 000h,000h,000h,000h,000h,000h,000h,000h,00Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BD20
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BD30
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,080h,000h,000h,000h,00Ah ;BD40
db 0BAh,0AAh,0FAh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BD50
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0AAh ;BD60
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FAh,0A0h,000h,000h,000h,000h,000h ;BD70
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,02Ah,0FAh,0ABh,0EAh,080h,000h ;BD80
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BD90
db 000h,00Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0BFh,0EAh,0AAh,0AAh,0AAh ;BDA0
db 0AAh,0AAh,0AAh,0BFh,0EAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,080h,000h ;BDB0
db 000h,000h,000h,000h,000h,0ABh,0EAh,0AFh,0AAh,000h,000h,000h,000h,000h,000h,000h ;BDC0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ah,0AAh,0AAh,0AAh ;BDD0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0ABh,0EAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0BEh,0AAh ;BDE0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,080h,000h,000h,000h,000h,000h,002h ;BDF0
db 0AFh,0AAh,0AEh,0A8h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BE00
db 000h,000h,000h,000h,000h,000h,000h,002h,0AAh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh ;BE10
db 0AAh,0ABh,0FFh,0AAh,0AAh,0AAh,0AAh,0AAh,0AFh,0FEh,0AAh,0AFh,0FFh,0FFh,0FFh,0FFh ;BE20
db 0FFh,0FFh,0FEh,0AAh,000h,000h,000h,000h,000h,000h,00Ah,0BEh,0AAh,0BEh,0A8h,000h ;BE30
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BE40
db 000h,000h,000h,02Ah,0AFh,0EAh,0AAh,0AAh,0AAh,0AAh,0ABh,0AAh,0AAh,0ABh,0AAh,0AAh ;BE50
db 0AAh,0AAh,0AAh,0AEh,0AAh,0AAh,0AEh,0AAh,0AAh,0AAh,0AAh,0AAh,0AFh,0EAh,0A0h,000h ;BE60
db 000h,000h,000h,000h,000h,02Ah,0FAh,0AAh,0BAh,0A0h,000h,000h,000h,000h,000h,000h ;BE70
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ah,0ABh ;BE80
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FAh,0AAh,0BFh,0AAh,0AAh,0AAh,0AAh,0AAh,0AFh,0EAh ;BE90
db 0AAh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0AAh,080h,000h,000h,000h,000h,000h,000h ;BEA0
db 0ABh,0FFh,0FFh,0FAh,0A0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BEB0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,002h,0AAh,0BFh,0FFh,0FAh,0AAh,0AAh ;BEC0
db 0AAh,0FEh,0AAh,0AFh,0AAh,0AAh,0AAh,0AAh,0AAh,0AFh,0AAh,0ABh,0FAh,0AAh,0AAh,0AAh ;BED0
db 0FFh,0FFh,0FAh,0AAh,000h,000h,000h,000h,000h,000h,002h,0AAh,0AAh,0AAh,0AAh,080h ;BEE0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BEF0
db 000h,000h,000h,000h,000h,0AAh,0AFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0AAh,0ABh,0EAh ;BF00
db 0AAh,0AAh,0AAh,0AAh,0BEh,0AAh,0AFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0EAh,0A8h,000h ;BF10
db 000h,000h,000h,000h,000h,002h,0AAh,0AAh,0AAh,0A8h,000h,000h,000h,000h,000h,000h ;BF20
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BF30
db 02Ah,0ABh,0FFh,0FFh,0FFh,0AAh,0AAh,0ABh,0EAh,0AAh,0FFh,0FFh,0FFh,0FFh,0FFh,0FAh ;BF40
db 0AAh,0BEh,0AAh,0AAh,0AFh,0FFh,0FFh,0FFh,0AAh,0A0h,000h,000h,000h,000h,000h,000h ;BF50
db 000h,0AAh,0AAh,0AAh,0A8h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BF60
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ah,0AAh,0BFh,0FFh,0FFh ;BF70
db 0FFh,0FFh,0FFh,0FAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0FFh,0FFh,0FFh,0FFh ;BF80
db 0FFh,0FFh,0FEh,0AAh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BF90
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BFA0
db 000h,000h,000h,000h,000h,000h,002h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BFB0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,000h ;BFC0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BFD0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;BFE0
db 000h,000h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;BFF0
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A8h,000h,000h,000h,000h,000h,000h ;C000
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;C010
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ah,0AAh,0AAh ;C020
db 0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh ;C030
db 0AAh,0AAh,0AAh,0AAh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;C040
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;C050
.LIST

dc060    dw        0                        ; ukazatel melodie (adresa)
dc062    dw        0                        ; priorita prob¡haj¡c¡ melodie
dc064    dw        0                        ; ‡¡ta‡ d‚lky t¢nu
dc066    label     word                     ; tabulka adres melodi¡
         dw        dc07e                    ; 0
         dw        dc0a0                    ; 1 st©¡len¡
         dw        dc0b2                    ; 2
         dw        dc0d8                    ; 3
         dw        dc0e2                    ; 4
         dw        dc0ec                    ; 5
         dw        dc0fa                    ; 6 do¨lo palivo
         dw        dc104                    ; 7
         dw        dc11a                    ; 8 proletˆn¡ branou
         dw        dc130                    ; 9
         dw        dc188                    ; 10
         dw        dc1ce                    ; 11

dc07e    dw        100,7d0h,1,1f40h,1,2710h,1,1f40h,1,2710h,1,1f40h,1,2710h,1,0,0
                                            ; 1: st©¡len¡
dc0a0    dw        100,1f40h,1,2710h,1,2ee0h,1,0,0

dc0b2    dw        100,7530h,1,2710h,2,9c40h,3,36b0h,4,32c8h,3,2ee0h,2,0ea60h,5,0,0,0,0

dc0d8    dw        90,0d6d8h,4,0,0

dc0e2    dw        90,0c350h,4,0,0

dc0ec    dw        90,1f4h,1,1388h,1,0,0
                                            ; 6: do¨lo palivo
dc0fa    dw        100,7d0h,3,0,0

dc104    dw        80,3e8h,1,0,1,3e8h,1,0,0,0,0
                                            ; 8: proletˆn¡ branou
dc11a    dw        80,3e8h,1,320h,1,258h,1,0,0,0,0

dc130    dw        70,2710h,1,2328h,1,1f40h,1,1b58h,1,1770h,1,1388h,1,0fa0h
         dw        1,0bb8h,1,7d0h,1,3e8h,1,1f4h,1,3e8h,1,7d0h,1,0bb8h,1,0fa0h
         dw        1,1388h,1,1770h,1,1b58h,1,1f40h,1,2328h,1,3e8h,0,0

dc188    dw        90,12ch,1,3e8h,1,7d0h,1,1388h,1,4e20h,2,3e8h,1,514h,1,640h
         dw        1,960h,1,15b3h,1,8235h,3,7d0h,1,0fa0h,1,1388h,1,1f40h,1,8235h,3,0,0

dc1ce    dw        90,4e20h,5,7d0h,1,2328h,5,0,0


dc1e0    label     word                     ; obr zek po zad n¡ hesla (tv ©)
                                            ;  (rozmˆr 41 linek * 10 bajt–)
db 000h,002h,0AAh,0AAh,0AAh,080h,000h,000h,000h,000h,000h,02Ah,0A0h,000h,02Ah,0AAh ;C1E0
db 080h,000h,000h,000h,000h,0AAh,000h,000h,000h,002h,0A0h,000h,000h,000h,002h,0A0h ;C1F0
db 000h,000h,000h,000h,0AAh,000h,000h,000h,00Ah,080h,000h,000h,000h,000h,00Ah,080h ;C200
db 000h,000h,00Ah,000h,000h,000h,000h,000h,00Ah,080h,000h,000h,00Ah,000h,000h,000h ;C210
db 005h,000h,002h,080h,000h,000h,028h,000h,000h,000h,015h,040h,002h,080h,000h,000h ;C220
db 0A0h,000h,000h,000h,055h,050h,002h,0A0h,000h,000h,0A0h,000h,000h,001h,055h,050h ;C230
db 000h,0A0h,000h,000h,0A0h,000h,000h,015h,055h,054h,000h,0A0h,000h,000h,0A0h,000h ;C240
db 001h,055h,055h,054h,000h,0A0h,000h,000h,0A0h,000h,015h,055h,055h,055h,000h,028h ;C250
db 000h,000h,080h,005h,055h,055h,055h,055h,000h,028h,000h,000h,080h,005h,000h,055h ;C260
db 050h,015h,040h,028h,000h,000h,080h,004h,040h,015h,040h,001h,000h,028h,000h,000h ;C270
db 0A0h,005h,06Ah,055h,058h,025h,040h,00Ah,000h,000h,0A0h,015h,080h,095h,060h,008h ;C280
db 000h,00Ah,000h,000h,0A0h,015h,060h,0D5h,078h,021h,050h,028h,000h,000h,0A0h,015h ;C290
db 055h,066h,055h,055h,050h,028h,000h,000h,0A0h,015h,055h,066h,055h,055h,050h,028h ;C2A0
db 000h,000h,0A0h,015h,0A5h,066h,055h,06Ah,050h,028h,000h,000h,0A9h,055h,059h,066h ;C2B0
db 055h,095h,095h,028h,000h,000h,029h,055h,055h,066h,055h,055h,055h,028h,000h,000h ;C2C0
db 00Ah,055h,055h,066h,095h,055h,054h,0A0h,000h,000h,00Ah,025h,055h,055h,095h,055h ;C2D0
db 060h,0A0h,000h,000h,00Ah,025h,065h,065h,095h,055h,062h,0A8h,000h,000h,00Ah,009h ;C2E0
db 095h,05Ah,055h,0A5h,062h,0A0h,000h,000h,002h,089h,0A5h,055h,055h,059h,06Ah,080h ;C2F0
db 000h,000h,00Ah,089h,055h,055h,056h,099h,08Ah,080h,000h,000h,00Ah,089h,057h,0D5h ;C300
db 07Dh,055h,08Ah,080h,000h,000h,002h,0A9h,057h,0FFh,0F5h,055h,08Ah,000h,000h,000h ;C310
db 000h,0A2h,055h,0FFh,0D5h,055h,08Ah,080h,000h,000h,000h,0A2h,055h,055h,055h,056h ;C320
db 00Ah,080h,000h,000h,000h,0A0h,095h,055h,055h,058h,02Ah,080h,000h,000h,000h,0A0h ;C330
db 025h,055h,055h,058h,02Ah,000h,000h,000h,000h,0A0h,025h,06Ah,055h,060h,02Ah,000h ;C340
db 000h,000h,00Ah,0A0h,009h,095h,095h,080h,0A8h,000h,000h,000h,002h,0A0h,009h,055h ;C350
db 056h,000h,0A0h,000h,000h,000h,002h,080h,002h,055h,058h,002h,080h,000h,000h,000h ;C360
db 002h,080h,000h,0AAh,0A0h,002h,0A0h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;C370

dc380    db        0ah,1,'JOYSTICK CALIBRATION',0ffh  ; text
dc397    db        2,5,'Adjust joystick for neutral position',0ffh ; text
dc3be    db        8,6,'and press trigger button',0ffh  ; text

dc3d9    db        0                        ; horn¡ poloha joysticku
dc3da    db        0                        ; doln¡ poloha joysticku
dc3db    db        0                        ; prav  poloha joysticku
dc3dc    db        0                        ; lev  poloha joysticku
dc3dd    db        10                       ; citlivost joysticku kolem st©edu
         db        0
         db        0

.XLIST
dc3e0    label     byte                     ; obr zek tov rny pro sc‚ny 4-7

db 055h,055h,055h,055h,055h,055h,055h,075h,055h,0FDh,055h,055h,055h,055h,055h,055h ;C3E0
db 055h,055h,057h,0BDh,05Eh,0EFh,055h,055h,095h,055h,055h,055h,055h,055h,05Bh,0FBh ;C3F0
db 07Ah,0FEh,0F5h,055h,0F5h,055h,055h,055h,055h,055h,07Eh,0AEh,0AAh,0BFh,0AAh,055h ;C400
db 0AAh,055h,000h,000h,055h,055h,0AAh,0ABh,0AAh,0AAh,0EEh,0A5h,0AAh,0A0h,055h,055h ;C410
db 00Fh,0FEh,082h,0AAh,0AAh,0AAh,0BAh,0A9h,0AAh,086h,011h,055h,052h,0AFh,0C2h,0AAh ;C420
db 0AAh,0AAh,0AAh,0AAh,00Ah,019h,010h,055h,064h,0AAh,083h,0FFh,00Fh,0FFh,0EFh,0BEh ;C430
db 008h,066h,000h,005h,099h,028h,082h,0A0h,050h,0ABh,0EFh,0BEh,022h,0AAh,0AAh,0AAh ;C440
db 0AAh,088h,002h,085h,055h,02Eh,0BAh,0EBh                                         ;C450

dc458    label     byte                     ; obr zek tov rny pro sc‚ny 8-11

db 075h,055h,055h,0FDh,055h,055h,055h,055h                                         ;C458
db 055h,055h,055h,075h,055h,0FDh,055h,055h,055h,055h,055h,055h,055h,055h,0FBh,055h ;C460
db 05Fh,0AFh,055h,055h,055h,055h,055h,055h,057h,0BDh,05Eh,0EFh,055h,055h,055h,055h ;C470
db 055h,055h,055h,055h,0EBh,0D5h,0BEh,0EBh,095h,000h,000h,055h,055h,055h,05Bh,0FBh ;C480
db 07Ah,0FEh,0F5h,055h,055h,055h,055h,055h,055h,056h,0BEh,0B6h,0AAh,0AAh,0C0h,055h ;C490
db 055h,001h,055h,055h,07Eh,02Eh,0AAh,0BFh,0AAh,055h,055h,055h,055h,055h,055h,0AFh ;C4A0
db 0AEh,000h,0AAh,0A8h,015h,051h,055h,054h,03Fh,0FFh,0E8h,00Bh,0AAh,0AAh,00Eh,0A5h ;C4B0
db 055h,055h,055h,055h,056h,0AAh,0A8h,044h,02Ah,0A1h,099h,011h,057h,0F5h,045h,06Bh ;C4C0
db 0FCh,00Ah,0AAh,0A0h,050h,0A9h,055h,05Fh,0D7h,0F5h,0FEh,0AAh,0AAh,000h,0AAh,084h ;C4D0
db 064h,020h,05Dh,07Dh,012h,0AAh,0A8h,00Fh,0FFh,0C6h,065h,03Fh,0FFh,0FFh,0FFh,0FFh ;C4E0
db 0FEh,0AAh,0AAh,0AAh,0AAh,010h,008h,010h,080h,015h,024h,0A8h,0A8h,00Ah,0A8h,019h ;C4F0
db 09Dh,042h,0AAh,057h,05Ah,0EAh,0BAh,0AAh,0AAh,082h,0A8h,060h,060h,020h,000h,011h ;C500
db 009h,020h,088h,00Ah,0A1h,099h,099h,094h,0AAh,0AFh,0EBh,0FAh,0FEh,0AAh,0A0h,082h ;C510
db 022h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,080h,008h,00Ah,08Ah,0AAh,0AAh,0AAh,02Ah,0BAh ;C520
db 0BEh,0AFh,0ABh,0AAh                                                             ;C530

dc534    label     byte                     ; obr zek tov rny pro sc‚ny 12 a v¡ce

db 055h,055h,055h,055h,055h,055h,055h,055h,055h,000h,000h,055h                     ;C534
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;C540
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;C550
db 055h,055h,055h,055h,040h,055h,055h,001h,055h,055h,055h,055h,055h,055h,055h,055h ;C560
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;C570
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,050h,015h,055h,055h,054h ;C580
db 005h,055h,055h,055h,055h,055h,045h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;C590
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;C5A0
db 055h,055h,055h,005h,055h,055h,055h,055h,050h,07Fh,0FFh,0FFh,0FFh,0D5h,031h,055h ;C5B0
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h ;C5C0
db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,054h,055h,055h,055h,054h,055h ;C5D0
db 055h,015h,055h,055h,05Fh,0D4h,00Ch,055h,055h,055h,055h,055h,055h,055h,055h,055h ;C5E0
db 055h,055h,05Fh,0F5h,055h,057h,0FDh,055h,055h,0FDh,055h,055h,055h,055h,055h,055h ;C5F0
db 055h,055h,051h,055h,055h,055h,057h,0D5h,055h,045h,055h,055h,05Fh,0FCh,00Ch,055h ;C600
db 055h,055h,055h,050h,005h,055h,055h,055h,055h,055h,0FFh,0FFh,055h,07Fh,0FFh,0D5h ;C610
db 05Fh,0FFh,0D5h,055h,055h,055h,055h,055h,055h,055h,045h,055h,055h,055h,07Fh,0FDh ;C620
db 055h,0D1h,055h,055h,055h,054h,00Ch,055h,055h,055h,055h,005h,050h,055h,055h,055h ;C630
db 055h,055h,0FFh,0FFh,055h,07Fh,0FFh,0D5h,05Fh,0FFh,0D5h,055h,055h,055h,055h,055h ;C640
db 055h,055h,015h,051h,055h,054h,054h,03Dh,057h,064h,055h,055h,045h,054h,00Ch,0FFh ;C650
db 0FFh,0FFh,0F0h,067h,055h,00Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0D7h,0FFh,0FFh,0F5h,0FFh ;C660
db 0FFh,0F5h,0F5h,055h,055h,050h,000h,01Dh,055h,054h,055h,051h,055h,054h,024h,017h ;C670
db 042h,065h,015h,055h,045h,052h,0AAh,015h,05Bh,0FBh,005h,076h,07Dh,050h,055h,055h ;C680
db 055h,057h,0FFh,0DFh,0EFh,0FFh,0F7h,0FAh,07Fh,0F7h,0F5h,055h,055h,044h,044h,04Fh ;C690
db 055h,051h,055h,001h,055h,05Ch,01Ch,015h,0C1h,099h,045h,054h,045h,054h,00Ch,055h ;C6A0
db 07Eh,0A0h,056h,003h,0FFh,055h,005h,055h,055h,055h,0FFh,07Eh,0BEh,0FFh,0DFh,0FBh ;C6B0
db 0FFh,0DFh,0D5h,055h,055h,041h,011h,00Fh,0F5h,045h,005h,002h,076h,074h,024h,026h ;C6C0
db 042h,064h,012h,054h,045h,012h,0AAh,015h,0AAh,085h,066h,000h,04Fh,065h,051h,055h ;C6D0
db 055h,055h,0FFh,0FEh,0AAh,0BFh,0FFh,0EFh,0BFh,0FFh,0D5h,055h,055h,0A0h,000h,02Bh ;C6E0
db 0AEh,045h,045h,001h,098h,018h,018h,019h,081h,098h,012h,0A4h,045h,014h,00Ch,06Ah ;C6F0
db 0AAh,019h,099h,000h,089h,099h,054h,055h,055h,055h,0AFh,0EAh,0AAh,0ABh,0FBh,0AAh ;C700
db 0FAh,0FDh,055h,055h,056h,0AAh,08Ah,0AAh,0AAh,025h,045h,002h,062h,064h,064h,024h ;C710
db 000h,004h,024h,0A8h,045h,012h,0AAh,02Ah,0A8h,060h,066h,000h,040h,066h,055h,015h ;C720
db 055h,06Ah,0FFh,0FEh,0AAh,0BFh,0FFh,0AAh,0AFh,0FFh,0D5h,055h,06Ah,0AAh,002h,0AAh ;C730
db 0AAh,029h,000h,001h,000h,000h,018h,010h,019h,000h,018h,0A8h,084h,014h,00Ch,0AAh ;C740
db 0A1h,090h,099h,001h,000h,001h,099h,045h,05Ah,0ABh,0AAh,0ABh,0AAh,0EAh,0AAh,0EAh ;C750
db 0BAh,0AAh,0B5h,055h,08Ah,0AAh,022h,0A2h,0A8h,0A0h,000h,002h,042h,064h,024h,000h ;C760
db 006h,000h,004h,028h,088h,012h,0AAh,02Ah,086h,060h,026h,002h,000h,000h,000h,012h ;C770
db 0AAh,0AEh,0AAh,0AAh,0EBh,0AAh,0AAh,0BAh,0EAh,0AAh,0AEh,05Ah,088h,08Ah,002h,080h ;C780
db 028h,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,028h,008h,028h,00Ch,0AAh ;C790
db 08Ah,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0A2h,0AAh,0BAh,0AAh,0AAh,0BEh,0AAh,0AAh,0AFh ;C7A0
db 0AAh,0AAh,0ABh,0AAh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;C7B0
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ;C7C0
.LIST

DataEnd  label     byte                     ; konec datov‚ho segmentu

Data     ENDS

; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
;
;                              Z sobn¡k
;
; °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

Zasob    SEGMENT   PARA

         db        1000h dup(?)             ; z sobn¡k

Zasob    ENDS

         END       Start
