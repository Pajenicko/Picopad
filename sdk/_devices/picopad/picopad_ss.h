
// ****************************************************************************
//
//                            PicoPad Screen Shot
//
// ****************************************************************************

#ifndef _PICOPAD_SS_H
#define _PICOPAD_SS_H

#ifdef __cplusplus
extern "C" {
#endif

#if USE_SCREENSHOT		// use screen shots

// Do one screen shot (generates file SCRxxxxx.BMP in root of SD card)
void ScreenShot();

// Do one small screen shot (generates file SCRxxxxx.BMP in root of SD card)
void SmallScreenShot();

#endif // USE_SCREENSHOT		// use screen shots

#ifdef __cplusplus
}
#endif

#endif // _PICOPAD_SS_H
