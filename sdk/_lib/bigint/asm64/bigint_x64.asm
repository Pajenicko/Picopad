bits 64
section .text

; Win64 calling convention:
;	input parameters: rcx, rdx, r8, r9, [rsp+28h], [rsp+30h], ...
;	output parameter: rax
;	stack contains: [rsp] (8) return, [rsp+8h] (20h) "shadow space" (can be used to access parameters RCX..R9)
;	need to preserve registers: rbx, rsi, rdi, r12, r13, r14, r15, rbp
;	may destroy registers: rax, rcx, rdx, r8, r9, r10, r11

; [rsp+0x28] = ... optional 5th parameter
; [rsp+0x20] = space for copy of R9 parameter (4th, R9 home)
; [rsp+0x18] = space for copy of R8 parameter (3rd, R8 home)
; [rsp+0x10] = space for copy of RDX parameter (2nd, RDX home)
; [rsp+8] = space for copy of RCX parameter (1st, RCX home)
; [rsp+0] = caller return address

; Caller need to push parameters to the stack (if needed)
; and then allocate free space in stack of size 20h bytes (sub rsp,20h).

; Function must align stack to 16 bytes boundary (= do 1 push)
; and preserve registers rbx, rsi, rdi, r12, r13, r14, r15, rbp

; =============================================================================
;                       Shift string 1 bit left
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=src start of string, r8=carry 0 or 1
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global ShiftL1Str_x64
ShiftL1Str_x64:

		; prepare input carry -> RAX
		mov		rax,r8				; RAX <- input carry 0 or 1

		; prepare big loop
		mov		r8,rcx				; save number of segments -> R8
		shr		rcx,2				; number of big loops -> RCX
		jz		ShiftL1_4			; no big loop

		; big loop
		rcr		rax,1				; get carry

		align	8					; optimize cache line

ShiftL1_2:							; 1 loop: 32 bytes, 256 bits
		mov		rax,qword [rdx]
		mov		r9,qword [rdx+8]
		rcl		rax,1
		mov		r10,qword [rdx+16]
		rcl		r9,1
		mov		r11,qword [rdx+24]
		rcl		r10,1
		mov		qword [rdx],rax
		rcl		r11,1
		mov		qword [rdx+8],r9
		mov		qword [rdx+16],r10
		mov		qword [rdx+24],r11
		dec		rcx
		lea		rdx,[rdx+32]
		jne		ShiftL1_2

		rcl		rax,1				; save carry

		; prepare small loop
ShiftL1_4:
		and		r8,3				; number of small loops
		jz		ShiftL1_8			; no small loop

		; small loop
		rcr		rax,1				; get carry

		mov		rax,qword [rdx]
		rcl		rax,1
		dec		r8					; loop counter
		mov		qword [rdx],rax
		jz		ShiftL1_6			; end

		mov		rax,qword [rdx+8]
		rcl		rax,1
		dec		r8					; loop counter
		mov		qword [rdx+8],rax
		jz		ShiftL1_6			; end

		mov		rax,qword [rdx+16]
		rcl		rax,1
		mov		qword [rdx+16],rax

ShiftL1_6:
		rcl		rax,1				; save carry

ShiftL1_8:
		and		rax,1
		ret

; =============================================================================
;                       Shift string 1 bit right
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=src after end of string, r8=carry 0 or 1
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global ShiftR1Str_x64
ShiftR1Str_x64:

		; prepare input carry -> RAX
		mov		rax,r8				; RAX <- input carry 0 or 1

		; prepare big loop
		mov		r8,rcx				; save number of segments -> R8
		shr		rcx,2				; number of big loops -> RCX
		jz		ShiftR1_4			; no big loop

		; big loop
		rcr		rax,1				; get carry

		align	8					; optimize cache line

