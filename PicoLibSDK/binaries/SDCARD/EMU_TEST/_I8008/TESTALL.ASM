; I8008 CPU speed: 500 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 20 us
; I8008-1 CPU speed: 800 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 12.5 us

; Compiled with Macroassembler AS

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	cpu	8008new		; Intel 8008 CPU with new mnemonics
	org	0		; start address of the code

hi	function x,(x>>8)&255	; get high byte
lo	function x,x&255	; get low byte

; -----------------------------------------------------------
;                     Print message
; -----------------------------------------------------------

Start:
	; prepare address of text
	mvi	l,lo(TextData)	; L <- text data LOW
	mvi	h,hi(TextData)	; H <- text data HIGH

	; prepare count of characters
	mvi	b,20		; B <- count of characters

	; output text
Msg2:	mov	a,m		; load one character -> A
	out	10		; output character to the display
; Text data array is always at address < 256,
; register H will always be 0, so we can
; increment only register L.
	inr	l		; increment register L

	; short delay = speed of generating characters
	mvi	e,0
	mvi	d,10
Msg3:	dcr	e
	jnz	Msg3
	dcr	d
	jnz	Msg3

	; next character
	dcr	b		; decrement loop counter
	jnz	Msg2		; loop if B not 0


	; [16] Blinking LED - initialize main time counter
	; main time counter uses register D
MainLoop:
	mvi	d,102		; [16] D <- 102, initialize main time counter

MainLoop2:

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------
; Takes 2378 clock cycles
; Uses registers: A, B, H, L

; ===== [58] preparation

	; [32] prepare address of numeric data
Count1:	mvi	l,lo(NumData)	; [16] L <- numeric data LOW
	mvi	h,hi(NumData)	; [16] H <- numeric data HIGH

	; [16] prepare number of digits
	mvi	b,10		; [16] B <- number of digits

	; [10] clear carry - to increase first digit
	cmp	a		; [10] clear carry

; ===== [1596] increment number: 10 loops, 1 loop takes 160 clock cycles, last loop takes 156 clock cycles

	; [32] increase one digit (here is carry = 0 to increase next digit)
Count2:	mov	a,m		; [16] load one digit -> A
	sbi	0ffh		; [16] increment A: A <- A + 1 - ~carry

	; [38 if < 10 skip, 34 if >= 10 not skip] check digit overflow
	cpi	10		; [16] check digit overflow: sets carry if < 10
	jc	Count4		; [18, 22] skip if digit < 10

	; [38] reset digit to 0
	mvi	a,0		; [16] A <- 0
	jmp	Count5		; [22]

; This part for time synchronization is not necessary,
; but we want to keep the counter running regularly,
; independent of the value of the number

	; [34] time synchronization
Count4:	nop			; [10]
	nop			; [10]
	mov	m,a		; [14] save new digit

	; [14] save new digit
Count5:	mov	m,a		; [14] save new digit

; The data array is always at address < 256,
; register H will always be 0, so we can
; increment only register L.

	; [10] increment HL pointer (carry flag stays unchanged)
	inr	l		; [10] increment register L

	; [32 if B > 0 loop, 28 if B = 0 not loop] loop counter (carry flag stays unchanged)
	dcr	b		; [10] decrement loop counter
	jnz	Count2		; [18, 22] loop if B not 0

; ===== [724] output number (in order from highest digit to lowest)

	; [16] prepare number of digits
	mvi	b,10		; [16] B <- number of digits

	; [708] decrement HL pointer: 10 loops, 1 loop takes 70 clock cycles, last loop takes 66 clock cycles
Count6:	dcr	l		; [10] decrement register L
	mov	a,m		; [16] load one digit -> A
	out	13		; [12] send digit to shift register
	dcr	b		; [10] decrement loop counter
	jnz	Count6		; [18, 22] loop if B not 0

	out	12		; [12] send shift register to the display

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------
; Takes 28 clock cycles
; Uses registers: A

	in	7		; [16] A <- input from keys
	out	14		; [12] output to LEDs <- A

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------
; CPU speed: 500 kHz
; delay 500 ms requires 250000 clock cycles
; One step of main loop = 2378 + 28 + 32 = 2438 clock cycles
; Last step of main loop = 2378 + 28 + 28 = 2434 clock cycles
; Number of main loops: 250000/2438 = 102 loops
; Main loops takes 101*2438 + 2434 = 248672 clock cycles
; Remain 1328 clock cycles, missing 1328 - 50 - 16 = 1262 clock cycles

; Uses registers: A, D

	; [32 if D > 0 loop, 28 if D = 0 last loop] count main time counter
	dcr	d		; [10] decrement D
	jnz	MainLoop2	; [18 or 22] main time loop

	; [1262] additional delay: one step of loop takes 32 clock cycles, last step takes 28 clock cycles
	mvi	b,38		; [16]
Blink2:	dcr	b		; [10]
	jnz	Blink2		; [18, 22]

	; additional delay (here is A = input from keys)
	out	14		; [12] output to LEDs <- A ... additional dely
	out	14		; [12] output to LEDs <- A ... additional dely
	nop			; [10] ... additional dely

	; [50] output A value to blink LED
	mvi	a,2		; [16] A <- bit 1
	out	15		; [12] output A to port 15
	jmp	MainLoop	; [22] new interval

	; text data - must be in first 256-byte page
TextData:
	db	'  Hello from I8008! '

	; numeric data - must be in first 256-byte page
NumData:
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
