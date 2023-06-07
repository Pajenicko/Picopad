
// ****************************************************************************
//
//                           Constant Templates of real32
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// real32: size 4 bytes, 32 bits, mantissa 23 bits, exponent 8 bits

// Normal precision:
const REAL REALNAME(Const0) =	{ { 0x00000000 }, };	// 0  (0)
const REAL REALNAME(Const1) =	{ { 0x3f800000 }, };	// 1  (1)
const REAL REALNAME(ConstM1) =	{ { 0xbf800000 }, };	// -1  (-1)
const REAL REALNAME(Const2) =	{ { 0x40000000 }, };	// 2  (2)
const REAL REALNAME(Const3) =	{ { 0x40400000 }, };	// 3  (3)
const REAL REALNAME(Const05) =	{ { 0x3f000000 }, };	// 0.5  (0.5)
const REAL REALNAME(ConstM05) =	{ { 0xbf000000 }, };	// -0.5  (-0.5)
const REAL REALNAME(Const075) =	{ { 0x3f400000 }, };	// 0.75  (0.75)
const REAL REALNAME(Const83) =	{ { 0x402aaaab }, };	// 8/3  (2.66666666666667)
const REAL REALNAME(Const10) =	{ { 0x41200000 }, };	// 10  (10)
const REAL REALNAME(Const100) =	{ { 0x42c80000 }, };	// 100  (100)
const REAL REALNAME(ConstExpMax) =	{ { 0x42b20f34 }, };	// exp(x) max  (89.029691931113)
const REAL REALNAME(ConstExpMin) =	{ { 0xc2b20f34 }, };	// exp(x) min  (-89.029691931113)
const REAL REALNAME(Const01) =	{ { 0x3dcccccd }, };	// 0.1 (1e-1)  (0.1)
const REAL REALNAME(Const001) =	{ { 0x3c23d70a }, };	// 0.01 (1e-2)  (0.01)
const REAL REALNAME(Const1eM4) =	{ { 0x38d1b717 }, };	// 0.0001 (1e-4)  (0.0001)
const REAL REALNAME(Const1eM8) =	{ { 0x322bcc77 }, };	// 0.00000001 (1e-8)  (1e-008)
const REAL REALNAME(ConstLn2) =	{ { 0x3f317218 }, };	// ln(2)  (0.693147180559945)
const REAL REALNAME(ConstRLn2) =	{ { 0x3fb8aa3b }, };	// 1/ln(2)  (1.44269504088896)
const REAL REALNAME(ConstLn10) =	{ { 0x40135d8e }, };	// ln(10)  (2.30258509299405)
const REAL REALNAME(ConstRLn10) =	{ { 0x3ede5bd9 }, };	// 1/ln(10)  (0.434294481903252)
const REAL REALNAME(ConstLog2) =	{ { 0x3e9a209b }, };	// log(2)  (0.301029995663981)
const REAL REALNAME(ConstRLog2) =	{ { 0x40549a78 }, };	// 1/log(2)  (3.32192809488736)
const REAL REALNAME(ConstEul) =	{ { 0x402df854 }, };	// Eul  (2.71828182845905)
const REAL REALNAME(ConstPi05) =	{ { 0x3fc90fdb }, };	// pi/2  (1.5707963267949)
const REAL REALNAME(ConstMPi05) =	{ { 0xbfc90fdb }, };	// -pi/2  (-1.5707963267949)
const REAL REALNAME(ConstPi) =	{ { 0x40490fdb }, };	// pi  (3.14159265358979)
const REAL REALNAME(ConstMPi) =	{ { 0xc0490fdb }, };	// -pi  (-3.14159265358979)
const REAL REALNAME(ConstPi2) =	{ { 0x40c90fdb }, };	// pi*2  (6.28318530717959)
const REAL REALNAME(ConstMPi2) =	{ { 0xc0c90fdb }, };	// -pi*2  (-6.28318530717959)
const REAL REALNAME(ConstRPi2) =	{ { 0x3e22f983 }, };	// 1/pi*2  (0.159154943091895)
const REAL REALNAME(ConstLnPi22) =	{ { 0x3f6b3f8e }, };	// ln(pi*2)/2  (0.918938533204673)
const REAL REALNAME(Const180Pi) =	{ { 0x42652ee1 }, };	// 180/pi  (57.2957795130823)
const REAL REALNAME(ConstPi180) =	{ { 0x3c8efa35 }, };	// pi/180  (0.0174532925199433)
const REAL REALNAME(Const200Pi) =	{ { 0x427ea5dd }, };	// 200/pi  (63.6619772367581)
const REAL REALNAME(ConstPi200) =	{ { 0x3c80adfd }, };	// pi/200  (0.015707963267949)
const REAL REALNAME(ConstPhi) =	{ { 0x3fcf1bbd }, };	// phi (sectio aurea = (1 + sqrt(5))/2)  (1.61803398874989)
const REAL REALNAME(ConstSqrt2) =	{ { 0x3fb504f3 }, };	// sqrt(2)  (1.4142135623731)
const REAL REALNAME(ConstRSqrt2) =	{ { 0x3f3504f3 }, };	// 1/sqrt(2)  (0.707106781186548)

