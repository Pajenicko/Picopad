/**
 * Original code from: https://www.hackster.io/brzi/google-chrome-dinosaur-game-on-3-4-tft-c8ad88
 */
#include "DinoGame.h"

DinoGame::DinoGame(Adafruit_ST7789 &display): display(display){}

void DinoGame::loop(){
    if(colided){
      endGame();
      return;
    }
    if (shift > 90) { //In the case we shifted trough 90 pixels (one ground sprite) we add a new one to the end of the list
      shift = 0;
      modifyGroundBuffer();
    }
    shiftArrays(arr, groundArray[0].sprite, groundArray[1].sprite, groundArray[2].sprite, groundArray[3].sprite, groundArray[4].sprite, shift);
    shift += 2 + speed_modifier;

    manageBird();
    
    if (!jumping) {
        if (!ducking) {
            if (runstate) overlapDino(arr, topJumpingLayer, dino_leftstep, 0, walk_style::walking);
            else overlapDino(arr, topJumpingLayer, dino_rightstep, 0, walk_style::walking);
        }
        else {
            if (runstate) overlapDino(arr, topJumpingLayer, dino_ducking_leftstep, 0, walk_style::ducking);
            else overlapDino(arr, topJumpingLayer, dino_ducking_rightstep, 0, walk_style::ducking);
        }
    }

    if (jumping) {
        if (!falling) jumpHeigth += 3 + speed_modifier;
        if (jumpHeigth > 70 && !falling) falling = true;
        if (falling) jumpHeigth -= 3 + speed_modifier;
        if (jumpHeigth < 0) {
            falling = false;
            jumping = false;
            jumpHeigth = 0;
        }
        overlapDino(arr, topJumpingLayer, dino_default, jumpHeigth, walk_style::walking);
    }

    if (getSteps() % 10 - speed_modifier == 0) runstate = !runstate; 
	/*Speed modifier is a placeholder variable.
	The initial idea was to speed up the game relative to the score but since i didn't use floating point numbers every time the modifier
	increments the game speeds up exponentialy so it's not used*/
    
    step();
    draw();
}

void DinoGame::manageBird(){
  if(!bird_info.inGame){
      if(!(groundArray[2].type == ground_type::cactus || groundArray[3].type == ground_type::cactus || groundArray[4].type == ground_type::cactus) && (random(100) > 60) && getSteps() > 35){
        bird_info.inGame = true; //The bird doesn't move with the same speed as the ground does so there must be enough free space to avoid
        bird_info.y_position = (random(100) > 65) ? bird_position::down : bird_position::up;//situations where it is unavoidable to fail the game
      }
    } else {
        if (bird_info.flop) overlapBird(arr, pterodactyl_downflop, bird_info.x_offset, bird_info.y_position);
        else overlapBird(arr, pterodactyl_upflop, bird_info.x_offset, bird_info.y_position);
        if (getSteps() % 20 - speed_modifier == 0) bird_info.flop = !bird_info.flop;
        bird_info.x_offset -= 2 + speed_modifier;
        if (bird_info.x_offset < -34){ //When the bird sprite isn't drawn anymore (the spirtes width is 34px) we remove it from the game
          bird_info.inGame = false;
          bird_info.x_offset = 320;
        }
    }
}

void DinoGame::modifyGroundBuffer(){
  uint8_t cactusCount = 0, chance = 0;
  for(uint8_t i = 0; i < 4; ++i){
    groundArray[i] = groundArray[i + 1]; //Shuffle all of the ground elements and count the cactuses
    if(groundArray[i].type == ground_type::cactus) ++cactusCount;
  }
  uint16_t* nextGroundElement = nullptr;
  ground_type nextGroundType;
  switch(cactusCount){
    case 0: chance = 100; break;
    case 1: chance = 75; break;
    default: chance = 0; //Having more than 2 cactus ground sprites can make the game unfair
  }
  if(!chance || groundArray[3].type == ground_type::cactus || random(100) < (100 - chance)){ //There is probably a better method but this is the one I came up with
    uint8_t index = ((sizeof(normalGrounds) / sizeof(normalGrounds[0])) * 10);
    nextGroundElement = (uint16_t*)normalGrounds[random(100) > 80];
    nextGroundType = ground_type::ground;
  } else { 
	uint8_t index = ((sizeof(cactusGrounds) / sizeof(cactusGrounds[0])) * 10);
	nextGroundElement = (uint16_t*)cactusGrounds[random(index) / 10];
	nextGroundType = ground_type::cactus;
  }
  groundArray[4].set(nextGroundElement, nextGroundType);
}