ShiftR1_2:
		mov		rax,qword [rdx-8]
		mov		r9,qword [rdx-16]
		rcr		rax,1
		mov		r10,qword [rdx-24]
		rcr		r9,1
		mov		r11,qword [rdx-32]
		rcr		r10,1
		mov		qword [rdx-8],rax
		rcr		r11,1
		mov		qword [rdx-16],r9
		mov		qword [rdx-24],r10
		mov		qword [rdx-32],r11
		dec		rcx
		lea		rdx,[rdx-32]
		jnz		ShiftR1_2

		rcl		rax,1				; save carry

		; prepare small loop
ShiftR1_4:
		and		r8,3				; number of small loops
		jz		ShiftR1_8			; no small loop

		; small loop
		rcr		rax,1				; get carry

		mov		rax,qword [rdx-8]
		rcr		rax,1
		dec		r8					; loop counter
		mov		qword [rdx-8],rax
		jz		ShiftR1_6			; end

		mov		rax,qword [rdx-16]
		rcr		rax,1
		dec		r8					; loop counter
		mov		qword [rdx-16],rax
		jz		ShiftR1_6			; end

		mov		rax,qword [rdx-24]
		rcr		rax,1
		mov		qword [rdx-24],rax

ShiftR1_6:
		rcl		rax,1				; save carry

ShiftR1_8:
		and		rax,1
		ret

; =============================================================================
;                       Shift string more bits left
; =============================================================================
; inputs: rcx=number of segments, rdx=shifts, r8=after destination, r9=after source

; Local variables:
;  rax = temporary, segment sample
;  rbx = temporary, save segment sample
;  rcx = (n) number of segments, loop counter, number of shifts in one segment
;  rdx = (shiftn) number of shifts by whole segments
;  r8 = (d) after destination pointer
;  r9 = (s) after source pointer
;  r10 = (n) number of segments (copy of rcx)
;  r11 = (shiftb) number of shifts by remaining bits
;  rdi = loop counter

		align	16					; optimize cache line

global ShiftLStr_x64
ShiftLStr_x64:

		; split number of shifts
		mov		r10,rcx				; save number of segments 'n' -> R10
		mov		r11,rdx				; save number of shifts 'shift' -> R11
		shr		rdx,6				; number of shifts by whole segments 'shiftn' -> RDX
		and		r11,0x3f			; number of bits in one segment 'shiftb' -> R11
		jnz		ShiftL_8			; not whole segments

; ----- shift by whole segments

		; clear last segment
		sub		r8,8				; shift destination pointer 'd'
		mov		qword [r8],0		; clear last segment

		; prepare transfer big loop
		shr		rcx,3				; number of big loops 'n' -> RCX
		jz		ShiftL_2			; no big loop

		; transfer big loop
ShiftL_1:
%assign LOOPINX 8
%rep 8
		mov		rax,qword [r9-LOOPINX] ; load source
		mov		qword [r8-LOOPINX],rax ; save destination
%assign LOOPINX LOOPINX+8
%endrep
		lea		r9,[r9-8*8]			; shift source pointer
		dec		rcx
		lea		r8,[r8-8*8]			; shift destination pointer
		jnz		ShiftL_1			; loop next step

		; prepare transfer small loop
ShiftL_2:
		and		r10,7				; number of small loops 'n'
		jz		ShiftL_4			; no small loop

		; transfer small loop
		mov		rcx,r10				; loop counter -> RCX
ShiftL_3:
		lea		r9,[r9-8]			; shift source pointer
		lea		r8,[r8-8]			; shift destination pointer
		mov		rax,qword [r9]		; load source
		dec		rcx
		mov		qword [r8],rax		; save destination
		jnz		ShiftL_3			; loop next step

ShiftL_4:
		; prepare clear big loop
		xor		rax,rax				; clear word 0 -> RAX
		mov		rcx,rdx				; get number of shifts of whole segments 'shiftn' -> RCX
		shr		rcx,3				; number of big loops -> RCX
		jz		ShiftL_6			; no big loop

		; clear big loop
ShiftL_5:
%assign LOOPINX 8
%rep 8
		mov		qword [r8-LOOPINX],rax ; save destination
%assign LOOPINX LOOPINX+8
%endrep
		dec		rcx
		lea		r8,[r8-8*8]			; shift destination pointer
		jne		ShiftL_5			; loop next step

		; prepare clear small loop
