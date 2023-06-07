
// ****************************************************************************
//                                 
//                             Project configuration
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#ifndef _CONFIG_H
#define _CONFIG_H

// === Use modules (set 1 = use module, 0 = do not use module)

#define USE_FLOAT	1		// 1 = use float support
#define USE_DOUBLE	1		// 1 = use double support

// === setup REAL numbers (1 = use, 0 = do not use)
// If generating constants with GenConst generator, enable all number types
//    to allow more accurate generation of Chebyshev constants.
#define USE_REAL16	1		// 1 = use real16 numbers (3 digits, exp +-4)
#define USE_REAL32	1		// 1 = use real32 numbers (float, 7 digits, exp +-38)
#define USE_REAL48	1		// 1 = use real48 numbers (11 digits, exp +-153)
#define USE_REAL64	1		// 1 = use real64 numbers (double, 16 digits, exp +-308)
#define USE_REAL80	1		// 1 = use real80 numbers (19 digits, exp +-4932)
#define USE_REAL96	1		// 1 = use real96 numbers (25 digits, exp +-1233)
#define USE_REAL128	1		// 1 = use real128 numbers (34 digits, exp +-4932)
#define USE_REAL160	1		// 1 = use real160 numbers (43 digits, exp +-9864)
#define USE_REAL192	1		// 1 = use real192 numbers (52 digits, exp +-19728)
#define USE_REAL256	1		// 1 = use real256 numbers (71 digits, exp +-78913)
#define USE_REAL384	1		// 1 = use real384 numbers (109 digits, exp +-315652)
#define USE_REAL512	1		// 1 = use real512 numbers (147 digits, exp +-1262611)
#define USE_REAL768	1		// 1 = use real768 numbers (224 digits, exp +-5050445)
#define USE_REAL1024	1		// 1 = use real1024 numbers (300 digits, exp +-20201781)
#define USE_REAL1536	1		// 1 = use real1536 numbers (453 digits, exp +-161614248)
#define USE_REAL2048	1		// 1 = use real2048 numbers (607 digits, exp +-161614248)
#define USE_REAL3072	1		// 1 = use real3072 numbers (1214 digits, exp +-161614248)
#define USE_REAL4096	1		// 1 = use real3072 numbers (1214 digits, exp +-161614248)

// Limiting the usage of large Chebyshev tables
//  Chebyshev approximations can speed up calculations of mathematical functions.
//  However, the use of Chebyshev approximations for long numbers takes a lot of
//  Flash memory and can be slow due to slow Flash memory access. If needed, set
//  a limit here on the bit length of the numbers for which Chebyshev approximations
//  will be used.
#define MAXCHEB_LN	4096		// max. REAL number supporting Chebyshev approximations of Ln()
#define MAXCHEB_EXP	4096		// max. REAL number supporting Chebyshev approximations of Exp()
#define MAXCHEB_SIN	4096		// max. REAL number supporting Chebyshev approximations of Sin()
#define MAXCHEB_ASIN	4096		// max. REAL number supporting Chebyshev approximations of ASin()
#define MAXCHEB_ATAN	4096		// max. REAL number supporting Chebyshev approximations of ATan()
#define MAXCHEB_SQRT	4096		// max. REAL number supporting Chebyshev approximations of Sqrt()

// Limiting the usage of linear factorials
//  Calculating the linear factorial requires tables that take up much Flash memory.
//  If you need to limit the size of the tables, set a limit here of the bit length of
//  the numbers that will support the linear factorial. The integer factorial
//  can still be used, but it is slow for large numbers.
#define MAXFACT_COEFF	4096	// max. REAL number supporting linear factorial

#define ASM64		0			// 1 = use assembler x64 optimization, if available

#endif // _CONFIG_H