// Extended precision:
const REALEXT REALNAME(Const0Ext) =	{ { 0x00000000 }, 0x00000000};	// 0  (0)
const REALEXT REALNAME(Const1Ext) =	{ { 0x80000000 }, 0x3fffffff};	// 1  (1)
const REALEXT REALNAME(ConstM1Ext) =	{ { 0x80000000 }, 0xbfffffff};	// -1  (-1)
const REALEXT REALNAME(Const2Ext) =	{ { 0x80000000 }, 0x40000000};	// 2  (2)
const REALEXT REALNAME(Const3Ext) =	{ { 0xc0000000 }, 0x40000000};	// 3  (3)
const REALEXT REALNAME(Const05Ext) =	{ { 0x80000000 }, 0x3ffffffe};	// 0.5  (0.5)
const REALEXT REALNAME(ConstM05Ext) =	{ { 0x80000000 }, 0xbffffffe};	// -0.5  (-0.5)
const REALEXT REALNAME(Const075Ext) =	{ { 0xc0000000 }, 0x3ffffffe};	// 0.75  (0.75)
const REALEXT REALNAME(Const83Ext) =	{ { 0xaaaaaaab }, 0x40000000};	// 8/3  (2.66666666666667)
const REALEXT REALNAME(Const10Ext) =	{ { 0xa0000000 }, 0x40000002};	// 10  (10)
const REALEXT REALNAME(Const100Ext) =	{ { 0xc8000000 }, 0x40000005};	// 100  (100)
const REALEXT REALNAME(ConstExpMaxExt) =	{ { 0xb17217fa }, 0x4000001b};	// exp(x) max  (372130559.284299)
const REALEXT REALNAME(ConstExpMinExt) =	{ { 0xb17217fa }, 0xc000001b};	// exp(x) min  (-372130559.284299)
const REALEXT REALNAME(Const01Ext) =	{ { 0xcccccccd }, 0x3ffffffb};	// 0.1 (1e-1)  (0.1)
const REALEXT REALNAME(Const001Ext) =	{ { 0xa3d70a3d }, 0x3ffffff8};	// 0.01 (1e-2)  (0.01)
const REALEXT REALNAME(Const1eM4Ext) =	{ { 0xd1b71759 }, 0x3ffffff1};	// 0.0001 (1e-4)  (0.0001)
const REALEXT REALNAME(Const1eM8Ext) =	{ { 0xabcc7712 }, 0x3fffffe4};	// 0.00000001 (1e-8)  (1e-008)
const REALEXT REALNAME(ConstLn2Ext) =	{ { 0xb17217f8 }, 0x3ffffffe};	// ln(2)  (0.693147180559945)
const REALEXT REALNAME(ConstRLn2Ext) =	{ { 0xb8aa3b29 }, 0x3fffffff};	// 1/ln(2)  (1.44269504088896)
const REALEXT REALNAME(ConstLn10Ext) =	{ { 0x935d8dde }, 0x40000000};	// ln(10)  (2.30258509299405)
const REALEXT REALNAME(ConstRLn10Ext) =	{ { 0xde5bd8a9 }, 0x3ffffffd};	// 1/ln(10)  (0.434294481903252)
const REALEXT REALNAME(ConstLog2Ext) =	{ { 0x9a209a85 }, 0x3ffffffd};	// log(2)  (0.301029995663981)
const REALEXT REALNAME(ConstRLog2Ext) =	{ { 0xd49a784c }, 0x40000000};	// 1/log(2)  (3.32192809488736)
const REALEXT REALNAME(ConstEulExt) =	{ { 0xadf85459 }, 0x40000000};	// Eul  (2.71828182845905)
const REALEXT REALNAME(ConstPi05Ext) =	{ { 0xc90fdaa2 }, 0x3fffffff};	// pi/2  (1.5707963267949)
const REALEXT REALNAME(ConstMPi05Ext) =	{ { 0xc90fdaa2 }, 0xbfffffff};	// -pi/2  (-1.5707963267949)
const REALEXT REALNAME(ConstPiExt) =	{ { 0xc90fdaa2 }, 0x40000000};	// pi  (3.14159265358979)
const REALEXT REALNAME(ConstMPiExt) =	{ { 0xc90fdaa2 }, 0xc0000000};	// -pi  (-3.14159265358979)
const REALEXT REALNAME(ConstPi2Ext) =	{ { 0xc90fdaa2 }, 0x40000001};	// pi*2  (6.28318530717959)
const REALEXT REALNAME(ConstMPi2Ext) =	{ { 0xc90fdaa2 }, 0xc0000001};	// -pi*2  (-6.28318530717959)
const REALEXT REALNAME(ConstRPi2Ext) =	{ { 0xa2f9836e }, 0x3ffffffc};	// 1/pi*2  (0.159154943091895)
const REALEXT REALNAME(ConstLnPi22Ext) =	{ { 0xeb3f8e43 }, 0x3ffffffe};	// ln(pi*2)/2  (0.918938533204673)
const REALEXT REALNAME(Const180PiExt) =	{ { 0xe52ee0d3 }, 0x40000004};	// 180/pi  (57.2957795130823)
const REALEXT REALNAME(ConstPi180Ext) =	{ { 0x8efa3513 }, 0x3ffffff9};	// pi/180  (0.0174532925199433)
const REALEXT REALNAME(Const200PiExt) =	{ { 0xfea5dd5c }, 0x40000004};	// 200/pi  (63.6619772367581)
const REALEXT REALNAME(ConstPi200Ext) =	{ { 0x80adfc91 }, 0x3ffffff9};	// pi/200  (0.015707963267949)
const REALEXT REALNAME(ConstPhiExt) =	{ { 0xcf1bbcdd }, 0x3fffffff};	// phi (sectio aurea = (1 + sqrt(5))/2)  (1.61803398874989)
const REALEXT REALNAME(ConstSqrt2Ext) =	{ { 0xb504f334 }, 0x3fffffff};	// sqrt(2)  (1.4142135623731)
const REALEXT REALNAME(ConstRSqrt2Ext) =	{ { 0xb504f334 }, 0x3ffffffe};	// 1/sqrt(2)  (0.707106781186548)