ShiftL_6:
		and		rdx,7				; number of small loops 'shiftn'
		jz		ShiftL_7			; no small loop

		; clear small loop
%assign LOOPINX 8
%rep 6
		dec		rdx					; loop counter
		mov		qword [r8-LOOPINX],rax ; save destination
		jz		ShiftL_7			; end
%assign LOOPINX LOOPINX+8
%endrep
		mov		qword [r8-LOOPINX],rax ; save destination
ShiftL_7:
		ret

; ----- shift by bits

ShiftL_8:
		; push registers
		push	rdi					; push RDI
		push	rbx					; push RBX
		push	rdx					; push RDX

		; store first segment
		lea		r9,[r9-8]			; shift source pointer 's'
		lea		r8,[r8-8]			; shift destination pointer 'd'
		mov		rax,qword [r9]		; load source
		mov		rdx,rax				; save entry
		mov		rcx,64				; number of base bits
		sub		rcx,r11				; number of remaining shifts
		shr		rax,cl				; shift segment right
		mov		qword [r8],rax		; save destination

		; check number of segments to shift
		mov		rcx,r11				; number of shifts 'shiftb' -> RCX
		or		r10,r10				; check number of segments 'n'
		jz		ShiftL_12			; no segment to shift
		dec		r10					; number of segments - 1
		jz		ShiftL_12			; no segment to shift

		; prepare big loop
		mov		rdi,r10				; number of segments 'n'
		shr		rdi,3				; number of big loops -> RDI
		jz		ShiftL_10			; no big loop

		; transfer big loop
ShiftL_9:
%assign LOOPINX 8
%rep 8
		mov		rax,qword [r9-LOOPINX] ; load segment
		mov		rbx,rax				; save segment
		shld	rdx,rax,cl			; shift
		mov		qword [r8-LOOPINX],rdx ; save shifted segment
		mov		rdx,rbx				; new high segment
%assign LOOPINX LOOPINX+8
%endrep
		lea		r9,[r9-8*8]			; shift source pointer 's'
		dec		rdi					; loop counter
		lea		r8,[r8-8*8]			; shift destination pointer 'd'
		jnz		ShiftL_9			; next loop step

		; prepare small loop
ShiftL_10:
		and		r10,7				; number of small loops 'n'
		jz		ShiftL_12			; no small loop

		; transfer small loop
ShiftL_11:
		lea		r9,[r9-8]			; shift source pointer 's'
		lea		r8,[r8-8]			; shift destination pointer 'd'
		mov		rax,qword [r9]		; load segment
		mov		rbx,rax				; save segment
		shld	rdx,rax,cl			; shift
		mov		qword [r8],rdx		; save shifted segment
		dec		r10					; loop counter
		mov		rdx,rbx				; new high segment
		jnz		ShiftL_11			; loop next step

		; store last segment
ShiftL_12:
		lea		r8,[r8-8]			; shift destination pointer
		shl		rdx,cl				; shift
		mov		qword [r8],rdx		; save shifted segment

		; pop registers
		pop		rdx					; pop RDX
		pop		rbx					; pop RBX
		pop		rdi					; pop RDI

		; jump to clear remaining segment
		jmp		ShiftL_4

; =============================================================================
;                            Add strings
; =============================================================================
; inputs: rcx=num1, rdx=num2, r8=dst, r9=src1, [rsp+28h]=src2
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global AddStr_x64
AddStr_x64:

		; save registers
		mov		qword [rsp+8],rcx		; save num1
		mov		qword [rsp+16],rdx		; save num2

; === add common parts, dst = src1 + src2

		; prepare size of common part
		cmp		rcx,rdx					; compare num1 width num2?
		cmovg	rcx,rdx					; num1 <- num2 if num1 > num2
		mov		rdx,rcx					; copy -> num2

		; prepare big loop
		mov		r10,qword [rsp+0x28]	; src2 -> R10
		xor		rax,rax					; clear carry
		shr		rcx,3					; number of big loops
		jz		AddStr_2				; no big loop

		; big loop
		rcr		rax,1					; get carry
