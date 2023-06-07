
// ****************************************************************************
//
//                           Constant Templates of real16
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// real16: size 2 bytes, 16 bits, mantissa 10 bits, exponent 5 bits

// Normal precision:
const REAL REALNAME(Const0) =	{ { 0x0000 }, };	// 0  (0)
const REAL REALNAME(Const1) =	{ { 0x3c00 }, };	// 1  (1)
const REAL REALNAME(ConstM1) =	{ { 0xbc00 }, };	// -1  (-1)
const REAL REALNAME(Const2) =	{ { 0x4000 }, };	// 2  (2)
const REAL REALNAME(Const3) =	{ { 0x4000 }, };	// 3  (3)
const REAL REALNAME(Const05) =	{ { 0x3800 }, };	// 0.5  (0.5)
const REAL REALNAME(ConstM05) =	{ { 0xb800 }, };	// -0.5  (-0.5)
const REAL REALNAME(Const075) =	{ { 0x3800 }, };	// 0.75  (0.75)
const REAL REALNAME(Const83) =	{ { 0x4155 }, };	// 8/3  (2.66666666666667)
const REAL REALNAME(Const10) =	{ { 0x4900 }, };	// 10  (10)
const REAL REALNAME(Const100) =	{ { 0x5440 }, };	// 100  (100)
const REAL REALNAME(ConstExpMax) =	{ { 0x49b3 }, };	// exp(x) max  (11.3972077083992)
const REAL REALNAME(ConstExpMin) =	{ { 0xc9b3 }, };	// exp(x) min  (-11.3972077083992)
const REAL REALNAME(Const01) =	{ { 0x2c66 }, };	// 0.1 (1e-1)  (0.1)
const REAL REALNAME(Const001) =	{ { 0x211f }, };	// 0.01 (1e-2)  (0.01)
const REAL REALNAME(Const1eM4) =	{ { 0x048e }, };	// 0.0001 (1e-4)  (0.0001)
const REAL REALNAME(Const1eM8) =	{ { 0x0000 }, };	// 0.00000001 (1e-8)  (1e-008)
const REAL REALNAME(ConstLn2) =	{ { 0x398c }, };	// ln(2)  (0.693147180559945)
const REAL REALNAME(ConstRLn2) =	{ { 0x3dc5 }, };	// 1/ln(2)  (1.44269504088896)
const REAL REALNAME(ConstLn10) =	{ { 0x409b }, };	// ln(10)  (2.30258509299405)
const REAL REALNAME(ConstRLn10) =	{ { 0x34f3 }, };	// 1/ln(10)  (0.434294481903252)
const REAL REALNAME(ConstLog2) =	{ { 0x34d1 }, };	// log(2)  (0.301029995663981)
const REAL REALNAME(ConstRLog2) =	{ { 0x40a5 }, };	// 1/log(2)  (3.32192809488736)
const REAL REALNAME(ConstEul) =	{ { 0x4170 }, };	// Eul  (2.71828182845905)
const REAL REALNAME(ConstPi05) =	{ { 0x3c48 }, };	// pi/2  (1.5707963267949)
const REAL REALNAME(ConstMPi05) =	{ { 0xbc48 }, };	// -pi/2  (-1.5707963267949)
const REAL REALNAME(ConstPi) =	{ { 0x4048 }, };	// pi  (3.14159265358979)
const REAL REALNAME(ConstMPi) =	{ { 0xc048 }, };	// -pi  (-3.14159265358979)
const REAL REALNAME(ConstPi2) =	{ { 0x4448 }, };	// pi*2  (6.28318530717959)
const REAL REALNAME(ConstMPi2) =	{ { 0xc448 }, };	// -pi*2  (-6.28318530717959)
const REAL REALNAME(ConstRPi2) =	{ { 0x3118 }, };	// 1/pi*2  (0.159154943091895)
const REAL REALNAME(ConstLnPi22) =	{ { 0x395a }, };	// ln(pi*2)/2  (0.918938533204673)
const REAL REALNAME(Const180Pi) =	{ { 0x5129 }, };	// 180/pi  (57.2957795130823)
const REAL REALNAME(ConstPi180) =	{ { 0x2478 }, };	// pi/180  (0.0174532925199433)
const REAL REALNAME(Const200Pi) =	{ { 0x51f5 }, };	// 200/pi  (63.6619772367581)
const REAL REALNAME(ConstPi200) =	{ { 0x2405 }, };	// pi/200  (0.015707963267949)
const REAL REALNAME(ConstPhi) =	{ { 0x3c79 }, };	// phi (sectio aurea = (1 + sqrt(5))/2)  (1.61803398874989)
const REAL REALNAME(ConstSqrt2) =	{ { 0x3da8 }, };	// sqrt(2)  (1.4142135623731)
const REAL REALNAME(ConstRSqrt2) =	{ { 0x39a8 }, };	// 1/sqrt(2)  (0.707106781186548)

