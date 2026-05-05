; Mandelbrot generator, EGA 320x200/16

code     segment
         assume    cs:code,ds:code
         org       100h

start:
         mov       ax,13
         int       10h

         mov       ax,0a000h
         mov       es,ax
         xor       di,di

         mov       dx,3ceh
         mov       al,1
         out       dx,al                    ; volba registru 1
         inc       dx
         mov       al,0fh
         out       dx,al                    ; v¨echny roviny podle registru 0

Mand1:   mov       word ptr ds:[X],-606     ; po‡ tek X
         mov       word ptr ds:[MaxX],320   ; po‡et bod– k zobrazen¡

; ------ generov n¡ jedn‚ linky

Mand2:   mov       bx,ds:[X]                ; adresa X
         mov       cx,ds:[Y]                ; adresa Y
         mov       byte ptr ds:[Barva],16   ; v˜choz¡ barva (b¡l )

; ------ X^2

Mand3:   mov       ax,bx                    ; adresa X
         imul      ax                       ; X^2
         mov       al,ah                    ;
         mov       ah,dl                    ; X / 256
         mov       bp,ax                    ; X^2/256

; ------ Y^2

         mov       ax,cx                    ; adresa Y
         imul      cx                       ; Y^2
         mov       al,ah
         mov       ah,dl                    ; Y / 256
         mov       si,ax                    ; Y^2/256

; ------ X^2 + Y^2

         add       ax,bp                    ; AX <- (X^2 + Y^2) / 256
         sub       ax,800h                  ; je > 800h ?
         jnc       Mand5                    ; je > 800h - zobrazen¡


         mov       ax,si                    ; Y^2 / 256
         sub       bp,ax                    ; X^2 - Y^2
         add       bp,ds:[X]                ; X^2 - Y^2 + X
         xchg      bp,bx                    ; BP <- X, BX <- X^2-Y^2+X
         mov       ax,cx                    ; AX <- Y
         imul      bp                       ; AX <- X*Y

         mov       cl,ah                    ;
         mov       ch,dl                    ; CX <- X*Y/256

         test      dh,80h                   ; je kladn‚ ‡¡slo ?
         jz        Mand4                    ; je kladn‚ ‡¡slo

         cmp       al,1
         cmc
         adc       cx,0                     ;

Mand4:   add       cx,cx                    ; X*Y/256 * 2
         add       cx,ds:[Y]                ; X*Y/256 * 2 + Y

         dec       byte ptr ds:[Barva]      ; sn¡‘en¡ ‡¡ta‡e barev
         jnz       Mand3                    ; v¨echny barvy

; ------ zobrazen¡ bodu

Mand5:
         mov       dx,3ceh
         mov       al,0
         out       dx,al                    ; volba registru 0
         inc       dx
         mov       al,ds:[Barva]
         out       dx,al                    ; volba barvy bodu

         dec       dx
         mov       al,8
         out       dx,al                    ; volba registru 8
         inc       dx

         mov       cl,byte ptr ds:[MaxX]    ; rotace k zobrazen¡ bodu
         dec       cl
         and       cl,7
         mov       al,1
         shl       al,cl
         out       dx,al                    ; bitov  maska pro z pis
         xchg      al,es:[di]               ; zobrazen¡ bodu
         or        cl,cl
         jnz       Mand8
         inc       di
Mand8:

; ------ dal¨¡ bod na lince

         add       word ptr ds:[X],3        ; zv˜¨en¡ adresy X
         dec       word ptr ds:[MaxX]       ; ‡¡ta‡ bod– k zobrazen¡
         jz        Mand7
         jmp       Mand2                    ; dal¨¡ bod na lince

; ------ test p©eru¨en¡ programu

Mand7:   mov       ah,1
         int       16h
         jnz       Mand6

; ------ dal¨¡ linka

         sub       word ptr ds:[Y],4        ; zv˜¨en¡ adresy Y
         dec       byte ptr ds:[MaxY]       ; nov  linka
         jz        Mand6
         jmp       Mand1                    ; dal¨¡ linka

; ------ konec programu

Mand6:   xor       ax,ax                    ; AX <- 0
         int       16h                      ; ‡ek n¡ na stisk kl vesy
         mov       ax,2                     ; videom¢d 2
         int       10h                      ; inicializace videom¢du 2
         int       20h                      ; n vrat z programu

X        dw        ?                        ; sou©adnice X
Y        dw        400                      ; sou©adnice Y

MaxX     dw        320                      ; po‡et bod– k zobrazen¡
MaxY     db        200                      ; po‡et linek k zobrazen¡
Barva    db        ?                        ; barva bodu

code     ends
         end       start