AddStr_1:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r9+LOOPINX]	; get src1
		adc		rax,qword [r10+LOOPINX]	; add src2
		mov		qword [r8+LOOPINX],rax	; store result
%assign LOOPINX LOOPINX+8
%endrep
		lea		r8,[r8+8*8]				; shift dst
		lea		r9,[r9+8*8]				; shift src1
		dec		rcx
		lea		r10,[r10+8*8]			; shift src2
		jnz		AddStr_1				; loop next step
		rcl		rax,1					; save carry

AddStr_2:
		; prepare small loop
		and		rdx,7					; number of small loops
		jz		AddStr_4				; no small loop
		mov		rcx,rdx					; number of small loops -> RCX

		; small loop
		rcr		rax,1					; get carry
AddStr_3:
		mov		rax,qword [r9]			; get src1
		adc		rax,qword [r10]			; add src2
		mov		qword [r8],rax			; store result
		lea		r8,[r8+8]				; shift dst
		lea		r9,[r9+8]				; shift src1
		dec		rcx
		lea		r10,[r10+8]				; shift src2
		jnz		AddStr_3				; loop next step
		rcl		rax,1					; save carry

; === add rest of num1, dst = src1 + 0

AddStr_4:
		; difference num1 - num2
		mov		rcx,qword [rsp+8]		; get num1
		sub		rcx,qword [rsp+16]		; difference num1 - num2
		jle		AddStr_8				; skip if num1 <= num2
		mov		rdx,rcx					; save number of segments

		; preapre big loop
		shr		rcx,3					; number of big loops
		jz		AddStr_6				; no big loop

		; big loop
		rcr		rax,1					; get carry
AddStr_5:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r9+LOOPINX]	; get src1
		adc		rax,0					; add src2 = 0
		mov		qword [r8+LOOPINX],rax	; store result
%assign LOOPINX LOOPINX+8
%endrep
		lea		r8,[r8+8*8]				; shift dst
		dec		rcx
		lea		r9,[r9+8*8]				; shift src1
		jnz		AddStr_5				; loop next step
		rcl		rax,1					; save carry

AddStr_6:
		; prepare small loop
		and		rdx,7					; number of small loops
		jz		AddStr_8				; no small loop

		; small loop
		rcr		rax,1					; get carry
%assign LOOPINX 0
%rep 6
		mov		rax,qword [r9+LOOPINX]	; get src1
		adc		rax,0					; add src2 = 0
		mov		qword [r8+LOOPINX],rax	; store result
		dec		rdx						; loop counter
		jz		AddStr_7				; end of loop
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,qword [r9+LOOPINX]	; get src1
		adc		rax,0					; add src2 = 0
		mov		qword [r8+LOOPINX],rax	; store result
AddStr_7:
		rcl		rax,1					; save carry

; === add rest of num2, dst = 0 + src2

AddStr_8:
		; difference num2 - num1
		mov		rcx,qword [rsp+16]		; get num2
		sub		rcx,qword [rsp+8]		; difference num2 - num1
		jle		AddStr_12				; skip if num2 <= num1
		mov		rdx,rcx					; save number of segments

		; preapre big loop
		shr		rcx,3					; number of big loops
		jz		AddStr_10				; no big loop

		; big loop
		rcr		rax,1					; get carry
AddStr_9:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r10+LOOPINX]	; get src2
		adc		rax,0					; add src1 = 0
		mov		qword [r8+LOOPINX],rax	; store result
%assign LOOPINX LOOPINX+8
%endrep
		lea		r8,[r8+8*8]				; shift dst
		dec		rcx
		lea		r10,[r10+8*8]			; shift src2
		jnz		AddStr_9				; loop next step
		rcl		rax,1					; save carry

AddStr_10:
		; prepare small loop
		and		rdx,7					; number of small loops
		jz		AddStr_12				; no small loop

		; small loop
		rcr		rax,1					; get carry
