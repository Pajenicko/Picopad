
import board
import displayio
from adafruit_display_shapes.rect import Rect
from adafruit_display_text import label
import terminalio
from rainbowio import colorwheel
import adafruit_requests

from adafruit_debouncer import Debouncer
from adafruit_ticks import ticks_ms, ticks_add, ticks_less
from digitalio import DigitalInOut, Pull



import wifi
import ssl
import socketpool
import os



pin = DigitalInOut(board.SW_LEFT)
pin.pull = Pull.UP
btn_left = Debouncer(pin)

pin = DigitalInOut(board.SW_RIGHT)
pin.pull = Pull.UP
btn_right = Debouncer(pin)


def map_range(s, a1, a2, b1, b2): return b1 + \
    ((s - a1) * (b2 - b1) / (a2 - a1))


def get_display():
    zoom=1
    display = board.DISPLAY

    display.auto_refresh = False
    group = displayio.Group(scale=zoom)

    class colors:
        white = 0xFFFFFF
        red = 0xFF0000
        grey = 0x777777
        light_grey = 0xAAAAAA
        black = 0x000000
        yellow = 0xFFFF00
        
    okresy = {
        "1": {
            "id": 1,
            "okres": "Cheb",
            "x": 18,
            "y": 100,
            "val": 0
        },
        "2": {
            "id": 2,
            "okres": "Sokolov",
            "x": 28,
            "y": 90,
            "val": 0
        },
        "3": {
            "id": 3,
            "okres": "Karlovy Vary",
            "x": 45,
            "y": 90,
            "val": 0
        },
        "4": {
            "id": 4,
            "okres": "Chomutov",
            "x": 60,
            "y": 75,
            "val": 0
        },
        "5": {
            "id": 5,
            "okres": "Louny",
            "x": 73,
            "y": 85,
            "val": 0
        },
        "6": {
            "id": 6,
            "okres": "Most",
            "x": 73,
            "y": 65,
            "val": 0
        },
        "7": {
            "id": 7,
            "okres": "Teplice",
            "x": 82,
            "y": 62,
            "val": 0
        },
        "8": {
            "id": 8,
            "okres": "Litoměřice",
            "x": 100,
            "y": 73,
            "val": 0
        },
        "9": {
            "id": 9,
            "okres": "Ústí nad Labem",
            "x": 94,
            "y": 58,
            "val": 0
        },
        "10": {
            "id": 10,
            "okres": "Děčín",
            "x": 105,
            "y": 50,
            "val": 0
        },
        "11": {
            "id": 11,
            "okres": "Česká Lípa",
            "x": 122,
            "y": 58,
            "val": 0
        },
        "12": {
            "id": 12,
            "okres": "Liberec",
            "x": 137,
            "y": 50,
            "val": 0
        },
        "13": {
            "id": 13,
            "okres": "Jablonec nad Nisou",
            "x": 149,
            "y": 55,
            "val": 0
        },
        "14": {
            "id": 14,
            "okres": "Semily",
            "x": 158,
            "y": 62,
            "val": 0
        },
        "15": {
            "id": 15,
            "okres": "Jičín",
            "x": 157,
            "y": 77,
            "val": 0
        },
        "16": {
            "id": 16,
            "okres": "Trutnov",
            "x": 175,
            "y": 66,
            "val": 0
        },
        "17": {
            "id": 17,
            "okres": "Náchod",
            "x": 188,
            "y": 77,
            "val": 0
        },
        "18": {
            "id": 18,
            "okres": "Hradec Králové",
            "x": 170,
            "y": 89,
            "val": 0
        },
        "19": {
            "id": 19,
            "okres": "Rychnov nad Kněžnou",
            "x": 195,
            "y": 92,
            "val": 0
        },
        "20": {
            "id": 20,
            "okres": "Ústí nad Orlicí",
            "x": 205,
            "y": 108,
            "val": 0
        },
        "21": {
            "id": 21,
            "okres": "Pardubice",
            "x": 172,
            "y": 102,
            "val": 0
        },
        "22": {
            "id": 22,
            "okres": "Chrudim",
            "x": 178,
            "y": 118,
            "val": 0
        },
        "23": {
            "id": 23,
            "okres": "Svitavy",
            "x": 207,
            "y": 125,
            "val": 0
        },
        "24": {
            "id": 24,
            "okres": "Šumperk",
            "x": 227,
            "y": 108,
            "val": 0
        },
        "25": {
            "id": 25,
            "okres": "Jeseník",
            "x": 238,
            "y": 88,
            "val": 0
        },
        "26": {
            "id": 26,
            "okres": "Bruntál",
            "x": 250,
            "y": 105,
            "val": 0
        },
        "27": {
            "id": 27,
            "okres": "Olomouc",
            "x": 240,
            "y": 130,
            "val": 0
        },
        "28": {
            "id": 28,
            "okres": "Opava",
            "x": 270,
            "y": 115,
            "val": 0
        },
        "29": {
            "id": 29,
            "okres": "Ostrava-město",
            "x": 286,
            "y": 120,
            "val": 0
        },
        "30": {
            "id": 30,
            "okres": "Karviná",
            "x": 298,
            "y": 118,
            "val": 0
        },
        "31": {
            "id": 31,
            "okres": "Frýdek-Místek",
            "x": 300,
            "y": 135,
            "val": 0
        },
        "32": {
            "id": 32,
            "okres": "Nový Jičín",
            "x": 275,
            "y": 130,
            "val": 0
        },
        "33": {
            "id": 33,
            "okres": "Vsetín",
            "x": 280,
            "y": 150,
            "val": 0
        },
        "34": {
            "id": 34,
            "okres": "Přerov",
            "x": 260,
            "y": 140,
            "val": 0
        },
        "35": {
            "id": 35,
            "okres": "Zlín",
            "x": 265,
            "y": 165,
            "val": 0
        },
        "36": {
            "id": 36,
            "okres": "Kroměříž",
            "x": 246,
            "y": 158,
            "val": 0
        },
        "37": {
            "id": 37,
            "okres": "Uherské Hradiště",
            "x": 255,
            "y": 175,
            "val": 0
        },
        "38": {
            "id": 38,
            "okres": "Hodonín",
            "x": 235,
            "y": 181,
            "val": 0
        },
        "39": {
            "id": 39,
            "okres": "Vyškov",
            "x": 229,
            "y": 160,
            "val": 0
        },
        "40": {
            "id": 40,
            "okres": "Prostějov",
            "x": 232,
            "y": 143,
            "val": 0
        },
        "41": {
            "id": 41,
            "okres": "Blansko",
            "x": 212,
            "y": 145,
            "val": 0
        },
        "42": {
            "id": 42,
            "okres": "Brno-město",
            "x": 211,
            "y": 163,
            "val": 0
        },
        "43": {
            "id": 43,
            "okres": "Brno-venkov",
            "x": 203,
            "y": 169,
            "val": 0
        },
        "44": {
            "id": 44,
            "okres": "Břeclav",
            "x": 218,
            "y": 185,
            "val": 0
        },
        "45": {
            "id": 45,
            "okres": "Znojmo",
            "x": 190,
            "y": 185,
            "val": 0
        },
        "46": {
            "id": 46,
            "okres": "Třebíč",
            "x": 179,
            "y": 165,
            "val": 0
        },
        "47": {
            "id": 47,
            "okres": "Žďár nad Sázavou",
            "x": 188,
            "y": 143,
            "val": 0
        },
        "48": {
            "id": 48,
            "okres": "Jihlava",
            "x": 161,
            "y": 153,
            "val": 0
        },
        "49": {
            "id": 49,
            "okres": "Havlíčkův Brod",
            "x": 164,
            "y": 130,
            "val": 0
        },
        "50": {
            "id": 50,
            "okres": "Pelhřimov",
            "x": 145,
            "y": 146,
            "val": 0
        },
        "51": {
            "id": 51,
            "okres": "Jindřichův Hradec",
            "x": 140,
            "y": 170,
            "val": 0
        },
        "52": {
            "id": 52,
            "okres": "Tábor",
            "x": 123,
            "y": 150,
            "val": 0
        },
        "53": {
            "id": 53,
            "okres": "České Budějovice",
            "x": 114,
            "y": 175,
            "val": 0
        },
        "54": {
            "id": 54,
            "okres": "Český Krumlov",
            "x": 105,
            "y": 196,
            "val": 0
        },
        "55": {
            "id": 55,
            "okres": "Prachatice",
            "x": 85,
            "y": 177,
            "val": 0
        },
        "56": {
            "id": 56,
            "okres": "Strakonice",
            "x": 88,
            "y": 158,
            "val": 0
        },
        "57": {
            "id": 57,
            "okres": "Písek",
            "x": 101,
            "y": 150,
            "val": 0
        },
        "58": {
            "id": 58,
            "okres": "Klatovy",
            "x": 65,
            "y": 157,
            "val": 0
        },
        "59": {
            "id": 59,
            "okres": "Domažlice",
            "x": 43,
            "y": 145,
            "val": 0
        },
        "60": {
            "id": 60,
            "okres": "Tachov",
            "x": 36,
            "y": 124,
            "val": 0
        },
        "61": {
            "id": 61,
            "okres": "Plzeň-sever",
            "x": 60,
            "y": 114,
            "val": 0
        },
        "62": {
            "id": 62,
            "okres": "Plzeň-město",
            "x": 63,
            "y": 125,
            "val": 0
        },
        "63": {
            "id": 63,
            "okres": "Plzeň-jih",
            "x": 70,
            "y": 136,
            "val": 0
        },
        "64": {
            "id": 64,
            "okres": "Rokycany",
            "x": 76,
            "y": 118,
            "val": 0
        },
        "65": {
            "id": 65,
            "okres": "Rakovník",
            "x": 80,
            "y": 100,
            "val": 0
        },
        "66": {
            "id": 66,
            "okres": "Kladno",
            "x": 96,
            "y": 94,
            "val": 0
        },
        "67": {
            "id": 67,
            "okres": "Mělník",
            "x": 115,
            "y": 82,
            "val": 0
        },
        "68": {
            "id": 68,
            "okres": "Mladá Boleslav",
            "x": 132,
            "y": 78,
            "val": 0
        },
        "69": {
            "id": 69,
            "okres": "Nymburk",
            "x": 142,
            "y": 93,
            "val": 0
        },
        "70": {
            "id": 70,
            "okres": "Kolín",
            "x": 138,
            "y": 105,
            "val": 0
        },
        "71": {
            "id": 71,
            "okres": "Kutná Hora",
            "x": 149,
            "y": 117,
            "val": 0
        },
        "72": {
            "id": 72,
            "okres": "Benešov",
            "x": 127,
            "y": 127,
            "val": 0
        },
        "73": {
            "id": 73,
            "okres": "Příbram",
            "x": 98,
            "y": 130,
            "val": 0
        },
        "74": {
            "id": 74,
            "okres": "Beroun",
            "x": 92,
            "y": 113,
            "val": 0
        },
        "75": {
            "id": 75,
            "okres": "Praha-západ",
            "x": 110,
            "y": 114,
            "val": 0
        },
        "76": {
            "id": 76,
            "okres": "Praha-východ",
            "x": 122,
            "y": 111,
            "val": 0
        },
        "77": {
            "id": 77,
            "okres": "Praha",
            "x": 113,
            "y": 102,
            "val": 0
        }
    }

   
    # Virtual LEDs
    dots = []
    w = 7
    h = 7

    mapa = displayio.OnDiskBitmap('./mapa.bmp')
    display_map = displayio.TileGrid(mapa, pixel_shader=mapa.pixel_shader)

    for item in okresy:
        dots.append(Rect(okresy[item]['x']-2, okresy[item]['y']-2, w, h, fill=colors.grey))

    group.append(display_map)   
    for item in dots:
        group.append(item)


    
    text_label = label.Label(terminalio.FONT, text='hodnota', x=5, y=5, color=0xFFFFFF, scale=1)

    group.append(text_label) 
    display.root_group = group

    return display, dots, okresy, text_label