void DinoGame::jump(){
    jumping = true;
}

void DinoGame::duck(){
    ducking = true;
}

void DinoGame::stand(){
    ducking = false;
}

void DinoGame::setSpeedModifier(uint8_t speed){
	speed_modifier = speed;
}

void DinoGame::newGame(){
  steps = 0;
  colided = false;
  ducking = false;
  displayedGameOver = false;
  bird_info.inGame = false;
  bird_info.x_offset = 320;
  jumping = false;
  falling = false;
  jumpHeigth = 0;
  groundArray[0].set(ground_0, ground_type::ground);
  groundArray[1].set(ground_0, ground_type::ground);
  groundArray[2].set(ground_0, ground_type::ground);
  groundArray[3].set(ground_0, ground_type::ground);
  groundArray[4].set(cactus_2, ground_type::cactus);
  display.fillScreen(ST77XX_WHITE);
  display.setFont(&PressStart2P_Regular6pt7b);
  display.setTextSize(1);
  drawTopScore();
}

bool DinoGame::isGameOver(){
    return displayedGameOver;
}

void DinoGame::endGame(){
  if(displayedGameOver) return;
  displayedGameOver = true;
  flashing = false;
  uint8_t offset = (ducking && jumpHeigth == 0) ? 11 : 0; //When dino dies while ducking he needs to be brought back up and shifted 11 pixels foreword to make the collision visible
  shiftArrays(arr, groundArray[0].sprite, groundArray[1].sprite, groundArray[2].sprite, groundArray[3].sprite, groundArray[4].sprite, shift + offset);
  manageBird();
  overlapDino(arr, topJumpingLayer, dino_gameover, jumpHeigth, walk_style::walking);
  draw();
  display.setTextColor(0x738E, 0);
  display.setCursor(110, 70);
  display.print("GAME OVER");
  display.drawRGBBitmap(148, 80, retry, 32, 29);
  
}

void DinoGame::drawScore(){
  if(last == 99999 && !flashing) return;
  uint32_t current = getSteps() / 10;
  if (last != current && !flashing) {
    if (current > 99999) current = 99999;
    String current_s = scoreToString(current);
    display.setCursor(260, 30);
    display.setTextColor(ST77XX_WHITE, 0);
    display.print(last_s);
    display.setCursor(260, 30);
    display.setTextColor(0x528A, 0);
    display.print(current_s);
    last = current;
    last_s = current_s;
    if(current > highScore) highScore = current;
    if (current % 100 == 0){
        flashing = true;
        last_flash_time = getSteps();
    } 
  }
  else if (flashing) { //Game's built in step function is used instead of millis because it gives consistant delays
    if (flash_count % 2 == 0) display.setTextColor(ST77XX_WHITE, 0);
    else display.setTextColor(0x528A, 0);
    display.setCursor(260, 30);
    if (!drawn) {
      drawn = true;
      display.print(last_s);
    }
    else if (getSteps() - last_flash_time > 35) {
      drawn = false;
      ++flash_count;
      last_flash_time = getSteps();
    }
    if (flash_count > 5) {
      flash_count = 2;
      flashing = false;
    }
  }
}

void DinoGame::drawTopScore(){
    display.setTextColor(0x738E, 0);
    display.setCursor(152, 30);
    display.print("HI ");
    display.print(scoreToString(highScore));
}

String DinoGame::scoreToString(uint32_t score){
    String score_s = String(score);
    if (score_s.length() < 5) { //Here the '0' padding is added
        String temp = "";
        for (uint8_t i = 0; i < 5 - score_s.length(); ++i) temp += "0";
        temp += score_s;
        score_s = temp;
    }
    return score_s;
}

