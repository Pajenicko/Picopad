
// ****************************************************************************
//
//                             Doubly Linked List
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#if USE_LIST	// use Doubly Linked List (lib_list.c, lib_list.h)

#ifndef _LIST_H
#define _LIST_H

#ifdef __cplusplus
extern "C" {
#endif

// === List entry

// list entry
typedef struct sListEntry_
{
	// pointer to next list entry
	struct sListEntry_* next;

	// pointer to previous list entry
	struct sListEntry_* prev;

} sListEntry;

// add new list entry after this entry
void ListEntryAddAfter(sListEntry* thisentry, sListEntry* newentry);

// add new list entry before this entry
void ListEntryAddBefore(sListEntry* thisentry, sListEntry* newentry);

// remove entry from the list
void ListEntryRemove(sListEntry* entry);

// get base structure from list entry
//   entry = pointer to list entry
//   base = base structure type
//   member = name of member variable of list entry in its owner
#define BASEFROMLIST(entry, base, member) ((base*)((char*)(entry) - \
		(((char*)&(((base*)NULL)->member)) - (char*)NULL)))

// === Simple list

// simple list
typedef struct
{
	sListEntry	head;

} sList;

// initialize list
void ListInit(sList* list);

// check if list is empty (check if it points to itself)
Bool ListIsEmpty(const sList* list);

// get head of the list - used as stop mark when walking through the list
INLINE sListEntry* ListGetHead(sList* list) { return &list->head; }

// get first list entry
sListEntry* ListGetFirst(sList* list);

// get last list entry
sListEntry* ListGetLast(sList* list);

// add new entry into start of list
void ListAddFirst(sList* list, sListEntry* entry);

// add new entry into end of list
void ListAddLast(sList* list, sListEntry* entry);

// to add new entry after entry in the list - use ListEntryAddAfter
// to add new entry before entry in the list - use ListEntryAddBefore
// to remove entry from the list - use ListEntryRemove

// walking through the simple list in forward direction
//	entry = variable of sListEntry*
//	list = simple list sList*
#define LISTFOREACH(entry, list) \
  for(entry = ListGetFirst(list); entry != ListGetHead(list); entry = entry->next)

// walking through the simple list in backward direction
//	entry = variable of sListEntry*
//	list = simple list sList*
#define LISTFOREACHBACK(entry, list) \
	for(entry = ListGetLast(list); entry != ListGetHead(list); entry = entry->prev)

// safe walking through the simple list (entry can be deleted)
//	entry = variable of sListEntry*
//	next = temporary variable of next sListEntry*
//	list = simple list sList*
#define LISTFOREACHSAFE(entry, next, list) \
  for(entry = ListGetFirst(list), next = entry->next; entry != ListGetHead(list); entry = next, next = entry->next)

// === List with count

// list with count
typedef struct
{
	// list head
	sListEntry	head;

	// number of entries
	int		num;

} sNumList;

// initialize list with count
void NumListInit(sNumList* list);

// check if list with count is empty
Bool NumListIsEmpty(const sNumList* list);

// get head of the list - used as stop mark when walking through the list
INLINE sListEntry* NumListGetHead(sNumList* list) { return &list->head; }

// get first list entry
sListEntry* NumListGetFirst(sNumList* list);

// get last list entry
sListEntry* NumListGetLast(sNumList* list);

// add new entry into start of list with count
void NumListAddFirst(sNumList* list, sListEntry* entry);

// add new entry into end of list with count
void NumListAddLast(sNumList* list, sListEntry* entry);

// add new entry into list with count, after old_entry
void NumListAddAfter(sNumList* list, sListEntry* oldentry, sListEntry* newentry);

// add new entry into list with count, before old_entry
void NumListAddBefore(sNumList* list, sListEntry* oldentry, sListEntry* newentry);

// remove entry from the list with count
void NumListRemove(sNumList* list, sListEntry* entry);

// walking through the list with count in forward direction
//	entry = variable of sListEntry*
//	numlist = list with count
#define NUMLISTFOREACH(entry, numlist) \
  for(entry = NumListGetFirst(&numlist); entry != NumListGetHead(&numlist); entry = entry->next)

// walking through the list with count in backward direction
//	entry = variable of sListEntry*
//	numlist = list with count
#define NUMLISTFOREACHBACK(entry, numlist) \
	for(entry = NumListGetLast(&numlist); entry != NumListGetHead(&numlist); entry = entry->prev)

// safe walking through the list with count (entry can be deleted)
//	entry = variable of sListEntry*
//	next = temporary variable of next sListEntry*
//	numlist = list with count
#define NUMLISTFOREACHSAFE(entry, next, numlist) \
  for(entry = NumListGetFirst(&numlist), next = entry->next; entry != NumListGetHead(&numlist); entry = next, next = entry->next)

#ifdef __cplusplus
}
#endif

#endif // _LIST_H

#endif // USE_LIST	// use Doubly Linked List (lib_list.c, lib_list.h)