// Decimal exponents (index REAL_DECEXP = number '1')
const REAL REALNAME(ConstExp)[REAL_DECEXP*2+1] = {	// total 13 numbers
	 { { 0x0a4fb11f }, },	// 1e-32 (1e-0x20)  (1e-032)
	 { { 0x24e69595 }, },	// 1e-16 (1e-0x10)  (1e-016)
	 { { 0x322bcc77 }, },	// 1e-8 (1e-0x8)  (1e-008)
	 { { 0x38d1b717 }, },	// 1e-4 (1e-0x4)  (0.0001)
	 { { 0x3c23d70a }, },	// 1e-2 (1e-0x2)  (0.01)
	 { { 0x3dcccccd }, },	// 1e-1 (1e-0x1)  (0.1)
	 { { 0x3f800000 }, },	// 1e+0 (1e+0x0)  (1)
	 { { 0x41200000 }, },	// 1e+1 (1e+0x1)  (10)
	 { { 0x42c80000 }, },	// 1e+2 (1e+0x2)  (100)
	 { { 0x461c4000 }, },	// 1e+4 (1e+0x4)  (10000)
	 { { 0x4cbebc20 }, },	// 1e+8 (1e+0x8)  (100000000)
	 { { 0x5a0e1bca }, },	// 1e+16 (1e+0x10)  (1e+016)
	 { { 0x749dc5ae }, },	// 1e+32 (1e+0x20)  (1e+032)
};

