
// ****************************************************************************
//
//                               Ray-trace rendering
//
// ****************************************************************************

#include "../include.h"

#include "vector.h"		// 3D vector
#include "sphere.h"		// 3D sphere object

// list of spheres
const Sphere Spheres[] = {
	// position, radius, color, reflection, transparency (transparency not realized)
	Sphere(V3(-1.5,-0.4,1), 1, V3(1,1,0), 0.5, 0), // yellow sphere
	Sphere(V3(0,0.4,0), 1, V3(1,0,0), 0.5, 0),  // red sphere
	Sphere(V3(2,-0.1,-6), 2, V3(0,0,(flt)0.4), (flt)0.7, 0), // blue sphere
	Sphere(V3(3,0.2,1), 1.5, V3(0,(flt)0.5,0), (flt)0.6, 0), // green sphere
};
#define OBJNUM count_of(Spheres)

const V3 Camera(0, 0, 10);		// camera position
const V3 Light(-6, 4, 10);		// light position
const flt Ambient = (flt)0.3;	// intensity of ambient light
const V3 BackCol((flt)0.4, (flt)0.6, 1); // background color in horizon

#define TOOFAR 1e10
#define FLOORY -2			// floor Y position
#define DEPTHMAX 6			// max. depth of trace

// trace ray
void Trace(V3* rgb, const V3 &orig, const V3 &dir, int depth, const Sphere* disable)
{
	// find nearest intersection
	flt t1best = TOOFAR, t2best = TOOFAR;
	const Sphere* sbest = NULL;
	flt t1, t2;
	int i;
	for (i = 0; i < OBJNUM; i++)
	{
		if (&Spheres[i] == disable) continue;
		t1 = TOOFAR;
		t2 = TOOFAR;
		if (Spheres[i].Intersect(orig, dir, &t1, &t2))
		{
			if (t1 < 0) t1 = t2;
			if (t1 < t1best)
			{
				t1best = t1;
				t2best = t2;
				sbest = &Spheres[i];
			}
		}
	}

	// if object not found, return sky color or continue with floor plane
	V3 col, pos, norm;
	flt refl;
	if (sbest == NULL)
	{
		// sky (black in top direction)
		flt k = dir.y;
		if (dir.y >= 0)
		{
			k *= 2.5;
			if (k > 1) k = 1;
			*rgb = BackCol*(1-k);
			return;
		}

		// floor - substitute with plane parameters
		t1best = (orig.y - FLOORY) / dir.y;
		pos = orig - (dir*t1best);
		norm.Set(0,1,0);
		col = ((int)(ceilf(pos.x) + ceilf(pos.z)) & 1) ? V3(1,1,1) : V3(1,0.25,0.25);
		refl = (flt)0.4;
	}
	else
	{
		// coordinate and normal in intersection point
		pos = orig + (dir*t1best);
		norm = pos - sbest->pos;
		norm.Norm();
		col = sbest->col;
		refl = sbest->ref;
	}

	// if normal and ray direction are not opposited, we are inside sphere, then reverse normal
	bool inside = false;
	if (dir.Dot(norm) > 0)
	{
		inside = true;
		norm.Inv();
	}

	// vector to light
	V3 light = Light - pos;
	light.Norm();

	// check if point is in shadow
	flt intens = 1;
	for (i = 0; i < OBJNUM; i++)
	{
		if (sbest == &Spheres[i]) continue;
		if (Spheres[i].Intersect(pos, light, &t1, &t2))
		{
			intens = 0;
			break;
		}
	}

	// get diffusion color
	intens = intens*norm.Dot(light)*(1-Ambient);
	if (intens <= 0) intens = 0;
	*rgb = col * (intens + Ambient);

	// add reflection
	if ((refl > 0) && (depth < DEPTHMAX))
	{
		// reflection vector
		V3 rdir = dir - norm*2*dir.Dot(norm);
		rdir.Norm();

		// add reflection
		V3 rgb2;
		Trace(&rgb2, pos, rdir, depth + 1, sbest);
		*rgb *= 1 - refl;
		*rgb += rgb2 * refl;
	}
}

