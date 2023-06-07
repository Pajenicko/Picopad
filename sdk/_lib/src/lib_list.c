
// ****************************************************************************
//
//                             Doubly Linked List
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_LIST	// use Doubly Linked List (lib_list.c, lib_list.h)

#include "../inc/lib_list.h"

// === List entry

// add new list entry after this entry
void ListEntryAddAfter(sListEntry* thisentry, sListEntry* newentry)
{
	sListEntry* next = thisentry->next;
	next->prev = newentry;
	newentry->next = next;
	newentry->prev = thisentry;
	thisentry->next = newentry;
}

// add new list entry before this entry
void ListEntryAddBefore(sListEntry* thisentry, sListEntry* newentry)
{
	sListEntry* prev = thisentry->prev;
	prev->next = newentry;
	newentry->prev = prev;
	newentry->next = thisentry;
	thisentry->prev = newentry;
}

// remove entry from the list
void ListEntryRemove(sListEntry* entry)
{
	sListEntry* next = entry->next;
	sListEntry* prev = entry->prev;
	next->prev = prev;
	prev->next = next;
}

// === Simple list

// initialize simple list
void ListInit(sList* list)
{
	list->head.next = &list->head;
	list->head.prev = &list->head;
}

// check if list is empty (check if it points to itself)
Bool ListIsEmpty(const sList* list)
{
	return list->head.next == &list->head;
}

// get first list entry
sListEntry* ListGetFirst(sList* list)
{
	return list->head.next;
}

// get last list entry
sListEntry* ListGetLast(sList* list)
{
	return list->head.prev;
}

// add new entry into start of list
void ListAddFirst(sList* list, sListEntry* entry)
{
	ListEntryAddAfter(&list->head, entry);
}	

// add new entry into end of list
void ListAddLast(sList* list, sListEntry* entry)
{
	ListEntryAddBefore(&list->head, entry);
}

// === List with count

// initialize list with count
void NumListInit(sNumList* list)
{
	list->head.next = &list->head;
	list->head.prev = &list->head;
	list->num = 0;
}

// check if list with count is empty
Bool NumListIsEmpty(const sNumList* list)
{
	return list->num == 0;
}

// get first list entry
sListEntry* NumListGetFirst(sNumList* list)
{
	return list->head.next;
}

// get last list entry
sListEntry* NumListGetLast(sNumList* list)
{
	return list->head.prev;
}

// add new entry into start of list with count
void NumListAddFirst(sNumList* list, sListEntry* entry)
{
	ListEntryAddAfter(&list->head, entry);
	list->num++;
}	

// add new entry into end of list with count
void NumListAddLast(sNumList* list, sListEntry* entry)
{
	ListEntryAddBefore(&list->head, entry);
	list->num++;
}

// add new entry into list with count, after old_entry
void NumListAddAfter(sNumList* list, sListEntry* oldentry, sListEntry* newentry)
{
	ListEntryAddAfter(oldentry, newentry);
	list->num++;
}

// add new entry into list with count, before old_entry
void NumListAddBefore(sNumList* list, sListEntry* oldentry, sListEntry* newentry)
{
	ListEntryAddBefore(oldentry, newentry);
	list->num++;
}

// remove entry from the list
void NumListRemove(sNumList* list, sListEntry* entry)
{
	ListEntryRemove(entry);
	list->num--;
}

#endif // USE_LIST	// use Doubly Linked List (lib_list.c, lib_list.h)
