
// ****************************************************************************
//
//                           List of text strings
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_TEXTLIST	// use List of text strings (lib_textlist.c, lib_textlist.h)

#include "../inc/lib_text.h"
#include "../inc/lib_textlist.h"

// initialize list of text strings
void TextListInit(sTextList* list)
{
	list->num = 0;
	list->max = 0;
	list->data = NULL;
}

// delete all entries in the list
void TextListDelAll(sTextList* list)
{
	int i;
	for (i = list->num - 1; i >= 0; i--) TextTerm(&list->data[i]);
	MemFree(list->data);
	list->num = 0;
	list->max = 0;
	list->data = NULL;
}

// set number of entries (init = initialize/terminate entries; returns False on memory error)
Bool TextListSetNum(sTextList* list, int num, Bool init)
{
	int i;
	pText* data2;

	// no change
	if (num == list->num) return True;

	// new max. number of entries (multiply of 16 entries)
	int max2 = (num + 0x0f) & ~0x0f;

	// increase size of memory block
	if (max2 > list->max)
	{
		data2 = (pText*)MemResize(list->data, max2*sizeof(pText));
		if (data2 == NULL) return False; // memory error
		list->data = data2;
		list->max = max2;
	}

	if (init)
	{
		// increase number of entries
		if (num > list->num)
		{
			for (i = list->num; i < num; i++) TextInit(&list->data[i]);
		}

		// decrease number of entris
		else
		{
			for (i = list->num - 1; i >= num; i--) TextTerm(&list->data[i]);
		}
	}

	// decrease size of memory block
	if (max2 < list->max)
	{
		data2 = (pText*)MemResize(list->data, max2*sizeof(pText));
		if (data2 != NULL) // memory OK
		{
			list->data = data2;
			list->max = max2;
		}
	}

	// set new number of entries
	list->num = num;
	return True;
}

// add new empty text entry (returns index of -1 on memory error)
int TextListNew(sTextList* list)
{
	int inx = list->num; // index of new last entry
	if (!TextListSetNum(list, inx+1, True)) return -1; // increase number of entries, return on error
	return inx;
}

// add new string entry with length (returns index of -1 on memory error)
int TextListAddStrLen(sTextList* list, const char* text, int len)
{
	int inx = list->num; // index of new last entry
	if (!TextListSetNum(list, inx+1, True)) return -1; // increase number of entries, return on error
	if (!TextSetStrLen(&list->data[inx], text, len)) return -1; // memory error
	return inx;
}

// add new text entry (returns index of -1 on memory error)
int TextListAdd(sTextList* list, const pText* text)
{
	int inx = list->num; // index of new last entry
	if (!TextListSetNum(list, inx+1, True)) return -1; // increase number of entries, return on error
	TextSet(&list->data[inx], text);
	return inx;
}

// add another list (returns index of first entry or -1 on error)
int TextListAddList(sTextList* list, const sTextList* list2)
{
	int inx = list->num; // index of new last entry
	int num = list2->num; // number of new entries
	if (num == 0) return inx; // source list is empty
	if (!TextListSetNum(list, inx + num, True)) return -1; // increase number of entries, return on error
	for (num--; num >= 0; num--)
	{
		TextSet(&list->data[inx+num], &list2->data[num]); // copy text
	}
	return inx;
}

// insert new entry into list (returns False on memory error)
Bool TextListIns(sTextList* list, int inx, const pText* text)
{
	// limit index
	if (inx < 0) inx = 0;
	int num = list->num;
	if (inx > num) inx = num;

	// increase number of entries, return on error
	if (!TextListSetNum(list, num + 1, False)) return False;

	// move remaining text variables
	MemMove(&list->data[inx+1], &list->data[inx], (num - inx)*sizeof(pText));

	// set new entry
	TextInit(&list->data[inx]);
	TextSet(&list->data[inx], text);
	return True;
}

// insert another list into list (returns False on memory error)
//  - source list and destination list cannot be the same
Bool TextListInsList(sTextList* list, int inx, const sTextList* list2)
{
	// cannot insert list into itself
	if (list == list2) return False;

	// limit index
	if (inx < 0) inx = 0;
	int num = list->num;
	if (inx > num) inx = num;

	// number of entries of source list
	int num2 = list2->num;

	// increase number of entries, return on error
	if (!TextListSetNum(list, num + num2, False)) return False;

	// move remaining text variables
	MemMove(&list->data[inx+num2], &list->data[inx], (num - inx)*sizeof(pText));

	// copy new entries
	for (num2--; num2 >= 0; num2--)
	{
		TextInit(&list->data[inx+num2]);
		TextSet(&list->data[inx+num2], &list2->data[num2]);
	}
	return True;
}