display, dots, okresy, text_label = get_display()


# Initialize WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

pool = socketpool.SocketPool(wifi.radio)
requests = adafruit_requests.Session(pool, ssl.create_default_context())


def update_data():
    with requests.get("http://cdn.tmep.cz/app/export/okresy-cr-vse.json") as response:
        data = response.json()
    return data


def show_data(h, data):
    min = 10000
    max = -10000

    for d in data:
        
        okresy[str(d['id'])]['val'] = d[h]
        if min > d[h]:
            min = d[h]
        if max < d[h]:
            max = d[h]

    if h == 'h1':
        text_label.text = 'Teplota'
        min_color = 200
        max_color = 20 
    elif h == 'h2':
        text_label.text = 'Vlhkost'
        min_color = 50
        max_color = 200
    elif h == 'h3':
        text_label.text = 'Tlak'
        min_color = 200
        max_color = 10
    elif h == 'h4':
        text_label.text = 'Kvalita vzduchu'
        min_color = 85
        max_color = 0
    print(min, max)


    i = 0
    for okres in okresy:
        dots[i].fill = colorwheel(map_range(okresy[okres]['val'], min, max, min_color, max_color))
        i+=1
    display.refresh()    


deadline = ticks_ms()

values = ['h1', 'h2', 'h3', 'h4']
i = 0

while True:


    if ticks_less(deadline, ticks_ms()):
        data = update_data()
        show_data(values[i], data)
        deadline = ticks_add(deadline, 300_000)
        print("Data updated")

    btn_left.update()
    btn_right.update()

    if btn_left.fell:
        i+=1
        if i>3:
            i=0
        show_data(values[i], data)
    if btn_right.fell:
        i-=1
        if i<0:
            i=3
        show_data(values[i], data)


    