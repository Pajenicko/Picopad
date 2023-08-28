"""
Original Dino image source: https://arks.itch.io/
"""
import ugame
import stage
import time
import random

class Dino(stage.Sprite):
    def __init__(self):
        super().__init__(tiles, 1, 28, 90)
        self.vy = 0  # Vertical speed
        self.y = 90
        self.dead = False # Add a flag to track if Rock has hit Dino
        self.jumping = False # Add a flag to track if Dino is jumping
        self.frame_count = 0  # Add a frame count for the animation
        self.can_double_jump = False  # Add a flag for the double jump
        self.jump_press = False  # Add a flag for the jump button press

    def update(self):
        super().update()

        keys = ugame.buttons.get_pressed()

        if keys & ugame.K_UP:
            if not self.jump_press and not self.jumping: # Normal jump
                sound.play(jump_sound)
                self.vy = -7  # Jump speed
                self.jumping = True
                self.can_double_jump = True  # Allow a double jump
                self.set_frame(4)  # Set the frame to the jumping frame
                self.jump_press = True  # Set the jump button press flag
            elif not self.jump_press and self.jumping and self.can_double_jump: # Double jump
                sound.play(jump_sound)
                self.vy = -4  # Double jump speed (smaller than the initial jump speed)
                self.can_double_jump = False  # Disable further double jumps until the next jump
                self.jump_press = True  # Set the jump button press flag
        else:
            self.jump_press = False  # Reset the jump button press flag when the button is released

        # Running animation
        if not self.jumping:  
            self.frame_count = (self.frame_count + 2) % 6  # Animate 6 frames
            self.set_frame(self.frame_count + 2)  # Set the frame + 2 offset (sky and ground)

        self.y += self.vy  # Apply vertical speed - jump or fall

        if self.y > 100:
            self.y = 100
            self.vy = 0
            self.jumping = False
            self.can_double_jump = False  # Disable double jumps when landing
        else:
            self.vy += 1  # Gravity

        self.move(self.x, self.y)


class Rock(stage.Sprite):
    def __init__(self, speed):
        super().__init__(tiles, 2, 160, 100)
        self.dx = -speed
        self.passed = False  # Add a flag to track if Dino has jumped over the Rock
        self.frame_count = 0  # Add a frame count for the animation

    def update(self):
        super().update()
        self.x += self.dx
        if self.x < -16:
            self.x = 160
            self.passed = False  # Reset the passed attribute when the Rock is reset
        elif self.x < 28 and not self.passed:  # If the Rock has moved past Dino
            self.passed = True
            global score
            score += 10  # Increase the score when Dino jumps over the Rock

        # Rock animation
        self.frame_count = (self.frame_count + 1) % 4  # Assuming there are 4 frames for the Rock animation
        self.set_frame(8 + self.frame_count)  # Set the frame

        self.move(self.x, self.y)


# load the sprite sheet
tiles = stage.Bank.from_bmp16("dino.bmp")

# create background - sky
background = stage.Grid(tiles, 10, 8 )

# create ground
for i in range(10):
    background.tile(i, 7, 1)
# sun
background.tile(8, 1, 13)
# clouds
background.tile(random.randint(4, 7), random.randint(1, 2), 12)
background.tile(random.randint(3, 7), random.randint(1, 3), 12)

jump_sound = open("jump.wav", 'rb')
boom_sound = open("boom.wav", 'rb')
sound = ugame.audio
sound.mute(False)



game = stage.Stage(ugame.display, 12)
sprites = []
score = 0
text = stage.Text(18, 1)

while True:
    dino = Dino()
    
    num_rocks = random.randint(1, 4)
    rocks = [Rock(random.randint(2, 4)) for _ in range(num_rocks)]
    sprites = [dino] + rocks
    game.layers = [text] + sprites + [background]  # Adding text as a layer
    game.render_block()

    while not dino.dead:

        for sprite in sprites:
            sprite.update()

        for rock in rocks:
            if stage.collide(dino.x + 2, dino.y + 2, dino.x + 14, dino.y + 14, rock.x + 4, rock.y + 6, rock.x + 4, rock.y + 14):
                sound.play(boom_sound)
                dino.dead = True
        
        game.render_sprites(sprites)
        game.tick()

    text.clear()
    text.cursor(0,0)
    text.text("Last score: " + str(score))  # Display the final score"
    score = 0
    
    time.sleep(5)
    
