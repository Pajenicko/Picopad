
// ****************************************************************************
//                                 
//                              Flappy
//
// ****************************************************************************

#include "../include.h"

namespace namespace_flappy
{

#undef _BALLS_H
#undef _BLUEENEMY_H
#undef _GAMELOOP_H
#undef _GAMEMAP_H
#undef _CHICKEN_H
#undef _LEVELS_H
#undef _MAIN_H
#undef _MUSHROOMS_H
#undef _OBJECTS_H
#undef _RANDOM_H
#undef _REDENEMY_H
#undef _SCENE_H
#undef _SELECT_H
#undef _SOLUTIONS_H
#undef _TILES_H

#include "src/main.h"		// main code
#include "src/objects.h"	// movable objects
#include "src/balls.h"		// balls
#include "src/blueenemy.h"	// blue enemies
#include "src/gameloop.h"	// game loop
#include "src/gamemap.h"	// game map
#include "src/chicken.h"	// chicken
#include "src/levels.h"		// game levels
#include "src/main.h"		// main code
#include "src/mushroom.h"	// mushrooms
#include "src/random.h"		// random number generator
#include "src/redenemy.h"	// red enemies
#include "src/select.h"		// select scene
#include "src/scene.h"		// scene
#include "src/solutions.h"	// solutions
#include "src/tiles.h"		// tiles

#include "src/balls.cpp"
#include "src/blueenemy.cpp"
#include "src/gameloop.cpp"
#include "src/gamemap.cpp"
#include "src/chicken.cpp"
#include "src/levels.cpp"
#include "src/main.cpp"
#include "src/mushroom.cpp"
#include "src/objects.cpp"
#include "src/random.cpp"
#include "src/redenemy.cpp"
#include "src/scene.cpp"
#include "src/select.cpp"
#include "src/solutions.cpp"
#include "src/tiles.cpp"

#include "img/tilesimg.cpp"

// main function
int main();

} // namespace namespace_flappy
