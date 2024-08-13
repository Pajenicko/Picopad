
#define LED_PIN			25		// GPIO with system LED
#define IO_BANK0_BASE		0x40014000	// GPIO pads
#define PADS_BANK0_BASE		0x4001c000	// GPIO pad control

#define SIO_BASE		0xd0000000	// SIO registers
#define SIO_CPUID_OFFSET	0x00000000	// offset of CPUID register
#define PICO_STACK_SIZE		0x1000u		// CPU 0 stack size
#define PICO_HEAP_SIZE		0x100u		// heap size
#define XIP_BASE		0x10000000	// Flash ROM base address
#define PPB_BASE		0xe0000000	// Cortex M0 control block
#define M0PLUS_VTOR_OFFSET	0x0000ed08	// offset of VTOR control register
#define BOOTLOADER_SIZE		0x8000		// size of boot loader
#define SCB_VTOR		0xe000ed08	// address of register of Cortex M0+ interrupt vector table VTOR

	.syntax unified
	.cpu cortex-m0plus
	.thumb

	.section .vectors, "ax"
	.align 8		// aligned to 256 bytes

// ==== Vector table

.global __vectors	// 48 vectors
__vectors:
	// ARM Cortex-M0+ core interrupt request indices - Exceptions
	.word	__StackTop	// -16 end of stack for CPU0
	.word	_reset_handler	// -15 IRQ_RESET reset handler
	.word	isr_nmi		// -14 IRQ_NMI interrupt of NMI
	.word	isr_hardfault	// -13 IRQ_HARDFAULT hard fault
	.word	isr_invalid	// -12 ... Reserved, should never fire
	.word	isr_invalid	// -11 ... Reserved, should never fire
	.word	isr_invalid	// -10 ... Reserved, should never fire
	.word	isr_invalid	// -9 ... Reserved, should never fire
	.word	isr_invalid	// -8 ... Reserved, should never fire
	.word	isr_invalid	// -7 ... Reserved, should never fire
	.word	isr_invalid	// -6 ... Reserved, should never fire
	.word	isr_svcall	// -5 IRQ_SVCALL SuperVisor Call
	.word	isr_invalid	// -4 ... Reserved, should never fire
	.word	isr_invalid	// -3 ... Reserved, should never fire
	.word	isr_pendsv	// -2 IRQ_PENDSV Pendable Service Call
	.word	isr_systick	// -1 IRQ_SYSTICK System Tick Timer

	// RP2040 device interrupt request indices - Interrupts
	.word	isr_irq0	// 0 IRQ_TIMER_0 isr_timer_0
	.word	isr_irq1	// 1 IRQ_TIMER_1 isr_timer_1
	.word	isr_irq2	// 2 IRQ_TIMER_2 isr_timer_2
	.word	isr_irq3	// 3 IRQ_TIMER_3 isr_timer_3
	.word	isr_irq4	// 4 IRQ_PWM_WRAP isr_pwm_wrap
	.word	isr_irq5	// 5 IRQ_USBCTRL isr_usbctrl
	.word	isr_irq6	// 6 IRQ_XIP isr_xip
	.word	isr_irq7	// 7 IRQ_PIO0_0 isr_pio0_0	
	.word	isr_irq8	// 8 IRQ_PIO0_1 isr_pio0_1	
	.word	isr_irq9	// 9 IRQ_PIO1_0 isr_pio1_0	
	.word	isr_irq10	// 10 IRQ_PIO1_1 isr_pio1_1	
	.word	isr_irq11	// 11 IRQ_DMA_0 isr_dma_0	
	.word	isr_irq12	// 12 IRQ_DMA_1 isr_dma_1	
	.word	isr_irq13	// 13 IRQ_IO_BANK0 isr_io_bank0	
	.word	isr_irq14	// 14 IRQ_IO_QSPI isr_io_qspi	
	.word	isr_irq15	// 15 IRQ_SIO_PROC0 isr_sio_proc0	
	.word	isr_irq16	// 16 IRQ_SIO_PROC1 isr_sio_proc1	
	.word	isr_irq17	// 17 IRQ_CLOCKS isr_clocks	
	.word	isr_irq18	// 18 IRQ_SPI0 isr_spi0	
	.word	isr_irq19	// 19 IRQ_SPI1 isr_spi1	
	.word	isr_irq20	// 20 IRQ_UART0 isr_uart0	
	.word	isr_irq21	// 21 IRQ_UART1 isr_uart1	
	.word	isr_irq22	// 22 IRQ_ADC_FIFO isr_adc_fifo	
	.word	isr_irq23	// 23 IRQ_I2C0 isr_i2c0	
	.word	isr_irq24	// 24 IRQ_I2C1 isr_i2c1	
	.word	isr_irq25	// 25 IRQ_RTC isr_rtc		
	.word	isr_irq26	// 26
	.word	isr_irq27	// 27
	.word	isr_irq28	// 28
	.word	isr_irq29	// 29
	.word	isr_irq30	// 30
	.word	isr_irq31	// 31

