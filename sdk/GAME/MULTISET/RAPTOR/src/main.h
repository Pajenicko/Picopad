
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define SHIELD_MAX	7
#define ENERGY_MAX	30
#define SHIP_SPEED	10
#define WEAPON_NUM	7 	// number of weapons
#define ENEMY_NUM	5	// number of enemies

#define WEAPON_ARTILLERY 4	// weapon is artillery
#define ARTILLERY_NUM	15	// number of missiles of artillery
#define WEAPON_SONARBOMB 5	// weapon is sonar bomb
#define WEAPON_BLACKHOLE 6	// weapon is black hole

// sound channels
#define SNDCHAN_GUN	0	// sound channel: machine gun
#define SNDCHAN_WEAPON	1	// sound channel: weapon
#define SNDCHAN_MISC	2	// sound channel: misc

// flying missile
typedef struct {
	int type;	// missile type (-1 = entry not used, WEAPON_NUM = missile hit)
	float x,y;	// missile coordinates
	float dx, dy;	// missile delta
	int anim;	// missile animation
} sMissile;

// enemy
typedef struct {
	int type;	// enemy type (-1 = entry not used, ENEMY_NUM = enemy dead)
	float x, y;	// enemy coordinates
	float dx, dy;	// enemy delta
	int anim;	// enemy animation
	int energy;	// enemy energy
} sEnemy;

// format: 4-bit paletted pixel graphics
// image width: 320 pixels
// image height: 320 lines
// image pitch: 160 bytes
extern const u16 LandscapeImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 LandscapeImg[51200] __attribute__ ((aligned(4)));
#define LANDSCAPEW	320
#define LANDSCAPEH	320

// format: 1-bit pixel graphics
// image width: 32 pixels
// image height: 192 lines
// image pitch: 4 bytes
extern const u8 ShadowsImg[768] __attribute__ ((aligned(4)));
#define SHADOWW		32
#define SHADOWH		32
#define SHADOW_SHIFTX	30
#define SHADOW_SHIFTY	30

// shadow indices
#define SHADOW_SHIP	0	// spaceship
#define SHADOW_ENEMY1	1	// enemy 1
#define SHADOW_ENEMY2	2	// enemy 2
#define SHADOW_ENEMY3	3	// enemy 3
#define SHADOW_ENEMY4	4	// enemy 4
#define SHADOW_ENEMY5	5	// enemy 5

// format: 8-bit paletted pixel graphics
// image width: 32 pixels
// image height: 1728 lines
// image pitch: 32 bytes
extern const u16 SpritesImg_Pal[55] __attribute__ ((aligned(4)));
extern const u8 SpritesImg[55296] __attribute__ ((aligned(4)));
#define SPRITEW		32
#define SPRITEH		32
#define TRANSCOL	RGBTO16(149, 34, 140)

// sprite indices