%assign LOOPINX 0
%rep 6
		mov		rax,qword [r10+LOOPINX]	; get src2
		adc		rax,0					; add src1 = 0
		dec		rdx						; loop counter
		mov		qword [r8+LOOPINX],rax	; store result
		jz		AddStr_11				; end of loop
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,qword [r10+LOOPINX]	; get src2
		adc		rax,0					; add src1 = 0
		mov		qword [r8+LOOPINX],rax	; store result
AddStr_11:
		rcl		rax,1					; save carry

AddStr_12:
		and		rax,1					; carry
		ret

; =============================================================================
;                            Sub strings
; =============================================================================
; inputs: rcx=num1, rdx=num2, r8=dst, r9=src1, [rsp+28h]=src2
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global SubStr_x64
SubStr_x64:

		; save registers
		mov		qword [rsp+8],rcx		; save num1
		mov		qword [rsp+16],rdx		; save num2

; === sub common parts, dst = src1 - src2

		; prepare size of common part
		cmp		rcx,rdx					; compare num1 width num2?
		cmovg	rcx,rdx					; num1 <- num2 if num1 > num2
		mov		rdx,rcx					; copy -> num2

		; prepare big loop
		mov		r10,qword [rsp+0x28]	; src2 -> R10
		xor		rax,rax					; clear carry
		shr		rcx,3					; number of big loops
		jz		SubStr_2				; no big loop

		; big loop
		rcr		rax,1					; get carry
SubStr_1:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r9+LOOPINX]	; get src1
		sbb		rax,qword [r10+LOOPINX]	; sub src2
		mov		qword [r8+LOOPINX],rax	; store result
%assign LOOPINX LOOPINX+8
%endrep
		lea		r8,[r8+8*8]				; shift dst
		lea		r9,[r9+8*8]				; shift src1
		dec		rcx
		lea		r10,[r10+8*8]			; shift src2
		jnz		SubStr_1				; loop next step
		rcl		rax,1					; save carry

SubStr_2:
		; prepare small loop
		and		rdx,7					; number of small loops
		jz		SubStr_4				; no small loop
		mov		rcx,rdx					; number of small loops -> RCX

		; small loop
		rcr		rax,1					; get carry
SubStr_3:
		mov		rax,qword [r9]			; get src1
		sbb		rax,qword [r10]			; sub src2
		mov		qword [r8],rax			; store result
		lea		r8,[r8+8]				; shift dst
		lea		r9,[r9+8]				; shift src1
		dec		rcx
		lea		r10,[r10+8]				; shift src2
		jnz		SubStr_3				; loop next step
		rcl		rax,1					; save carry

; === sub rest of num1, dst = src1 - 0

SubStr_4:
		; difference num1 - num2
		mov		rcx,qword [rsp+8]		; get num1
		sub		rcx,qword [rsp+16]		; difference num1 - num2
		jle		SubStr_8				; skip if num1 <= num2
		mov		rdx,rcx					; save number of segments

		; preapre big loop
		shr		rcx,3					; number of big loops
		jz		SubStr_6				; no big loop

		; big loop
		rcr		rax,1					; get carry
SubStr_5:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r9+LOOPINX]	; get src1
		sbb		rax,0					; sub src2 = 0
		mov		qword [r8+LOOPINX],rax	; store result
%assign LOOPINX LOOPINX+8
%endrep
		lea		r8,[r8+8*8]				; shift dst
		dec		rcx
		lea		r9,[r9+8*8]				; shift src1
		jnz		SubStr_5				; loop next step
		rcl		rax,1					; save carry

SubStr_6:
		; prepare small loop
		and		rdx,7					; number of small loops
		jz		SubStr_8				; no small loop

		; small loop
		rcr		rax,1					; get carry
%assign LOOPINX 0
%rep 6
		mov		rax,qword [r9+LOOPINX]	; get src1
		sbb		rax,0					; sub src2 = 0
		dec		rdx						; loop counter
		mov		qword [r8+LOOPINX],rax	; store result
		jz		SubStr_7				; end of loop
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,qword [r9+LOOPINX]	; get src1
		sbb		rax,0					; sub src2 = 0
		mov		qword [r8+LOOPINX],rax	; store result
