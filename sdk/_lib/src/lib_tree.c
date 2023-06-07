
// ****************************************************************************
//
//                                Tree List
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_TREE		// use Tree list (lib_tree.c, lib_tree.h)

#include "../inc/lib_tree.h"

// initialize tree entry (set all pointers to NULL)
void TreeInit(sTree* tree)
{
	// pointer to parent (NULL=none, root)
	tree->parent = NULL;

	// pointer to next neighbor (NULL=none)
	tree->next = NULL;

	// pointer to previous neighbor (NULL=none)
	tree->prev = NULL;

	// pointer to first child (NULL=none)
	tree->first = NULL;

	// pointer to last child (NULL=none)
	tree->last = NULL;
}

// add initialized new child entry (or branch) into begin of list (new child
// can have branch of children, it must have initialized entries first and last)
void TreeAddFirst(sTree* tree, sTree* entry)
{
	entry->next = tree->first;
	entry->prev = NULL;

	if (tree->first == NULL)
		tree->last = entry;
	else
		tree->first->prev = entry;

	tree->first = entry;
	entry->parent = tree;
}

// add initialized new child entry (or branch) into end of list (new child
// can have branch of children, it must have initialized entries first and last)
void TreeAddLast(sTree* tree, sTree* entry)
{
	entry->next = NULL;
	entry->prev = tree->last;

	if (tree->last == NULL)
		tree->first = entry;
	else
		tree->last->next = entry;

	tree->last = entry;
	entry->parent = tree;
}

// add initialized neighbor entry (or branch) after current entry (neighbor
// can have branch of children, it must have initialized entries first and last)
void TreeAddAfter(sTree* tree, sTree* entry)
{
	entry->next = tree->next;
	entry->prev = tree;

	if (tree->next != NULL)
		tree->next->prev = entry;
	else
		if (tree->parent != NULL)
			tree->parent->last = entry;

	entry->parent = tree->parent;
	tree->next = entry;
}

// add initialized neighbor entry (or branch) before current entry (neighbor
// can have branch of children, it must have initialized entries first and last)
void TreeAddBefore(sTree* tree, sTree* entry)
{
	entry->next = tree;
	entry->prev = tree->prev;

	if (tree->prev != NULL)
		tree->prev->next = entry;
	else
		if (tree->parent != NULL)
			tree->parent->first = entry;

	entry->parent = tree->parent;
	tree->prev = entry;
}

// detach entry from parent and neighbors (children will stay attached to entry, parent <- NULL)
void TreeRemove(sTree* tree)
{
	if (tree->prev != NULL)
		tree->prev->next = tree->next;
	else
		if (tree->parent != NULL)
			tree->parent->first = tree->next;

	if (tree->next != NULL)
		tree->next->prev = tree->prev;
	else
		if (tree->parent != NULL)
			tree->parent->last = tree->prev;

	tree->prev = NULL;
	tree->next = NULL;
	tree->parent = NULL;
}

// find next tree entry (cyclic, including children)
sTree* TreeFindNext(sTree* tree)
{
	// nest into children branch
	if (tree->first != NULL) return tree->first;

	// get next neighbor or rise up to parent
	sTree* entry = tree;
	for (;;)
	{
		if (entry->next != NULL) return entry->next; // continue with neighbor
		if (entry->parent == NULL)
		{
			while (entry->prev != NULL) entry = entry->prev; // find first root entry
			return entry; // root, return this first root entry
		}
		entry = entry->parent; // rise up to parent
	}
}

// find next tree entry with stop mark (including children, returns NULL instead of stop entry)
sTree* TreeFindNextStop(sTree* tree, sTree* stop)
{
	sTree* entry = TreeFindNext(tree);
	if (entry == stop) entry = NULL;
	return entry;
}

#endif // USE_TREE		// use Tree list (lib_tree.c, lib_tree.h)