// spaceship
#define SPRITE_SHIP	0	// spaceship standing and animating (2 phases)
#define SPRITE_SHIPD	0	// spaceship moving down
#define SPRITE_SHIPU	1	// spaceship moving up
#define SPRITE_SHIPR	2	// spaceship moving right
#define SPRITE_SHIPL	3	// spaceship moving left
// weapon 0 - machine gun
#define SPRITE_WEAPON0_TILE	4	// weapon 0 tile
#define SPRITE_WEAPON0_MISSILE	5	// weapon 0 missile
#define SPRITE_WEAPON0_NUM	1	// weapon 0 animation phases
// weapon 1 - green rocket
#define SPRITE_WEAPON1_TILE	6	// weapon 1 tile
#define SPRITE_WEAPON1_MISSILE	7	// weapon 1 missile
#define SPRITE_WEAPON1_NUM	1	// weapon 1 animation phases
// weapon 2 - silver rocket
#define SPRITE_WEAPON2_TILE	8	// weapon 2 tile
#define SPRITE_WEAPON2_MISSILE	9	// weapon 2 missile
#define SPRITE_WEAPON2_NUM	1	// weapon 2 animation phases
// weapon 3 - laser
#define SPRITE_WEAPON3_TILE	10	// weapon 3 tile
#define SPRITE_WEAPON3_MISSILE	11	// weapon 3 missile
#define SPRITE_WEAPON3_NUM	1	// weapon 3 animation phases
// weapon 4 - artillery
#define SPRITE_WEAPON4_TILE	12	// weapon 4 tile
#define SPRITE_WEAPON4_MISSILE	13	// weapon 4 missile
#define SPRITE_WEAPON4_NUM	1	// weapon 4 animation phases
// weapon 5 - sonar bomb
#define SPRITE_WEAPON5_TILE	14	// weapon 5 tile
#define SPRITE_WEAPON5_MISSILE	15	// weapon 5 missile
#define SPRITE_WEAPON5_NUM	8	// weapon 5 animation phases
// weapon 6 - black hole
#define SPRITE_WEAPON6_TILE	23	// weapon 6 tile
#define SPRITE_WEAPON6_MISSILE	24	// weapon 6 missile
#define SPRITE_WEAPON6_NUM	6	// weapon 6 animation phases
// explosion
#define SPRITE_EXPLOSE1		30	// explosion 1
#define SPRITE_EXPLOSE2		31	// explosion 2
#define SPRITE_EXPLOSE3		32	// explosion 3
#define SPRITE_EXPLOSE4		33	// explosion 4
#define SPRITE_EXPLOSE5		34	// explosion 5
#define SPRITE_EXPLOSE6		35	// explosion 6
#define SPRITE_EXPLOSE7		36	// explosion 7
#define SPRITE_EXPLOSE8		37	// explosion 8
// enemy 1
#define SPRITE_ENEMY1		38	// enemy 1
#define SPRITE_ENEMY1_MISSILE	39	// enemy 1 missile
// enemy 2
#define SPRITE_ENEMY2		40	// enemy 2
#define SPRITE_ENEMY2_MISSILE	41	// enemy 2 missile
// enemy 3
#define SPRITE_ENEMY3		42	// enemy 3
#define SPRITE_ENEMY3_MISSILE	43	// enemy 3 missile
// enemy 4
#define SPRITE_ENEMY4		44	// enemy 4
#define SPRITE_ENEMY4_MISSILE	45	// enemy 4 missile
// enemy 5
#define SPRITE_ENEMY5		46	// enemy 5
#define SPRITE_ENEMY5_MISSILE	47	// enemy 5 missile
#define SPRITE_ENEMY5B		48	// enemy 5
#define SPRITE_ENEMY5C		49	// enemy 5
// hit missile
#define SPRITE_HIT0		50	// hit 0
#define SPRITE_HIT1		51	// hit 1
#define SPRITE_HIT2		52	// hit 2
#define SPRITE_HIT3		53	// hit 3

// format: 4-bit paletted pixel graphics
// image width: 16 pixels
// image height: 208 lines
// image pitch: 8 bytes
extern const u16 TilesImg_Pal[11] __attribute__ ((aligned(4)));
extern const u8 TilesImg[1664] __attribute__ ((aligned(4)));
#define TILEW	16
#define TILEH	16

#define TILE_ENERGY2	0	// energy, 2 points
#define TILE_ENERGY1	1	// energy, 1 point
#define TILE_SHIELD	2	// shield
#define TILE_DIGIT0	3	// digit 0
#define TILE_DIGIT1	4	// digit 1
#define TILE_DIGIT2	5	// digit 2
#define TILE_DIGIT3	6	// digit 3
#define TILE_DIGIT4	7	// digit 4
#define TILE_DIGIT5	8	// digit 5
#define TILE_DIGIT6	9	// digit 6
#define TILE_DIGIT7	10	// digit 7
#define TILE_DIGIT8	11	// digit 8
#define TILE_DIGIT9	12	// digit 9

// sounds
extern const u8 ArtillerySnd[48441];	// weapon 4 - artillery
extern const u8 BlackholeSnd[22138];	// weapon 6 - black hole
extern const u8 Blackhole2Snd[5060];	// weapon 6 - sucking black hole
extern const u8 ExplosionSnd[30424];	// enemy explosion
extern const u8 FailSnd[4924];		// lost energy
extern const u8 GreenrocketSnd[26730];	// weapon 1 - green rocket
extern const u8 LaserSnd[18089];	// weapon 3 - laser
extern const u8 LevelupSnd[25636];	// level up
extern const u8 LostSnd[19131];		// lost shield
extern const u8 MachinegunSnd[7000];	// weapon 0 - machine gun
extern const u8 SilverrocketSnd[28232];	// weapon 2 - silver rocket
extern const u8 SonarSnd[25970];	// weapon 5 - sonar bomb

#endif // _MAIN_H