// Factorial coefficients
#ifdef FACT_COEFF
const REALEXT REALNAME(ConstFact)[FACT_COEFF] = {	// FACT_COEFF = 4
	 { { 0xaaaaaaab }, 0x3ffffffb},	// a0  (0.0833333333333333)
	 { { 0x88888889 }, 0x3ffffffa},	// a1  (0.0333333333333333)
	 { { 0x81381381 }, 0x3ffffffd},	// a2  (0.252380952380952)
	 { { 0x868e2543 }, 0x3ffffffe},	// a3  (0.525606469002695)
};
#endif

// Chebyshev coefficients of Ln()
#ifdef CHEB_LN
const REALEXT REALNAME(ConstChebLn)[CHEB_LN] = {	// CHEB_LN = 13
	 { { 0xcf991f66 }, 0x3ffffffd},	// 0  (0.405465108109638)
	 { { 0xaaaaaaa9 }, 0x3ffffffd},	// 1  (0.333333333139308)
	 { { 0xe38e38df }, 0xbffffffa},	// 2  (-0.0555555554892635)
	 { { 0xca458e42 }, 0x3ffffff8},	// 3  (0.0123456849323702)
	 { { 0xca458fcc }, 0xbffffff6},	// 4  (-0.00308642159143346)
	 { { 0xd7be7b58 }, 0x3ffffff4},	// 5  (0.000822998312287382)
	 { { 0xefb6ca45 }, 0xbffffff2},	// 6  (-0.000228609107864486)
	 { { 0x8952049c }, 0x3ffffff1},	// 7  (6.54794611136822e-005)
	 { { 0xa03b65c9 }, 0xbfffffef},	// 8  (-1.91011454901968e-005)
	 { { 0xb4d13635 }, 0x3fffffed},	// 9  (5.38877348255085e-006)
	 { { 0xd8a01e11 }, 0xbfffffeb},	// 10  (-1.61398543996327e-006)
	 { { 0xbd6ca7ba }, 0x3fffffea},	// 11  (7.05661007405212e-007)
	 { { 0xe877d73d }, 0xbfffffe8},	// 12  (-2.16502815508779e-007)
};
#endif

// Chebyshev coefficients of Exp()
#ifdef CHEB_EXP
const REALEXT REALNAME(ConstChebExp)[CHEB_EXP] = {	// CHEB_EXP = 10
	 { { 0x80000000 }, 0x3fffffff},	// 0  (1)
	 { { 0xb17217f8 }, 0x3ffffffe},	// 1  (0.693147180601954)
	 { { 0xf5fdeff0 }, 0x3ffffffc},	// 2  (0.240226506255567)
	 { { 0xe35846b5 }, 0x3ffffffa},	// 3  (0.0555041086190613)
	 { { 0x9d956176 }, 0x3ffffff8},	// 4  (0.00961813466710737)
	 { { 0xaec4023e }, 0x3ffffff5},	// 5  (0.00133335616465047)
	 { { 0xa1805ca9 }, 0x3ffffff2},	// 6  (0.000154019750482348)
	 { { 0xffe1c9dc }, 0x3fffffee},	// 7  (1.52517549025788e-005)
	 { { 0xb3c1ad20 }, 0x3fffffeb},	// 8  (1.3392906481613e-006)
	 { { 0xdcf8ad51 }, 0x3fffffe7},	// 9  (1.02897824066917e-007)
};
#endif

