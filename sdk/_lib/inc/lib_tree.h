
// ****************************************************************************
//
//                                Tree List
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#if USE_TREE		// use Tree list (lib_tree.c, lib_tree.h)

#ifndef _TREE_H
#define _TREE_H

#ifdef __cplusplus
extern "C" {
#endif

// tree entry
typedef struct sTree_
{
	// pointer to parent (NULL=none, =root)
	struct sTree_* parent;

	// pointer to next neighbor (NULL=none)
	struct sTree_* next;

	// pointer to previous neighbor (NULL=none)
	struct sTree_* prev;

	// pointer to first child (NULL=none)
	struct sTree_* first;

	// pointer to last child (NULL=none)
	struct sTree_* last;

} sTree;

// initialize tree entry (set all pointers to NULL)
void TreeInit(sTree* tree);

// add initialized new child entry (or branch) into begin of list (new child
// can have branch of children, it must have initialized entries first and last)
void TreeAddFirst(sTree* tree, sTree* entry);

// add initialized new child entry (or branch) into end of list (new child
// can have branch of children, it must have initialized entries first and last)
void TreeAddLast(sTree* tree, sTree* entry);

// add initialized neighbor entry (or branch) after current entry (neighbor
// can have branch of children, it must have initialized entries first and last)
void TreeAddAfter(sTree* tree, sTree* entry);

// add initialized neighbor entry (or branch) before current entry (neighbor
// can have branch of children, it must have initialized entries first and last)
void TreeAddBefore(sTree* tree, sTree* entry);

// detach entry from parent and neighbors (children will stay attached to entry, parent <- NULL)
void TreeRemove(sTree* tree);

// find next tree entry (cyclic, including children)
sTree* TreeFindNext(sTree* tree);

// find next tree entry with stop mark (including children, returns NULL instead of stop entry)
sTree* TreeFindNextStop(sTree* tree, sTree* stop);

// walking through children of tree branch in forward direction
//  entry = variable of sTree* type
//  parent = parent of sTree* type
#define TREEFOREACHCHILD(entry, parent) \
	for(entry = (parent)->first; entry != NULL; entry = entry->next)

// walking through children of tree branch in back direction
//  entry = variable of sTree* type
//  parent = parent of sTree* type
#define TREEFOREACHCHILDBACK(entry, parent) \
	for(entry = (parent)->last; entry != NULL; entry = entry->prev)

// walking through all tree entries
//  entry = variable of sTree* type
//  root = starting entry of sTree* type (it will stop on this entry)
#define TREEFOREACH(entry, root) \
	for (entry = root; entry != NULL; entry = TreeFindNextStop(entry, root))

// get pointer to base object from pointer to tree entry
//	entry = pointer to tree entry of sTree type
//	type = pointer to owner of sTree entry
//	member = name of member variable of sTree entry in its owner
#define BASEFROMTREE(entry, type, member) ((type*)((char*)(entry) - \
		(((char*)&(((type*)NULL)->member)) - (char*)NULL)))

#ifdef __cplusplus
}
#endif

#endif // _TREE_H

#endif // USE_TREE		// use Tree list (lib_tree.c, lib_tree.h)