// copy list from another list (destroys old content, returns False on memory error)
Bool TextListCopy(sTextList* list, const sTextList* list2)
{
	if (list == list2) return True; // lists are equal
	TextListDelAll(list); // delete all entries
	return TextListAddList(list, list2) >= 0; // add source list
}

// delete entries from text list
void TextListDel(sTextList* list, int inx, int num)
{
	// check index and number
	if ((num > 0) && TextListIsValid(list, inx))
	{
		// limit number of entries
		if (num > list->num - inx) num = list->num - inx;

		// terminate deleted entries
		int i = num;
		for (i--; i >= 0; i--) TextTerm(&list->data[inx+i]);

		// move remaining entries
		MemMove(&list->data[inx], &list->data[inx+num], (list->num - inx - num)*sizeof(pText));

		// set new number of entries
		TextListSetNum(list, list->num - num, False);
	}
}

// duplicate text entry (returns index of -1 on error)
int TextListDup(sTextList* list, int inx)
{
	if (TextListIsNotValid(list, inx)) return -1; // invalid index
	pText txt;
	TextInit(&txt); // prepare temporary variable
	TextSet(&txt, &list->data[inx]); // copy text entry into temporary variable
	int res = TextListAdd(list, &txt); // add entry into list
	TextTerm(&txt); // terminate temporary variable
	return res;
}

// get text from text list
void TextListGet(const sTextList* list, pText* text, int inx)
{
	if (TextListIsValid(list, inx))
		TextSet(text, &list->data[inx]);
	else
		TextEmpty(text);
}

// set text to text list
void TextListSet(sTextList* list, const pText* text, int inx)
{
	if (TextListIsValid(list, inx)) TextSet(&list->data[inx], text);
}

// reverse order of entries of text list
void TextListReverse(sTextList* list)
{
	int i = 0;
	int j = list->num - 1;
	pText txt;
	for (; i < j; i++, j--)
	{
		txt = list->data[i];
		list->data[i] = list->data[j];
		list->data[j] = txt;
	}
}

// split text string into text list by string delimiter with length (destroys old content od text list, returns False on memory error)
//  list ... destination list (content will be destroyed)
//  text ... source text to split
//  delim ... text of delimiter
//  len ... lenth of text of delimiter (or -1 to auto-length, or 0 to split to single characters)
//  limit ... max. number of entries (use BIGINT to unlimited)
Bool TextListSplitStrLen(sTextList* list, const pText* text, const char* delim, int len, int limit)
{
	// delete old content
	TextListDelAll(list); // delete all entries from the list
	if (TextIsEmpty(text)) return True; // source text is empty

	// prepare length of delimiter
	if (delim == NULL) len = 0;
	if (len < 0) len = StrLen(delim);

	// split text string
	int pos; // current pointer in source text
	int oldpos = 0; // old pointer of start of substring
	limit--; // limit number without last string
	if (len <= 0) // delimiter text is empty - split to single characters
	{
		// split text to single characters
		for (; oldpos < TextLen(text); oldpos++)
		{
			if (list->num >= limit) break; // limit for number of entries has been exceeded
			if (TextListAddStrLen(list, &(*text)->data[oldpos], 1) < 0) return False; // insert 1 character
		}
	}
	else
	{
		for (;;)
		{
			if (list->num >= limit) break; // limit for number of entries has been exceeded
			pos = TextFindStrLen(text, delim, len, oldpos); // find next delimiter
			if (pos < 0) break; // no next delimiter
			if (TextListAddStrLen(list, &(*text)->data[oldpos], pos - oldpos) < 0) return False; // insert substring
			oldpos = pos + len; // shift old position (skip delimiter)
		}
	}

	// add rest of string
	return TextListAddStrLen(list, &(*text)->data[oldpos], (*text)->len - oldpos) >= 0;
}