// Extended precision:
const REALEXT REALNAME(Const0Ext) =	{ { 0x0000 }, 0x00000000};	// 0  (0)
const REALEXT REALNAME(Const1Ext) =	{ { 0x8000 }, 0x3fffffff};	// 1  (1)
const REALEXT REALNAME(ConstM1Ext) =	{ { 0x8000 }, 0xbfffffff};	// -1  (-1)
const REALEXT REALNAME(Const2Ext) =	{ { 0x8000 }, 0x40000000};	// 2  (2)
const REALEXT REALNAME(Const3Ext) =	{ { 0xc000 }, 0x40000000};	// 3  (3)
const REALEXT REALNAME(Const05Ext) =	{ { 0x8000 }, 0x3ffffffe};	// 0.5  (0.5)
const REALEXT REALNAME(ConstM05Ext) =	{ { 0x8000 }, 0xbffffffe};	// -0.5  (-0.5)
const REALEXT REALNAME(Const075Ext) =	{ { 0xc000 }, 0x3ffffffe};	// 0.75  (0.75)
const REALEXT REALNAME(Const83Ext) =	{ { 0xaaab }, 0x40000000};	// 8/3  (2.66666666666667)
const REALEXT REALNAME(Const10Ext) =	{ { 0xa000 }, 0x40000002};	// 10  (10)
const REALEXT REALNAME(Const100Ext) =	{ { 0xc800 }, 0x40000005};	// 100  (100)
const REALEXT REALNAME(ConstExpMaxExt) =	{ { 0xb172 }, 0x4000001b};	// exp(x) max  (372130559.284299)
const REALEXT REALNAME(ConstExpMinExt) =	{ { 0xb172 }, 0xc000001b};	// exp(x) min  (-372130559.284299)
const REALEXT REALNAME(Const01Ext) =	{ { 0xcccd }, 0x3ffffffb};	// 0.1 (1e-1)  (0.1)
const REALEXT REALNAME(Const001Ext) =	{ { 0xa3d7 }, 0x3ffffff8};	// 0.01 (1e-2)  (0.01)
const REALEXT REALNAME(Const1eM4Ext) =	{ { 0xd1b7 }, 0x3ffffff1};	// 0.0001 (1e-4)  (0.0001)
const REALEXT REALNAME(Const1eM8Ext) =	{ { 0xabcc }, 0x3fffffe4};	// 0.00000001 (1e-8)  (1e-008)
const REALEXT REALNAME(ConstLn2Ext) =	{ { 0xb172 }, 0x3ffffffe};	// ln(2)  (0.693147180559945)
const REALEXT REALNAME(ConstRLn2Ext) =	{ { 0xb8aa }, 0x3fffffff};	// 1/ln(2)  (1.44269504088896)
const REALEXT REALNAME(ConstLn10Ext) =	{ { 0x935e }, 0x40000000};	// ln(10)  (2.30258509299405)
const REALEXT REALNAME(ConstRLn10Ext) =	{ { 0xde5c }, 0x3ffffffd};	// 1/ln(10)  (0.434294481903252)
const REALEXT REALNAME(ConstLog2Ext) =	{ { 0x9a21 }, 0x3ffffffd};	// log(2)  (0.301029995663981)
const REALEXT REALNAME(ConstRLog2Ext) =	{ { 0xd49a }, 0x40000000};	// 1/log(2)  (3.32192809488736)
const REALEXT REALNAME(ConstEulExt) =	{ { 0xadf8 }, 0x40000000};	// Eul  (2.71828182845905)
const REALEXT REALNAME(ConstPi05Ext) =	{ { 0xc910 }, 0x3fffffff};	// pi/2  (1.5707963267949)
const REALEXT REALNAME(ConstMPi05Ext) =	{ { 0xc910 }, 0xbfffffff};	// -pi/2  (-1.5707963267949)
const REALEXT REALNAME(ConstPiExt) =	{ { 0xc910 }, 0x40000000};	// pi  (3.14159265358979)
const REALEXT REALNAME(ConstMPiExt) =	{ { 0xc910 }, 0xc0000000};	// -pi  (-3.14159265358979)
const REALEXT REALNAME(ConstPi2Ext) =	{ { 0xc910 }, 0x40000001};	// pi*2  (6.28318530717959)
const REALEXT REALNAME(ConstMPi2Ext) =	{ { 0xc910 }, 0xc0000001};	// -pi*2  (-6.28318530717959)
const REALEXT REALNAME(ConstRPi2Ext) =	{ { 0xa2fa }, 0x3ffffffc};	// 1/pi*2  (0.159154943091895)
const REALEXT REALNAME(ConstLnPi22Ext) =	{ { 0xeb40 }, 0x3ffffffe};	// ln(pi*2)/2  (0.918938533204673)
const REALEXT REALNAME(Const180PiExt) =	{ { 0xe52f }, 0x40000004};	// 180/pi  (57.2957795130823)
const REALEXT REALNAME(ConstPi180Ext) =	{ { 0x8efa }, 0x3ffffff9};	// pi/180  (0.0174532925199433)
const REALEXT REALNAME(Const200PiExt) =	{ { 0xfea6 }, 0x40000004};	// 200/pi  (63.6619772367581)
const REALEXT REALNAME(ConstPi200Ext) =	{ { 0x80ae }, 0x3ffffff9};	// pi/200  (0.015707963267949)
const REALEXT REALNAME(ConstPhiExt) =	{ { 0xcf1c }, 0x3fffffff};	// phi (sectio aurea = (1 + sqrt(5))/2)  (1.61803398874989)
const REALEXT REALNAME(ConstSqrt2Ext) =	{ { 0xb505 }, 0x3fffffff};	// sqrt(2)  (1.4142135623731)
const REALEXT REALNAME(ConstRSqrt2Ext) =	{ { 0xb505 }, 0x3ffffffe};	// 1/sqrt(2)  (0.707106781186548)