/*
// render image fast
void Render3DFast()
{
	// local variables
	int tmp;
	int x, y;			// current X and Y coordinates in bitmap
	flt xx, yy;		// current X and Y coordinates in viewing plane
	V3 rgbV;			// result pixel color as vactor 0..1
	V3 orig(0, 0, 10);	// camera position
	V3 dir;				// ray direction
	flt fov = 45*PI/180; // field of view in degrees
	flt tfov = (flt)tanf(fov/2); // height/2 of viewing plane
	flt ar = WIDTH/(flt)HEIGHT; // aspect ratio
	u16* dst = &FrameBuf[0];
	int red, green, blue;

	// render picture
	for (y = HEIGHT-2; y >= 0; y -= 2)
	{
		for (x = 0; x < WIDTH; x += 2)
		{
			// ray direction vector
			xx = (flt)(2*(x + 0.5)/WIDTH - 1) * tfov * ar;
			yy = (flt)(2*(y + 0.5)/HEIGHT - 1) * tfov;
			dir.Set(xx, yy, -1);
			dir.Norm();

			// trace this ray
			Trace(&rgbV, Camera, dir, 0, NULL);

			// convert vector to RGB pixel
			tmp = (int)(rgbV.x*256 + 0.5);
			if (tmp < 0) tmp = 0;
			if (tmp > 255) tmp = 255;
			red =  tmp; // red

			tmp = (int)(rgbV.y*256 + 0.5);
			if (tmp < 0) tmp = 0;
			if (tmp > 255) tmp = 255;
			green =  tmp; // green

			tmp = (int)(rgbV.z*256 + 0.5);
			if (tmp < 0) tmp = 0;
			if (tmp > 255) tmp = 255;
			blue =  tmp; // blue

			*dst++ = RGBTO16(red, green, blue);

		}
		dst += WIDTH;

		DispDirtyRect(0, DispHeight - 2 - y, DispWidth, 2);
		DispUpdate();
	}
}
*/

// render image (useaa = use antialiasing)
void Render3D(/*Bool useaa*/)
{
	// local variables
	int tmp;
	int x, y;			// current X and Y coordinates in bitmap
	flt xx, yy;		// current X and Y coordinates in viewing plane
	V3 rgbV;			// result pixel color as vactor 0..1
	V3 orig(0, 0, 10);	// camera position
	V3 dir;				// ray direction
	flt fov = 45*PI/180; // field of view in degrees
	flt tfov = (flt)tanf(fov/2); // height/2 of viewing plane
	flt ar = WIDTH/(flt)HEIGHT; // aspect ratio
	int red, green, blue;

	// render picture
#if RENDER_BOTHCORES	// 1 = use both cores to render, 0 = use only core 0
	u16* dst = &FrameBuf[(CpuID() == 0) ? 0 : WIDTH];
	y = (CpuID() == 0) ? (HEIGHT-1) : (HEIGHT-2);
	for (; y >= 0; y -= 2)
	{
#else
	u16* dst = &FrameBuf[0];
	for (y = HEIGHT-1; y >= 0; y--)
	{
#endif
		for (x = 0; x < WIDTH; x++)
		{
/*
			// use antialiasing
			if (useaa)
			{
				int ix, iy;
				V3 rgbVtmp;
				rgbV.Zero();
				for (iy = 0; iy < 3; iy++)
				{
					for (ix = 0; ix < 3; ix++)
					{
						// ray direction vector
						xx = (flt)(2*(x + ix/(flt)3 + 1/(flt)6)/WIDTH - 1) * tfov * ar;
						yy = (flt)(2*(y + iy/(flt)3 + 1/(flt)6)/HEIGHT - 1) * tfov;
						dir.Set(xx, yy, -1);
						dir.Norm();

						// trace this ray
						Trace(&rgbVtmp, Camera, dir, 0, NULL);
						rgbV += rgbVtmp;
					}
				}
				rgbV *= (flt)1/9;
			}

			// no antialiasing
			else
*/
			{
				// ray direction vector
				xx = (flt)(2*(x + 0.5)/WIDTH - 1) * tfov * ar;
				yy = (flt)(2*(y + 0.5)/HEIGHT - 1) * tfov;
				dir.Set(xx, yy, -1);
				dir.Norm();

				// trace this ray
				Trace(&rgbV, Camera, dir, 0, NULL);
			}

			// convert vector to RGB pixel
			tmp = (int)(rgbV.x*256 + 0.5);
			if (tmp < 0) tmp = 0;
			if (tmp > 255) tmp = 255;
			red =  tmp; // red

			tmp = (int)(rgbV.y*256 + 0.5);
			if (tmp < 0) tmp = 0;
			if (tmp > 255) tmp = 255;
			green =  tmp; // green

			tmp = (int)(rgbV.z*256 + 0.5);
			if (tmp < 0) tmp = 0;
			if (tmp > 255) tmp = 255;
			blue =  tmp; // blue

			*dst++ = RGBTO16(red, green, blue);
		}

#if RENDER_BOTHCORES	// 1 = use both cores to render, 0 = use only core 0
		if (CpuID() == 0)
		{
			DispDirtyRect(0, HEIGHT - 1 - y, WIDTH, 2);
			DispUpdate();
		}
		dst += WIDTH;
#else
		DispDirtyRect(0, HEIGHT - 1 - y, WIDTH, 1);
		DispUpdate();
#endif
	}
}
