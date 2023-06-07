
// ****************************************************************************
//
//                                 Solutions
//
// ****************************************************************************
// The game uses a custom random number generator to ensure repeatability of the scene solving macros.
//   Do not change seed value RandomSet(123456789) - solution macros are tuned to this value

#ifndef _SOLUTIONS_H
#define _SOLUTIONS_H

#define SOLUTIONMAX	8	// number of solutions
extern const char* const SharpSolution[SOLUTIONMAX];

// Macro keys:
//   U up
//   D down
//   L left
//   R right
//   W wait
//   X shoot
//   0..9 repeat key (0 means 10, 1 means 11, 2 means 12)

#endif // _SOLUTIONS_H