// Decimal exponents (index REAL_DECEXP = number '1')
const REAL REALNAME(ConstExp)[REAL_DECEXP*2+1] = {	// total 7 numbers
	 { { 0x048e }, },	// 1e-4 (1e-0x4)  (0.0001)
	 { { 0x211f }, },	// 1e-2 (1e-0x2)  (0.01)
	 { { 0x2c66 }, },	// 1e-1 (1e-0x1)  (0.1)
	 { { 0x3c00 }, },	// 1e+0 (1e+0x0)  (1)
	 { { 0x4900 }, },	// 1e+1 (1e+0x1)  (10)
	 { { 0x5440 }, },	// 1e+2 (1e+0x2)  (100)
	 { { 0x70e2 }, },	// 1e+4 (1e+0x4)  (10000)
};

// Factorial coefficients
#ifdef FACT_COEFF
const REALEXT REALNAME(ConstFact)[FACT_COEFF] = {	// FACT_COEFF = 2
	 { { 0xaaab }, 0x3ffffffb},	// a0  (0.0833333333333333)
	 { { 0x8889 }, 0x3ffffffa},	// a1  (0.0333333333333333)
};
#endif

// Chebyshev coefficients of Ln()
#ifdef CHEB_LN
const REALEXT REALNAME(ConstChebLn)[CHEB_LN] = {	// CHEB_LN = 7
	 { { 0xcf99 }, 0x3ffffffd},	// 0  (0.405464172363281)
	 { { 0xaaac }, 0x3ffffffd},	// 1  (0.333343505859375)
	 { { 0xe391 }, 0xbffffffa},	// 2  (-0.0555582046508789)
	 { { 0xc930 }, 0x3ffffff8},	// 3  (0.0122795104980469)
	 { { 0xc900 }, 0xbffffff6},	// 4  (-0.0030670166015625)
	 { { 0xf951 }, 0x3ffffff4},	// 5  (0.000951066613197327)
	 { { 0x8b82 }, 0xbffffff3},	// 6  (-0.000266090035438538)
};
#endif

// Chebyshev coefficients of Exp()
#ifdef CHEB_EXP
const REALEXT REALNAME(ConstChebExp)[CHEB_EXP] = {	// CHEB_EXP = 7
	 { { 0x8000 }, 0x3fffffff},	// 0  (1)
	 { { 0xb172 }, 0x3ffffffe},	// 1  (0.693145751953125)
	 { { 0xf5fe }, 0x3ffffffc},	// 2  (0.240226745605469)
	 { { 0xe34a }, 0x3ffffffa},	// 3  (0.0554904937744141)
	 { { 0x9d90 }, 0x3ffffff8},	// 4  (0.00961685180664063)
	 { { 0xb24b }, 0x3ffffff5},	// 5  (0.00136026740074158)
	 { { 0xa3f6 }, 0x3ffffff2},	// 6  (0.00015636533498764)
};
#endif