// ==== Application info header (start at offset 48*4)

	.ascii	"PPAD"		// app[48]: identification magic mark
	.word	0x01234567	// app[49]: application length after this header (=total length without boot loader and 51*4)
	.word	0x89ABCDEF	// app[50]: application CRC of following program data
				// app[51]: ...start of program data

// ==== Declare weak symbols for each ISR (default fall to breakpoint), can be overriden by C function

.macro decl_isr name
.weak \name
.type \name,%function
.thumb_func
\name:
.endm
	decl_isr	isr_invalid
	decl_isr	isr_nmi
	decl_isr	isr_hardfault
	decl_isr	isr_svcall
	decl_isr	isr_pendsv
	decl_isr	isr_systick

	decl_isr	isr_irq0
	decl_isr	isr_irq1
	decl_isr	isr_irq2
	decl_isr	isr_irq3
	decl_isr	isr_irq4
	decl_isr	isr_irq5
	decl_isr	isr_irq6
	decl_isr	isr_irq7
	decl_isr	isr_irq8
	decl_isr	isr_irq9
	decl_isr	isr_irq10
	decl_isr	isr_irq11
	decl_isr	isr_irq12
	decl_isr	isr_irq13
	decl_isr	isr_irq14
	decl_isr	isr_irq15
	decl_isr	isr_irq16
	decl_isr	isr_irq17
	decl_isr	isr_irq18
	decl_isr	isr_irq19
	decl_isr	isr_irq20
	decl_isr	isr_irq21
	decl_isr	isr_irq22
	decl_isr	isr_irq23
	decl_isr	isr_irq24
	decl_isr	isr_irq25
	decl_isr	isr_irq26
	decl_isr	isr_irq27
	decl_isr	isr_irq28
	decl_isr	isr_irq29
	decl_isr	isr_irq30
	decl_isr	isr_irq31

	// unhandled IRQ
.global unhandled_irq
unhandled_irq:

