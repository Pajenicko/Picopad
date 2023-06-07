
// ****************************************************************************
//
//                          2D Transformation Matrix
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_MAT2D			// use 2D transformation matrix (lib_mat2d.c, lib_mat2d.h)

#include "../inc/lib_mat2d.h"

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
	float shearx, float sheary, float r, float tx, float ty)
{
	// initialize to base unit matrix
	Mat2D_Unit(m);

	// set reference point
	Mat2D_TransX(m, x0);
	Mat2D_TransY(m, y0);

	// rotate image around its center
	Mat2D_Rot(m, r);

	// shear after scalling and before rotation
	Mat2D_ShearX(m, shearx);
	Mat2D_ShearY(m, sheary);

	// scale image to destination size
	Mat2D_ScaleX(m, (wd == 0) ? 0 : (1.0f/wd));
	Mat2D_ScaleY(m, (hd == 0) ? 0 : (1.0f/hd));

	// resize from image size to unit size
	Mat2D_ScaleX(m, ws);
	Mat2D_ScaleY(m, hs);

	// shift
	Mat2D_TransX(m, tx);
	Mat2D_TransY(m, ty);
}

// export matrix to int array[6]
void Mat2D_ExportInt(const sMat2D* m, int* mat)
{
	mat[0] = TOFRACT(m->m11);
	mat[1] = TOFRACT(m->m12);
	mat[2] = TOFRACT(m->m13);
	mat[3] = TOFRACT(m->m21);
	mat[4] = TOFRACT(m->m22);
	mat[5] = TOFRACT(m->m23);
}

#endif // USE_MAT2D			// use 2D transformation matrix (lib_mat2d.c, lib_mat2d.h)