void DinoGame::shiftArrays(uint16_t buff[], const uint16_t arr1[], const uint16_t arr2[], const uint16_t arr3[], 
                                        const uint16_t arr4[], const uint16_t arr5[], const uint16_t shiftValue){
    memset(buff, 0xFF, 9600); //This is the part the bird flies in when it's in the top position
    uint16_t count = 4800, line = 0; //4800 (=320*15) offsets the starting drawing position 15 lines downward (also the offset from the part the bird flies in)
    while (line < 38) {
    for (uint16_t i = 0; i < 320; ++i) {
        if (i < 91 - shiftValue) buff[count] = arr1[i + shiftValue + line * 90]; //shiftValue offsets the starting x position of the sprite array
        else if (i > 90 - shiftValue && i < 181 - shiftValue) buff[count] = arr2[(i - 90  + shiftValue) + line * 90];
        else if (i > 180 - shiftValue && i < 271 - shiftValue) buff[count] = arr3[(i - 180  + shiftValue) + line * 90];
        else buff[count] = arr4[(i - 270  + shiftValue) + line * 90];
        ++count;
    }
    ++line;
    }
    if (shiftValue > 40) { //If we need to start drawing from the 5th buffer(the one that starts behind the screen) we enter here
    line = 0;
    while (line < 38) {
        count = 0;
        for (uint16_t i = 320 - (shiftValue - 40); i < 320; ++i) {
            buff[(line + 15) * 320 + i] = arr5[count + line * 90];
            ++count;
        }
        ++line;
    }
    }

}

void DinoGame::overlapDino(uint16_t gameBuff[], uint16_t dinoBuff[], const uint16_t dinoModel[], int16_t height, walk_style style){
    memset(dinoBuff, 0xff, sizeof(topJumpingLayer));
    uint16_t modelLine = 0,
            w = style == walk_style::walking ? 34 : 45, //h and w are derived from which sprite (ducking or jumping) is the dino in at the moment
            h = style == walk_style::walking ? 36 : 22,
            checkline = style == walk_style::walking ? 30 : 32; //checkline makes sure that collision detection doesnt happen below the ground line (15 lines above 0)
    height += style == walk_style::walking ? 20 : -7; //This is the offset to make dino a little below ground point
    while (modelLine < h) {
        for (uint16_t i = 0; i < w; ++i) {
        if (height > h && style == walk_style::walking) dinoBuff[(95 - height) * 34 + i] = dinoModel[modelLine * w + i]; //For the parts of dino that are in the top layer we dont perform transparency and collision checks
        else {
            uint16_t* const destination = &gameBuff[(h - height) * 320 + i + 15];
            uint16_t color = dinoModel[modelLine * w + i];
            if ((h - height) < checkline && *destination == 0x528A && color == 0x528A) colided = true; //Colision is checked before the line 15
            if (color != 0xFFFF) *destination = color; //0xFFFF is the "transparent" color in this game
            }
        }
        --height;
        ++modelLine;
    }
}

void DinoGame::overlapBird(uint16_t gameBuff[], const uint16_t modelBuff[], int16_t offset, bird_position position){
    uint16_t line = 0, line_offset = position == bird_position::up ? 1 : 18; //y offset
    int16_t start = offset < 0 ? -offset : 0, end = offset > 286 ? 320 - offset : 34; //Starting and ending x coordinates for drawing the bird depending on where on the screen it is positioned
    while (line < 27) {
        for (int16_t i = start; i < end; ++i) {
            uint16_t color = modelBuff[i + line * 34];
            if (color != 0xFFFF) gameBuff[offset + i + (line + line_offset) * 320] = color;
        }
        ++line;
    }
}

void DinoGame::setDelayType(DelayType type){
    this->type = type;
}

void DinoGame::setDelayValue(uint16_t val){
    delayValue = val;
}

void DinoGame::step(){
    unsigned long temp = type == DelayType::Miliseconds ? millis() : micros();
    if(temp - previous_time >= delayValue){
        previous_time = temp;
        ++steps;
    }
}

unsigned long DinoGame::getSteps(){
    return steps;
}

void DinoGame::draw(){
    display.drawRGBBitmap(0, 78, arr, 320, 53);
    display.drawRGBBitmap(15, 19, topJumpingLayer, 34, 59);
    drawScore();
}
