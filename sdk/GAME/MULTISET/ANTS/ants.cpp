
// ****************************************************************************
//
//                                 Ants
//
// ****************************************************************************

#include "../include.h"

namespace namespace_ants
{

#undef _MAIN_H
#undef _GAME_H
#include "src/main.h"		// main code
#include "src/game.h"		// game engine
#include "src/main.cpp"
#include "src/game.cpp"

#include "img/background.cpp"
#include "img/blacksreds.cpp"
#include "img/cards.cpp"
#include "img/castle.cpp"
#include "img/cloud.cpp"
#include "img/cursor.cpp"
#include "img/fence.cpp"
#include "img/flags.cpp"
#include "img/grass.cpp"
#include "img/shadow.cpp"
#include "img/state.cpp"
#include "img/trumpet.cpp"
#include "img/win.cpp"

#include "snd/applause.cpp"
#include "snd/build_castle.cpp"
#include "snd/build_fence.cpp"
#include "snd/card.cpp"
#include "snd/curse.cpp"
#include "snd/decrease_stocks.cpp"
#include "snd/fanfares.cpp"
#include "snd/increase_power.cpp"
#include "snd/increase_stocks.cpp"
#include "snd/ruin_castle.cpp"
#include "snd/ruin_fence.cpp"

// main function
int main();

} // namespace namespace_ants

