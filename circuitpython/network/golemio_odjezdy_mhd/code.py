"""
What about using some open data that are provided by your government or city?
In this example we will connect to Prague data platform Golemio.cz and display departure times at some public transport stop.

1. To get started, let's set up an API Golemio account, and generate your API key for free at https://api.golemio.cz/api-keys/auth/sign-up Don't forget to set the api key as an environment variable  GOLEMIO_API_KEY in the settings.toml file.
2. Next, set the WiFi SSID and password as environment variables CIRCUITPY_WIFI_SSID and CIRCUITPY_WIFI_PASSWORD in the settings.toml file.
3. Finally set stop STOP_NAME or STOP_GTFS_ID in settings.toml file for stop that you want you inspect.
   - STOP_NAME is case-sensitive fullname of stop, MUST BE written with diacritics, no acronyms are accepted.
   - GTFS ID (General Transit Feed Specification ID) is unique id for every stop, where you can be more selective,
     eg. U400Z101P is GTFS ID for Muzeum metro A direction Depo Hostivar.
     List of GTFS ID can be found at https://data.pid.cz/stops/json/stops.json

If you are interested than you might check departure times at https://mapa.pid.cz/ they should be exatly same like in this script.

You can find the required libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
import os
import wifi
import ssl
import sys
import socketpool
import time
import zlib
import json
import adafruit_requests


# If you have font with Czech diacritics than you will not need this
def removeCzechDiacritics(text):
    """
    Convert Czech characters to plain ASII.
    """
    diacritics    = "ÁÉĚÍÓÖÚŮÝČĎŇŘŠŤŽáéěíóöúůüýčďňřšťž✈"
    no_diacritics = "AEEIOOUUYCDNRSTZaeeioouuuycdnrstz "
    result = ""
    
    for char in text:
        if char in diacritics:
            index = diacritics.index(char)
            result += no_diacritics[index]
        else:
            result += char
    
    return result


def PrintStopInfo(stop):
    print(f"Departures from {removeCzechDiacritics(stop["stop_name"]).upper()}")

def PrintDepartures(departures):
    for depart in departures:
        if depart["trip"]["is_air_conditioned"]:
            aircondition = "*"
        else:
            aircondition = " "

        print(f"{depart["route"]["short_name"]:>4} {aircondition} {removeCzechDiacritics(depart["trip"]["headsign"]):25} {depart["departure_timestamp"]["minutes"]:>3} min")

def PrintInfotexts(infotexts):
    for inf in infotexts:
        print(inf["text"])


def ConnectWifi(wifi_ssid, wifi_password):
    wifi.radio.connect(wifi_ssid, wifi_password)
    print("Connected to WiFi", wifi_ssid)

    pool = socketpool.SocketPool(wifi.radio)
    request = adafruit_requests.Session(pool, ssl.create_default_context())
    return request


def AskGolem(request, api_key, query):

    if (request is None or api_key is None or query is None):
        print("Not enough parameters to bring Golem to live. Try harder.")
        return

    # You might wanna to tweak query parameters in request url, you can do a lot of magic here
    # see docs at https://api.golemio.cz/pid/docs/openapi/#/%F0%9F%9A%8F%20PID%20Departure%20Boards%20(v2)/get_v2_pid_departureboards
    url = f"https://api.golemio.cz/v2/pid/departureboards?{query}&preferredTimezone=Europe%2FPrague&total=10"

    headers = {
        "X-Access-Token": api_key, # Use secret of Shem HaMephorash
        "Accept": "application/json"
    }
    # Uncomment if there is a problem with gzip compression of the response
    # headers["Accept-Encoding"] = "identity";

    response = request.get(url, headers=headers)
    status_code = response.status_code

    if "content-encoding" in response.headers and response.headers["content-encoding"] == "gzip":
        print("Decompressing response...")
        decompressed = zlib.decompress(response.content, 31) # 31 for gzip, see https://docs.python.org/3/library/zlib.html#zlib.decompress
        json_response = json.loads(decompressed)
    else:
        json_response = json.loads(response.text)

    if status_code != 200:
        print("- E - R - R - O - R - ") # May all your teeth fall out, except one to give you a toothache. (Yiddish Curse)
        if "error_status" in json_response and "error_message" in json_response:
            print(json_response["error_status"], json_response["error_message"])
            
            if "error_info" in json_response:
                print(json_response["error_info"])
        else:
            print(f"Status code: {status_code}")

    if "stops" in json_response and "departures" in json_response and "infotexts" in json_response:
        print()
        PrintStopInfo(json_response["stops"][0])
        print("-" * 40)
        PrintDepartures(json_response["departures"])
        PrintInfotexts(json_response["infotexts"])
        print("Powered by PID.cz and Golemio.cz")
    else:
        print("Wrong response :("); # You should be transformed into a chandelier, to hang by day and to burn by night. (Yiddish Curse)



api_key = None
query = None

if os.getenv("GOLEMIO_API_KEY") is None or len(os.getenv("GOLEMIO_API_KEY")) < 80:
    print("You need to set GOLEMIO_API_KEY in settings.toml.")
    sys.exit(1)
else:
    api_key = os.getenv("GOLEMIO_API_KEY")

if os.getenv("STOP_NAME") is not None and len(os.getenv("STOP_NAME")) > 0:
    query = f"names={os.getenv("STOP_NAME")}"
elif os.getenv("STOP_GTFS_ID") is not None and len(os.getenv("STOP_GTFS_ID")) > 0:
    query = f"ids={os.getenv("STOP_GTFS_ID")}"
else:
    print("You need to set either STOP_GTFS_ID or STOP_NAME in settings.toml.")
    sys.exit(1)

request = ConnectWifi(os.getenv("CIRCUITPY_WIFI_SSID"), os.getenv("CIRCUITPY_WIFI_PASSWORD"))
AskGolem(request, api_key, query)
