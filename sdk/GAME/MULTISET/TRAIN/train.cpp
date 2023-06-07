
// ****************************************************************************
//
//                                  Train
//
// ****************************************************************************

#include "../include.h"

namespace namespace_train
{

#undef _MAIN_H
#undef _GAME_H
#undef _LEVELS_H
#include "src/main.h"		// main code
#include "src/game.h"		// game engine
#include "src/levels.h"		// game levels

#include "src/main.cpp"
#include "src/levels.cpp"
#include "src/game.cpp"

#include "img/tiles.cpp"

#include "snd/collect.cpp"
#include "snd/crash.cpp"
#include "snd/step.cpp"
#include "snd/success.cpp"

// main function
int main();

} // namespace namespace_train
