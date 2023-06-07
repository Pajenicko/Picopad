
// ****************************************************************************
//
//                               3D Vector
//
// ****************************************************************************

#ifndef _VECTOR_H
#define _VECTOR_H

// 3D vector
class V3
{
public:
	
	// vector coordinates
	flt x, y, z;

	// constructor
	V3() {};
	V3(flt xx, flt yy, flt zz) { x = xx; y = yy; z = zz; }

	// compare vectors
	inline bool Equ(const V3 &v) { return (x == v.x) && (y == v.y) && (z == v.z); }

	// set value
	void Zero() { x = y = z = 0; }
	void SetX() { x = 1; y = 0; z = 0; }
	void SetY() { x = 0; y = 1; z = 0; }
	void SetZ() { x = 0; y = 0; z = 1; }
	void Set(flt xx, flt yy, flt zz) { x = xx; y = yy; z = zz; }
	void Set(const V3 &v) { x = v.x; y = v.y; z = v.z; }
	V3& operator = (const V3 &v) { x = v.x; y = v.y; z = v.z; return *this; }

	// set normalized vector (set length to 1)
	void SetNorm(const V3 &v)
	{
		flt r = (flt)sqrtf(v.x*v.x + v.y*v.y + v.z*v.z);
		if (r == 0)
		{
			x = y = 0;
			z = 1;
		}
		else
		{
			r = 1/r;
			x = v.x * r;
			y = v.y * r;
			z = v.z * r;
		}
	}

	// add two vectors
	void Add(flt xx, flt yy, flt zz) { x += xx; y += yy; z += zz; }
	void Add(const V3 &v) { x += v.x; y += v.y; z += v.z; }
	V3 operator + (const V3 &v) const { return V3(x + v.x, y + v.y, z + v.z); }
	V3& operator += (const V3 &v) { x += v.x; y += v.y; z += v.z; return *this; }

	// subtract two vectors
	void Sub(flt xx, flt yy, flt zz) { x -= xx; y -= yy; z -= zz; }
	void Sub(const V3 &v) { x -= v.x; y -= v.y; z -= v.z; }
	V3 operator - (const V3 &v) const { return V3(x - v.x, y - v.y, z - v.z); }
	V3& operator -= (const V3 &v) { x -= v.x; y -= v.y; z -= v.z; return *this; }

	// unary negation, turn vector into inverse direction
	void Inv() { x = -x; y = -y; z = -z; }
	V3 operator - () const { return V3(-x, -y, -z); }

	// multiplication by scalar value
	void Mul(flt k) { x *= k; y *= k; z *= k; }
	V3 operator * (const flt &k) const { return V3(x*k, y*k, z*k); }
	V3& operator *= (const flt &k) { x *= k; y *= k; z *= k; return *this; }

	// division
	void Div(flt k) { k = 1/k; x *= k; y *= k; z *= k; }
	V3 operator / (flt k) const { k = 1/k; return V3(x*k, y*k, z*k); }
	V3& operator /= (flt k) { k = 1/k; x *= k; y *= k; z *= k; return *this; }

	// length of vector
	flt Len2() const { return x*x + y*y + z*z; }
	flt Len() const { return (flt)sqrt(x*x + y*y + z*z); }

	// distance of two vectors
	flt Dist2(const V3 &v) const
	{
		flt dx = x - v.x;
		flt dy = y - v.y;
		flt dz = z - v.z;
		return dx*dx + dy*dy + dz*dz;
	}
	flt Dist(const V3 &v) const { return (flt)sqrt(Dist2(v)); }

	// normalize vector (set length to 1)
	void Norm()
	{
		flt r = (flt)sqrtf(x*x + y*y + z*z);
		if (r == 0)
			{ x = 0; y = 0; z = 1; }
		else
			{ r = 1/r; x *= r; y *= r; z *= r; }
	}

	// scalar (dot) product V1.V2 (result is cosinus of angle of two vectors * lengths of vectors)
	flt Dot(const V3 &v) const { return x*v.x + y*v.y + z*v.z; }
	flt Angle(const V3 &v)
	{
		flt r = (flt)sqrtf(Len2()*v.Len2());
		if (r == 0) return 0;
		return (flt)acosf((x*v.x + y*v.y + z*v.z)/r);
	}

	// vector (cross) product V1xV2, multiply two vectors and store result into this vector 
	// (result is perpendicular normal vector to this two vectors)
	void Mul(const V3 &v1, const V3 &v2)
	{
		flt xx = v1.y * v2.z - v1.z * v2.y;
		flt yy = v1.z * v2.x - v1.x * v2.z;
		flt zz = v1.x * v2.y - v1.y * v2.x;
		x = xx;
		y = yy;
		z = zz;
	}
	V3 operator * (const V3 &v) const { return V3(y*v.z - z*v.y, z*v.x - x*v.z, x*v.y - y*v.x); }
};

#endif // _VECTOR_H