// Chebyshev coefficients of Sin()
#ifdef CHEB_SIN
const REALEXT REALNAME(ConstChebSin)[CHEB_SIN] = {	// CHEB_SIN = 13
	 { { 0xb504f334 }, 0x3ffffffe},	// 0  (0.707106781192124)
	 { { 0x8e2c18d7 }, 0x3ffffffe},	// 1  (0.555360367288813)
	 { { 0xdf52db04 }, 0xbffffffc},	// 2  (-0.218089506262913)
	 { { 0xe9dd2e0e }, 0xbffffffa},	// 3  (-0.0570956992160063)
	 { { 0xb7ad24d9 }, 0x3ffffff8},	// 4  (0.0112107143249887)
	 { { 0xe6d08314 }, 0x3ffffff5},	// 5  (0.00176097488474625)
	 { { 0xf1b5585d }, 0xbffffff2},	// 6  (-0.000230511073652906)
	 { { 0xd8f4f31f }, 0xbfffffef},	// 7  (-2.58632701317651e-005)
	 { { 0xaa65c4ba }, 0x3fffffec},	// 8  (2.53912110714793e-006)
	 { { 0xede60cfa }, 0x3fffffe8},	// 9  (2.21560369717544e-007)
	 { { 0x957adcb7 }, 0xbfffffe5},	// 10  (-1.74017541973437e-008)
	 { { 0xa8983627 }, 0xbfffffe1},	// 11  (-1.22668699113412e-009)
	 { { 0xb0e079fd }, 0x3fffffdd},	// 12  (8.04342841517845e-011)
};
#endif

// Chebyshev coefficients of ASin()
#ifdef CHEB_ASIN
const REALEXT REALNAME(ConstChebASin)[CHEB_ASIN] = {	// CHEB_ASIN = 20
	 { { 0xc4cfa76e }, 0x3ffffffd},	// 0  (0.384396774461493)
	 { { 0xcf1d3c10 }, 0x3ffffffd},	// 1  (0.404519917443395)
	 { { 0x8790cef6 }, 0x3ffffffa},	// 2  (0.0330970844661351)
	 { { 0x86be79ef }, 0x3ffffff9},	// 3  (0.0164482480540755)
	 { { 0xa96695fa }, 0x3ffffff7},	// 4  (0.00516969988893834)
	 { { 0x9cfe1b83 }, 0x3ffffff6},	// 5  (0.00239551707909413)
	 { { 0x8838dabc }, 0x3ffffff5},	// 6  (0.00103929205033637)
	 { { 0x833bb650 }, 0x3ffffff4},	// 7  (0.000500615122291492)
	 { { 0xfd5ae65a }, 0x3ffffff2},	// 8  (0.000241618230234053)
	 { { 0xfe9bbb44 }, 0x3ffffff1},	// 9  (0.000121406710718475)
	 { { 0x884269b7 }, 0x3ffffff1},	// 10  (6.49735572721966e-005)
	 { { 0x8dfd8016 }, 0x3ffffff0},	// 11  (3.38531102386241e-005)
	 { { 0xb45dc2ad }, 0x3fffffee},	// 12  (1.07506663660217e-005)
	 { { 0xb8ebf107 }, 0x3fffffed},	// 13  (5.51109452651133e-006)
	 { { 0xd74010fc }, 0x3fffffee},	// 14  (1.28299152351019e-005)
	 { { 0xeec17fdc }, 0x3fffffed},	// 15  (7.11547902909615e-006)
	 { { 0x978b9918 }, 0xbfffffed},	// 16  (-4.51640202925319e-006)
	 { { 0xac1537ac }, 0xbfffffec},	// 17  (-2.56423474453982e-006)
	 { { 0xa9f633f7 }, 0x3fffffec},	// 18  (2.53262714178248e-006)
	 { { 0xbe88f146 }, 0x3fffffeb},	// 19  (1.41959586397178e-006)
};
#endif

// Chebyshev coefficients of ATan()
#ifdef CHEB_ATAN
const REALEXT REALNAME(ConstChebATan)[CHEB_ATAN] = {	// CHEB_ATAN = 14
	 { { 0xded3d42e }, 0x3ffffffe},	// 0  (0.870419751387089)
	 { { 0xd0a4a60d }, 0xbffffffb},	// 1  (-0.10187654235051)
	 { { 0xaad1804f }, 0x3ffffff9},	// 2  (0.0208518510844442)
	 { { 0xa4d9f15d }, 0xbffffff7},	// 3  (-0.00503086362186878)
	 { { 0xac6fcdd4 }, 0x3ffffff5},	// 4  (0.00131558787870745)
	 { { 0xbd4246d1 }, 0xbffffff3},	// 5  (-0.000360982690949641)
	 { { 0xd67728dc }, 0x3ffffff1},	// 6  (0.000102265103919308)
	 { { 0xf8b14690 }, 0xbfffffef},	// 7  (-2.9646454208887e-005)
	 { { 0x93414f63 }, 0x3fffffee},	// 8  (8.77708897562002e-006)
	 { { 0xb01a5c32 }, 0xbfffffec},	// 9  (-2.624138732088e-006)
	 { { 0xc7c664e4 }, 0x3fffffea},	// 10  (7.44219783577194e-007)
	 { { 0xf333ceef }, 0xbfffffe8},	// 11  (-2.26499863253959e-007)
	 { { 0xe161bc7f }, 0x3fffffe7},	// 12  (1.04951570961687e-007)
	 { { 0x8bc6b5e6 }, 0xbfffffe6},	// 13  (-3.2544185651906e-008)
};
#endif

