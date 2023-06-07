
// ****************************************************************************
//
//                                 Game levels
//
// ****************************************************************************

#ifndef _LEVELS_H
#define _LEVELS_H

#define SCENESET_NUM		7	// number of scene sets

// scene set descriptor
typedef struct {
	const char* name;		// name of this scene set
	int num;			// number of scenes in this scene set
	int width;			// width of wall map definition (19 or 38)
	int height;			// height of wall map definition (10 or 20)
	const u8* const* list;		// list of scene definitions
	int first;			// number of first scene in the list
	const char* const* solution;	// list of solutions (NULL=not supported)
	int solutionnum;		// number of solutions 0=not supported)
} sSceneSet;

extern const sSceneSet SceneSets[SCENESET_NUM];

#endif // _LEVELS_H
