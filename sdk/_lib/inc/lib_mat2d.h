
// ****************************************************************************
//
//                          2D Transformation Matrix
//
// ****************************************************************************

#define FRACT		12	// number of bits of fractional part of fractint number (use max. 13, min. 8)
#define FRACTMUL (1<<FRACT)	// - update vga_config.h too
#define TOFRACT(f) ((int)((f)*FRACTMUL + (((f) < 0) ? -0.5f : 0.5f)))

#if USE_MAT2D			// use 2D transformation matrix (lib_mat2d.c, lib_mat2d.h)

#ifndef _MAT2D_H
#define _MAT2D_H

#ifdef __cplusplus
extern "C" {
#endif

// transformation matrix
typedef struct {
	float m11, m12, m13;
	float m21, m22, m23;
} sMat2D;

// trasform X
INLINE float Mat2D_GetX(sMat2D* m, float x, float y)
{
	return x * m->m11 + y * m->m12 + m->m13;
}	

// trasform Y
INLINE float Mat2D_GetY(sMat2D* m, float x, float y)
{
	return x * m->m21 + y * m->m22 + m->m23;
}	

// set unit matrix
INLINE void Mat2D_Unit(sMat2D* m)
{
	m->m11 = 1; m->m12 = 0; m->m13 = 0;
	m->m21 = 0; m->m22 = 1; m->m23 = 0;
}

// copy from another matrix
INLINE void Mat2D_Copy(sMat2D* m, const sMat2D* src)
{
	m->m11 = src->m11; m->m12 = src->m12; m->m13 = src->m13;
	m->m21 = src->m21; m->m22 = src->m22; m->m23 = src->m23;
}

// translate in X direction
//  1  0 tx   m11 m12 m13   m11 m12 m13+tx
//  0  1  0 * m21 m22 m23 = m21 m22 m23
//  0  0  1     0   0   1    0   0   1
INLINE void Mat2D_TransX(sMat2D* m, float tx)
{
	m->m13 += tx;
}

// translate in Y direction
//  1  0  0   m11 m12 m13   m11 m12 m13
//  0  1 ty * m21 m22 m23 = m21 m22 m23+ty
//  0  0  1     0   0   1    0   0   1
INLINE void Mat2D_TransY(sMat2D* m, float ty)
{
	m->m23 += ty;
}

// scale in X direction
//  sx 0  0   m11 m12 m13    m11*sx m12*sx m13*sx
//  0  1  0 * m21 m22 m23  = m21    m22    m23
//  0  0  1     0   0   1      0      0      1
INLINE void Mat2D_ScaleX(sMat2D* m, float sx)
{
	m->m11 *= sx;
	m->m12 *= sx;
	m->m13 *= sx;
}	

// scale in Y direction
//  1  0  0   m11 m12 m13    m11    m12    m13
//  0  sy 0 * m21 m22 m23  = m21*sy m22*sy m23*sy
//  0  0  1     0   0   1      0      0      1
INLINE void Mat2D_ScaleY(sMat2D* m, float sy)
{
	m->m21 *= sy;
	m->m22 *= sy;
	m->m23 *= sy;
}	

// rotate, using sin and cos
//  cosa -sina  0   m11 m12 m13   m11*cosa-m21*sina  m12*cosa-m22*sina  m13*cosa-m23*sina
//  sina  cosa  0 * m21 m22 m23 = m11*sina+m21*cosa  m12*sina+m22*cosa  m13*sina+m23*cosa
//   0      0   1     0   0   1           0                    0                 1
INLINE void Mat2D_RotSC(sMat2D* m, float sina, float cosa)
{
	float t1 = m->m11;
	float t2 = m->m21;
	m->m11 = t1*cosa - t2*sina;
	m->m21 = t1*sina + t2*cosa;

	t1 = m->m12;
	t2 = m->m22;
	m->m12 = t1*cosa - t2*sina;
	m->m22 = t1*sina + t2*cosa;

	t1 = m->m13;
	t2 = m->m23;
	m->m13 = t1*cosa - t2*sina;
	m->m23 = t1*sina + t2*cosa;
}

// rotate, using angle
INLINE void Mat2D_Rot(sMat2D* m, float a)
{
	Mat2D_RotSC(m, sinf(a), cosf(a));
}

// rotate by 90 deg (sina=1, cosa=0)
INLINE void Mat2D_Rot90(sMat2D* m)
{
	float t = m->m11;
	m->m11 = - m->m21;
	m->m21 = t;

	t = m->m12;
	m->m12 = - m->m22;
	m->m22 = t;

	t = m->m13;
	m->m13 = - m->m23;
	m->m23 = t;
}

// rotate by 180 deg (=flipX and flipY) (sina=0, cosa=-1)
INLINE void Mat2D_Rot180(sMat2D* m)
{
	m->m11 = - m->m11;
	m->m21 = - m->m21;
	m->m12 = - m->m12;
	m->m22 = - m->m22;
	m->m13 = - m->m13;
	m->m23 = - m->m23;
}

// rotate by 270 deg (sina=-1, cosa=0)
INLINE void Mat2D_Rot270(sMat2D* m)
{
	float t = m->m11;
	m->m11 = m->m21;
	m->m21 = -t;

	t = m->m12;
	m->m12 = m->m22;
	m->m22 = -t;

	t = m->m13;
	m->m13 = m->m23;
	m->m23 = -t;
}

// Shear in X direction
//  1  dx 0   m11 m12 m13   m11+m21*dx m12+m22*dx m13+m23*dx
//  0  1  0 * m21 m22 m23 = m21        m22        m23
//  0  0  1     0   0   1     0          0          1
INLINE void Mat2D_ShearX(sMat2D* m, float dx)
{
	m->m11 += m->m21*dx;
	m->m12 += m->m22*dx;
	m->m13 += m->m23*dx;
}

// Shear in Y direction
//  1  0  0   m11 m12 m13   m11        m12        m13
//  dy 1  0 * m21 m22 m23 = m21+m11*dy m22+m12*dy m23+m13*dy
//  0  0  1     0   0   1     0          0          1
INLINE void Mat2D_ShearY(sMat2D* m, float dy)
{
	m->m21 += m->m11*dy;
	m->m22 += m->m12*dy;
	m->m23 += m->m13*dy;
}

// flip in Y direction
//  1  0  0   m11 m12 m13     m11   m12    m13
//  0 -1  0 * m21 m22 m23  = -m21  -m22   -m23
//  0  0  1     0   0   1      0     0      1
INLINE void Mat2D_FlipY(sMat2D* m)
{
	m->m21 = - m->m21;
	m->m22 = - m->m22;
	m->m23 = - m->m23;
}	

// flip in X direction
//  -1 0  0   m11 m12 m13    -m11  -m12   -m13
//  0  1  0 * m21 m22 m23  = m21    m22    m23
//  0  0  1     0   0   1      0      0      1
INLINE void Mat2D_FlipX(sMat2D* m)
{
	m->m11 = - m->m11;
	m->m12 = - m->m12;
	m->m13 = - m->m13;
}

// prepare transformation matrix (for DrawImgMat function)
//  ws ... source image width
//  hs ... source image height
//  x0 ... reference point X on source image
//  y0 ... reference point Y on source image
//  wd ... destination image width (negative = flip image in X direction)
//  hd ... destination image height (negative = flip image in Y direction)
//  shearx ... shear image in X direction
//  sheary ... shear image in Y direction
//  r ... rotate image (angle in radians)
//  tx ... shift in X direction (ws = whole image width)
//  ty ... shift in Y direction (hs = whole image height)
void Mat2D_PrepDrawImg(sMat2D* m, int ws, int hs, int x0, int y0, int wd, int hd,
	float shearx, float sheary, float r, float tx, float ty);

// export matrix to int array[6]
void Mat2D_ExportInt(const sMat2D* m, int* mat);

#ifdef __cplusplus
}
#endif

#endif // _MAT2D_H

#endif // USE_MAT2D			// use 2D transformation matrix (lib_mat2d.c, lib_mat2d.h)
