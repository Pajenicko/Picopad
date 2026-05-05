import displayio
import terminalio
from digitalio import DigitalInOut, Pull
from adafruit_debouncer import Debouncer
from adafruit_display_shapes.rect import Rect
from adafruit_progressbar.progressbar import HorizontalProgressBar
from adafruit_display_text import label
import adafruit_imageload
import board


def increase(start, step):
    num = start
    while True:
        num += step
        yield num

def get_display():
    
    display = board.DISPLAY
    display.auto_refresh = False
    group = displayio.Group()

    class colors:
        white = 0xFFFFFF
        red = 0xFF0000
        grey = 0x777777
        light_grey = 0xAAAAAA
        black = 0x000000
        yellow = 0xFFFF00
        

    # Keypad buttons
    keys = []
    x = 270
    inc = increase(250, -60)
    w = 40
    h = 40

    for item in range(4):
        keys.append(Rect(x, next(inc), w, h, fill=colors.grey))
    
    # Keypad labels
    labels_keys = []
    x = 284
    inc = increase(-30, 60)

    for item in ["G", "E", "D", "C"]:
        labels_keys.append(label.Label(terminalio.FONT, text=item, color=colors.black, x=x, y=next(inc), scale=2))

    # Settings labels
    labels = []
    x = 10
    inc = increase(-15, 30)

    for item in ["drums", "octave", "shape", "lfo", "freqency", "q-factor", "release", "detune"]:
        labels.append(label.Label(terminalio.FONT, text=item, color=colors.white, x=x, y=next(inc)))

    # make first label active (red)
    labels[0].color = colors.red
    
    # Settings bars
    bars = []
    x = 80
    inc = increase(72, 30)
    w = 150
    h = 8

    for item in range(5):
        bars.append(HorizontalProgressBar((x, next(inc)), (w, h), bar_color=colors.white,
                            outline_color=colors.light_grey, fill_color=colors.grey,))
    

    # UI icons
    sprites = []

    sprite_sheet, palette = adafruit_imageload.load("/synth.bmp",
                                                    bitmap=displayio.Bitmap,
                                                    palette=displayio.Palette)

    active_palette = displayio.Palette(2)
    active_palette[0] = colors.yellow
    active_palette[1] = colors.black
    
    inverse_palette = displayio.Palette(2)
    inverse_palette[0] = colors.white
    inverse_palette[1] = colors.black

    # normal palette is defaul black & white
    # active palette is yellow & black - for selected icon
    # inverse palette is white & black
    class palettes:
        normal = palette
        active = active_palette
        inverse = inverse_palette

    # every icon is 15x13
    w = 15
    h = 13

    # shape selection line
    x = 80
    for item in range(6):
        sprite = displayio.TileGrid(sprite_sheet, pixel_shader=palette, tile_width=w, tile_height=h)
        sprite.x = x
        sprite.y = 68
        sprite[0] = item
        x += w+10
        sprites.append(sprite)
    
    # octave selection line
    x = 80
    for item in range(5):
        sprite = displayio.TileGrid(sprite_sheet, pixel_shader=palette, tile_width=w, tile_height=h)
        sprite.x = x
        sprite.y = 38
        sprite[0] = item + 6
        x += w+10
        sprites.append(sprite)
        
    # drums active line
    x = 80
    for item in range(3):
        sprite = displayio.TileGrid(sprite_sheet, pixel_shader=palette, tile_width=w, tile_height=h)
        sprite.x = x
        sprite.y = 10
        sprite[0] = item + 11
        x += w+10
        sprites.append(sprite)

    # make first icon on each line active
    sprites[0].pixel_shader = active_palette
    sprites[8].pixel_shader = active_palette

    for item in keys + labels_keys + labels + bars + sprites:
        group.append(item)

    # Setup buttons
    buttons = []

    for item in [ board.SW_A, board.SW_B, board.SW_X, board.SW_Y,
                  board.SW_LEFT, board.SW_RIGHT, board.SW_UP, board.SW_DOWN ]:
        pin = DigitalInOut(item)
        pin.pull = Pull.UP
        buttons.append(Debouncer(pin))


    display.root_group = group

    return display, keys, labels, bars, sprites, buttons, colors, palettes