SubStr_7:
		rcl		rax,1					; save carry

; === sub rest of num2, dst = 0 - src2

SubStr_8:
		; difference num2 - num1
		mov		rcx,qword [rsp+16]		; get num2
		sub		rcx,qword [rsp+8]		; difference num2 - num1
		jle		SubStr_12				; skip if num2 <= num1
		mov		rdx,rcx					; save number of segments

		; preapre big loop
		shr		rcx,3					; number of big loops
		jz		SubStr_10				; no big loop

		; big loop
		rcr		rax,1					; get carry
SubStr_9:
%assign LOOPINX 0
%rep 8
		mov		rax,0					; get src1 = 0
		sbb		rax,qword [r10+LOOPINX]	; sub src2
		mov		qword [r8+LOOPINX],rax	; store result
%assign LOOPINX LOOPINX+8
%endrep
		lea		r8,[r8+8*8]				; shift dst
		dec		rcx
		lea		r10,[r10+8*8]			; shift src2
		jnz		SubStr_9				; loop next step
		rcl		rax,1					; save carry

SubStr_10:
		; prepare small loop
		and		rdx,7					; number of small loops
		jz		SubStr_12				; no small loop

		; small loop
		rcr		rax,1					; get carry
%assign LOOPINX 0
%rep 6
		mov		rax,0					; get src1 = 0
		sbb		rax,qword [r10+LOOPINX]	; sub src2
		dec		rdx						; loop counter
		mov		qword [r8+LOOPINX],rax	; store result
		jz		SubStr_11				; end of loop
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,0					; get src1 = 0
		sbb		rax,qword [r10+LOOPINX]	; sub src2
		mov		qword [r8+LOOPINX],rax	; store result
SubStr_11:
		rcl		rax,1					; save carry

SubStr_12:
		and		rax,1					; mask carry
		ret

; =============================================================================
;                         Negate string
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=src start of string
; output: rax=carry 1 if result is not 0

		align	16					; optimize cache line

global NegStr_x64
NegStr_x64:

		; clear input carry -> RAX
		xor		rax,rax				; RAX <- 0 input carry
		xor		r9,r9				; R9 <- 0, source of 0

		; prepare big loop
		mov		r8,rcx				; save number of segments -> R8
		shr		rcx,3				; number of big loops -> RCX
		jz		NegStr_4			; no big loop

		; big loop
		rcr		rax,1				; get carry

NegStr_2:
%assign LOOPINX 0
%rep 8
		mov		rax,r9				; RAX <- 0
		sbb		rax,qword [rdx+LOOPINX] ; negate, rax = 0 - src
		mov		qword [rdx+LOOPINX],rax ; store segment
%assign LOOPINX LOOPINX+8
%endrep
		dec		rcx
		lea		rdx,[rdx+8*8]		; shift pointer
		jnz		NegStr_2			; loop next step
		rcl		rax,1				; save carry

		; prepare small loop
NegStr_4:
		and		r8,7				; number of small loops
		jz		NegStr_8			; no small loop

		; small loop
		rcr		rax,1				; get carry
%assign LOOPINX 0
%rep 6
		mov		rax,r9				; RAX <- 0
		sbb		rax,qword [rdx+LOOPINX] ; negate, rax = 0 - src
		dec		r8					; loop counter
		mov		qword [rdx+LOOPINX],rax ; store segment
		jz		NegStr_6			; end
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,r9				; RAX <- 0
		sbb		rax,qword [rdx+LOOPINX] ; negate, rax = 0 - src
		mov		qword [rdx+LOOPINX],rax ; store segment
NegStr_6:
		rcl		rax,1				; save carry

NegStr_8:
		and		rax,1				; mask carry
		ret

; =============================================================================
;                         Multiply and set string
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=multiply, r8=dst, r9=src

global MulSetStr_x64
MulSetStr_x64:
		; prepare registers
		xor		r10,r10					; R10 <- 0, carry
		mov		r11,rdx					; R11 <- multiply

		; prepare big loop
		mov		qword [rsp+8],rcx		; save number of segments
		shr		rcx,3					; number of big loops -> RCX
		jz		MulSetStr_4				; no big loop

		; big loop
