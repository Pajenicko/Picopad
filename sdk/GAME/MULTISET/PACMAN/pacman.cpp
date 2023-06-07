
// ****************************************************************************
//
//                                  PacMan
//
// ****************************************************************************

#include "../include.h"

namespace namespace_pacman
{

#undef _MAIN_H
#include "src/main.h"		// main code
#include "src/def.h"		// definitions
#include "src/data.h"		// data and tables
#include "src/game.h"		// game
#include "src/main.h"		// main code
#include "src/open.h"		// open screen

#include "src/data.cpp"
#include "src/game.cpp"
#include "src/main.cpp"
#include "src/open.cpp"

#include "img/logo.cpp"
#include "img/tiles.cpp"
#include "img/sprites.cpp"
#include "img/status.cpp"

#include "snd/startsnd.cpp"
#include "snd/siren.cpp"
#include "snd/wakka.cpp"
#include "snd/frighten.cpp"
#include "snd/eatghost.cpp"
#include "snd/eatfruit.cpp"
#include "snd/death.cpp"
#include "snd/extrapac.cpp"

// main function
int main();

} // namespace namespace_pacman
