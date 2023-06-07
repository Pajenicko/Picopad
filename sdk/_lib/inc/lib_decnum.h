
// ****************************************************************************
//
//                              Decode number
//
// ****************************************************************************

#ifndef _DECNUM_H
#define _DECNUM_H

#ifdef __cplusplus
extern "C" {
#endif

// temporary decode text buffer
#define DECNUMBUF_SIZE	16		// max. size of decode text buffer
extern char DecNumBuf[DECNUMBUF_SIZE];

// decode unsigned number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecUNum(char* buf, u32 num, char sep);

// decode signed number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecNum(char* buf, s32 num, char sep);

// decode hex number (dig = number of digits)
void DecHexNum(char* buf, u32 num, u8 dig);

// decode 2 digits of number
void Dec2Dig(char* buf, u8 num);

// decode 2 digits of number with space character
void Dec2DigSpc(char* buf, u8 num);

#ifdef __cplusplus
}
#endif

#endif // _DECNUM_H
