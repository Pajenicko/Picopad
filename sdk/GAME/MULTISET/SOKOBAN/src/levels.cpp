
// ****************************************************************************
//
//                                 Game levels
//
// ****************************************************************************

//   x = grass (empty)
//   # = wall
//   ! or | = next row
//   space or _ or - = floor
//   $ or b = box
//   * or B = box on mark
//   . = mark
//   @ or p = player
//   + or P = player on mark

#include "../include.h"

// selected level
int Level;		// current level 0..
const char* LevDef;	// current level definition
const char* LevSolve;	// current level solve

const char* const Levels[] = {

	// 1
	"xx#####x!"
	"###   #x!"
	"# $ # ##!"
	"# #  . #!"
	"#    # #!"
	"## #   #!"
	"x#@  ###!"
	"x#####xx",
	"uuluuRldd3ruruullDDullddrRlddrruUluR",

	// 2
	"xx#####x!"
	"###   #x!"
	"# $ # ##!"
	"# #  . #!"
	"#    # #!"
	"##$#.  #!"
	"x#@  ###!"
	"x#####xx",
	"rruu3luurlddrrurru2(ulldd)rru3rddlldlludrruuluullddrrurd",

	// 3
	"xx#####x!"
	"###   #x!"
	"# $ # ##!"
	"# #  . #!"
	"# .  # #!"
	"##$#.$ #!"
	"x#@  ###!"
	"x#####xx",
	"rruu3luurldd3rddlludrr3urrddlruuluulldllddrddrruudd2(lluur)rdrdl",

	// 4
	"xxxx####!"
	"#####  #!"
	"#   $  #!"
	"#  .#  #!"
	"## ## ##!"
	"#      #!"
	"# @#   #!"
	"#  #####!"
	"####xxxx",
	"4urRll3d3ruuruul3Duu3l3drrdrru3Lrr3u3lddDlddr3Ud3r3u4ldR",

	// 5
	"xxxx####!"
	"#####  #!"
	"#   $  #!"
	"# *.#  #!"
	"## ## ##!"
	"#      #!"
	"# @#   #!"
	"#  #####!"
	"####xxxx",
	"3ururldldd3ruuruul3duulldllu3rll3drrdrru3lrruuruul3duu3l3dlddr3udrrdrru3lrr3u4ldrddlddr3u",

	// 6
	"xxxx####!"
	"#####  #!"
	"#   *  #!"
	"# *.#  #!"
	"## ## ##!"
	"# $    #!"
	"# @#   #!"
	"#  #####!"
	"####xxxx",
	"luruururldlddrrdrru3lrruuruul3duulldllu3rll3dlddr3udrrdrru3lrruuruuld4ldrddlddr3ud3ruurul",

	// 7
	"x#####xx!"
	"x#   ##x!"
	"## #$ ##!"
	"# $    #!"
	"#. .#  #!"
	"### @ ##!"
	"xx# # #x!"
	"xx#   #x!"
	"xx#####x",
	"lullu3rlluurrdrdllruullddldrurddrruru3lruullddrdlrdrrddlluu",

	// 8
	"x#####xx!"
	"x#   ##x!"
	"##.#$ ##!"
	"# $    #!"
	"#. .#$ #!"
	"### @ ##!"
	"xx# # #x!"
	"xx#   #x!"
	"xx#####x",
	"luurrddllullu3rlluurrdrdllddrrurulluullddldr3urrddlruulldd3rddllddrr3uru3ldlu3r4dlluu",

	// 9
	"x#####xx!"
	"x#   #xx!"
	"##$# ###!"
	"#   $@ #!"
	"# #  # #!"
	"# #. . #!"
	"#   ####!"
	"#####xxx",
	"rdd3luuruulldurr4drruulrdd3ldll3uruurr3durrddll4ullddrluurr3du3l3drruruuld",

	// 10
	"x#####xx!"
	"x#   #xx!"
	"##$# ###!"
	"#  .$@ #!"
	"# #  # #!"
	"# #..$ #!"
	"#   ####!"
	"#####xxx",
	"rddllulur3l3drrur4ulldurr4drruulrdd3ldll3uruurr3d3ullddrll3drruuddll3uruu2(rrdd)llrruulld",

	// 11
	"x#####xxx!"
	"##   ###x!"
	"# . .  #x!"
	"# # ## ##!"
	"#    $$@#!"
	"### #   #!"
	"xx#   ###!"
	"xx#####xx",
	"dlullrddll3udlluururrdrrdullulldrrlddrrdrru3lrddll3udlluururrdldd3ruul",

	// 12
	"x#####xxx!"
	"##   ###x!"
	"# . . .#x!"
	"# # ## ##!"
	"#    $$@#!"
	"### # $ #!"
	"xx#   ###!"
	"xx#####xx",
	"dlu3lddrrudll4ullddrluu5rddlddll3udlluu3rl4drruulrddll3udlluururrdldd4rdl3ulrdd3lddrrudlluurrdruu",

	// 13
	"xxxx####x!"
	"x####  #x!"
	"## $   #x!"
	"#  # #$#x!"
	"#.@.   ##!"
	"## # #  #!"
	"x#      #!"
	"x#  #####!"
	"x####xxxx",
	"rruurr3drd3luulluurr4dldl3urruulldld3ruurur4drd4ldluudrruulluu4rddll",

	// 14
	"xxxx####x!"
	"x####  #x!"
	"## $   #x!"
	"#  # #$#x!"
	"#.@..  ##!"
	"## # #  #!"
	"x#   $  #!"
	"x#  #####!"
	"x####xxxx",
	"4rddll4urrdd4luurr4dldl3u4rdrd3l4ulldld3rddldl3urruulldldrrluu3rur4drd4ldluudrruulluu4rddllrruulld",

	// 15
	"xxx####x!"
	"####  #x!"
	"# $   #x!"
	"#  .# ##!"
	"## #.  #!"
	"# @  $ #!"
	"#   ####!"
	"#####xxx",
	"uulurrl3drrurrd3ldl3urururddulldldd4ruluulldllu3rur3drd3ldluud3r3u4ldr",

	// 16
	"xxx####x!"
	"####  #x!"
	"# $ $ #x!"
	"#  .# ##!"
	"## #.  #!"
	"# @  $ #!"
	"#.  ####!"
	"#####xxx",
	"rrurrd3ldlluru3(ur)3dldlrurrdllr3ulldldduulu3rur3dldldluudrruruu4ldrddrrurrd3ldl3ulu3rurddu3l3d4rul",

	// 17
	"xxxx#####x!"
	"xxx##   ##!"
	"xx## .#  #!"
	"x##   @  #!"
	"##    #  #!"
	"#  $ #####!"
	"# * ##xxxx!"
	"#  ##xxxxx!"
	"####xxxxxx",
	"ld3ldlddrurudllururlddrurudllururrdluldrr3urrddlldldluldruurdru",

	// 18
	"xxxx#####x!"
	"xxx##   ##!"
	"xx## .#  #!"
	"x##   @  #!"
	"##  * #  #!"
	"#  $ #####!"
	"# * ##xxxx!"
	"#  ##xxxxx!"
	"####xxxxxx",
	"3ldldldd3(ru)dldllururu3r3ldlddrurudllurur2(rdluld)u3r3urrdrddlulluldrdlr3urrdrdllruulldlddrulddllur",

	// 19
	"####xxxx!"
	"#  ####x!"
	"#     #x!"
	"#     #x!"
	"### ###x!"
	"# $$  ##!"
	"# . .@ #!"
	"####   #!"
	"xxx#####",
	"ll3urul4dllurdr3ulluurdldrur3dldrrl3urrulldlluurdldrur3drdlrdrrul",

	// 20
	"####xxxx!"
	"#  ####x!"
	"#     #x!"
	"#     #x!"
	"### ###x!"
	"# $$$ ##!"
	"# ...@ #!"
	"####   #!"
	"xxx#####",
	"ll3urul4dllurdr3ulluurdldrurdrrull3dldrrdrrululldllurdrrl3ulluurdldrurdrrull3drdl3ulluurdldrur3drddrrul",

	// 21
	"#####xx!"
	"#   ###!"
	"#     #!"
	"##    #!"
	"####$##!"
	"#  $ ##!"
	"# @   #!"
	"###. .#!"
	"xx#####",
	"rr3uruldlluurdldrur3dldllurrddrrul3uruldlluurdldrur4dldruu3ldrurd",

	// 22
	"#####xx!"
	"#   ###!"
	"# .   #!"
	"## $  #!"
	"####$##!"
	"#  $ ##!"
	"# @   #!"
	"###. .#!"
	"xx#####",
	"rr3urullulldrdrluurdr3dldllurrddrrul3urullulldrdrluurdr4dlr4ulldrur3dlddruu3ldrurdr3urull",

	// 23
	"xxxxxx####x!"
	"#######  #x!"
	"#        #x!"
	"#  $ #.# #x!"
	"#  $## # ##!"
	"###   @   #!"
	"xx###  #  #!"
	"xxxx##.  ##!"
	"xxxxx#####x",
	"3ulldlullddrulu6rur4dllddrrurulddlluu3luulu5rur4dllddrrurullr3ull4d4u3l3drrdruu",

	// 24
	"xxxxxx####x!"
	"#######  #x!"
	"#        #x!"
	"#  $ #.# #x!"
	"# $$## # ##!"
	"### . @   #!"
	"xx###  #  #!"
	"xxxx##.  ##!"
	"xxxxx#####x",
	"3ulldlu3r3d3lud3r3u5lddrulu3rdlru3rur4dllddrrurullrddlluu3lululu6rur4dllddrruruldd"
	"lluu3luulu5rur4dllddrrurul3ull4d4u3l3drrdru3l3u5r3d3lru",

	// 25
	"xxxxx####!"
	"xxx###  #!"
	"x### .. #!"
	"x# $$#  #!"
	"## # #@##!"
	"#       #!"
	"#   #   #!"
	"######  #!"
	"xxxxx####",
	"uulldduurr3d3ldlluruurldd3rdr3uruuldlldlldd4ruurul3d4luurrdulldd3rdr3u",

	// 26
	"xxxxx####!"
	"xxx###  #!"
	"x### .. #!"
	"x# $$#  #!"
	"## # #@##!"
	"#  *    #!"
	"#   #   #!"
	"######  #!"
	"xxxxx####",
	"d3ldllu4rdr3uruuldlldduurr3drddluu3ldlluruurldd3rdrruluuruuldlldlldd3rdrr"
	"uluurul3d3ldllu4rdru4luurrdulldd3rdrru3lrruu",

	// 27
	"x####xxx!"
	"x#  ####!"
	"x#     #!"
	"x# #.  #!"
	"##*##$##!"
	"#      #!"
	"# # @  #!"
	"#    ###!"
	"######xx",
	"uruululldduurrdrddldd3luurrdrr3uru3lul3duu3r4dllurdruudldd3luurrl3u4rdl3dllurdr3uru3luldd",

	// 28
	"x####xxx!"
	"x#  ####!"
	"x#     #!"
	"x# #.  #!"
	"##*##$##!"
	"#    * #!"
	"# # @  #!"
	"#    ###!"
	"######xx",
	"rruluululldduurrdr3dllurdd3luur3urrdrddrdlld3luu3rll3urrdrru3lul3duu3r3dldd3luurldd3r"
	"uurrdl4u3l3drr3ldd3ruruuddld3luur3u4rdlu3l3drrdr3uru3lulddu3r3dlddludlluu3r",

	// 29
	"########!"
	"#   #  #!"
	"#      #!"
	"## #.  #!"
	"#    ###!"
	"# # . #x!"
	"# $$# #x!"
	"###  @#x!"
	"xx#####x",
	"lluur3ullddlddrluurrdruuddrd2(dlluu)rrluurrddurruuldrdl",

	// 30
	"########!"
	"#   #  #!"
	"#      #!"
	"## #. .#!"
	"#    ###!"
	"# # * #x!"
	"# $$# #x!"
	"###  @#x!"
	"xx#####x",
	"lluuddrruul3ullddrdrrddlluuruurullulldrddlddrluuruurrdrru3luldrr3drddllulluurrll"
	"ddrruruurullulld3r3dldlluurrdruurruuldrdlullulld3rddlludrrurruuldrdlullulld4rurd",

	// 31
	"#####xx!"
	"#   ##x!"
	"# #  ##!"
	"#. #$ #!"
	"#  @  #!"
	"#.##$##!"
	"#    #x!"
	"######x",
	"ll3ur3(rd)luulull5d3ruulluluur3(rd)ldd3l3u3d3ruulluld3ruululld",

	// 32
	"####xxx!"
	"#  ###x!"
	"#    ##!"
	"# .#$ #!"
	"## @  #!"
	"x#.#$##!"
	"x#   #x!"
	"x#####x",
	"luurrdrdluull4drruulrddll3uluurdrrdrdlddll3ulur4drruulrddll3uluur3drruulrddlluluurd",

	// 33
	"x#######x!"
	"x#  #  ##!"
	"## **$. #!"
	"#   #   #!"
	"#   @ ###!"
	"#  ####xx!"
	"####xxxxx",
	"ll3urdldd3ruruuldllulddlddrurudrruruuldllddrrudlluurrdd4lurd3ruulluld3rd2(dllu)rurlddru",

	// 34
	"x#######x!"
	"##  #  #x!"
	"#  **$.##!"
	"#   #   #!"
	"### @   #!"
	"xx####  #!"
	"xxxxx####",
	"rr3uldrdd3luluurdrrurddrddluludlluluurdrrddlludrruulldd4ruld3luurrurddu3ldllurdrdrruruldrrddluu",

	// 35
	"xx####xx!"
	"###  ###!"
	"#   *$ #!"
	"# #  #@#!"
	"# # *. #!"
	"#   ####!"
	"#####xxx",
	"dlluluurd3l3drru3ruu3l3rdd3lud3ruulldldr3uldrddldll3urrurddu3l3drruuddll3urr",

	// 36
	"#####xxx!"
	"#   ##xx!"
	"# #  ###!"
	"#   *$ #!"
	"###  #@#!"
	"xx# *. #!"
	"xx#  ###!"
	"xx####xx",
	"dlldl3ulluurrdrdldd3ruulldldr3ulduullddrrdrddl3ulluurrdrdduulullddrr",

	// 37
	"xx####x!"
	"x##  #x!"
	"##   ##!"
	"#  *$ #!"
	"# # #@#!"
	"#  *. #!"
	"###  ##!"
	"xx#  #x!"
	"xx####x",
	"dlluullddrluurrddrruullddlluururddurrddll4urdl3drruulrddlluuddrddluurruu4lddrrlluurrduruuld",

	// 38
	"xx####xx!"
	"xx#  ###!"
	"x## .  #!"
	"##@$$$ #!"
	"# . . ##!"
	"#   ###x!"
	"#  ##xxx!"
	"####xxxx",
	"d3rurulldrdlldllururrdlr3ulddu3rdldlulldrllddru",

	// 39
	"xx#####x!"
	"###   #x!"
	"#     #x!"
	"#  #.###!"
	"##@$$$ #!"
	"x#.#.# #!"
	"x#     #!"
	"x#  ####!"
	"x####xxx",
	"ddrr3u3dl2(luur)urrdlddlluururdll4d4ruu3l3rdd4lu2(urrd)d3ldlurruullulurrurrdlddlluururd",

	// 40
	"xx####x!"
	"x##  #x!"
	"## . ##!"
	"#@$$$ #!"
	"#. .# #!"
	"# #   #!"
	"#   ###!"
	"#####xx",
	"drrudllururdll3drrurruulluld3rddllulrdrruulluurdlldrddrruulrddlluulldru3rddlldllu",

	// 1
	"xxxx#####xxxxxxxxxx!"
	"xxxx#   #xxxxxxxxxx!"
	"xxxx#$  #xxxxxxxxxx!"
	"xx###  $##xxxxxxxxx!"
	"xx#  $ $ #xxxxxxxxx!"
	"### # ## #xxx######!"
	"#   # ## #####  ..#!"
	"# $  $          ..#!"
	"##### ### #@##  ..#!"
	"xxxx#     #########!"
	"xxxx#######xxxxxxxx!",
	"u3l3ululldll3d11rurd12lulld13rdrrlu7l3ulull3duull3d11rurrld7l3ullul3duull3d11rdru7l3ull3urdduu"
	"ll5duull3d13r8l3ullul3duull3d12rlur",

	// 2
	"############xx!"
	"#..  #     ###!"
	"#..  # $  $  #!"
	"#..  #$####  #!"
	"#..    @ ##  #!"
	"#..  # #  $ ##!"
	"###### ##$ $ #!"
	"xx# $  $ $ $ #!"
	"xx#    #     #!"
	"xx############!",
	"rdrr3drruuluuruullu4ldduu4rdrrddld3lu6ldl3udd5r3urrdluldduu4rdrrddld3lu6ldluud5r3u4rd3lulddu6rdd"
	"ld3lu6l4r4d3lurrdr4urrd3rdrdd4lulldllurdr3uddrrdrru4lrrd4ruululldulu5l3r4dllurdr3uddrrdrruluulu4l"
	"dlu5rdrdd3ldllurdr3udd3ruulu4lullrd5rd3rdrd6ldllurdr3udd3ruulu4ldlluuddru5rdrrdrd5ldllurdr3udd3ru"
	"ulu5l5rd3ruuru4lulldduurrd3r3d3lu4luld3r3urrdlulddu5r3d3lu4ldl3urul",

	// 3
	"xxxxxxxx########x!"
	"xxxxxxxx#     @#x!"
	"xxxxxxxx# $#$ ##x!"
	"xxxxxxxx# $  $#xx!"
	"xxxxxxxx##$ $ #xx!"
	"######### $ # ###!"
	"#....  ## $  $  #!"
	"##...    $  $   #!"
	"#....  ##########!"
	"########xxxxxxxxx!",
	"lddll4d8l8rurrdrrulld9l7r4urr3drd9l4ruurdrd5ldlu8r6u4lddr3drd5lu4l3rd5r3urdduurur3dld6ld4l3ru4ru"
	"urrdrd6lu3lrrd4ru5rd8ld3lrru5r4uluur5drd5lullrd5r6urrddrdlul3drd6ldllru5r4uluur5drd5luldrdl",

	// 4
	"xxxxxxxxxxx########!"
	"xxxxxxxxxxx#  ....#!"
	"############  ....#!"
	"#    #  $ $   ....#!"
	"# $$$#$  $ #  ....#!"
	"#  $     $ #  ....#!"
	"# $$ #$ $ $########!"
	"#  $ #     #xxxxxxx!"
	"## #########xxxxxxx!"
	"#    #    ##xxxxxxx!"
	"#     $   ##xxxxxxx!"
	"#  $$#$$  @#xxxxxxx!"
	"#    #    ##xxxxxxx!"
	"###########xxxxxxxx!",
	"llul4Luluuluur5RurRu3RurD4ldllu8R8l4drruUUlu5R4lddrUlu3Rd4RUUllDDlU4l4dr3Ulu6R8l3dRUUlu7R4l4d"
	"l3Ulu5R6ldd6lddrUlu7R6l4dlddr5Ulu6RdrUUlu5Ru4RDrDuUllDDR3lU3l3dlUUlu4Ru4R3lDRR8ldd3lddLUlu5Rd"
	"dlUrrUl3Ldllu6RUlu7R4l3dlUUlu5R7lDrd3Ldllu6R6ld3Dlddr5Ulu6R5l7drrULdl6Ulu5RdrUUlu6Rd3RURDllUU"
	"RllD3l3dlUUlu7R6l3dlU6l5dr3Rurrd5Ldl5Ulu7RUlu7R4l3dlUUlu5R7ldd4l5d6rddlUru5Ldl5Ulu6R5l5d5rddl"
	"Uru4Ldl5Ulu5RdrUUlu6Rd3RUUllD4l3dlUUd7luurDld7R6luurDld5Ruu5RdRRlU3l3dlUUlu4RuRRlD4l3dlU5luur"
	"Dld5RUlu5RdRUR4l3dlUUlu5RluR",

	// 5
	"xxxxxxxx#####xxxx!"
	"xxxxxxxx#   #####!"
	"xxxxxxxx# #$##  #!"
	"xxxxxxxx#     $ #!"
	"######### ###   #!"
	"#....  ## $  $###!"
	"#....    $ $$ ##x!"
	"#....  ##$  $ @#x!"
	"#########  $  ##x!"
	"xxxxxxxx# $ $  #x!"
	"xxxxxxxx### ## #x!"
	"xxxxxxxxxx#    #x!"
	"xxxxxxxxxx######x!",
	"luulld9l8rddluru7l8rurrd9l9rddluru8l7rddluru6ldlu8r3dlrrdd3l4uru6lu4l3rd4r3u4rdd3l3ruu4luur"
	"rdull4drd4ld4l3ru4ru4ruu3lruull4drd4lu3lrrd4ru4rurru5lruull4drd4ld3lrru4rd4r3uru4lruull4drd"
	"4lullrd4r3druuru5ldllru7r3drrdd3l4uru6luldrdl",

	// 6
	"######xx###x!"
	"#..  #x##@##!"
	"#..  ###   #!"
	"#..     $$ #!"
	"#..  # # $ #!"
	"#..### # $ #!"
	"#### $ #$  #!"
	"xxx#  $# $ #!"
	"xxx# $  $  #!"
	"xxx#  ##   #!"
	"xxx#########!",
	"dr4dlDr3uLDr3ulD5LulD7rddlUru6LdLLrU6rddlUru6L7r4dll3Uru5LuLLDDulUdDrrU7r6dllUll4U4drr3Uruul"
	"l5L7rddlUru6L3r4dllddrUluRdr4U4drrur3Ulul3LuLLrD5rurrd6LdLLUUrD3r4dlluRdr3U4drrdr5Ulul4L5rur"
	"rd6LdLUruL",

	// 7
	"xxxxxxx#####x!"
	"x#######   ##!"
	"## # @## $$ #!"
	"#    $      #!"
	"#  $  ###   #!"
	"### #####$###!"
	"# $  ### ..#x!"
	"# $ $ $ ...#x!"
	"#    ###...#x!"
	"# $$ #x#...#x!"
	"#  ###x#####x!"
	"####xxxxxxxxx!",
	"ld5r4d4u7ldr4dllurl3druurrdl3urd5rurddl5uluur6dldru6lddrulu4r3luluulu6rur6duuld4ld3lu"
	"urld8r3urruulul4duu6l3dld6rurd3urrulul3duu4ldlul3dld6r7l3druulu6r",

	// 8
	"xx####xxxxxxxxxx!"
	"xx#  ###########!"
	"xx#    $   $ $ #!"
	"xx# $# $ #  $  #!"
	"xx#  $ $  #    #!"
	"### $# #  #### #!"
	"#@#$ $ $  ##   #!"
	"#    $ #$#   # #!"
	"#   $    $ $ $ #!"
	"#####  #########!"
	"xx#      #xxxxxx!"
	"xx#      #xxxxxx!"
	"xx#......#xxxxxx!"
	"xx#......#xxxxxx!"
	"xx#......#xxxxxx!"
	"xx########xxxxxx!",
	"d3ruR5D4ulldRur3Duu3rUUruuluuLL3d7DLruLLul3DuurDDrRRl9uuurrdLul9DD9urrdLul8D7uLLDDulDDR"
	"ur6DRRlDLLrdRRl6urruuLrruu3ld6D4u4ldRRur5DR8urrDrdLLruulld8DLdR9u3uLL4D3ul4DldRRluRR4D5"
	"ur6DL6ul5ul6DldRRur6DR9uuu4rdrd3rddlldlld3L3rurrurr3ulLu7Lrdd3l3ur6DldRur5D5ur6D5u4rurr"
	"d5L5ruurr4u9Lrdd3l3ur6DldRur4D4ur5D4u6ruurrdd7L7r4u3lUru7Lrdd3l3ur6DldRur3D3ur4DLLulD",

	// 9
	"xxxxxxxxxx#######!"
	"xxxxxxxxxx#  ...#!"
	"xxxxxx#####  ...#!"
	"xxxxxx#      . .#!"
	"xxxxxx#  ##  ...#!"
	"xxxxxx## ##  ...#!"
	"xxxxx### ########!"
	"xxxxx# $$$ ##xxxx!"
	"x#####  $ $ #####!"
	"##   #$ $   #   #!"
	"#@ $  $    $  $ #!"
	"###### $$ $ #####!"	
	"xxxxx#      #xxxx!"
	"xxxxx########xxxx!",
	"rurrd3ruuldrdrruul4ulu7r6l5drddl6ulu6r5l6dllurdr5ulu5r4l5dllurdr4ulu4rdruud4l5dr4dl8ulu4r"
	"uu3rdrddluulddlu4l9dluudlullulld5rdr7ulu7r6l5dlldrdr6ulu6r5l7d4lulld5rdr7ulu5r4l6d3rulldl"
	"5ulu4ru3rddluuld4l5drruldl4ulu4rd3rllu4l6d3rdlldl7ulu4rurrld4l7d5rurrd6ldl7ulu4rdrrlu4l9d"
	"3rulldl8ulu4rurd4l7d5rurrd6ldl7ulu5rldr",

	// 10
	"x###xx#############!"
	"##@####       #   #!"
	"# $$   $$  $ $ ...#!"
	"#  $$$#    $  #...#!"
	"# $   # $$ $$ #...#!"
	"###   #  $    #...#!"
	"#     # $ $ $ #...#!"
	"#    ###### ###...#!"
	"## #  #  $ $  #...#!"
	"#  ## # $$ $ $##..#!"
	"# ..# #  $      #.#!"
	"# ..# # $$$ $$$ #.#!"
	"##### #       # #.#!"
	"xxxx# ######### #.#!"
	"xxxx#           #.#!"
	"xxxx###############!",
	"dr4drdl5ulldrur4dl3dldr4urrdlrdr6d10r4u3luurdldlluur3uluurru3rur6d5u3lu3ld6rur12d5ul6u6l3dr"
	"uulu5rur5d4u5l3druulu5rur11d5ul5u4lddrulu3rur4d3u5l6dlddr7ulu6rur10d5ul4u5l10d4l4u3rdr6ulu5r"
	"ur3duu5l6d4lddrurrdr7ulu6rur9d5ul3u5l10dludllurrdr9ulu5rurddu5l7d4lu3rdr6ulu6rur8d5uluu5l9dll"
	"urdr8ulu5rurd5l6d3ldrrdr7ulu6rur7d5ulu5l6d4ldd3rdr8ulu5rur7d6u3ld6lddrrdr3ulu6rur6d5u3lu6ld9r"
	"ur6d5u13ldllu13rur5d4u12lddrulu11rur4d3u11l3dlulddl4dldr5urrdlrdr6d10r4u3lul6ulu5rur3duu5l6d"
	"l3dr5ulur4drruldl6ulu6rur5d4u4l4dl3ulu5rur4d3u4l3dll3dlddr7ulu6rur3duu4l3d6ld3rullu3r4dlddr7u"
	"lu5rurddu3l3dluulu4rurd5l10drudruuldl8ulu6rurddu6l8d4rd3ldl9ulu6rurd6l6drrddrdlldl9ud4lu3ru6r"
	"3lddllulu5r10ld4ldrur3dl4d4urrdlul3duur5u11r",

	// 11
	"xxxxxxxxxx####xxxxx!"
	"xxxxx####x#  #xxxxx!"
	"xxx### @###$ #xxxxx!"
	"xx##      $  #xxxxx!"
	"x##  $ $$## ##xxxxx!"
	"x#  #$##     #xxxxx!"
	"x# # $ $$ # ###xxxx!"
	"x#   $ #  # $ #####!"
	"####    #  $$ #   #!"
	"#### ## $         #!"
	"#.    ###  ########!"
	"#.. ..#x####xxxxxxx!"
	"#...#.#xxxxxxxxxxxx!"
	"#.....#xxxxxxxxxxxx!"
	"#######xxxxxxxxxxxx!",
	"d3ldldlddrrd3rdrr4urr3d5uruu2(l4dl)lu3lulluururu6r6ldldlddrrd3rdrr4uludrddlur3dlluluurrllddl"
	"luurdrdlul3drdl4ullu3(ur)rdl3drdlul3dlddur4ullu3(ur)4drdrdrruulullddlul3drddu3lulddrdruur4ul"
	"luururrddrdlu3ru3ruu3lddullul3dl4drd3lrr3urrulul4drdlluldrr3u3rdrr3u3lrruu3lddrdl3uruurd4rddl"
	"lrruuruuldrd4lddullul3dl4drdllr3urrul3uruurdrdllul3dl4drdl3urruldrrdrrdruruldl3u3lrruu3lddl4d"
	"lddlurr3urruldrrd4r4ullrruuruuldrd4lddrd3lrruu3lddl4drdllulddurr3urrul3uruurdrdllul3dl4drdllul"
	"drr3urruldrrd6ruldl6uruuldrd5luldrdlul3dl4drdllr3urrulul4drdl3u3rd8rurrd7ldl4udd4ruldl3ullrr"
	"uuruuldrd4lddrd3lrruu3lddrdl3uruurdrdllul3dl4dldr3urrulul4d",

	// 12
	"################x!"
	"#              #x!"
	"# # ######     #x!"
	"# #  $ $ $ $#  #x!"
	"# #   $@$   ## ##!"
	"# #  $ $ $###...#!"
	"# #   $ $  ##...#!"
	"# ###$$$ $ ##...#!"
	"#     # ## ##...#!"
	"#####   ## ##...#!"
	"xxxx#####     ###!"
	"xxxxxxxx#     #xx!"
	"xxxxxxxx#######xx!",
	"ldrddrrur3duu3luulldlul4u7r3drud3lurru3rur4dldrdrull5d4lur4uluurrulu3rur4dl6d3lurrdr5ur5u13l7d4r"
	"u4rur3duul3ulurrdrulu3rur5dl5d4lu3rdr4url3d3l3u3luurdldrrur3d3uluulurrdrulu3rur6dl4d4lu3rdr3url"
	"dd3l3u5lddrrudll3urd3rur3duu4l4u4rdrulu3rur7dldrldd4lurrl3u4lullu3rdld3rur3d3ul3(lu)4rdrulu3ru"
	"r7dl3dllurdruudd4lu3rdru3l3uluululu3rdrulu3rur6d6u11ldd7rdrulu3rur5d4u3ldlldd5lulu7rdrulu3rur4d3u"
	"3ldlldd4lulu6rdrulu3rur3d",

	// 13
	"xxx#########xxxxxxx!"
	"xx##   ##  ######xx!"
	"###     #  #    ###!"
	"#  $ #$ #  #  ... #!"
	"# # $#@$## # #.#. #!"
	"#  # #$  #    . . #!"
	"# $    $ # # #.#. #!"
	"#   ##  ##$ $ . . #!"
	"# $ #   #  #$#.#. #!"
	"## $  $   $  $... #!"
	"x#$ ######    ##  #!"
	"x#  #xxxx##########!"
	"x####xxxxxxxxxxxxxx!",
	"UruLullddD3urr3dDD3ldll4urRururr4drrdL3drrRdrru3Rluu3r3dl6U5d4ldllu5Rluu3r3dl5U6ldDrRR3lDld3RUd3"
	"Rlu4Ud4lddrRRluurrdD3r3dl3Udd9lulld9RR8l4ul4ulldldllddrD3rRDDld6Rdr4UdlluurRRl3u3rdLdD3ruuLLulD3r"
	"ddlUruLr4dl3Ur6dl5U4d9ll4ur3Dld9R9l3u5lddRd9Rdr4Udlluur4R3ldd5r3dl3Udd9ll3u3ldDld9R4R9l4luluRurDD"
	"ld9Rdr4Ud5r3dlU9l4lddlUUruulldRurDld9RdrUUdlluur4R5ldd8l4uluurrdrDuluurRur7Dld9RR9l3l3u3Rur3Dld8R"
	"8l7ull3D3u3rd5Dld7R9ll3u3Rur3Dld5RdrUUdlluurRR3luurRRluuR",

	// 14
	"xxxxxxx#######xxxx!"
	"x#######     #xxxx!"
	"x#     # $@$ #xxxx!"
	"x#$$ #   #########!"
	"x# ###......##   #!"
	"x#   $......## # #!"
	"x# ###......     #!"
	"##   #### ### #$##!"
	"#  #$   #  $  # #x!"
	"#  $ $$$  # $## #x!"
	"#   $ $ ###$$ # #x!"
	"#####     $   # #x!"
	"xxxx### ###   # #x!"
	"xxxxxx#     #   #x!"
	"xxxxxx########  #x!"
	"xxxxxxxxxxxxx####x!",
	"ull5d5rdd3l3ruu7l4u4l3d3r3lddrrd3r3d4ruudd4luurr4ud4rdd3lr4drrdrr6u6dlluuldl3udd4luurr3urullur"
	"rdd3rdd3lr3drruludd5luurr4ud4rdd3lrr3dluudd4luurr3uruu3ld3rd4ruurrdd4lrdd3lr3d4luurr3urulldlr"
	"r3dllddllurd5r3ulldlldld5rdd4lud4rururuldluurullr3d4luurr3urul4dlldlld6rdruruldluurullr3d4luu"
	"rr4u4dlluldduullulldldd4rd6rdruruldluurullr3d4luurr3uruulldr4d3ld5luurdld4rd6rdruruldluurull"
	"r3d4luurr3uluurrdl4d3lduulldrdd6rdruruldluurullr3d4luurr4u4dllulddld6rdruruldluurullr3d4luu"
	"rr3u3d5luull5u4rdrrddrlurl3urrdlul3d3u4rd3lulddllulldlul7d3rurddu3ldrrd6rdruruldluurullr3d4lu"
	"urr4u4d3ldu5ld4rd6rdruruldluurullr3d4luurr3u3d3ldld6rdruruldluurullr3d4luurruu",

	// 15
	"xxx########xxxxxx!"
	"xxx#   #  #xxxxxx!"
	"xxx#  $   #xxxxxx!"
	"x### #$   ####xxx!"
	"x#  $  ##$   #xxx!"
	"x#  # @ $ # $#xxx!"
	"x#  #      $ ####!"
	"x## ####$##     #!"
	"x# $#.....# #   #!"
	"x#  $..**. $# ###!"
	"##  #.....#   #xx!"
	"#   ### #######xx!"
	"# $$  #  #xxxxxxx!"
	"#  #     #xxxxxxx!"
	"######   #xxxxxxx!"
	"xxxxx#####xxxxxxx!",
	"drrduruu3rddldrr3dllulluldldlluurd3lddllddrulurur4ul2(uurr)3drr4dl4dllulluuddrd3r4ur4ull3ull"
	"ddr3lddrddldrrlddllddrulurdruuddrd3r4ululd4rdlu3rdrr3ulu3lrruulldl3dllrr3ururrddllulddu3rdr"
	"r3dllullullddrrurruuru3lulddu3rdrrdrru3lr3dllullulrddllurdrurruuru3lul3duu3r3dlldllur4u3ldrr"
	"ur4dldr4u3luuluurr3dldrrur4d3ull3urrur3durrddllul3duull4urrur4durrddllulddulluu4lddrddld4r3l3u"
	"luur4dld3r3ldrddllurdruulurrl3drd3ruu",

	// 16
	"#####xxxxxxxxx!"
	"#   ##xxxxxxxx!"
	"#    #xx####xx!"
	"# $  ####  #xx!"
	"#  $$ $   $#xx!"
	"###@ #$    ##x!"	
	"x#  ##  $ $ ##!"
	"x# $  ## ## .#!"
	"x#  #$##$  #.#!"
	"x###   $..##.#!"	
	"xx#    #.*...#!"
	"xx# $$ #.....#!"
	"xx#  #########!"
	"xx#  #xxxxxxxx!"
	"xx####xxxxxxxx!",
	"uludrdru3rddlu3rdlulu4lddlddrurrddldduu4rdrrdrr4ululull3drdduul3urrdl3urdd3lur5lulld3rlddlddr"
	"urrdd3rdrrdrr4ululrdr4dllurdr3udd4luurdld3rdruud3lu3lddlulu4r3luulluuru3rdr3drd3ldllu4rd3rdr"
	"u4l5urrdlul3drd3ldllu4rd3r3l4urr3ulddrdlullur4drdldrrlld3rlluu3ldllu4r3urr3uld6lulld7rllddr"
	"ur3drddldrrluu3ldllu4r3urrulruuld8l3urddld7r4drddldruu3ldllu4r3urrulruuld7l3urddld6r5d3urr"
	"ulruuld6luurdld5r4drdldrlulld3ldrlddruuluru4rurddu3lddlullddruluru4rurd3lddlulu4r3urrulruuld"
	"l5d3urrulul4d",

	// 17
	"xxx##########xxx!"
	"xxx#..  #   #xxx!"
	"xxx#..      #xxx!"
	"xxx#..  #  ####x!"
	"xx#######  #  ##!"
	"xx#            #!"
	"xx#  #  ##  #  #!"
	"#### ##  #### ##!"
	"#  $  ##### #  #!"
	"# # $  $  # $  #!"	
	"# @$  $   #   ##!"
	"#### ## #######x!"
	"xxx#    #xxxxxxx!"
	"xxx######xxxxxxx!",
	"luurrdrdrruldlluulldd4ruul3u9r5dllurdr4uru3ldl3uluurrd6l4r3d5l3drddl4ulu9rur4drdldllurdr4u"
	"ru3ldl3uluurrd5l3r3d5l5d3luurrdr3ulu9rur4drdldllurdr4uru3ldl3uluurrd4luld3r3d5l4d3rdrru4l"
	"dl4ulu9rur4drdldllurdr4uru3ldl3uluurrd4ldllru3r3d5l7d3ruullrrdd3l6ulu9rur4drdldllurdr4uru"
	"3ldl3uluurrd4lullrd3r3d5l5d4ru3ldl4ulu9rur4drdldllurdr4uru3ldl3uluurrd4ldlurul",

	// 18
	"xxxxx###########xxx!"
	"xxxxx#  .  #   #xxx!"
	"xxxxx# #.    @ #xxx!"
	"x##### ##..# ####xx!"
	"##  # ..###     ###!"	
	"# $ #...   $ #  $ #!"
	"#    .. ##  ## ## #!"
	"####$##$# $ #   # #!"
	"xx## #    #$ $$ # #!"
	"xx#  $ # #  # $## #!"
	"xx#               #!"
	"xx#  ###########  #!"
	"xx####xxxxxxxxx####!",
	"lddrr3dldurrdl4ulld5ld3l3dlddru10r5urullr6d3luurrllddrruruu3d6luuluulluurrd5ruudd5lul3ur"
	"rd4rurrd4ldlu3rddl4drruruurullr3dldll3uruudd5lul3urrd4rurrd4luld3rddrr3dlddr4u5d3r5ullullr"
	"3dldll3uruudd5lul3urrd4rurrd4lulldrurdrrddrr3dlddr4urullr4d3l3uruudd5lul3urrd4rurrd5lruld3"
	"r3d5ldlud3luuldld4rl3dlddr4u3drruur3ulldr3lulld4rl4drruldl3u3d7r4ulu5ldllulld3r3drruruuddr"
	"ruruu4lr3drdd3r3ud3r4ulld5l3rddrudd3r4ulld4l",

	// 19
	"xx######xxxxxxxxxxx!"
	"xx#   @####xxxxxxxx!"
	"##### $   #xxxxxxxx!"
	"#   ##    ####xxxxx!"
	"# $ #  ##    #xxxxx!"
	"# $ #  ##### #xxxxx!"
	"## $  $    # #xxxxx!"
	"## $ $ ### # #xxxxx!"
	"## #  $  # # #xxxxx!"
	"## # #$#   # #xxxxx!"
	"## ###   # # ######!"
	"#  $  #### # #....#!"
	"#    $    $   ..#.#!"	
	"####$  $# $   ....#!"
	"#       #  ## ....#!"
	"###################!",
	"d3rdd3r9dllu5lulld11rurd9lddrulu8rdrrdrullu14lur5ur3ulldr7dld13rurrlddldrrluu13l6urrddrr"
	"uu4r5d5u7lul6dld4rdrru7rurddldruu8ldllu9rurdd5ldlur4ulldlluullulul5dld4rdrru7rurd8ldllu9"
	"rdrrlu5l3ulldll3u3lul3ur3dl5dld13rurd5l6u7lul6dld12rdrruuld4l3ullulrddll3u3lul5dld13rdru5"
	"l6u5luurdldllul6dld13r4l6u7lul6dld8rdr4ullulluu4r6d3ldd3luruulld10r3l3ullullu4l4dld8rd5ru"
	"ll8u3luu3l3dl3d3rdrr3d6u7lul6dld12r4ld4r",

	// 20
	"xxxx##########xxxxx!"
	"#####        ####xx!"
	"#     #   $  #@ #xx!"
	"# #######$####  ###!"
	"# #    ## #  #$ ..#!"
	"# # $     #  #  #.#!"
	"# # $  #     #$ ..#!"
	"# #  ### ##     #.#!"
	"# ###  #  #  #$ ..#!"
	"# #    #  ####  #.#!"
	"# #$   $  $  #$ ..#!"
	"#    $ # $ $ #  #.#!"
	"#### $###    #$ ..#!"
	"xxx#    $$ ###....#!"
	"xxx#      ##x######!"
	"xxx########xxxxxxxx!",
	"r3dlUr3d4lu3l4dLLulldd3l9u4ru4rd3D4lulld5Rd3RurD4l4dllulldd3l9u4ru4r3dDld3Rd3RU3rddllU4luurDl"
	"d3RuRuulDu3r4dlldlUrUURld3LdlUru3L5u4ld4l9d3ruurrdrr3uUru3Lulld4R5dllulldd3l9u4ru4r3dDld3RurD"
	"ld3Rd3ruUllUluRRlldDrD3LdlUru3L5u4ld4l9d3ruurrdrr3uUru3Lulld4R5dllulldd3l9u4ru4r3dDld3RurDld3"
	"RdRRlddrruUll3UluRuul4Drd3LdlUru3L5u4ld4l9d3ruurrdrr3uUru3Lulld4R5drRddlUruLdl5U4dllulld3R3ld"
	"3l9u4ru4r3dD3Lulld4R4drddl5U3RurDld3RurD4lu3l4d4ld3l9u4ru4r3dD3Lulld4R6drrdrruu3Ldl5U3RurD4l4"
	"d4ld3l9u4ru4r3dD3Lulld4Rd3Rd3RdRRlU4luurD4l4d4ld3l9u4ru4r3dDl5d4lulDr4d5r3Ul5u3Rd3RuRRlD4luur"
	"Dld3RdR3dl3UrU3LdlUru3L5urrdLul4D4u4ld4l9drRu5r3uU3RurDld3RuR3DldRRlddrruU3l3u3lullu3Lulld4R6"
	"drruLdl5U4d5ldll9u4ru4r3dD3Lulld4R6drrdrUru3L4dlluRdr3Ul5U3RurD4l4d5ldll9u4ru4r3dD3Lulld4R6dr"
	"ruLdl5U3Rd3Rur5Durr3d3lURRdrUll5u4luurDld3Rur3DldRRll3u3lu3l5drdd5luUlu4R4ldll9u4ru4r3dD3Lull"
	"d4R4drddl5U3RurDld3Rur6DldRRl6u4lu3l4dlldLulldll9u4ru4r3dD3Lulld4Rd3RurD4l5drdd4lUlUlu4R3lddr"
	"U4l9u4ru4r3dD6lddrUlu5R4drddl5U3Rd3Rur6DldR3ulD4u3luurDld3Rur3DldR3u4lu3l4dllulld3R4ldll9u4ru"
	"4r3dD3Lulld4R4drddl5U3RurD4l4d5ldll9u4ru4r3dD3Lulld4Rd3Rd3Rur5DlDRRll5u3luurDld3Rur5DldR5u4lu"
	"3l4d5ldll9u4ru4r3dDld3RurDld3Rur6D",

	// 21
	"#########xxxxxx!"
	"#       #xxxxxx!"
	"#       ####xxx!"
	"## #### #  #xxx!"
	"## #@##    #xxx!"
	"# $$$ $  $$#xxx!"
	"#  # ## $  #xxx!"
	"#  # ##  $ ####!"
	"####  $$$ $#  #!"
	"x#   ##   ....#!"
	"x# #   # #.. .#!"
	"x#   # # ##...#!"
	"x##### $  #...#!"
	"xxxxx##   #####!"
	"xxxxxx#####xxxx!",
	"drrll4dllddrrurrddrdrrul3uruurdldrrdrruuldll4uluur5dld3rur3dulull5u3ldrrur4dldrrddrr3uldll4"
	"u3l3u5l3d7rur4dld3rurddlulluuludll3(ur)4dldrrdrruul3duu5lur4uluu5l3d5r3l4dllddrrurrddrdr3ud"
	"dlluull4udd3rd4rdrruulddll3ulldld4rdrruuldrdlulluuldld4rurd3l4ul3dld4rll5ull4duuld5u5l3drr3d"
	"3rd4rluulldld3ru6l3u5rur5d4u9lddrulu8rur4d",

	// 22
	"######xxxxx####xxxx!"
	"#    #######  #####!"
	"#   $#  #  $  #   #!"
	"#  $  $  $ # $ $  #!"
	"##$ $   # @# $    #!"
	"#  $ ########### ##!"
	"# #   #.......# $#x!"
	"# ##  # ......#  #x!"
	"# #   $........$ #x!"
	"# # $ #.... ..#  #x!"
	"#  $ $####$#### $#x!"
	"# $   ### $   $  ##!"
	"# $     $ $  $    #!"
	"## ###### $ ##### #!"
	"#         #       #!"
	"###################!",
	"uuRRddRRuRurrddldDldD8lLLuullUlUUluurDDRR3Du3l5drRuu4R4l3drrUUddlluuRuRR3lddlldRRlldRdd7r3uR3Ul"
	"uR4dlddR6Ulu3Rdd4rdDlUruLLr4dlLulLrrRdrUdrrdd6lUUl5URdrUddrU3rddD3ldLLdl5UdllUdlUUd4l3dRUUlu5RU"
	"d4lddrUluRuulDrdRRlldlluRRl5ullDRur4DrdRlddldd3rRRdr4UlURlUllDurrR6drd6ruu6Ldl5URdrU3ruur5D4lLd"
	"lUU3drd6ruuLLuUr6uruul6D7ldlU3ldlluRRuull5ur6Drd3RdrUd3Ru4r3Dld4Ldl3Udd5lUll3u8RUdRdlL4drd6ruuL"
	"Lr9ulldRur8Dld4Ldl4ULuR5drd6ruuLLuuUruLr4u4luRluurDDldRuRRur9Dld4Ldl3Udd5luUUlu5RdRRUdl4drd6ruu"
	"LLr9u3ldRRur8Dld4Ldl3Udd6luu3l5uRRur3Drd4rRRdLu5ldllu7R6l4u3ruulDLdlluur5Drddllu5R5l3dld7Rdr4U4"
	"drd6ruu6Ldl3Ud6r8u4lulld5Ldlluur5Drddllu4R3l5u3rdLLul4Drddllu3R",

	// 23
	"xxxx#######xxxxxxxx!"
	"xxxx#  #  ####xxxxx!"
	"##### $#$ #  ##xxxx!"
	"#.. #  #  #   #xxxx!"
	"#.. # $#$ #  $####x!"
	"#.  #     #$  #  #x!"
	"#..   $#  # $    #x!"
	"#..@#  #$ #$  #  #x!"
	"#.. # $#     $#  #x!"
	"#.. #  #$$#$  #  ##!"
	"#.. # $#  #  $#$  #!"
	"#.. #  #  #   #   #!"
	"##. ####  #####   #!"
	"x####xx####xxx#####!",
	"urru4r3dlddrulu3rdrruulur3dlu3luuldr4uldd3luurdld3rur3dldr3u4lddrulu3rdrddluuru3luldrd4l"
	"3ru4r5dl4uru3luldrd3lul6d4ul3udd4ru4r7dl6uru3luldrd4l3ru3r3d3rdrru4ldl3uru3luldrd3lul5d"
	"3uluud4ru3ruuruul3durdd3luldrd4l3ru4rddld3rdrru4ldl3uru3luldrd3lull5d3uru3r3dr3ulu3rur3d"
	"ld3rdrru4ldl3uru3luldrd4luudl4d3u4r5dr5ulu3rur3dld3rdrru4ldl3uru3luldrd4l3ru3r3d4r3dluur"
	"u3ldl3uru3luldrd3lull3druu3ru3r3d5ruuldrd4ldl3uru3lul3ur3dldrd4lulddu4ru3rur3dld3r3drr3u4"
	"ldl3uru3luldrd3luld3ru3r3d4ruuldrd3ldl3uru3luldrd3ldlu3ru3r3d3ruuruul3drd3ldl3uru3luldrd3l"
	"ul4d3u3ru3r3d3ruu4rurddlddrddl4uru4lulddrd3ldl3uru3luldrd3lul3duu3ru3r3d3ruu4rdr3drdldl5ur"
	"u4lulddrd3ldl3uru3luldrd3lulddu3ru3r3d5rulu3rur5drdldl5uru4lulddrd3ldl3uru3luldrd3luld3ru3"
	"r3d3r6ur3duurddlddrd4ldl3uru3luldrd4l3ru3r3d3ruu4rur5drdldl5uru4lulddrd3ldl3uru3luldrd3l",

	// 24
	"###############xxxx!"
	"#..........  .####x!"
	"#..........$$.#  #x!"
	"###########$ #   ##!"
	"#      $  $     $ #!"
	"## ####   #  $ #  #!"
	"#      #   ##  # ##!"
	"#  $#  # ##  ### ##!"
	"# $ #$###    ### ##!"
	"###  $ #  #  ### ##!"
	"###    $ ## #  # ##!"
	"x# $  #  $  $ $   #!"
	"x#  $  $#$$$  #   #!"
	"x#  #  $      #####!"
	"x# @##  #  #  #xxxx!"
	"x##############xxxx!",
	"uurllurrurruluuru3ldlluruu5rdrru3ruu10l11ru11l10r3dludlldllu5l3dr3drddrd7rururrdrrul6uru"
	"lulldlrddlul3u9l10ru10l8r4d3rulldluud3rurrd3ldl3u8l9ru9l7r3dlldllu3r8l3dr3d4rd3r3lu3lddr"
	"d7rururrdr7uru4ldlluuddr3u7l8ru8l6r3d5r7d3ldldlluru4rdr7uru5ldluud5r7d5lddrulu4rdr7uru4ld"
	"l3u6l7ru7l5r3d5r7d4l3druulu3rdr7uru5ldluud9l3dr3drr4ull4d4rddu8rdr7uru4ldl3u5l6ru6l4r3d9l"
	"ddldrur3dr3drrd3rud3rdruulu3rdr7uru5ldluud9ldd3r3drdrd8rdr7uru4ldl3u4l5ru5l3r3d5r7d5luuru"
	"ul3duul3(ld)dld5rluu5rdr7uru5ldluud5r7d3l3dluulu4rdr7uru4ldl3u3l4ru4lrr3d9lddr3drd3rd8rdr"
	"7uru5ldluud5r7d5l3ul3(ld)dllud3lurru3rd8rdr7uru4ldl3ull3ru3lr3d5r7d5l3ulldldllu3lddld4rlul"
	"u3rddu8rdr7uru5ldluud9lddlddrur4dld4rd6rdruulu3rdr7uru4ldl3ulur3d4r7d5l3ul3(ld)8rdr7uru4ld"
	"luud4r7d9ldld6rdruulu3rdr7uru5ldl3urul",

	// 25
	"####xxxxxxxxxxxxxxx!"
	"#  ##############xx!"
	"#  #   ..#......#xx!"
	"#  # # ##### ...#xx!"
	"##$#    ........#xx!"
	"#   ##$######  ####!"
	"# $ #     ######@ #!"
	"##$ # $   ######  #!"
	"#  $ #$$$##       #!"
	"#      #    #$#$###!"
	"# #### #$$$$$    #x!"
	"# #    $     #   #x!"
	"# #   ##        ###!"
	"# ######$###### $ #!"
	"#        #xxxx#   #!"
	"##########xxxx#####!",
	"ddldu4lddrddllu4luu5l5d7ruudd7l5u5rddrrd4ruulu3luululuulluurrdulldd9rdruuru4lrdd6lddldrd"
	"d5l5d7r3ull7ulluurrdulldd9rdruuru3ldd6l7drrd4ruulu3luurullrddlul3ulluurrdulldd9rdru8l3dr"
	"ruldl3ulluurrdulldd8rurrdrulddluud7lddrr3d3rdrdd4l5urulldl3ulluurrdulldd9rdru8lddrr5dllu"
	"ullul3ulldrur3drdrr5ulluurrdulldd8rurrddlu7lddrr8d7l5u4r4l5d7ruurruldl5urulldl3ulluurrdu"
	"lldd9rdruuld7lddrr5drruldl4urulldl3ulluurrdulldd8rurrddlu7lddrr4d3rulldl3urulldl3ulluurrd"
	"ulldd10r8lddrr5dll7ulluurrdulldd9rdru8l5d5lururdld3r4l5d7ruu6ruu5ldl4urulldl3ulluurrdulld"
	"d9r7lddrr5dll7ulluurrdulldd8r6lddrr4d6rdrru7ldl4urulldl3ulluurrdulldd7r5l5d3l4ul3dld4r4l5"
	"d7ruu7rddrruldl3uru7ldl4urulldl4u3drr5d3ldllu4rl7ulluu3rldulldd6r4l5d3l4uluuluur7dld4r4l5d"
	"7r7urulldl4u3drr5dll7ulluurrdulldd5r3lddrr4d4rd3ldl5urulldl3ulluurrdulldd4rllddrr3d3r2(urr"
	"d)d6ldl4urulldl3ulluurrdulldd3r",

	// 26
	"x#######xxxxxxx!"
	"x#  #  #####xxx!"
	"##  #  #...###x!"
	"#  $#  #...  #x!"
	"# $ #$$ ...  #x!"
	"#  $#  #... .#x!"
	"#   # $########!"
	"##$       $ $ #!"
	"##  #  $$ #   #!"
	"x######  ##$$@#!"
	"xxxxxx#      ##!"
	"xxxxxx########x!",
	"ullu3ldulluluu4r4lddrulu3rdru3l4dlullull3urdrull3drudrddluruulldrurdld3rdr3ulu3rdrruul"
	"d3l3d3lull3urr3dld3rdr3ulu3rurrddluud3l3d3lulluurur3dld3rdr3ulu4r3l3d4l6ur5dld3rdr3ulu"
	"3ru3rddlurulld3ldldrd3ldluulururddld3rdr3ulu5r4luul4drd3ldluulururddld3rdr3ulu4ru3rddlur"
	"ulld4l4dru4rdrru6ldl3ulu5rurrddluruld5l3dr3d4ruuru5ldl3ulu6rurd6l3dr3d5ruuru6ldl3ulu4r3l"
	"3d3rdlu3r3d3luurullrddlul3ulu3rll4drruldl3ulurr",

	// 27
	"x#################x!"
	"x#...   #    #   ##!"
	"##.....  $## # #$ #!"
	"#......#  $  #    #!"
	"#......#  #  # #  #!"
	"######### $  $ $  #!"
	"xx#     #$##$ ##$##!"
	"x##   $    # $    #!"
	"x#  ## ### #  ##$ #!"
	"x# $ $$     $  $  #!"
	"x# $    $##$ ######!"
	"x#######  @ ##xxxxx!"
	"xxxxxxx######xxxxxx!",
	"3(ru)uluuluulldlu4ruu3ld6luld7ru3rdd3lr3(rdd)3luul3uluru4l4ru3rdd3ldluru3lulddrd4lruluu"
	"rrd4rd3rddlrrddrdd3luul3udrruulldluru6lulddu7r3d3rdd4ruuruu3ldd4lrrddrdd3luul3udrruulld"
	"luru6l6r3d3rdd4ruu6lrrddrdd3luul3udrruulldluru5l5r3d3rddrud3ruu6l3r4d3luul3udrruulldluru"
	"4l4r5drddrr3uru3lrr4dlluul3udrruulldluru3lulddllru4rd4rddrddluru3lrr4dlluul3udrruulldlur"
	"u4lulldduurddu5r3d5ruurrdrd7lrr4dlluul3udrruulldluru5l5r3d5r4urr3drd7lrr4dlluul3udrruul"
	"ldluru4l4r5d3ldd5rdr4uru3lrr4dlluul3udrruulldluru3luld4r5dllu4lddlddru8rdr4uru3lrr4dldd"
	"3lulu3ruul3udrruulldluru3ldllru4r5drddrdr4uru3lrr4dlluul3udrruulldluru3lullrd4r5dllu3ldld"
	"ld3rdrrllu6rdr4uru3lrr4dldd3lulu3ruul3udrruulldluru3ldlu4r5drddrdr4uru3lrr4dlluul3udrruul"
	"ldluru3luld4r5d5lulddldrd4r4lu8rdr4uru3lrr4dldd3lulu3ruul3udrruulldluru3l3r5drddrdr4uru3l"
	"rrdd5rddl3u3d6luul3udrruulldlurullulddu3r3d5ruu3rdd7lrr4dlluul3udrruulldlurulluld3r5d3ldd"
	"5rdr4uru3lrr4dlluul3udrruulldlurull",

	// 28
	"xxxxxxxxx#####xxx!"
	"xxxxx#####   #xxx!"
	"xxxx## $  $  ####!"
	"##### $  $ $ ##.#!"
	"#       $$  ##..#!"
	"#  ###### ###.. #!"
	"## #  #    #... #!"
	"# $   #    #... #!"
	"#@ #$ ## ####...#!"
	"####  $ $$  ##..#!"
	"xxx##  $ $  $...#!"
	"xxxx# $$  $ #  .#!"
	"xxxx#   $ $  ####!"
	"xxxx######   #xxx!"
	"xxxxxxxxx#####xxx!",
	"r3ulu4rururrdr3dl4drrurdrrdruud5lddrulu5rdr3uldd4l3drrululu3rdr3urullr3d3l3dluulu4r"
	"dr4urullr4d6l4ur3ululldld3l3d3r3d8rdr5uruudl5d6l4urrdlul3dld6rdr4u3d6l3ur3urrulrruu"
	"lldl4drdlul3dld7rdr6udl4d6l3ur3u2(rrul)uldl4drdlul3dld6rdr3udd3lulld4l3u3l3u3ru3rlur"
	"r4dl3dld7rdr4ul3d6l4urrdlul3dld7r6l3ur3urrulruuldl4drdlul3dld6rdrruuld6l3ur3urrulul4"
	"drdlul3dld6rdr4urdl3urddl3d9lurrlluu3l3u3rurrdrur3dl3dld6rdr5u4d6l4urrdlul3dld6rdr4u3"
	"d9ldd4rludlluru7r3l3dluulu4rdr3u2(dd3l)ulu6rdruud3lu7lurdd8rdru6l3ur4u4ld3l3drrurddld"
	"3rlluu3l3u6rur3dl3dld6r5l4urrdlul3dld5r",

	// 29
	"#####xxxxxxxxxxxxxx!"
	"#   ##xxxxxxxxxxxxx!"
	"# $  #########xxxxx!"
	"## # #       ######!"
	"## #   $#$#@  #   #!"
	"#  #      $ #   $ #!"
	"#  ### ######### ##!"
	"#  ## ..*..... # ##!"
	"## ## *.*..*.* # ##!"
	"# $########## ##$ #!"
	"#  $   $  $    $  #!"
	"#  #   #   #   #  #!"
	"###################!",
	"d5lddrdrru5rdlu4ldllulld3rll5urdu4rdrrdrrurrdl4drddlulldllurrl3u6l6r3d3ldllu4rdr3"
	"uru6ldll3uruul4dldrrl4ulluulul4dlddrddlddrurrdrru4r4ldllu4rdrrurrdrrul3u6ldllur3u"
	"lluull3dlddrddld3r2(drrurr)dr3uru5l4r3d3ldllu4rdr3uru4l3r3d7ldllu8rdr3uru3lrr3d11l"
	"3uluur4dld11rdr3urullr3d11l8urr3drur3dldr5u5rdd4l4rurrdrrurrdl4drddlulldl3urul3d11l"
	"8urrddrr3d4u3rdurrdd4l4rurrdrrurrdl4drd3ldl3udd11l8u2(rrdd)u5rurrdrrur5drd3ldluu",

	// 30
	"xxxxxxx###########x!"
	"xxxxxxx#   #     #x!"
	"#####xx#     $ $ #x!"
	"#   ##### $## # ##x!"
	"# $ ##   # ## $  #x!"
	"# $  @$$ # ##$$$ #x!"
	"## ###   # ##    #x!"
	"## #   ### #####$#x!"
	"## #     $  #....#x!"
	"#  ### ## $ #....##!"
	"# $   $ #   #..$. #!"
	"#  ## $ #  ##.... #!"	
	"#####   ######...##!"
	"xxxx#####xxxx#####x!",
	"lluullddr4dlddru3rddrruuluu3rddrruuld6uluurdrrurrd4l6d4lulldrurd5rddlurul7ulldru"
	"rdrru4rd4l3rddr6drdlldl3urulrruu3l3u3d3ruuld4u3ldr3drrur6drdllur5ulldrll4urur3dr"
	"5dlldd3ruldlur4u2(llur)luurrddr6drdl5ullur3u5lulld6rur3dr5dlddrru3lurr3ullur3u5l6d"
	"rddl7ulu5rur3dr5dlddrruldlur4ullur3u5l6d4lulld5rdrddluur6ulu5rur3dr5dlddrrul4ullur"
	"3u5l6d4lulld5rdr6ulu5rur3dr6drd3lruur3ullur3u5l6d4luurruull3dld4rdr6ulu5rur3dr5dld"
	"drrullr4ullur3u5l6d4luurrululd3luulldd5rddld4rdr6ulu5rur3dr5dlddrrul4ullur3u5l6d4l"
	"uurrululd3luuldld5rddld4rdr6ulu5rur3dr6drdllur4ullur3u5l6d4luurrulul3dld4rdr6ulu5r"
	"ur3dr6drdl5ullur3u5l6d4l3u4l4dlddr5u4d3rddrruul4uruul3dld4rdr6ulu5rur3dr7d5ullur3u5"
	"l6d4lddrddl6uruul3dld4rdr6ulu5rur3dr6d4ullur3u5l6d4l3u3lulldr5d3rdruud4l5u4rddld4rd"
	"r6ulu5rur3dr5d3ullur3u5l6d4luurrulul3dld4rdr6ulu5rur3dr4duullurur3d",

	// 31
	"xx####xxxxxxxxxxxx!"
	"xx#  #########xxxx!"
	"x##  ##  #   #xxxx!"
	"x#  $# $@$   ####x!"
	"x#$  $  # $ $#  ##!"
	"##  $## #$ $     #!"	
	"#  #  # #   $$$  #!"
	"# $    $  $## ####!"
	"# $ $ #$#  #  #xxx!"
	"##  ###  ###$ #xxx!"	
	"x#  #....     #xxx!"
	"x####......####xxx!"
	"xxx#....####xxxxxx!"
	"xxx#...##xxxxxxxxx!"
	"xxx#...#xxxxxxxxxx!"
	"xxx#####xxxxxxxxxx!",
	"uldd3lddrdrr3drdllul3drdluurr5ulluluu3r6drdlluldduu8r4uluulu3lul8drdl8urrdrddluurullu"
	"l8dl3dluu4ru4r4ululldldlrdr4ulull7drdlluldrr4u3ruurrulu3lul8drdlulddlrr5u3r3uru3lul8"
	"drdllul3durr5urr3urullul8drdllulddrr5ullululldlddru4rll3u3r7d4u3luulldld5rll3u3r6drdl"
	"luldrr4u5lddrulu4rll3u3r6drdl4ulldlldlulu5rll3u3r6d6u3lull3dld5rll3u3r5drdlldrru5r4ur"
	"ulldluuluurrddu4lul8d3u5l3u4rur6drddllur3u3luul4urddld3rur7drdl4u3ru3r4d4l4r5u3rd6luur"
	"u3lul7drdl3urr3urullul8d6ruuldrd4l4r5u3ldluurullul7d",

	// 32
	"xxxxxx####xxx!"
	"xx#####  #xxx!"
	"x##     $#xxx!"
	"## $  ## ###x!"
	"#@$ $ # $  #x!"
	"#### ##   $#x!"
	"x#....#$ $ #x!"
	"x#....#   $#x!"
	"x#....  $$ ##!"
	"x#... # $   #!"
	"x######$ $  #!"
	"xxxxxx#   ###!"
	"xxxxxx#$ ###x!"
	"xxxxxx#  #xxx!"
	"xxxxxx####xxx!",
	"rurr3drddrrurrd6ldluurrd6rddluru7l6r3dlluuru4l3r3d3(ru)5ldlu4r3urddurdd5lullrd3rd"
	"drud3rull5ur4d5ldlluurd4r3ulurl3drd3ldlurul5u3rur6drd5l4urulu3rur4drruldlddrd4ldl5"
	"uruu3r5drd3lrr6u3lddl5drurrddrud3rullu4l3r6u3lddl4d3rddruru4l3r5dl4urullrr6u4l4d3ulldrurdd",

	// 33
	"############!"
	"##     ##  #!"
	"##   $   $ #!"
	"#### ## $$ #!"
	"#   $ #    #!"
	"# $$$ # ####!"
	"#   # # $ ##!"
	"#  #  #  $ #!"
	"# $# $#    #!"
	"#   ..# ####!"
	"####.. $ #@#!"
	"#.....# $# #!"	
	"##....#  $ #!"
	"###..##    #!"
	"############!",
	"ddldll3u3l3ur3ul3urrdll3r6d3rululdl3u3ruu4lull3dr3dl3d3ruurl5drruldl3urdlddrruldlu"
	"uru3lulddrdllr5ur3ul3urrd4rdd3l2(ddrddl)uru3lulddrdluu3ruuruul4drddluru3luldrd3lrdr5urd"
	"d5ul3urrdr8dllulddrdluu4rddluru3luldrdllruu3luurdldrrll5urrlddrurur6duulddrdlu3r8ulull3dl"
	"dr4urrdlul3dr5d5uluu5rdlul8dllul3duu4rddluru3lulddu3r3u3rdllul3drddluru3luldu3l3urddldrrll"
	"5urrdrur6drr7u3rdllul7drddluru3lrr8u3lddldrur5d4ul4ulldrur3dldrur4d",

	// 34
	"x#########xxxx!"
	"x#....   ##xxx!"
	"x#.#.#  $ ##xx!"
	"##....# # @##x!"
	"# ....#  #  ##!"
	"#     #$ ##$ #!"
	"## ###  $    #!"
	"x#$  $ $ $#  #!"
	"x# #  $ $ ## #!"
	"x#  ###  ##  #!"
	"x#    ## ## ##!"
	"x#  $ #  $  #x!"
	"x###$ $   ###x!"
	"xxx#  #####xxx!"
	"xxx####xxxxxxx!",
	"lul4(rd)dlu3luuluuru5lrddll6drddl6ulur6d3rdlrddluuruldd3rur3ulluur4uru4l4dlul7drrurd"
	"luldl8urruu3r5dld3l3rdrr3dldlldluurullul4ulurrdruull6drddl6ulurrdrull3d4rdrudrru6l4r"
	"uurdl4uru3lrd3r3(dr)ddlu3l4r3dlddlld4ldluurullul4ulurdrul5drddl7u3d5r5urulld3r3(dr)d3"
	"ld6lrd3rdrddrd4ldluurullul4ulu3rll5drddl6ulurrl3d5ruurdrd6l5r4drd4ldluurullul4ulur5drddl6u",

	// 35
	"############x######!"
	"#   #    # ###....#!"
	"#   $$#   @  .....#!"
	"#   # ###   # ....#!"
	"## ## ###  #  ....#!"
	"x# $ $     # # ####!"
	"x#  $ $##  #      #!"
	"#### #  #### # ## #!"
	"#  # #$   ## #    #!"
	"# $  $  # ## #   ##!"
	"# # $ $    # #   #x!"
	"#  $ ## ## # #####x!"
	"# $$     $$  #xxxxx!"
	"## ## ### $  #xxxxx!"
	"x#    #x#    #xxxxx!"
	"x######x######xxxxx!",
	"llu3ldlldl3drru5rdr3ulu5rurddu7lu3ldlldldd7rdr3ulu7r8lu3l3duullulld3rll3d7rdr3ulu6r7lu3l3"
	"duu3l3d7rdr3ulu4rddl9dllu3l5uludr5d5r8u4rl3uld6lu3l4dldru4rdr3ulu4rd3rululdlddl8d5l5ululu4"
	"rdr3ulu6rurddllu4l3d4lddrddl3ulu4rdr3ulu6r5l3d6l4drdr4ulu4rdr3ulu5rurd5l3d4l4d3ldrddrdd3lu"
	"ul3urrdrddlur5ulu6rdr3ulu5rdru5l3d4l4d5lddrrdr6ulu6rdr3ulu5rurddldll8d5l3udrruulldl2(3ulu4"
	"rdr)ruulddu4l3d6l7drdd3luulurrdr6ulu6rdr3ulu4rdrruuldrdlu4l3d6l6dludlluurrdr4ulu6rdr3ulu5r"
	"dru5l3d4lddr5d4lrrdd3luulurrdr6ulu6rdr3ulu5r4l3d4lddr5d5r6urruuddlluurl10d3luru7lrrdd3luulu"
	"rrdr6ulu6rdr3ulu4rdru4l3d4l5dl5rdu3lddrrd3r7urruuddlluurl8d9lr6ulu6rdr3ulu4rddl8d7ldd3luulu"
	"rrdr6ulu6rdr3ulu3r",

	// 36
	"xxxxxxxxxxxx#####xx!"
	"#####xx######   #xx!"
	"#   ####  $ $ $ #xx!"
	"# $   ## ## ##  ##x!"
	"#   $ $     $  $ #x!"
	"### $  ## ##     ##!"
	"xx# ##### #####$$ #!"
	"x##$##### @##     #!"
	"x# $  ###$### $  ##!"
	"x# $  #   ###  ###x!"
	"x# $$ $ #   $$ #xxx!"
	"x#     #   ##  #xxx!"
	"x#######.. .###xxxx!"
	"xxxx#.........#xxxx!"
	"xxxx#.........#xxxx!"
	"xxxx###########xxxx!",
	"l6d9u3rd3rddrud3lddrddlu3l4ruulurruu3lu3l8duu5ruuldrd4l3r3urruu3lu3l7dldrrd4ld6rll4u3r3urr"
	"urrdldllulddrd4l2(3ruu)lduu3lu3l9d3u4r3u3rdllulddrd4l3ruurr3u3lu3l8d8u3rdrruur4drdllulddrd4l"
	"3ruurr3u3lu3l7dr3d4lu6rllul8u5ruruulddrdrdul3drdllulddrd4l3ruurr3ullu4l8duu4r3u4rululddrdllu"
	"lddrd4l3ruurr3ullu4l7dldd3rd4lruur8u5rur4drdllulddrd4ldluulldld4l3ur3uru5r8d8u5rur4drdllulddr"
	"d4l3ruurr4u6l7drdd3ld4rluul8u3ldlluluulldd13rur4drdllulddrd4l3ruurr4u6l8d8u6luuldld13rur4drdl"
	"lulddrd4l3ruurr4u6l7dlddrrldluur8u4lulluldld13rur4drdllulddrd4ldluulldld4l3ur3uruulld7r8d8u5r"
	"ur4drdllulddrd4ldluulldldlluruulrddluddlluur4uruulld7r7d7u5rur4drdllulddrd4l3dllrdruul3ulldlldl"
	"l6uruulld7r9d9u5rur4drdllulddrd4ldluulld3ldl6uruulld7r8d8u5rur4drdllulddrd4ldluulldlluldl5uruul"
	"ld7r7dlddur8u5rur4drdllulddrd4ldluulldlluuldl4uruulld7r7drddul8u5rur4drdllulddrd4l3ruurr4u6l7dl"
	"dr8urruu3rur6drdllulddrd4l3ruurr4u6l7drdl8uluu6rur6drdllulddrd4l3ruurr4u6l7d",

	// 37
	"###########xxxxxxxx!"
	"#......   #########!"
	"#......   #  ##   #!"
	"#..### $    $     #!"
	"#... $ $ #   ##   #!"
	"#...#$#####    #  #!"
	"###    #   #$  #$ #!"
	"xx#  $$ $ $  $##  #!"
	"xx#  $   #$#$ ##$ #!"
	"xx### ## #    ##  #!"
	"xxx#  $ $ ## ######!"
	"xxx#    $  $  #xxxx!"
	"xxx##   # #   #xxxx!"
	"xxxx#####@#####xxxx!"
	"xxxxxxxx###xxxxxxxx!",
	"uull4rdrruluur3(uul)lu2(3ldd)rrudlluuluu4rdd3l4drr3udllul3u4rdd3lrr8drruldl7udlluluuld3urrdluld"
	"u4rdrdd3lrr7drruldl6udlluuluu4rdd3lrr7d4ru3ldl6udllul3ulurrd3rdd3lrr6d3ruullrrdd3l5udllul3u4rdd"
	"3ldluud4ruurrdd5l3ruu4lddr4d4ru3ldl3udrruull4ru8rurrd9lu5luld2(4rddru)lu4rurrd9lu5l3rddru5r4drdd"
	"l5ulu4rurrd9lu4lrrddru5r4dllulldurrd6ldluurr5d6rdr3ulludrr5ulu4rurrd9lu3lullrrdrddru5r4d6ldl3u5d"
	"3ruulu4rlddrr5ulu4rurrd9lullru3lrr3druud4rdd3rdldl3ulu4rurrd9luu3lr3dru10r4dl3uru10lurullr3dluud"
	"11r6dl5uru10ldludll",

	// 38
	"xxxxxx####x!"
	"####### @#x!"
	"#     $  #x!"
	"#   $## $#x!"
	"##$#...# #x!"
	"x# $...  #x!"
	"x# #. .# ##!"
	"x#   # #$ #!"
	"x#$  $    #!"
	"x#  #######!"
	"x####xxxxxx!",
	"ddlu3ldllddrrdru3l3urrddrddldll3u3drddl4urr3u3ldrrurddrdr3dllullddrulurluurrdru3rddrd5luudll"
	"ddrulurluu3rl3u3rdr4drd5luudllddrulurl3udrr3u3ldrrurdu3rur6drd5luudllddrulurdru",

	// 39
	"xxxxxxxxxxxxx######!"
	"x#############....#!"
	"##   ##     ##....#!"
	"#  $$##  $ @##....#!"
	"#      $$ $#  ....#!"
	"#  $ ## $$ # # ...#!"
	"#  $ ## $  #  ....#!"
	"## ##### ### ##.###!"
	"##   $  $ ##   .  #!"
	"# $###  # ##### ###!"
	"#   $   #       #xx!"
	"#  $ #$ $ $###  #xx!"
	"# $$$# $   #x####xx!"
	"#    #  $$ #xxxxxxx!"
	"######   ###xxxxxxx!"
	"xxxxx#####xxxxxxxxx!",
	"u3ldrddlu5lrddlulldr3dlddru4rdrrdrrudlluru5rdr9ulurrl9d6lddrulu5rdr5u4d5ld4luurdld3rdrul"
	"u5rdr4ud3luu4rul5d6luuluuluu3ldll4dld5ruu3l3rdrdld3rdrulu5rdr5ulurrl5d6luul3ulu3ldll4dld5"
	"rurd5l4ul3ur6dld5rd3rdrulu5rdr6ulurrl6d6luu6l3rdrdld3rdrulu5rdr7ulurrl7d6luuluuluu4ldl4dl"
	"d5rurd5l4ul3ur6dld5rd3rdrulu5rdr8ulurrl8d6luulldd5l8urrdlul7dld5rd3rdrulu5rdr5ulur5d6luull"
	"ddld3rdrulu5rdr9u8d6luuluuluu4lul6dld5rurdld3rdrulu5rdr8u7d6luul3urrdluu6lul6dld5rurdld3rd"
	"rulu5rdr7u6d6luul3uru6lul6dld5rurdld3rdrulu5rdr6u5d6luuluur4uldrd6lul6dld5rurdld3rdrulu5rd"
	"r5ur4u3dl5d6luul6uldu4rdluldld5lul6dld5rurdld3rdrulu5rdr5ul3uddr5d6luul3urru7lul6dld5rurdld"
	"3rdrulu5rdr5ur3uddl5d6luul6u3rd3luldrd5lul6dld5rurdld3rdrulu5rdr5uluudr5d6luul4u4lddlul4dld"
	"5rurd6l3druulu5rd3rdrulu5rdr5urul5d6luulldd5l3drruulu3rd3rdrulu5rdr5uruulldrurdl5d6luulldd3l"
	"3d3(lu)5rd3rdrulu5rdr6ulur6d6luulldd3lddlulu4rd3rdrulu5rdr5ulur5d6luullddlddrddl3u3rdlrrulu5"
	"rdr6u5d6luu7ldd4rurdld3rdrulu5rdr5u4d5ld4l3drrululu3rdrulu5rdr4u3d5l3dlldluulu3rdrulu5rdr3u3"
	"l2(uurl)4d3rdd5ld3ldrrdruulu5rdruu",

	// 40
	"xxxx############x!"
	"xxxx#          ##!"
	"xxxx#  # #$$ $  #!"
	"xxxx#$ #$#  ## @#!"
	"xxx## ## # $ # ##!"
	"xxx#   $ #$  # #x!"
	"xxx#   # $   # #x!"
	"xxx## $ $   ## #x!"
	"xxx#  #  ##  $ #x!"
	"xxx#    ## $$# #x!"
	"######$$   #   #x!"
	"#....#  ########x!"
	"#.#... ##xxxxxxxx!"
	"#....   #xxxxxxxx!"
	"#....   #xxxxxxxx!"
	"#########xxxxxxxx!",
	"l5dllrrddlludrr9u6l4dlldl3drruulrddl3dlddrruldluruuru3ruruu4ldduu4rddld3l3uruulldlddldrr3dlld"
	"d3ru5ldlurrurullrd3ruu4ruruulu3(ld)uu4rddld3l3ululddldrr3dlddrrul4uluuruurrdrdlldduu4rddld3l3"
	"ululddldrr4drd5l3rur4ul3uluruuruurr5drdlldduu4rddld3l3ululddldrr3dlldd3ru5lruruld3r3uluurrddu"
	"u4rddld3luur3ullrr4ullddl5dldrr3dlddrrul4uluurrdduu4rddld3luur7u3l7dldrr4drd4lrrur4uluurrddur"
	"7u6r7dllrrddllulld3luur7u4rdru3ldrddldduurrd2(lrdl)lrr3ulddld3lulddldrr3dlldd3ru4lu3ruu4ruruu4"
	"ldduu4rddld3l3ululddldrr3dlddrru3lrr4ul4u3rdrdlldduu3ruurrd3lrr4ul4dr3dld3l3ululddldrr3dlddrru"
	"l3u4ruruu4ldduu4rddld3l3ululddldrr4drdllur4ul4u3rdrdlldduu4rddld3l3ululddldrr3dllrddrrulldluurr"
	"uu4rur8urrdllul5drd4ldduu4rddld3l3ululddldrr3dlddrrullr4uluurrdduu4rddld3l3rurrdrruullrr5uru4lu"
	"l5drd5lulddldrr3dlddrruldlur3u4rur3urululddrd4ldduu4rddld3l3ululddldrr3dlddrrul4uluurrdduu4rddl"
	"d3lul4drdllu",

	// 41
	"xxxxxxxxxxx#####xxx!"
	"xxxxxxxxxx##   ##xx!"
	"xxxxxxxxx##     #xx!"
	"xxxxxxxx##  $$  #xx!"
	"xxxxxxx## $$  $ #xx!"
	"xxxxxxx# $    $ #xx!"
	"####xxx#   $$ #####!"
	"#  ######## ##    #!"
	"#.            $$$@#!"
	"#.# ####### ##   ##!"
	"#.# #######. #$ $##!"
	"#........... #    #!"
	"##############  $ #!"
	"xxxxxxxxxxxxx##  ##!"
	"xxxxxxxxxxxxxx####x!",
	"ulld4luul3(ur)ddlul6drd9l3u7r7l3d8r5ulur3d3ru3rd6l3d8l3u7r7l3d8r5u3l5(ur)r3(dl)6drd8l7r7urrd"
	"lul6drd7l6r6urrdlul5drd6l5r5urr5uldl8drd5l4r5urr3ulul8drd4l3r5ulluurur7drd3lrr5ullurur6drdll"
	"r9u4rd3lul8drdl8u4rd3lul7d6u4rd3lul5du3rddruru14lul3duu14r3druuddrdldlul3uru13lulddu13ru3rd1"
	"5luld13r4dr3uru14l",

	// 42
	"xxxxx########xxxxx!"
	"xx####      ######!"
	"xx#    ## $ $   @#!"
	"xx# ## ##$#$ $ $##!"
	"### ......#  $$ ##!"
	"#   ......#  #   #!"
	"# # ......#$  $  #!"
	"# #$...... $$# $ #!"
	"#   ### ###$  $ ##!"
	"###  $  $  $  $ #x!"
	"xx#  $  $  $  $ #x!"
	"xx######   ######x!"
	"xxxxxxx#####xxxxxx!",
	"llddrdrddlddlld3lullrrddllul3uru3lrr4drdrruulldl3urullr3drddrurulldl5uru3ld4l3drrdd5rdrurulldl3"
	"urul4d6ruuld4ldl5urull3u3r4d4urrddr4d7lrrdd4rudrrulu4l4rdrdd4ldlul5urul3d5ruuldrd5l3drruldl4ud4"
	"rdrd4ldl3ulurulurdrr4urrdlul3duurr4drd4l3rdd4rd6ldlul3urul4drruldl3uluruuldr4d8ru3l3ruu3luldrd5"
	"l4rdrd4ldl5udd4ru3rddrd7ldl4ud4ru4ruul4drd7ldl3u4ru3r4ur3drd4luldrd4l3ru3ruullul3drd3lrru3r3ullr"
	"ull4drdllr5ululdduu3lddu3l3drr4l3drruuddll3u3rl5d3rulldl4uddll3urr",

	// 43
	"xxxxxxxx#######xxxx!"
	"xxxx#####  #  ####x!"
	"xxxx#   #   $    #x!"	
	"x#### #$$ ## ##  #x!"
	"##      # #  ## ###!"
	"#  ### $#$  $  $  #!"
	"#...    # ##  #   #!"
	"#...#    @ # ### ##!"
	"#...#  ###  $  $  #!"
	"########x##   #   #!"
	"xxxxxxxxxx#########!",
	"rdrdrrurrdru3ldlluruurull4r3ulluld3l4d4u3rddldlrr3dllu4ldluru4l3rd4ruu3r3u3l4du3r3dllu4ldluru3l3ru"
	"urdulluurrdrlulldd3lddulddru3rd4ruu3r3u3l4du3r3dllu4ldluruurd4ldlluurdd3u3ruurrddurr4d3ldluru3ldl"
	"luurdldr3u5rdd3urru6r3d5lrr3dllu4ldluru4luld6r3urr3du6rdrru7lrr3dllu4ldluru4l5r3urr3du3r3d3rdrru4"
	"ldl3uru3lrr3dllu4ldluru3l3ruu4ldd5r3urr3du3r3d4ruuru7lrr3dllu4ldluru3l4r3urr3du3r3dllu4ldlurull",

	// 44
	"x#####xxxxxxxxxxxxx!"
	"x#   #xxxxxxxxxxxxx!"
	"x# # #######xxxxxxx!"
	"x#      $@######xxx!"
	"x# $ ##$ ###   #xxx!"
	"x# #### $    $ #xxx!"
	"x# ##### #  #$ ####!"
	"##  #### ##$      #!"
	"#  $#  $  # ## ## #!"
	"#         # #...# #!"
	"######  ###  ...  #!"
	"xxxxx####x# #...# #!"
	"xxxxxxxxxx# ### # #!"
	"xxxxxxxxxx#       #!"
	"xxxxxxxxxx#########!",
	"6l5rdd5rduur6d3l3urrur3dldr3u3lulu3rur5dlddrurul4u7luru4luull7dld4rurrdrrul3uluurdld6rur5drddll"
	"ur5u6luu4luull8d3rurrddlurr4uluurdld6rur5duu3l3drrdrrul5u6luu5lruull7dld4rurrddlurr4uluurdld6ru"
	"r6drdl6u6luu4ldlul5dld4rurrdr4uluurdld6rur6d5u6l3dlddlu4luurdld3rurrdr4uluurdld6rur5d4u6l3dlddl"
	"ulurrdr4uluurdld6rur4du3r3dlr3dllu",

	// 45
	"#####x####xxxxxx!"
	"#...#x#  ####xxx!"
	"#...###  $  #xxx!"
	"#....## $  $###x!"
	"##....##   $  #x!"
	"###... ## $ $ #x!"
	"# ##    #  $  #x!"
	"#  ## # ### ####!"
	"# $ # #$  $    #!"
	"#  $ @ $    $  #!"
	"#   # $ $$ $ ###!"
	"#  ######  ###xx!"	
	"# ##xxxx####xxxx!"
	"###xxxxxxxxxxxxx!",
	"3r3l3urrddrdlu3rdlrddluruu3lddrrululuull4drruldl4u3(ruldlu)urulddrr3d3rddrdrrulldlldl4u3(ruldlu)"
	"rr3d3rddrd4ru4ldlldl4uruldluruldl3uldrr3d3rddrdlldlulldllu4r3u2(ruldlu)rullrr3d3r3dldlu4luurdld4"
	"r3u3(ruldlu)udrr3d3r3dldl4u3(ruldlu)rr3d3rdd7rd5lddrulu3ldl4u2(ruldlu)ur3d3rdd4rd5ldl4u2(ruldlu)r"
	"ulr3d3rdd5rddlldluru4ldl4u2(ruldlu)rr6d4rdruru5ldl4uruldluudd3rdd4ruurruull4drd6ldl4uruldlurullrd"
	"d3rdd4ruurrulul4drd6ldl4uruldluruldd3rdd4ruull3urur6drd6ldl4uruldlud3rdd4ruulluululuurdld3rur6drd6"
	"ldl5udrrdd4r6ulldlluurdld3rur6drd6ldl4urulld3rdd4ruulluurur5drd6ldl4uruldrrdd4ruullurur4drd6ldl4u",

	// 46
	"##########xxxx!"
	"#        ####x!"
	"# ###### #  ##!"
	"# # $ $ $  $ #!"
	"#       #$   #!"
	"###$  $$#  ###!"
	"xx#  ## # $##x!"
	"xx##$#   $ @#x!"
	"xxx#  $ $ ###x!"
	"xxx# #   $  #x!"
	"xxx# ##   # #x!"
	"xx##  ##### #x!"
	"xx#         #x!"
	"xx#.......###x!"
	"xx#.......#xxx!"
	"xx#########xxx!",
	"3ldlddrrurr3d7l7ururrdllrruuruu7l3d3r9dld5ruu3r3u3luurd4lruruu3l7dld5ru3r3ulldluru4lrr3u3l8dld"
	"4ruu4r3ulluuld4l3u3rddrd3lrr3u3l8d9u3l3u7rddl4drruuruul5d4lrr3u3l7dld4ru4r3ulldlur4ur3urdrdllul5d"
	"4lrr3u3l7dld3rurdu4r3ulldluruuruuluurrdlul5d4lrr3u3l7dld3ru5r3ulldluru4lrr5u3rurdrdllul3drdllr4ul"
	"l4duu3l7dldrrl5urrurrd3lrr3u3l7dldr7ulururu5rurdrdllul3drdllr4uluu7l3drrur9dlddrrul8u3rddrd3lrr3"
	"u3l7dldr10u6rurdrdllul3drdllr4ull4drd3lrr4ulldl7drdl7ul3ur10d5urrdrdru3r3d5l5r3ullu4lrr3u3l7durd",

	// 47
	"xxxxxxxxx####xxxxx!"
	"x#########  ##xxxx!"
	"##  $      $ #####!"
	"#   ## ##   ##...#!"
	"# #$$ $ $$#$##...#!"
	"# #   @   #   ...#!"
	"#  $# ###$$   ...#!"
	"# $  $$  $ ##....#!"
	"###$       #######!"
	"xx#  #######xxxxxx!"
	"xx####xxxxxxxxxxxx!",
	"lddrdrrurd3luluu4rd6rdr3udd7l3urrdduull3d6rdruud7lullurd3lddrd4rudlluru6r6lddrulu5rdr3ud4luulu"
	"ur4duull3d5r4lddllurdrulu4rdrruuld4ldd4lu3rdrulu4rdru5lu4lu3rlluu4rur4duull3d5rdru5lddllurdrulu"
	"5ruudrd6lu6lu5r3l3dllulld8rdrulu5r5lulu5lddld7rdrulu4rdru4ld9l4urur4dldrrddluru5rdrulu3rurrddl"
	"u4lu6ldld7rdrulu4rdruuld3ldd5lullddrulu6rdrulu4rurd5lu6l3u7rur4duull3d4r3lddllurdrulu3rlurrd",

	// 48
	"xx#########xx!"
	"xx#*.*#*.*#xx!"
	"xx#.*.*.*.#xx!"
	"xx#*.*.*.*#xx!"
	"xx#.*.*.*.#xx!"
	"xx#*.*.*.*#xx!"
	"xx###   ###xx!"
	"xxxx#   #xxxx!"
	"###### ######!"
	"#           #!"
	"# $ $ $ $ $ #!"
	"## $ $ $ $ ##!"
	"x#$ $ $ $ $#x!"
	"x#   $@$   #x!"
	"x#  #####  #x!"
	"x####xxx####x!",
	"luur4ulurululuuddrdrruruu4lddrurrdllr7dlddr9u7dllurdr6u5d3lurrdr3ur4ullrurr3lddrrddl3d5ld4rdr8"
	"ulurrl7d4ldd3rdr9u6d3l4dl3ulu4rdr6u9dllullddr3urrdr7u4d4ld3rdr5u3d3r3(dl)5ul4u3dr3drrdldl4ur4u"
	"3dl3d5rd4ldl4ul3uddr3d4rdd3ldl5ur3uddl3d3r4dr3uru4ldl3uluudr7drrurrddl3ulldl5uruudl3d4rd3ldl4u"
	"lurdru",

	// 49
	"xxxxxxx####xxxxx!"
	"xxxxxxx#  ##xxxx!"
	"xxxxxxx#   ##xxx!"
	"xxxxxxx# $$ ##xx!"
	"xxxxx###$  $ ##x!"
	"xx####    $   #x!"
	"###  # #####  #x!"
	"#    # #....$ #x!"
	"# #   $ ....# #x!"
	"#  $ # #.*..# #x!"
	"###  #### ### #x!"
	"xx#### @$  ##$##!"
	"xxxxx### $     #!"
	"xxxxxxx#  ##   #!"
	"xxxxxxx#########!",
	"rd4rdrrul5ulld3ldrrlddlddr3udd3rdrru4l3r5uluur6d4ulld3ldrddlddr4ulurrl4d3rdrru4lullddr4uluu4ru"
	"r5d4u3ldl4d3rdrru4lul4uldll3u5rlululd3u4(rd)drd3ldllu4rur5d4u4l4dlddr4u3d3rdrrul5u5ldr5lu3ld"
	"drrdrulu5r4ld3luurrurdld4rl3urrurrdrluurdrddrd4l3r3ulldrurddrd3lrr3u4ld3rurddrdllruull3ulddld"
	"3rurddrdlr5d3lullddr3u",

	// 50
	"xxxxxx############x!"
	"xxxxx##..    #   #x!"
	"xxxx##..* $    $ #x!"
	"xxx##..*.# # # $##x!"
	"xxx#..*.# # # $  #x!"
	"####...#  #    # #x!"
	"#  ## #          #x!"
	"# @$ $ ###  #   ##x!"
	"# $   $   # #   #xx!"
	"###$$   # # # # #xx!"
	"xx#   $   # # #####!"
	"xx# $# #####      #!"
	"xx#$   #xxx#    # #!"
	"xx#  ###xxx##     #!"
	"xx#  #xxxxxx#    ##!"
	"xx####xxxxxx######x!",
	"rdrr3u3(ru)rrurrdrr4drdl6urrdlul5dl5dldrurdl4urrul5ullulld4rurrdlul4dl6dldr4urruul4u6l3(dl)l"
	"ururu8rurrdlul5drdl5u8ldlddrurudlluru8rurrdlul5dldr5u8lddrulu8rurrdlul5d4u6ld3l5dllurdr3u2(lu"
	"rdru)lu8rurrdlul4d3u6ld3l7dluulurdr3u2(lurdru)lu8rurrdluld6ld3l4d4ld3rdr4u2(lurdru)luru3r3lddl"
	"l6drrdlddll3udluurdr4ulurdrulurl5d3lurrdr3ulur3drdrdldl5u3(ru)dldllurl4dll4dru3dl4urdr5uruuldr"
	"dldd3ldrrdr4uruuldruurrdlulddr3urd6rurrd8l2(uldrdl)uu8rddruluurrd8luldrdllu8rddlddr3uru7luldrdlu"
	"ldu8rddl4dr5uru7luldrdlu7r3d3ldrr5drr3dll7ur4uru7lulddu7r3dlldr5drrddldl7ur4uru7luld7r3dlldr5drr"
	"dldl6ur4uru8l7r3dlldrdr4uru6lrulld6rddrrddllulldrddrrul4uru7l6rddrrddldl4uru6l3ru3l",

};

// number of levels
const int LevNum = count_of(Levels)/2;
