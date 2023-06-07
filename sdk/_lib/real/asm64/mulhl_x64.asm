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
;                       CHECK compiler compatibility
; =============================================================================
; inputs: rcx=par1 (123), rdx=par2 (456), r8=par3 (789), r9=par4 (321), [rsp+28h]=par5 (654), [rsp+30h]=par6 (987)
; output: rax=output 1=OK, 0=not

global CheckComp_x64
CheckComp_x64:
		xor		rax,rax				; RAX <- 0 error
		cmp		rcx,123
		jne		CheckComp_x64_8	
		cmp		rdx,456
		jne		CheckComp_x64_8	
		cmp		r8,789
		jne		CheckComp_x64_8	
		cmp		r9,321
		jne		CheckComp_x64_8	
		cmp		qword [rsp+28h],654
		jne		CheckComp_x64_8	
		cmp		qword [rsp+30h],987
		jne		CheckComp_x64_8	
		inc		rax					; RAX <- 1 ok
CheckComp_x64_8:
		ret

; =============================================================================
;                     long multiply rH:rL <- a*b (8 bits)
; =============================================================================
; inputs: rcx=u8* rH, rdx=u8* rL, r8=u8 a, r9=u8 b

		align	16					; optimize cache line

global MulHL8
MulHL8:
		mov		al,r8b
		mul		r9b
		mov		byte [rdx],al
		mov		byte [rcx],ah
		ret

; =============================================================================
;                    long multiply rH:rL <- a*b (16 bits)
; =============================================================================
; inputs: rcx=u16* rH, rdx=u16* rL, r8=u16 a, r9=u16 b

		align	16					; optimize cache line

global MulHL16
MulHL16:
		mov		r10,rdx
		mov		ax,r8w
		mul		r9w
		mov		word [r10],ax
		mov		word [rcx],dx
		ret

; =============================================================================
;                    long multiply rH:rL <- a*b (32 bits)
; =============================================================================
; inputs: rcx=u32* rH, rdx=u32* rL, r8=u32 a, r9=u32 b

		align	16					; optimize cache line

global MulHL32
MulHL32:
		mov		r10,rdx
		mov		eax,r8d
		mul		r9d
		mov		dword [r10],eax
		mov		dword [rcx],edx
		ret

; =============================================================================
;                    long multiply rH:rL <- a*b (64 bits)
; =============================================================================
; inputs: rcx=u64* rH, rdx=u64* rL, r8=u64 a, r9=u64 b

		align	16					; optimize cache line

global MulHL64
MulHL64:
		mov		r10,rdx
		mov		rax,r8
		mul		r9
		mov		qword [r10],rax
		mov		qword [rcx],rdx
		ret

; =============================================================================
;         long divide res <- a (16 bits)/b (8 bits), store remainder to *rem
; =============================================================================
; inputs: rcx=u8* rem, rdx=u16 a, r8=u8 b

		align	16					; optimize cache line

global DivHL8
DivHL8:
		mov		ax,dx
		div		r8b
		mov		byte [rcx],ah
		ret

; =============================================================================
;         long divide res <- aH:aL/b (16 bits), store remainder to *rem
; =============================================================================
; inputs: rcx=u16 aL, rdx=u16 aH, r8=u16 b, r9=u16* rem

		align	16					; optimize cache line

global DivHL16
DivHL16:
		mov		ax,cx
		div		r8w
		mov		word [r9],dx
		ret

; =============================================================================
;         long divide res <- aH:aL/b (32 bits), store remainder to *rem
; =============================================================================
; inputs: rcx=u32 aL, rdx=u32 aH, r8=u32 b, r9=u32* rem

		align	16					; optimize cache line

global DivHL32
DivHL32:
		mov		eax,ecx
		div		r8d
		mov		dword [r9],edx
		ret

; =============================================================================
;         long divide res <- aH:aL/b (64 bits), store remainder to *rem
; =============================================================================
; inputs: rcx=u64 aL, rdx=u64 aH, r8=u64 b, r9=u64* rem

		align	16					; optimize cache line

global DivHL64
DivHL64:
		mov		rax,rcx
		div		r8
		mov		qword [r9],rdx
		ret