// Chebyshev coefficients of Sqrt()
#ifdef CHEB_SQRT
const REALEXT REALNAME(ConstChebSqrt)[CHEB_SQRT] = {	// CHEB_SQRT = 20
	 { { 0xca62c1d7 }, 0x3fffffff},	// 0  (1.58113883016631)
	 { { 0xf2dce89b }, 0x3ffffffd},	// 1  (0.474341648980044)
	 { { 0x91b7bed2 }, 0xbffffffb},	// 2  (-0.0711512477719225)
	 { { 0xaedc7ea6 }, 0x3ffffff9},	// 3  (0.0213453744509025)
	 { { 0x83254fba }, 0xbffffff8},	// 4  (-0.00800450120732421)
	 { { 0xdc532110 }, 0x3ffffff6},	// 5  (0.00336188847722951)
	 { { 0xc650e8dd }, 0xbffffff5},	// 6  (-0.00151303141183234)
	 { { 0xbafcee60 }, 0x3ffffff4},	// 7  (0.00071330265927827)
	 { { 0xb5b2067b }, 0xbffffff3},	// 8  (-0.000346556494491779)
	 { { 0xb59ebc59 }, 0x3ffffff2},	// 9  (0.000173206387955815)
	 { { 0xc2779c9e }, 0xbffffff1},	// 10  (-9.27292030041826e-005)
	 { { 0xca4ffdea }, 0x3ffffff0},	// 11  (4.82350511958884e-005)
	 { { 0x80c2106b }, 0xbfffffef},	// 12  (-1.53491572163489e-005)
	 { { 0x83e2995f }, 0x3fffffee},	// 13  (7.86096768123912e-006)
	 { { 0x98e3ecd2 }, 0xbfffffef},	// 14  (-1.82259478975766e-005)
	 { { 0xa9891941 }, 0x3fffffee},	// 15  (1.01051057335155e-005)
	 { { 0xd6f71393 }, 0x3fffffed},	// 16  (6.40646047678217e-006)
	 { { 0xf41387eb }, 0xbfffffec},	// 17  (-3.6370201810243e-006)
	 { { 0xf147700d }, 0xbfffffec},	// 18  (-3.59533806904011e-006)
	 { { 0x8737a79f }, 0x3fffffec},	// 19  (2.01489629514384e-006)
};
#endif

// Cordic atan coefficients
#ifdef CORD_ATAN
const REAL REALNAME(ConstAtanInit) =	{ { 0x4dba76d4 }, };	// init value of atan table (=1/expansion factor)  (0.607252935008881)
const REAL REALNAME(ConstAtan)[CORD_ATAN] = {	// CORD_ATAN = 12
	 { { 0x6487ed51 }, },	// 0  (0.785398163397448)
	 { { 0x3b58ce0b }, },	// 1  (0.463647609000806)
	 { { 0x1f5b75f9 }, },	// 2  (0.244978663126864)
	 { { 0x0feadd4d }, },	// 3  (0.124354994546761)
	 { { 0x07fd56ee }, },	// 4  (0.0624188099959574)
	 { { 0x03ffaab7 }, },	// 5  (0.0312398334302683)
	 { { 0x01fff556 }, },	// 6  (0.0156237286204768)
	 { { 0x00fffeab }, },	// 7  (0.00781234106010111)
	 { { 0x007fffd5 }, },	// 8  (0.00390623013196697)
	 { { 0x003ffffb }, },	// 9  (0.00195312251647882)
	 { { 0x001fffff }, },	// 10  (0.000976562189559319)
	 { { 0x00100000 }, },	// 11  (0.000488281211194898)
};
#endif