MulSetStr_2:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r9+LOOPINX]	; RAX <- [src]
		mul		r11						; RDX:RAX <- [src] * num
		add		rax,r10					; add carry
		adc		rdx,0					; carry		
		mov		qword [r8+LOOPINX],rax	; save result
		mov		r10,rdx					; R10 <- new carry
%assign LOOPINX LOOPINX+8
%endrep
		add		r8,8*8					; shift dst
		add		r9,8*8					; shift src
		dec		rcx						; loop counter
		jnz		MulSetStr_2				; loop next step

		; prepare small loop
MulSetStr_4:
		mov		rcx,qword [rsp+8]		; RCX <- len
		and		rcx,7					; number of small loops
		jz		MulSetStr_8				; no small loop

		; small loop
MulSetStr_6:
		mov		rax,qword [r9]			; RAX <- [src]
		mul		r11						; RDX:RAX <- [src] * num
		add		rax,r10					; add carry
		adc		rdx,0					; carry		
		mov		qword [r8],rax			; save result
		mov		r10,rdx					; R10 <- new carry
		add		r8,8					; shift dst
		add		r9,8					; shift src
		dec		rcx
		jnz		MulSetStr_6				; loop next step

		; store last segment
MulSetStr_8:
		mov		qword [r8],r10			; save carry
		ret

; =============================================================================
;                         Multiply and add string
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=multiply, r8=dst, r9=src

global MulAddStr_x64
MulAddStr_x64:
		; prepare registers
		xor		r10,r10					; R10 <- 0, carry
		mov		r11,rdx					; R11 <- multiply

		; prepare big loop
		mov		qword [rsp+8],rcx		; save number of segments
		shr		rcx,3					; number of big loops -> RCX
		jz		MulAddStr_4				; no big loop

		; big loop
MulAddStr_2:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r9+LOOPINX]	; RAX <- [src]
		mul		r11						; RDX:RAX <- [src] * num
		add		rax,r10					; add carry
		adc		rdx,0					; carry		
		add		qword [r8+LOOPINX],rax	; add [dst]
		adc		rdx,0					; carry		
		mov		r10,rdx					; R10 <- new carry
%assign LOOPINX LOOPINX+8
%endrep
		add		r8,8*8					; shift dst
		add		r9,8*8					; shift src
		dec		rcx						; loop counter
		jnz		MulAddStr_2				; loop next step

		; prepare small loop
MulAddStr_4:
		mov		rcx,qword [rsp+8]		; RCX <- len
		and		rcx,7					; number of small loops
		jz		MulAddStr_8				; no small loop

		; small loop
MulAddStr_6:
		mov		rax,qword [r9]			; RAX <- [src]
		mul		r11						; RDX:RAX <- [src] * num
		add		rax,r10					; add carry
		adc		rdx,0					; carry		
		add		qword [r8],rax			; add [dst]
		adc		rdx,0					; carry		
		mov		r10,rdx					; R10 <- new carry
		add		r8,8					; shift dst
		add		r9,8					; shift src
		dec		rcx
		jnz		MulAddStr_6				; loop next step

		; store last segment
MulAddStr_8:
		mov		qword [r8],r10			; save carry
		ret

; =============================================================================
;                           Divide string
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=div divisor, r8=dst, r9=src (dst/src = after end of string)
; returns RAX = remainder (carry)

global DivStr_x64
DivStr_x64:
		; prepare registers
		mov		r11,rdx					; R11 <- divisor
		xor		rdx,rdx					; RDX <- 0, carry

		; prepare big loop
		mov		r10,rcx					; save number of segments
		shr		rcx,3					; number of big loops -> RCX
		jz		DivStr_4				; no big loop

		; big loop
DivStr_2:
%assign LOOPINX 8
%rep 8
		mov		rax,qword [r9-LOOPINX]	; RAX <- [src]
		div		r11						; RAX quotient, RDX remainder <- RDX:[src] / div
		mov		[r8-LOOPINX],rax		; save result
