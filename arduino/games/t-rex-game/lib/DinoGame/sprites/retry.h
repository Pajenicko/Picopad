/**
 * Original code from: https://www.hackster.io/brzi/google-chrome-dinosaur-game-on-3-4-tft-c8ad88
 */
const uint16_t retry[] __attribute__ ((aligned(4))) ={
0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0010 (16)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x0020 (32)
0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0030 (48)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF,   // 0x0040 (64)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0050 (80)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF,   // 0x0060 (96)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0070 (112)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0080 (128)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0090 (144)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x00A0 (160)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0x528A, 0x528A,   // 0x00B0 (176)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x00C0 (192)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A,   // 0x00D0 (208)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x00E0 (224)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x00F0 (240)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0100 (256)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x0110 (272)
0xFFFF, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0120 (288)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x0130 (304)
0xFFFF, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0140 (320)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x0150 (336)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0160 (352)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A,   // 0x0170 (368)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0180 (384)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0x528A, 0x528A,   // 0x0190 (400)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x01A0 (416)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x01B0 (432)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x01C0 (448)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x01D0 (464)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x01E0 (480)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x01F0 (496)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0200 (512)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0210 (528)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0220 (544)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0230 (560)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0240 (576)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x0250 (592)
0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0260 (608)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x0270 (624)
0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0280 (640)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x0290 (656)
0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x02A0 (672)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x02B0 (688)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x02C0 (704)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x02D0 (720)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x02E0 (736)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x02F0 (752)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0300 (768)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0310 (784)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0320 (800)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0330 (816)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0340 (832)
0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0350 (848)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF,   // 0x0360 (864)
0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0370 (880)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF,   // 0x0380 (896)
0xFFFF, 0xFFFF, 0xFFFF, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A,   // 0x0390 (912)
0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0x528A, 0xFFFF, 0xFFFF, 0xFFFF,   // 0x03A0 (928)
};
