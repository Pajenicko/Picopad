import terminalio
from adafruit_bitmap_font import bitmap_font

class ExtraFont:

    def __init__(self):
        self.builtin_font = terminalio.FONT
        self.extra_font = bitmap_font.load_font("/extra.bdf")

    def get_glyph(self, code_point):
        glyph = self.builtin_font.get_glyph(code_point)
        if glyph is None:
            glyph = self.extra_font.get_glyph(code_point)
        return glyph

    def get_bounding_box(self):
        return self.builtin_font.get_bounding_box()

