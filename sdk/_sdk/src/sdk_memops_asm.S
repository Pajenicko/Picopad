
// ****************************************************************************
//
//                            Memory operations
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

/*
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "../asm_include.inc"

	.syntax unified
	.cpu cortex-m0plus
	.thumb

wrapper_func_text __aeabi_memset
	// args are backwards
	eors	r0,r1
	eors	r1,r0
	eors	r0,r1

// continue to memset

wrapper_func memset
	ldr	r3,=MemSet
	ldr	r3,[r3]
	bx	r3

wrapper_func_text __aeabi_memset4
wrapper_func __aeabi_memset8
	// args are backwards
	eors	r0,r1
	eors	r1,r0
	eors	r0,r1
	ldr	r3,=MemSet32
	ldr	r3,[r3]
	bx	r3

wrapper_func_text __aeabi_memcpy
wrapper_func memcpy
	ldr	r3,=MemCopy
	ldr	r3,[r3]
	bx	r3

wrapper_func_text __aeabi_memcpy4
wrapper_func __aeabi_memcpy8
	ldr	r3,=MemCopy32
	ldr	r3,[r3]
	bx	r3
