
// ****************************************************************************
//
//                                 Game levels
//
// ****************************************************************************

#ifndef _LEVELS_H
#define _LEVELS_H

#define LEVNUM	50	// number of levels (without demo scene)

// Item indices (symbols are used in level definitions)
#define CRY	(ITEM+0)	// crystal
#define CRO	(ITEM+1)	// crown
#define	TRE	(ITEM+2)	// tree
#define	APL	(ITEM+3)	// apple
#define	COW	(ITEM+4)	// cow
#define	CHE	(ITEM+5)	// cherry
#define	POL	(ITEM+6)	// pool
#define	GIR	(ITEM+7)	// giraffe
#define	ICE	(ITEM+8)	// ice cream
#define	CAK	(ITEM+9)	// cake
#define	COM	(ITEM+10)	// computer
#define	CAR	(ITEM+11)	// car
#define	BAL	(ITEM+12)	// balloon
#define	CLO	(ITEM+13)	// alarm clock
#define	ELE	(ITEM+14)	// elephant
#define	GLA	(ITEM+15)	// drinking glass
#define	MON	(ITEM+16)	// money
#define	AIR	(ITEM+17)	// airplane
#define	LEM	(ITEM+18)	// Lemmings

#define	EMP	EMPTY		// empty tile
#define	WAL	WALL		// wall tile
#define LOC	LOCO_R		// locomotive
#define GAT	GATE		// gate

// level scenes
extern const u8 Levels[(LEVNUM+1)*MAPW*MAPH];

// level paswords
extern const char LevelPsw[(LEVNUM+1)*PSWLEN+1];

// Level solution
extern const char* const Solution[LEVNUM+1];

#endif // _LEVELS_H
