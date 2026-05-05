import board
import displayio
import asyncio
from collections import deque
import random
import terminalio
from adafruit_display_text import label
from digitalio import DigitalInOut, Direction, Pull

# Setup buttons
btn_down = DigitalInOut(board.SW_DOWN)
btn_down.pull = Pull.UP

btn_up = DigitalInOut(board.SW_UP)
btn_up.pull = Pull.UP

btn_left = DigitalInOut(board.SW_LEFT)
btn_left.pull = Pull.UP

btn_right = DigitalInOut(board.SW_RIGHT)
btn_right.pull = Pull.UP

# Directions for snake movement
UP = (0, -1)
DOWN = (0, 1) 
LEFT = (-1, 0)
RIGHT = (1, 0)

class Game:

    def __init__(self, zoom):
        # Initialize display
        display = board.DISPLAY  
        # We know when we need to change the display, so we'll manage it manually
        display.auto_refresh = False
        
        self.zoom = zoom
        # Set game dimensions based on display size and zoom  
        self.width = int(display.width / zoom)
        self.height = int(display.height / zoom)
        
        # Create bitmap for game map
        self.map = displayio.Bitmap(self.width, self.height, 4)  

        # Create sprite group and scale it
        self.screen = displayio.Group(scale=zoom)
        
        # Create color palette
        palette = displayio.Palette(4)
        palette[0] = 0x000000  # Black - backgdooround
        palette[1] = 0x00FF00  # Green - snake
        palette[2] = 0xFF0000  # Red - apple
        palette[3] = 0xFFFF00  # Yellow - wall

        # Add tiled background bitmap scaled to screen size   
        bg_sprite = displayio.TileGrid(self.map, pixel_shader=palette, x=0, y=0)
        self.screen.append(bg_sprite)

        # Add text label for messages
        self.text = label.Label(terminalio.FONT, text="", color=0xFFFFFF, x=8, y=6, line_spacing=0.8)
        self.screen.append(self.text)

        # Show sprite group on the display
        display.root_group = self.screen
        
        self.reset()

    def reset(self):
        # Reset game state
        self.text.text = "" 
        self.map.fill(0)
        self.snake = Snake((20,14)) 
        self.apple = Apple((30,14))

        # Draw walls
        for i in range(0,self.width):
            self.map[(i,0)] = 3
            self.map[(i,self.height-1)] = 3

        for i in range(0,self.height):
            self.map[(0,i)] = 3
            self.map[(self.width-1,i)] = 3
        
        # Draw doors in walls
        for i in range(int(self.width/2)-2,int(self.width/2)+2):
            self.map[(i,0)] = 0
            self.map[(i,self.height-1)] = 0

        for i in range(int(self.height/2)-2,int(self.height/2)+2):
            self.map[(0,i)] = 0
            self.map[(self.width-1,i)] = 0

    def refresh(self):
        # Refresh the display
        board.DISPLAY.refresh()

# Snake class        
class Snake:
    def __init__(self, position):
        self.head = position
        self.body = deque((),100) 
        self.body.append(self.head)
        self.direction = RIGHT
        self.speed = 0.2
        self.length = 0
        
# Apple class
class Apple:    
    def __init__(self, position):
        self.position = position

    def new(self):
        # Generate new random apple position
        while True:
            position = (random.randint(0,game.width-game.zoom), random.randint(0, game.height-game.zoom))
            if game.map[position] == 0:
                game.map[position] = 2
                self.position = position
                break
        
# Background button check task        
async def button_check_bg():
    while True:    
        button_check()
        await asyncio.sleep(0)

# Main snake movement task
async def move():
    global game
    
    while True:
        # Refresh apple
        map = game.map 
        snake = game.snake
        apple = game.apple
        map[apple.position] = 2

        while True:
            # Check buttons to better respond to user input
            button_check()  

            # Calculate new head position
            # Use modulo to wrap around edges
            new_head = ((snake.head[0] + snake.direction[0]) % game.width, 
                        (snake.head[1] + snake.direction[1]) % game.height)

            # Insert new head into body
            snake.body.append(new_head)
            
            # Check if new head overlaps anything
            pixel = map[new_head]

            # Draw new head
            map[new_head] = 1
            
            # Remove tail
            if pixel == 0:
                old_end = snake.body.popleft()
                map[old_end] = 0
            
            # Collision with wall or self
            elif pixel == 1 or pixel == 3:
                break
                
            # Ate apple
            else:
                # Generate new apple
                apple.new()  
                # Increase speed and size
                snake.speed *= 0.9
                snake.length += 1
        
            # Update head position  
            snake.head = new_head
            
            # Refresh display
            game.refresh()
            await asyncio.sleep(snake.speed)

        # Show game over message
        game.text.text = f"Game\nOver\n= {snake.length}"  
        game.refresh()
        await asyncio.sleep(5)
        
        # Reset game
        game.reset()
        
# Handle button presses  
def button_check():
    global game
    snake = game.snake
    if btn_down.value == False:
        snake.direction = DOWN
    if btn_up.value == False:
        snake.direction = UP
    if btn_left.value == False:
        snake.direction = LEFT
    if btn_right.value == False:
        snake.direction = RIGHT
        
# Create game instance with 8x zoom
game = Game(8)   

# Run tasks concurrently
loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.gather(
    move(),
    button_check_bg()
))