// split text string into text list by 1-character delimiter (destroys old content od text list, returns False on memory error)
//  list ... destination list (content will be destroyed)
//  text ... source text to split
//  delim ... 1-character delimiter
//  limit ... max. number of entries (use BIGINT to unlimited)
Bool TextListSplitChar(sTextList* list, const pText* text, char delim, int limit)
{
	// delete old content
	TextListDelAll(list); // delete all entries from the list
	if (TextIsEmpty(text)) return True; // source text is empty

	// split text string
	int pos; // current pointer in source text
	int oldpos = 0; // old pointer of start of substring
	limit--; // limit number without last string
	for (;;)
	{
		if (list->num >= limit) break; // limit for number of entries has been exceeded
		pos = TextFindChar(text, delim, oldpos); // find next delimiter
		if (pos < 0) break; // no next delimiter
		if (TextListAddStrLen(list, &(*text)->data[oldpos], pos - oldpos) < 0) return False; // insert substring
		oldpos = pos + 1; // shift old position (skip delimiter)
	}

	// add rest of string
	return TextListAddStrLen(list, &(*text)->data[oldpos], (*text)->len - oldpos) >= 0;
}

// split text to words, limited by white space characters
Bool TextListSplitWords(sTextList* list, const pText* text, int limit)
{
	// delete old content
	TextListDelAll(list); // delete all entries from the list
	if (TextIsEmpty(text)) return True; // source text is empty

	// split text string
	int pos; // current pointer in source text
	int oldpos = 0; // old pointer of start of substring
	limit--; // limit number without last string
	for (;;)
	{
		pos = TextFindNoSpace(text, oldpos); // find non white space character - find start of word
		if (pos < 0) return True; // no next word, store nothing
		oldpos = pos; // use it as start of next word
		if (list->num >= limit) break; // limit for number of entries has been exceeded
		pos = TextFindSpace(text, oldpos); // find white space character - find end of word
		if (pos < 0) break; // no next delimiter
		if (TextListAddStrLen(list, &(*text)->data[oldpos], pos - oldpos) < 0) return False; // insert substring
		oldpos = pos; // shift old position (skip delimiter)
	}

	// add rest of string
	return TextListAddStrLen(list, &(*text)->data[oldpos], (*text)->len - oldpos) >= 0;
}

// split text to lines (delimiter is LF, reduce CR)
Bool TextListSplitLines(sTextList* list, const pText* text, int limit)
{
	// delete old content
	TextListDelAll(list); // delete all entries from the list
	if (TextIsEmpty(text)) return True; // source text is empty

	// split text string
	int pos; // current pointer in source text
	int oldpos = 0; // old pointer of start of substring
	int p1, p2; // save pointers
	limit--; // limit number without last string
	for (;;)
	{
		if (list->num >= limit) break; // limit for number of entries has been exceeded
		pos = TextFindChar(text, '\n', oldpos); // find next delimiter
		if (pos < 0) break; // no next delimiter
		p1 = oldpos; // save pointers
		p2 = pos;
		while ((p1 < p2) && ((*text)->data[p1] == '\r')) p1++; // reduce CR from start of line
		while ((p2 > p1) && ((*text)->data[p2-1] == '\r')) p2--; // reduce CR from end of line
		if (TextListAddStrLen(list, &(*text)->data[p1], p2 - p1) < 0) return False; // insert substring
		oldpos = pos + 1; // shift old position (skip delimiter)
	}

	// reduce CR from start of line
	while ((oldpos < (*text)->len) && ((*text)->data[oldpos] == '\r')) oldpos++;

	// do not store last empty string
	if (oldpos == (*text)->len) return True;

	// add rest of string
	return TextListAddStrLen(list, &(*text)->data[oldpos], (*text)->len - oldpos) >= 0;
}

// join text strings with string delimiter with length (returns False on memory error)
Bool TextListJoinStrLen(const sTextList* list, pText* text, const char* delim, int len)
{
	int inx;

	// empty output string
	TextEmpty(text);

	// no entry
	if (list->num == 0) return True;

	// prepare length of delimiter
	if (delim == NULL) len = 0;
	if (len < 0) len = StrLen(delim);

	// set first entry
	TextSet(text, &list->data[0]);

	// join strings
	for (inx = 1; inx < list->num; inx++)
	{
		if (!TextAddStrLen(text, delim, len)) return False; // add delimiter
		if (!TextAdd(text, &list->data[inx])) return False; // add text entry
	}
	return True;
}

// join text strings with character delimiter (returns False on memory error)
Bool TextListJoinChar(const sTextList* list, pText* text, char delim)
{
	int inx;

	// empty output string
	TextEmpty(text);

	// no entry
	if (list->num == 0) return True;

	// set first entry
	TextSet(text, &list->data[0]);

	// join strings
	for (inx = 1; inx < list->num; inx++)
	{
		if (!TextAddCh(text, delim)) return False; // add delimiter
		if (!TextAdd(text, &list->data[inx])) return False; // add text entry
	}
	return True;
}

#endif // USE_TEXTLIST	// use List of text strings (lib_textlist.c, lib_textlist.h)
