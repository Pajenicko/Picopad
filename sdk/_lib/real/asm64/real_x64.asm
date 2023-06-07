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

; Do not use 'loop' nor 'rcl [mem]' instructions - they decrease performance (cannot be interlaced)

; =============================================================================
;      Shift string 1 bit left, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=src start of string, r8=carry 0 or 1
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global ShiftL1Big_x64
ShiftL1Big_x64:

		; loop
		rcr		r8,1				; get carry

		align	8					; optimize cache line

ShiftL1Big_2:						; 1 loop: 32 bytes, 256 bits
		mov		rax,qword [rdx]
		mov		r8,qword [rdx+8]
		rcl		rax,1
		mov		r9,qword [rdx+16]
		rcl		r8,1
		mov		r10,qword [rdx+24]
		rcl		r9,1
		mov		qword [rdx],rax
		rcl		r10,1
		mov		qword [rdx+8],r8
		mov		qword [rdx+16],r9
		mov		qword [rdx+24],r10
		dec		rcx
		lea		rdx,[rdx+32]
		jne		ShiftL1Big_2

		rcl		rax,1				; save carry
		and		rax,1
		ret

; =============================================================================
;      Shift string 1 bit right, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=src after end of string, r8=carry 0 or 1
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global ShiftR1Big_x64
ShiftR1Big_x64:

		; loop
		rcr		r8,1				; get carry

		align	8					; optimize cache line

ShiftR1Big_2:						; 1 loop: 32 bytes, 256 bits
		mov		rax,qword [rdx-8]
		mov		r8,qword [rdx-16]
		rcr		rax,1
		mov		r9,qword [rdx-24]
		rcr		r8,1
		mov		r10,qword [rdx-32]
		rcr		r9,1
		mov		qword [rdx-8],rax
		rcr		r10,1
		mov		qword [rdx-16],r8
		mov		qword [rdx-24],r9
		mov		qword [rdx-32],r10
		dec		rcx
		lea		rdx,[rdx-32]
		jne		ShiftR1Big_2

		rcl		rax,1				; save carry
		and		rax,1
		ret

; =============================================================================
;           Add string, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=dst start of destination, r8=src start of source, r9=carry 0 or 1
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global AddBig_x64
AddBig_x64:

		; loop
		rcr		r9,1				; get carry

AddBig_2:							; 1 loop: 32 bytes, 256 bits
		mov		rax,qword [rdx]
		mov		r9,qword [rdx+8]
		adc		rax,qword [r8]
		mov		r10,qword [rdx+16]
		adc		r9,qword [r8+8]
		mov		r11,qword [rdx+24]
		adc		r10,qword [r8+16]
		mov		qword [rdx],rax
		adc		r11,qword [r8+24]
		mov		qword [rdx+8],r9
		lea		r8,[r8+32]
		mov		qword [rdx+16],r10
		dec		rcx
		mov		qword [rdx+24],r11
		lea		rdx,[rdx+32]
		jne		AddBig_2

		rcl		rax,1				; save carry
		and		rax,1
		ret

; =============================================================================
;           Sub string, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=dst start of destination, r8=src start of source, r9=carry 0 or 1
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global SubBig_x64
SubBig_x64:

		; loop
		rcr		r9,1				; get carry

SubBig_2:							; 1 loop: 32 bytes, 256 bits
		mov		rax,qword [rdx]
		mov		r9,qword [rdx+8]
		sbb		rax,qword [r8]
		mov		r10,qword [rdx+16]
		sbb		r9,qword [r8+8]
		mov		r11,qword [rdx+24]
		sbb		r10,qword [r8+16]
		mov		qword [rdx],rax
		sbb		r11,qword [r8+24]
		mov		qword [rdx+8],r9
		lea		r8,[r8+32]
		mov		qword [rdx+16],r10
		dec		rcx
		mov		qword [rdx+24],r11
		lea		rdx,[rdx+32]
		jne		SubBig_2

		rcl		rax,1				; save carry
		and		rax,1
		ret

; =============================================================================
;        Inverted Sub string, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=dst start of destination, r8=src start of source, r9=carry 0 or 1
; output: rax=carry 1 or 0

		align	16					; optimize cache line

global InvSubBig_x64
InvSubBig_x64:

		; loop
		rcr		r9,1				; get carry

InvSubBig_2:							; 1 loop: 32 bytes, 256 bits
		mov		rax,qword [r8]
		mov		r9,qword [r8+8]
		sbb		rax,qword [rdx]
		mov		r10,qword [r8+16]
		sbb		r9,qword [rdx+8]
		mov		r11,qword [r8+24]
		sbb		r10,qword [rdx+16]
		mov		qword [rdx],rax
		sbb		r11,qword [rdx+24]
		mov		qword [rdx+8],r9
		lea		r8,[r8+32]
		mov		qword [rdx+16],r10
		dec		rcx
		mov		qword [rdx+24],r11
		lea		rdx,[rdx+32]
		jne		InvSubBig_2

		rcl		rax,1				; save carry
		and		rax,1
		ret

