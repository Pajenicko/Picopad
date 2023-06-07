
// ****************************************************************************
//
//                           List of text strings
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#if USE_TEXTLIST	// use List of text strings (lib_textlist.c, lib_textlist.h)

#ifndef _TEXTLIST_H
#define _TEXTLIST_H

#include "lib_text.h"

#ifdef __cplusplus
extern "C" {
#endif

// list of text strings
typedef struct
{
	// number of entries in the list
	int		num;

	// array size (current max. number of entries)
	int		max;

	// data array
	pText*		data;

} sTextList;

// initialize list of text strings (constructor)
void TextListInit(sTextList* list);

// delete all entries in the list
void TextListDelAll(sTextList* list);

// set number of entries (init = initialize/terminate entries; returns False on memory error)
Bool TextListSetNum(sTextList* list, int num, Bool init);

// terminate list of text strings (destructor)
INLINE void TextListTerm(sTextList* list) { TextListDelAll(list); }

// get number of entries in the list
INLINE int TextListNum(const sTextList* list) { return list->num; }

// get array of entries
INLINE pText* TestListData(sTextList* list) { return list->data; }

// check if entry index is valid
INLINE Bool TextListIsValid(const sTextList* list, int inx) { return (u32)inx < (u32)list->num; }
INLINE Bool TextListIsNotValid(const sTextList* list, int inx) { return (u32)inx >= (u32)list->num; }

// get pointer to text entry (without index checking)
INLINE pText* TextListEntry(sTextList* list, int inx) { return &list->data[inx]; }

// add new empty text entry (returns index of -1 on memory error)
int TextListNew(sTextList* list);

// add new string entry with length (returns index of -1 on memory error)
int TextListAddStrLen(sTextList* list, const char* text, int len);

// add new string entry (returns index of -1 on memory error)
INLINE int TextListAddStr(sTextList* list, const char* text)
	{ return TextListAddStrLen(list, text, -1); }

// add new text entry (returns index of -1 on memory error)
int TextListAdd(sTextList* list, const pText* text);

// add another list (returns index of first entry or -1 on error)
int TextListAddList(sTextList* list, const sTextList* list2);

// insert new entry into list (returns False on memory error)
Bool TextListIns(sTextList* list, int inx, const pText* text);

// insert another list into list (returns False on memory error)
//  - source list and destination list cannot be the same
Bool TextListInsList(sTextList* list, int inx, const sTextList* list2);

// copy list from another list (destroys old content, returns False on memory error)
Bool TextListCopy(sTextList* list, const sTextList* list2);

// delete entries from text list
void TextListDel(sTextList* list, int inx, int num);

// delete first entry from text list
INLINE void TextListDelFirst(sTextList* list) { TextListDel(list, 0, 1); }

// delete last entry from text list
INLINE void TextListDelLast(sTextList* list) { TextListDel(list, list->num-1, 1); }

// delete entries from text list to end of list
INLINE void TextListDelToEnd(sTextList* list, int inx) { TextListDel(list, inx, BIGINT); }

// duplicate text entry (returns index of -1 on error)
int TextListDup(sTextList* list, int inx);

// get text from text list
void TextListGet(const sTextList* list, pText* text, int inx);

// set text to text list
void TextListSet(sTextList* list, const pText* text, int inx);

// reverse order of entries of text list
void TextListReverse(sTextList* list);

// split text string into text list by string delimiter with length (destroys old content od text list, returns False on memory error)
//  list ... destination list (content will be destroyed)
//  text ... source text to split
//  delim ... text of delimiter
//  len ... lenth of text of delimiter (or -1 to auto-length, or 0 to split to single characters)
//  limit ... max. number of entries (use BIGINT to unlimited)
Bool TextListSplitStrLen(sTextList* list, const pText* text, const char* delim, int len, int limit);

// split text string into text list by string delimiter (destroys old content od text list, returns False on memory error)
INLINE Bool TextListSplitStr(sTextList* list, const pText* text, const char* delim, int limit)
	{ return TextListSplitStrLen(list, text, delim, -1, limit); }

// split text string into text list by text delimiter (destroys old content od text list, returns False on memory error)
INLINE Bool TextListSplit(sTextList* list, const pText* text, const pText* delim, int limit)
	{ return TextListSplitStrLen(list, text, (*delim)->data, (*delim)->len, limit); }

// split text string into text list by 1-character delimiter (destroys old content od text list, returns False on memory error)
//  list ... destination list (content will be destroyed)
//  text ... source text to split
//  delim ... 1-character delimiter
//  limit ... max. number of entries (use BIGINT to unlimited)
Bool TextListSplitChar(sTextList* list, const pText* text, char delim, int limit);

// split text to words, limited by white space characters
Bool TextListSplitWords(sTextList* list, const pText* text, int limit);

// split text to lines (delimiter is LF, reduce CR)
Bool TextListSplitLines(sTextList* list, const pText* text, int limit);

// join text strings with string delimiter with length (returns False on memory error)
Bool TextListJoinStrLen(const sTextList* list, pText* text, const char* delim, int len);

// join text strings with string delimiter (returns False on memory error)
INLINE Bool TextListJoinStr(const sTextList* list, pText* text, const char* delim)
	{ return TextListJoinStrLen(list, text, delim, -1); }

// join text strings with text delimiter (returns False on memory error)
INLINE Bool TextListJoin(const sTextList* list, pText* text, pText* delim)
	{ return TextListJoinStrLen(list, text, (*delim)->data, (*delim)->len); }

// join text strings with character delimiter (returns False on memory error)
Bool TextListJoinChar(const sTextList* list, pText* text, char delim);

// join lines with LF as delimiter (returns False on memory error)
INLINE Bool TextListJoinLines(const sTextList* list, pText* text)
	{ return TextListJoinChar(list, text, '\n'); }

#ifdef __cplusplus
}
#endif

#endif // _TEXTLIST_H

#endif // USE_TEXTLIST	// use List of text strings (lib_textlist.c, lib_textlist.h)