//	bkpt	#0				// break point
//	b	unhandled_irq

	// initialize LED output
	ldr	r3,=(PADS_BANK0_BASE + LED_PIN*4+4) // = GPIO_PAD(LED_PIN) = 0x4001c000 + 25*4 + 4 = 0x4001c068 (GPIO pad control register)
	movs	r2,#0x56			// B1|B2|B4|B6 ... value to reset pad setup
	str	r2,[r3,#0]			// reset pad setup

	ldr	r3,=(IO_BANK0_BASE + LED_PIN*8+4) // = GPIO_CTRL(LED_PIN) = 0x40014000 + 25*8 + 4 = 0x400140cc (GPIO pin control register)
	movs	r2,#5				// GPIO_FNC_SIO
	str	r2,[r3,#0]			// set GPIO function GPIO_FNC_SIO, reset all overrides

	ldr	r3,=(SIO_BASE + 0x1C)		// = GPIO_OE_SET - 8 = GPIO_OUT_XOR = 0xd0000000 + 0x1C = 0xd000001C
	movs	r2,#1
	lsls	r2,#LED_PIN			// mask value of LED_PIN bit
	str	r2,[r3,#8]			// enable output

unhandled_irq_2:
	// flip LED output
	str	r2,[r3,#0]			// flip output (= GPIO_OUT_XOR = 0xd0000000 + 0x1C = 0xd000001C)

	// wait loop
	ldr	r1,=3000000			// wait period
unhandled_irq_3:
	subs	r1,#1
	bne	unhandled_irq_3
	b	unhandled_irq_2

// ==== Reset handler

	.section .reset, "ax"

.type _reset_handler,%function
.thumb_func
.global _reset_handler
_reset_handler:

// set stack pointer (may be uninitialized from BOOTROM when starting RAM version)

	ldr	r0,=__StackTop			// top of the stack
	msr	MSP,r0				// set stack pointer

// set vector table address (may be uninitialized from BOOTROM when starting RAM version)

	ldr	r0,=__vectors			// vectors
	ldr	r1,=SCB_VTOR			// SCB_VTOR register (PPB_BASE + 0xED08)
	str	r0,[r1,#0]			// set VTOR address

// Only core 0 should run the C runtime startup code; core 1 is normally
// sleeping in the bootrom at this point but check to be sure

	ldr	r0,=(SIO_BASE + SIO_CPUID_OFFSET) // address of CPUID register
	ldr	r0,[r0]				// get current CPU (0 or 1)
	cmp	r0,#0				// is running on CPU 0 ?
	bne	hold_non_core0_in_bootrom	// run CPU 1 back to bootrom

// Copy read-only data from Flash to RAM (only if not RAM version)

#if !NO_FLASH

	ldr	r1,=__etext			// read address of data in Flash
	ldr	r2,=__data_start__		// write address of data to RAM
	ldr	r3,=__data_end__		// end of write address
	b	data_cpy

data_cpy_loop:
	ldm	r1!,{r0}			// load word from [R1] to R0 and increment R1
	stm	r2!,{r0}			// save word to [R2] from R0 and increment R2
data_cpy:
	cmp	r2,r3				// check limit of write address
	blo	data_cpy_loop			// repeat until R2 >= R3

#endif

// Zero out the BSS segment

2:	ldr	r1,=__bss_start__		// start of BSS segment -> R1 (get from linker script *.ld)
	ldr	r2,=__bss_end__			// end of BSS segment -> R2 (get from linker script *.ld)
	movs	r0,#0				// clear value 0 -> R0
	b	bss_fill_test

bss_fill_loop:
	stm	r1!,{r0}			// store 0 from R0 to [R1] and increment R1
bss_fill_test:
	cmp	r1,r2				// end of segment?
	bne	bss_fill_loop			// continue with next data

// Runtime initialize, function RuntimeInit()

	ldr	r1,=RuntimeInit
	blx	r1

// Start main function Main()

	ldr	r1,=main
	blx	r1

// Exit and loop

1:	//bkpt	#0				// break point
	b	1b


// ==== Run CPU 1 back to bootrom

hold_non_core0_in_bootrom:
	ldr	r0,='W'|('V' << 8)
	bl	RomFunc				// rom_func_lookup
	bx	r0

// ==== Run application

.type GoToApp,%function
.thumb_func
.global GoToApp
GoToApp:
	ldr	r0,=(XIP_BASE + BOOTLOADER_SIZE) // vector table of application -> R0
	ldr	r1,=(PPB_BASE + M0PLUS_VTOR_OFFSET) // address of vector table
	str	r0,[r1]				// set application vector table
	ldmia	r0,{r0, r1}			// load stack pointer -> R0 and start address -> R1
	msr	msp,r0				// set stack pointer
	bx	r1				// run application code

// ==== CPU 0 stack
.section .stack0
	.align	5
	.equ	StackSize,PICO_STACK_SIZE
	.space	StackSize

// ==== Heap
.section .heap
	.align	2
	.equ	HeapSize,PICO_HEAP_SIZE
	.space	HeapSize