%assign LOOPINX LOOPINX+8
%endrep
		sub		r8,8*8					; shift dst
		sub		r9,8*8					; shift src
		dec		rcx
		jnz		DivStr_2				; loop next step

		; prepare small loop
DivStr_4:
		and		r10,7					; number of small loops
		jz		DivStr_8				; no small loop

		; small loop
%assign LOOPINX 8
%rep 6
		mov		rax,qword [r9-LOOPINX]	; RAX <- [src]
		div		r11						; RAX quotient, RDX remainder <- RDX:[src] / num
		dec		r10						; loop counter
		mov		[r8-LOOPINX],rax		; save result
		jz		DivStr_8				; end
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,qword [r9-LOOPINX]	; RAX <- [src]
		div		r11						; RAX quotient, RDX remainder <- RDX:[src] / num
		mov		[r8-LOOPINX],rax		; save result
DivStr_8:
		mov		rax,rdx					; RAX <- remainder
		ret

; =============================================================================
;                            Divide Sub strings
; =============================================================================
; inputs: rcx=num, rdx=dst, r8=src

global DivSubStr_x64
DivSubStr_x64:

		; prepare big loop
		xor		rax,rax					; clear carry
		mov		r9,rcx					; num -> R9
		shr		rcx,3					; number of big loops
		jz		DivSubStr_2				; no big loop

		; big loop
		rcr		rax,1					; get carry
DivSubStr_1:
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r8+LOOPINX]	; get src
		sbb		qword [rdx+LOOPINX],rax	; subtract from dst
%assign LOOPINX LOOPINX+8
%endrep
		lea		r8,[r8+8*8]				; shift src1
		dec		rcx
		lea		rdx,[rdx+8*8]			; shift dst
		jnz		DivSubStr_1				; loop next step
		rcl		rax,1					; save carry

DivSubStr_2:
		; prepare small loop
		and		r9,7					; number of small loops
		jz		DivSubStr_4				; no small loop

		; small loop
		rcr		rax,1					; get carry
%assign LOOPINX 0
%rep 8
		mov		rax,qword [r8+LOOPINX]	; get src
		sbb		qword [rdx+LOOPINX],rax	; subtract from dst
		dec		r9						; loop counter
		jz		DivSubStr_4				; end of loop
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,qword [r8+LOOPINX]	; get src
		sbb		qword [rdx+LOOPINX],rax	; subtract from dst
DivSubStr_4:
		ret

; =============================================================================
;                           Modulo string
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=div divisor, r8=src (after end of string)
; returns RAX = remainder (carry)

global ModStr_x64
ModStr_x64:
		; prepare registers
		mov		r11,rdx					; R11 <- divisor
		xor		rdx,rdx					; RDX <- 0, carry

		; prepare big loop
		mov		r10,rcx					; save number of segments
		shr		rcx,3					; number of big loops -> RCX
		jz		ModStr_4				; no big loop

		; big loop
ModStr_2:
%assign LOOPINX 8
%rep 8
		mov		rax,qword [r8-LOOPINX]	; RAX <- [src]
		div		r11						; RAX quotient, RDX remainder <- RDX:[src] / div
%assign LOOPINX LOOPINX+8
%endrep
		sub		r8,8*8					; shift src
		dec		rcx
		jnz		ModStr_2				; loop next step

		; prepare small loop
ModStr_4:
		and		r10,7					; number of small loops
		jz		ModStr_8				; no small loop

		; small loop
%assign LOOPINX 8
%rep 6
		mov		rax,qword [r8-LOOPINX]	; RAX <- [src]
		div		r11						; RAX quotient, RDX remainder <- RDX:[src] / num
		dec		r10						; loop counter
		jz		ModStr_8				; end
%assign LOOPINX LOOPINX+8
%endrep
		mov		rax,qword [r8-LOOPINX]	; RAX <- [src]
		div		r11						; RAX quotient, RDX remainder <- RDX:[src] / num
ModStr_8:
		mov		rax,rdx					; RAX <- remainder
		ret
