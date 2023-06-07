
// ****************************************************************************
//
//                               Interpolator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_INTERP	// use interpolator (sdk_interp.c, sdk_interp.h)

#include "../inc/sdk_interp.h"

// save interpolator state (for current CPU core)
void InterpSave(u8 interp, sInterpSave* save)
{
	save->accum0 = *INTERP_ACCUM(interp, 0);
	save->accum1 = *INTERP_ACCUM(interp, 1);
	save->base0 = *INTERP_BASE(interp, 0);
	save->base1 = *INTERP_BASE(interp, 1);
	save->base2 = *INTERP_BASE(interp, 2);
	save->ctrl0 = *INTERP_CTRL(interp, 0);
	save->ctrl1 = *INTERP_CTRL(interp, 1);
}

// load interpolator state (for current CPU core)
void InterpLoad(u8 interp, const sInterpSave* save)
{
	*INTERP_ACCUM(interp, 0) = save->accum0;
	*INTERP_ACCUM(interp, 1) = save->accum1;
	*INTERP_BASE(interp, 0) = save->base0;
	*INTERP_BASE(interp, 1) = save->base1;
	*INTERP_BASE(interp, 2) = save->base2;
	*INTERP_CTRL(interp, 0) = save->ctrl0;
	*INTERP_CTRL(interp, 1) = save->ctrl1;
}

// reset interpolator to default state
//  interp ... interpolator 0 or 1
void InterpReset(u8 interp)
{
	*INTERP_ACCUM(interp, 0) = 0;
	*INTERP_ACCUM(interp, 1) = 0;
	*INTERP_BASE(interp, 0) = 0;
	*INTERP_BASE(interp, 1) = 0;
	*INTERP_BASE(interp, 2) = 0;
	*INTERP_CTRL(interp, 0) = 31<<10;
	*INTERP_CTRL(interp, 1) = 31<<10;
}

#endif // USE_INTERP	// use interpolator (sdk_interp.c, sdk_interp.h)
