/**
 * Original code from: https://www.hackster.io/brzi/google-chrome-dinosaur-game-on-3-4-tft-c8ad88
 */
#include <Arduino.h>
#include <Adafruit_ST7789.h>
#include "sprites/dino.h"
#include "sprites/ground.h"
#include "sprites/pterodactyl.h"
#include "font/PressStart2P.h"
#include "sprites/retry.h"

enum class walk_style
{
	walking,
	ducking
};

enum class bird_position
{
	up,
	down
};

struct pterodactyl
{
  bool inGame = false;
  bird_position y_position = bird_position::up;
  int16_t x_offset = 320;
  bool flop = 0;
};

enum class ground_type
{
	ground,
	cactus
};

struct ground
{
	uint16_t *sprite;
	ground_type type;
  void set(const uint16_t *sprite, ground_type type){
    this->sprite = (uint16_t*) sprite;
    this->type = type;
  }
};

enum class DelayType{
	Miliseconds, 
	Microseconds
};

#ifndef DinoGame_H
#define DinoGame_H
class DinoGame
{
public:
	DinoGame(Adafruit_ST7789 &display);
	void loop();
	void jump();
	void duck();
	void stand();
	void newGame();
	bool isGameOver();
	void endGame();
	void setSpeedModifier(uint8_t speed);

private:
	void drawScore();
	void drawTopScore();
	String scoreToString(uint32_t score);
	void shiftArrays(uint16_t buff[], const uint16_t arr1[], const uint16_t arr2[], const uint16_t arr3[], const uint16_t arr4[], const uint16_t arr5[], const uint16_t shiftValue);
	void overlapDino(uint16_t gameBuff[], uint16_t dinoBuff[], const uint16_t dinoModel[], int16_t height, walk_style style);
	void overlapBird(uint16_t gameBuff[], const uint16_t modelBuff[], int16_t offset, bird_position position);
  void manageBird();
  void modifyGroundBuffer();
	void setDelayType(DelayType type);
	void setDelayValue(uint16_t val);
	void step();
	void draw();
	unsigned long getSteps();
	uint16_t arr[16960], topJumpingLayer[2006];
	ground groundArray[5];
  pterodactyl bird_info;
	int16_t jumpHeigth = 0, shift = 0, level = 0, bird = 320;
	uint8_t speed_modifier = 0;
	bool runstate = 0, jumping = false, falling = false, colided = false, ducking = false, flop = false, displayedGameOver = false;
	uint32_t last = 0, last_flash_time = 0;
	String last_s = "0";
	uint8_t flash_count = 2;
	uint32_t highScore = 0;
	bool flashing = false, drawn = false;
	Adafruit_ST7789 &display;
	DelayType type = DelayType::Miliseconds;
	uint16_t delayValue = 1;
	unsigned long steps = 0, previous_time = 0;
  const uint16_t* normalGrounds[2] = {ground_0, ground_1};
  const uint16_t* cactusGrounds[4] = {cactus_0, cactus_1, cactus_2, cactus_3};
};
#endif