// Chebyshev coefficients of Sin()
#ifdef CHEB_SIN
const REALEXT REALNAME(ConstChebSin)[CHEB_SIN] = {	// CHEB_SIN = 9
	 { { 0xb505 }, 0x3ffffffe},	// 0  (0.707107543945313)
	 { { 0x8e2c }, 0x3ffffffe},	// 1  (0.55535888671875)
	 { { 0xdf53 }, 0xbffffffc},	// 2  (-0.218090057373047)
	 { { 0xe9dd }, 0xbffffffa},	// 3  (-0.0570955276489258)
	 { { 0xb7ad }, 0x3ffffff8},	// 4  (0.0112106800079346)
	 { { 0xe6c4 }, 0x3ffffff5},	// 5  (0.00176060199737549)
	 { { 0xf1ae }, 0xbffffff2},	// 6  (-0.000230483710765839)
	 { { 0xd4cf }, 0xbfffffef},	// 7  (-2.53687612712383e-005)
	 { { 0xa7ca }, 0x3fffffec},	// 8  (2.50025186687708e-006)
};
#endif

// Chebyshev coefficients of ASin()
#ifdef CHEB_ASIN
const REALEXT REALNAME(ConstChebASin)[CHEB_ASIN] = {	// CHEB_ASIN = 8
	 { { 0xc4cf }, 0x3ffffffd},	// 0  (0.384391784667969)
	 { { 0xcf1d }, 0x3ffffffd},	// 1  (0.404518127441406)
	 { { 0x8802 }, 0x3ffffffa},	// 2  (0.0332050323486328)
	 { { 0x8733 }, 0x3ffffff9},	// 3  (0.0165038108825684)
	 { { 0x987a }, 0x3ffffff7},	// 4  (0.0046532154083252)
	 { { 0x8bac }, 0x3ffffff6},	// 5  (0.00213122367858887)
	 { { 0xe898 }, 0x3ffffff5},	// 6  (0.00177454948425293)
	 { { 0xe586 }, 0x3ffffff4},	// 7  (0.000875562429428101)
};
#endif

// Chebyshev coefficients of ATan()
#ifdef CHEB_ATAN
const REALEXT REALNAME(ConstChebATan)[CHEB_ATAN] = {	// CHEB_ATAN = 6
	 { { 0xded4 }, 0x3ffffffe},	// 0  (0.87042236328125)
	 { { 0xd0a5 }, 0xbffffffb},	// 1  (-0.101877212524414)
	 { { 0xaa48 }, 0x3ffffff9},	// 2  (0.0207862854003906)
	 { { 0xa43a }, 0xbffffff7},	// 3  (-0.00501179695129395)
	 { { 0xc2ad }, 0x3ffffff5},	// 4  (0.00148525834083557)
	 { { 0xd721 }, 0xbffffff3},	// 5  (-0.000410325825214386)
};
#endif

// Chebyshev coefficients of Sqrt()
#ifdef CHEB_SQRT
const REALEXT REALNAME(ConstChebSqrt)[CHEB_SQRT] = {	// CHEB_SQRT = 8
	 { { 0xca63 }, 0x3fffffff},	// 0  (1.58114624023438)
	 { { 0xf2dd }, 0x3ffffffd},	// 1  (0.474342346191406)
	 { { 0x9209 }, 0xbffffffb},	// 2  (-0.0713062286376953)
	 { { 0xaf82 }, 0x3ffffff9},	// 3  (0.0214242935180664)
	 { { 0xee13 }, 0xbffffff7},	// 4  (-0.00726544857025146)
	 { { 0xc3a2 }, 0x3ffffff6},	// 5  (0.00298511981964111)
	 { { 0xa824 }, 0xbffffff6},	// 6  (-0.00256562232971191)
	 { { 0xa392 }, 0x3ffffff5},	// 7  (0.00124794244766235)
};
#endif

// Cordic atan coefficients
#ifdef CORD_ATAN
const REAL REALNAME(ConstAtanInit) =	{ { 0x4dbb }, };	// init value of atan table (=1/expansion factor)  (0.607252935103139)
const REAL REALNAME(ConstAtan)[CORD_ATAN] = {	// CORD_ATAN = 7
	 { { 0x6488 }, },	// 0  (0.785398163397448)
	 { { 0x3b59 }, },	// 1  (0.463647609000806)
	 { { 0x1f5c }, },	// 2  (0.244978663126864)
	 { { 0x0feb }, },	// 3  (0.124354994546761)
	 { { 0x07fd }, },	// 4  (0.0624188099959574)
	 { { 0x0400 }, },	// 5  (0.0312398334302683)
	 { { 0x0200 }, },	// 6  (0.0156237286204768)
};
#endif
