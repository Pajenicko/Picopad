
// ****************************************************************************
//
//                                  Sokoban
//
// ****************************************************************************

#include "../include.h"

namespace namespace_sokoban
{

#undef _GAME_H
#undef _LEVELS_H
#undef _SELECT_H
#undef _MAIN_H
#include "src/game.h"		// game engine
#include "src/levels.h"		// game levels
#include "src/select.h"		// select
#include "src/main.h"		// main code

#include "src/main.cpp"
#include "src/game.cpp"
#include "src/select.cpp"
#include "src/levels.cpp"

#include "img/tiles4.cpp"
#include "img/tiles8.cpp"
#include "img/tiles12.cpp"
#include "img/tiles16.cpp"
#include "img/tiles20.cpp"
#include "img/tiles24.cpp"
#include "img/tiles28.cpp"
#include "img/tiles32.cpp"

#include "snd/yippee.cpp"

// main function
int main();

} // namespace namespace_sokoban