; =============================================================================
;           Negate string, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=src start of string
; output: rax=carry 1 (if result is 0) or 0

		align	16					; optimize cache line

global NegBig_x64
NegBig_x64:

		; loop
		xor		r8,r8				; temporary 0, clear carry

NegBig_2:							; 1 loop: 32 bytes, 256 bits
		mov		rax,r8
		mov		r9,r8
		sbb		rax,qword [rdx]
		mov		r10,r8
		sbb		r9,qword [rdx+8]
		mov		r11,r8
		sbb		r10,qword [rdx+16]
		mov		qword [rdx],rax
		sbb		r11,qword [rdx+24]
		mov		qword [rdx+8],r9
		mov		qword [rdx+16],r10
		dec		rcx
		mov		qword [rdx+24],r11
		lea		rdx,[rdx+32]
		jne		NegBig_2

		cmc							; complement carry
		rcl		rax,1				; save carry
		and		rax,1
		ret

; =============================================================================
;             Copy, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=dst start of destination, r8=src start of source

		align	16					; optimize cache line

global CopyBig_x64
CopyBig_x64:

		; loop

CopyBig_2:							; 1 loop: 32 bytes, 256 bits
		mov		rax,qword [r8]
		mov		r9,qword [r8+8]
		mov		qword [rdx],rax
		mov		r10,qword [r8+16]
		mov		qword [rdx+8],r9
		mov		r11,qword [r8+24]
		mov		qword [rdx+16],r10
		lea		r8,[r8+32]
		mov		qword [rdx+24],r11
		dec		rcx
		lea		rdx,[rdx+32]
		jne		CopyBig_2

		rcl		rax,1				; save carry
		and		rax,1
		ret

; =============================================================================
;      Multiply and add string, length multiply of 256-bit blocks (4x u64)
; =============================================================================
; inputs: rcx=num number of 4x u64 segments, rdx=multiply, r8=dst, r9=src
; output: rax=carry

		align	16						; optimize cache line

global MulAddBig_x64
MulAddBig_x64:

		; prepare registers
		push	rbx
		xor		r10,r10					; R10 <- 0, carry
		mov		r11,rdx					; R11 <- multiply

		; loop
MulAddBig_2:
%assign LOOPINX 0
%rep 4
		mov		rax,qword [r9+LOOPINX]	; RAX <- [src]
		mov		rbx,qword [r8+LOOPINX]	; RBX <- [dst]
		mul		r11						; RDX:RAX <- [src] * num
		add		rax,r10					; add carry
		adc		rdx,0					; carry		
		add		rbx,rax					; add [dst]
		adc		rdx,0					; carry		
		mov		qword [r8+LOOPINX],rbx	; store LOW
		mov		r10,rdx					; R10 <- new carry
%assign LOOPINX LOOPINX+8
%endrep
		add		r8,4*8					; shift dst
		add		r9,4*8					; shift src
		dec		rcx						; loop counter
		jnz		MulAddBig_2				; loop next step

		mov		rax,r10					; save carry
		pop		rbx
		ret

; =============================================================================
;                     Multiply and add 1 segment 64
; =============================================================================
; inputs: rcx=dst, rdx=multiply, r8=src
; output: rax=carry

		align	16						; optimize cache line

global MulAdd1_x64
MulAdd1_x64:

		mov		rax,qword [r8]			; RAX <- [src]
		mov		r9,qword [rcx]			; R9 <- [dst]
		mul		rdx						; RDX:RAX <- [src] * num
		add		r9,rax					; add [dst]
		adc		rdx,0					; carry		
		mov		qword [rcx],r9			; store LOW
		mov		rax,rdx					; save carry
		ret

; =============================================================================
;      Multiply and add string, length multiply of 64-bit segments
; =============================================================================
; inputs: rcx=num number of u64 segments, rdx=multiply, r8=dst, r9=src
; output: rax=carry

		align	16						; optimize cache line

global MulAdd64_x64
MulAdd64_x64:

		; prepare registers
		push	rbx
		xor		r10,r10					; R10 <- 0, carry
		mov		r11,rdx					; R11 <- multiply

		; loop
MulAdd64_2:
		mov		rax,qword [r9]			; RAX <- [src]
		mov		rbx,qword [r8]			; RBX <- [dst]
		mul		r11						; RDX:RAX <- [src] * num
		add		rax,r10					; add carry
		adc		rdx,0					; carry		
		add		rbx,rax					; add [dst]
		adc		rdx,0					; carry		
		mov		qword [r8],rbx			; store LOW
		mov		r10,rdx					; R10 <- new carry
		add		r8,8					; shift dst
		add		r9,8					; shift src
		dec		rcx						; loop counter
		jnz		MulAdd64_2				; loop next step

		mov		rax,r10					; save carry
		pop		rbx
		ret
