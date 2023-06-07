
// ****************************************************************************
//                                 
//                                FAT file system
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_FAT	// use FAT file system (lib_fat.c, lib_fat.h)

#include "../inc/lib_fat.h"

// disk buffer
ALIGNED u8 DiskBuf[SECT_SIZE];

// current sector in disk buffer (SECT_NONE = none)
u32 DiskBufSect = SECT_NONE;

// dirty flag - sector in disk buffer is modified
Bool DiskBufDirty = False;

// disk FAT info
u8 DiskFS = FS_NONE;	// file system type (FS_FAT12,..)
u8 FSinfo = FSI_DISABLE; // FSinfo flag (FSI_DISABLE,...)
u8 FatNum;		// number of FATs (1 or 2)
u8 ClustSizeSect;	// cluster size in number of sectors
u16 RootNum;		// number of root directory entries (only FAT12 or FAT16; 0 on FAT32)
u32 DiskSizeSect;	// disk size in number of sectors (including system tables)
u32 ClustSize;		// cluster size in bytes
u32 ClustLast;		// last allocated cluster (SECT_NONE = unknown)
u32 ClustFree;		// number of free clusters (SECT_NONE = unknown)
u32 ClustNum;		// number of clusters (= number of FAT entries - 2)
u32 FatEntry;		// number of FAT entries (= number of clusters + 2)
u32 FatSizeSect;	// size of FAT (number of sectors per one FAT table)
u32 DiskBase;		// volume base sector (= boot base sector)
u32 FatBase;		// FAT base sector
u32 DirBase;		// root directory base sector (FAT12, FAT16) or cluster (FAT32)
u32 DataBase;		// data base sector
u32 CurDirClust;	// current directory start cluster (0 = root)
u32 DiskSerial;		// disk serial number (0 = invalid)

// working directory
sFile DirTmp;		// working directory

// file info
sFileInfo FileInfoTmp;	// file info

// file system name
const char FSName0[] = "none";
const char FSName1[] = "FAT12";
const char FSName2[] = "FAT16";
const char FSName3[] = "FAT32";
const char FSName4[] = "FAT";
const char* const FSName[FS_NUM+1] = { FSName0, FSName1, FSName2, FSName3, FSName4 };

// text strings
const char FSOEMText[] = "MSDOS5.0";
const char FSNoNameText[] = "NO NAME    ";
const char FSFat12Text[] = "FAT12   ";
const char FSFat16Text[] = "FAT16   ";
const char FSFat32Text[] = "FAT32   ";

// check if cluster is valid
Bool Disk_ClustValid(u32 clust)
{
	return (clust >= 2) && (clust < FatEntry);
}

// compare file system name (fs=FS_FAT12, FS_FAT16 or FS_FAT32)
Bool Disk_CompFATName(const char* name, u8 fs)
{
	const char* n = FSName[fs];
	u8 i, ch;
	for (i = 0; i < 5; i++)
	{
		ch = *n;
		if (ch == 0) break;
		if (ch != name[i]) return False;
		n++;
	}
	return True;
}

// flush disk buffer if modified (returns False on error)
Bool Disk_FlushBuf()
{
	if (DiskBufDirty)
	{
		// reset dirty flag (in case of error too, maybe write-protected)
		DiskBufDirty = False;

		// write sector to disk
		if (!SDWriteSect(DiskBufSect, DiskBuf)) return False;

		// write 2nd copy of FAT
		if (	(DiskFS != FS_NONE) &&	// valid file system?
			((u32)(DiskBufSect - FatBase) < FatSizeSect) && // is it 1st copy of FAT?
			(FatNum == 2)) // 2 FATs ?
			SDWriteSect(DiskBufSect + FatSizeSect, DiskBuf); // write into 2nd FAT
	}
	return True;
}

// synchronize filesystem
Bool Disk_SyncFS()
{
	// flush disk buffer
	if (!Disk_FlushBuf()) return False;

	// synchronize FSinfo (not if disabled)
	if ((DiskFS == FS_FAT32) && (FSinfo == FSI_DIRTY))
	{
		memset(DiskBuf, 0, SECT_SIZE); // clear disk buffer
		sFSinfo* fs = (sFSinfo*)DiskBuf;
		fs->leadsig = LEADSIG; // leading signature
		fs->strucsig = STRUCSIG; // structure signature
		fs->freeclust = ClustFree; // number of free clusters
		fs->lastclust = ClustLast; // last allocated cluster
		fs->bootsig = BOOTSIG; // boot signature
		DiskBufSect = DiskBase + 1; // 2nd sector immediately after boot sector
		SDWriteSect(DiskBufSect, DiskBuf);
		FSinfo = 0; // not dirty and not disabled
	}
	return True;
}

// move disk access window in disk buffer (returns False on error)
Bool Disk_MoveBuf(u32 sect)
{
	if (sect != DiskBufSect)
	{
		// flush current disk buffer
		if (!Disk_FlushBuf()) return False;

		// read new sector
		if (!SDReadSect(sect, DiskBuf))
		{
			DiskBufSect = SECT_NONE;
			return False;
		}

		// new sector is valid
		DiskBufSect = sect;
	}
	return True;
}

// get physical sector number from cluster number (returns 0 if invalid cluster number)
u32 Disk_ClustSect(u32 clust)
{
	if (!Disk_ClustValid(clust)) return 0;
	return DataBase + ClustSizeSect * (clust - 2);
}

// read FAT entry for cluster number (returns SECT_NONE on error)
u32 Disk_ReadFat(u32 clust)
{
	u32 off, sect, n;

	// check cluster number
	if (!Disk_ClustValid(clust)) return SECT_NONE;

	// get FAT entry
	switch (DiskFS)
	{
	case FS_FAT12:	// FAT12

		// byte offset of 1st part of the entry
		off = clust + (clust >> 1);

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return SECT_NONE;

		// 1st part of the entry
		n = DiskBuf[off & SECT_MASK];

		// byte offset of 2nd part of the entry
		off++;

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return SECT_NONE;

		// add 2nd part of the entry
		n |= (u16)DiskBuf[off & SECT_MASK] << 8;

		// adjust bit position
		return ((clust & 1) != 0) ? (n >> 4) : (n & 0xfff);

	case FS_FAT16:	// FAT16

		// byte offset of the entry
		off = clust << 1;

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return SECT_NONE;

		// read entry
		return *(u16*)&DiskBuf[off & SECT_MASK];

	case FS_FAT32:	// FAT32

		// byte offset of the entry
		off = clust << 2;

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return SECT_NONE;

		// read entry
		return *(u32*)&DiskBuf[off & SECT_MASK] & 0x0fffffff;

	default:
		return SECT_NONE;
	}
}

// write FAT entry for cluster number (returns FALSE on error)
Bool Disk_WriteFat(u32 clust, u32 val)
{
	u32 off, sect;
	u8* p;
	u32* p32;

	// check cluster number
	if (!Disk_ClustValid(clust)) return False;

	// set FAT entry
	switch (DiskFS)
	{
	case FS_FAT12:	// FAT12

		// byte offset of 1st part of the entry
		off = clust + (clust >> 1);

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return False;

		// set 1st part of the entry
		p = &DiskBuf[off & SECT_MASK];
		*p = (u8)(((clust & 1) != 0) ? ((*p & 0xf) | (val << 4)) : val);

		// set dirty flag
		DiskBufDirty = True;

		// byte offset of 2nd part of the entry
		off++;

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return False;

		// set 2nd part of the entry
		p = &DiskBuf[off & SECT_MASK];
		*p = (u8)(((clust & 1) != 0) ? (val >> 4) : ((*p & 0xf0) | ((val >> 8) & 0xf)));

		// set dirty flag
		DiskBufDirty = True;

		return True;

	case FS_FAT16:	// FAT16

		// byte offset of the entry
		off = clust << 1;

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return False;

		// set entry
		*(u16*)&DiskBuf[off & SECT_MASK] = (u16)val;

		// set dirty flag
		DiskBufDirty = True;

		return True;

	case FS_FAT32:	// FAT32

		// byte offset of the entry
		off = clust << 2;

		// sector index
		sect = FatBase + (off >> SECT_SIZE_BITS);

		// read sector
		if (!Disk_MoveBuf(sect)) return False;

		// set entry
		p32 = (u32*)&DiskBuf[off & SECT_MASK];
		*p32 = (*p32 & 0xf0000000) | (val & 0x0fffffff);

		// set dirty flag
		DiskBufDirty = True;

		return True;

	default:
		return False;
	}
}

// clear FAT cluster chain (returns False on error)
//   clust = start cluster
//   prev = previous cluster to mark end of chain, or 0 if no previous cluster (= clear entire chain)
Bool Disk_ClearFat(u32 clust, u32 prev)
{
	u32 next;

	// check cluster number
	if (!Disk_ClustValid(clust)) return False;

	// mark end of cluster chain
	if (prev != 0)
	{
		if (!Disk_WriteFat(prev, ~0UL)) return False;
        }

	// remove the chain
	do {
		// get next cluster
		next = Disk_ReadFat(clust);
		if (next == 0) break; // empty cluster (invalid FAT chain)
		if (next == SECT_NONE) return False; // disk error

		// mark the cluster as free
		if (!Disk_WriteFat(clust, 0)) return False;

		// update FSinfo
		if (ClustFree < ClustNum)
		{
			ClustFree++;
			FSinfo |= FSI_DIRTY;
		}

		// shift to next cluster
		clust = next;

	// until end of chain
	} while (clust < FatEntry);

	return True;
}

// create or stretch cluster chain by 1 cluster (0 = create new chain;
//    returns new cluster or SECT_NONE on error, or 0 if disk is full)
u32 Disk_CreateFat(u32 clust)
{
	u32 c, sc, nc; // current cluster, start cluster, new cluster

	// prepare start cluster -> sc
	if (clust == 0) // create new cluster
	{
		sc = ClustLast; // last used cluster
		if ((sc == 0) || (sc >= FatEntry)) sc = 1; // new start
	}
	else // stretch chain
	{
		sc = Disk_ReadFat(clust); // read current cluster
		if (sc < 2) return SECT_NONE; // free cluster is invalid
		if (sc == SECT_NONE) return SECT_NONE; // disk error
		if (sc < FatEntry) return sc; // already followed by next cluster
		sc = clust; // use current cluster as start cluster
	}

	// no free clusters
	if (ClustFree == 0) return 0;

	// try to use nearest next cluster
	nc = 0;
	if (sc == clust) // stretching existing chain
	{
		// check if next cluster is free
		nc = sc + 1; // next cluster = start cluster + 1
		if (nc >= FatEntry) nc = 2; // overflow to first cluster
		c = Disk_ReadFat(nc); // read new cluster
		if (c == SECT_NONE) return SECT_NONE; // error
		if (c != 0) // next cluster is not free
		{
			c = ClustLast; // last allocated cluster
			if (Disk_ClustValid(c)) sc = c; // use as start cluster
			nc = 0; // unknown next cluster
		}
	}

	// find next cluster
	if (nc == 0) // new cluster is unknown
	{
		// going from start cluster
		nc = sc;

		// find free cluster
		for (;;)
		{
			nc++; // shift to next cluster
			if (nc >= FatEntry) // check overflow
			{
				nc = 2; // start from the first cluster again
				if (nc > sc) return 0; // no free cluster
			}

			// check this next cluster
			c = Disk_ReadFat(nc); // read FAT entry
			if (c == 0) break; // free cluster has been found OK
			if (c == SECT_NONE) return SECT_NONE; // error
			if (nc == sc) return 0; // no free cluster
		}
	}

	// mark new cluster as "end of chain"
	if (!Disk_WriteFat(nc, ~0UL)) return SECT_NONE;

	// link from previous cluster
	if (clust != 0)
	{
		if (!Disk_WriteFat(clust, nc)) return SECT_NONE;
	}

	// update FSinfo
	ClustLast = nc;
	if ((ClustFree <= ClustNum) && (ClustFree > 0)) ClustFree--;
	FSinfo |= FSI_DIRTY;

	// return new cluster number
	return nc;
}

// clear directory cluster (returns False on error)
Bool Disk_DirClear(u32 clust)
{
	// flush disk buffer
	if (!Disk_FlushBuf()) return False;

	// prepare start sector
	u32 sect = Disk_ClustSect(clust);
	if (sect == 0) return False;

	// prepare sector
	DiskBufSect = sect;
	memset(DiskBuf, 0, SECT_SIZE);

	// write sectors of the cluster
	u8 num = ClustSizeSect;
	for (; num > 0; num--)
	{
		if (!SDWriteSect(sect, DiskBuf)) return False;
		sect++;
	}

	return True;
}

// prepare directory index from directory offset (returns False on error)
//  - requires valid sclust (start cluster of the directory, 0 = root)
//  - sets: off, clust, sect, dir
//  - sets dir->sect=0 on error
Bool Disk_DirInx(sFile* dir, u32 off)
{
	// invalidate sector
	dir->sect = 0;

	// check offset
	if ((off & (DIR_SIZE-1)) != 0) return False;

	// set current directory offset
	dir->off = off;

	// directory start cluster
	u32 clust = dir->sclust;
	if ((clust == 0) && (DiskFS == FS_FAT32)) clust = DirBase;

	// start sector of start cluster
	if (clust == 0)
	{
		// root directory start sector
		if (off >= (u32)RootNum * DIR_SIZE) return False;
		dir->sect = DirBase;
	}
	else
	{
		// find cluster with required offset
		while (off >= ClustSize)
		{
			// get next cluster
			clust = Disk_ReadFat(clust);
			if (!Disk_ClustValid(clust)) return False;
			off -= ClustSize;
		}
		dir->sect = Disk_ClustSect(clust);
	}

	// invalid sector
	if (dir->sect == 0) return False;

	// directory cluster
	dir->clust = clust;

	// current sector
	dir->sect += off >> SECT_SIZE_BITS;

	// pointer to directory entry
	dir->dir = (sDir*)&DiskBuf[off & SECT_MASK];

	return True;
}

// move to next directory entry (stretch = stretch table if needed; returns False on error or end of directory)
//  - requires valid off, sect, clust
//  - sets: off, clust, sect, dir
//  Sets dir->sect=0 if end of directory (returns False)
Bool Disk_DirNext(sFile* dir, Bool stretch)
{
	u32 clust;

	// next entry
	u32 off = dir->off + DIR_SIZE;

	// shift to next sector
	if ((off & SECT_MASK) == 0) // sector has been changed
	{
		// increase directory sector
		dir->sect++;

		// root directory
		if (dir->clust == 0)
		{
			// end of root directory
			if (off >= (u32)RootNum * DIR_SIZE)
			{
				dir->sect = 0; // end of directory
				return False;
			}
		}
		else
		{
			// check if cluster has been changed
			if (((off >> SECT_SIZE_BITS) & (ClustSizeSect - 1)) == 0)
			{
				// get next cluster
				clust = Disk_ReadFat(dir->clust);
				if ((clust < 2) || (clust == SECT_NONE)) return False;

				// end of chain, stretch it
				if (clust >= FatEntry)
				{
					// flag - end of directory
					dir->sect = 0;

					// cannot stretch
					if (!stretch) return False;

					// stretch the chain
					clust = Disk_CreateFat(dir->clust);
					if (clust == SECT_NONE) return False; // error
					if (clust == 0) return False; // disk is full

					// clear new cluster
					if (!Disk_DirClear(clust)) return False;
				}

				// set new cluster
				dir->clust = clust;
				dir->sect = Disk_ClustSect(clust);
			}
		}
	}

	// new offset
	dir->off = off;

	// new pointer
	dir->dir = (sDir*)&DiskBuf[off & SECT_MASK];

	return True;
}

// allocate new (free or deleted) directory entry (returns False on error)
//  - start cluster dir->sclust must be valid (or 0 = root)
//  - cluster chain may be stretched if needed
//  - sets: off, clust, sect, dir
//  - disk buffer contains valid directory entry (pointed by dir->dir)
Bool Disk_DirAlloc(sFile* dir)
{
	// prepare pointers to 1st directory entry
	if (!Disk_DirInx(dir, 0)) return False;

	// find unused entry
	for (;;)
	{
		// read sector with current directory entry
		if (!Disk_MoveBuf(dir->sect)) return False;

		// empty or deleted directory entry can be used
		if (((u8)dir->dir->name[0] == (u8)DIR_DEL) || ((u8)dir->dir->name[0] == (u8)DIR_FREE))
			break;

		// shift to next entry (and maybe stretch the directory)
		if (!Disk_DirNext(dir, True)) return False;
	} 

	return True;
}

// load start cluster number from directory entry
u32 Disk_LoadStartClust(sDir* dir)
{
	u32 clust = dir->clustL;
	if (DiskFS == FS_FAT32)
		clust |= (u32)dir->clustH << 16;
	return clust;
}

// save start cluster number to directory entry
void Disk_SaveStartClust(sDir* dir, u32 clust)
{
	dir->clustL = (u16)clust;
	if (DiskFS == FS_FAT32)
		dir->clustH = (u16)(clust >> 16);
}

// read current directory entry or find next valid entry (returns False on error or end of directory)
//  attr = attributes to search more to normal attributes (use ATTR_DIR_MASK to search all except volumes and long filenames)
//  - requires valid off, sect, clust, dir
//  - sets dir->sect=0 if end of directory (returns False)
//  - sets: off, clust, sect, dir
//  - disk buffer contains valid directory entry (pointed by dir->dir)
Bool Disk_DirRead(sFile* dir, u8 attr)
{
	u8 ch, a;

	// until end of directory
	while (dir->sect > 0)
	{
		// read current sector
		if (!Disk_MoveBuf(dir->sect)) return False;

		// reached end of directory
		ch = dir->dir->name[0];
		if (ch == DIR_FREE) break;

		// check if entry is valid
		a = dir->dir->attr & ATTR_MASK;
		if ((ch != DIR_DEL) && ((a & ~attr) == 0)) return True;

		// move to next directory entry (sets dir->sect=0 if end of directory)
		if (!Disk_DirNext(dir, False)) return False;
	}

	// end of directory
	dir->sect = 0;

	// not found
	return False;
}

// find directory entry by the name, volume excluded (returns False on error or if not found)
//  - requires valid sclust (start cluster of the directory, 0 = root)
//  - requires dir->name to search for
//  - sets dir->sect=0 if not found (returns False)
//  - disk buffer contains valid directory entry (pointed by dir->dir), loads dir->attr
Bool Disk_DirFind(sFile* dir)
{
	// rewind pointer to start of directory (sets dir->sect=0 on error)
	if (!Disk_DirInx(dir, 0)) return False;

	u8 ch;

	// until end of directory
	while (dir->sect > 0)
	{
		// read sector
		if (!Disk_MoveBuf(dir->sect)) return False;

		// reached end of directory
		ch = dir->dir->name[0];
		if (ch == DIR_FREE) break;

		// get attributes
		dir->attr = dir->dir->attr & ATTR_MASK;

		// exclude volume label
		if ((dir->attr & ATTR_VOL) == 0)
		{
			// check file name
			if (memcmp(dir->name, dir->dir->name, 11) == 0) return True;
		}

		// move to next directory entry (sets dir->sect=0 if end of directory)
		if (!Disk_DirNext(dir, False)) return False;
	}

	// end of directory
	dir->sect = 0;

	// not found
	return False;
}

// create directory entry (returns False on error)
//  - start cluster dir->sclust must be valid (or 0 = root)
//  - requires dir->name to contain name of new entry
//  - sets: off, clust, sect, dir
//  - disk buffer contains created directory entry (pointed by dir->dir)
Bool Disk_DirCreate(sFile* dir)
{
	// allocate new entry (and read sector with the directory entry)
	if (!Disk_DirAlloc(dir)) return False;

	// directory entry
	sDir* d = dir->dir;

	// clear the entry
	memset(d, 0, DIR_SIZE);

	// set file name
	memcpy(d->name, dir->name, 11);

	// set default entries
	u16 ti = FATTIME();
	u16 da = FATDATE();

	d->ctime = ti;
	d->cdate = da;
	d->adate = da;
	d->wtime = ti;
	d->wdate = da;

	// set dirty flag
	DiskBufDirty = True;

	return True;
}

// remove directory entry (returns False on error)
//  - requires valid sect, dir
Bool Disk_DirRemove(sFile* dir)
{
	// read sector with directory entry
	if (!Disk_MoveBuf(dir->sect)) return False;

	// mark deleted entry
	dir->dir->name[0] = DIR_DEL;

	// set dirty flag
	DiskBufDirty = True;

	return True;
}

// get file info from directory entry (returns False on error)
//  - requires valid dir->sect and valid directory entry in sector buffer (dir->dir)
Bool Disk_GetFileInfo(sFile* dir, sFileInfo* fi)
{
	// invalidate file info
	fi->name[0] = 0;
	fi->namelen = 0;

	// end of directory
	if (dir->sect == 0) return False;

	// copy filename
	u8 s, d, c;
	s = d = 0;
	while (s < 11)
	{
		c = dir->dir->name[s++];
		if (c != ' ') fi->name[d++] = c; // store character (skip space)
		if (s == 8) fi->name[d++] = '.'; // insert '.'
	}

	// mark end of name (delete dot if no extension)
	if ((d > 0) && (fi->name[d-1] == '.')) d--;
	fi->name[d] = 0;
	fi->namelen = d;

	// attributes
	fi->size = dir->dir->size; // file size
	fi->wtime = dir->dir->wtime; // modification time
	fi->wdate = dir->dir->wdate; // modification date
	fi->attr = dir->dir->attr & ATTR_MASK; // attributes
	
	return True;
}

// convert character to uppercase
char UpperCase(char ch)
{
	if ((ch >= 'a') && (ch <= 'z')) ch += 'A' - 'a';
	return ch;
}

// convert character to lowercase
char LowerCase(char ch)
{
	if ((ch >= 'A') && (ch <= 'Z')) ch += 'a' - 'A';
	return ch;
}

// get character and convert to uppercase (and shift text pointer)
char Disk_GetChar(const char** p)
{
	const char* p2 = *p;
	char ch = *p2++;
	*p = p2;
	if ((ch >= 'a') && (ch <= 'z')) ch += 'A' - 'a';
	return ch;
}

// check filename pattern matching (pat=ASCIIZ pattern string, name=11-character name; returns True if match)
//  ? = one character can be anything
//  * = rest of name or extension can be anything
//  . = extension separator. If not given '.', all extensions will match.
//  alone '.' = current directory
//  alone '..' = upper directory
Bool Disk_Match(const char* pat, const char* name)
{
	// special case - dot directory
	if ((pat[0] == '.') && (name[0] == '.'))
	{
		// up-directory '..'
		if ((pat[1] == '.') && (pat[2] == 0) && (name[1] == '.')) return True;

		// current directory '.'
		if ((pat[1] == 0) && (name[1] == ' ')) return True;
	}

	// check characters
	char ch, ch2;
	u8 i;
	Bool ext = False; // checking extension
	for (i = 0; i < 11;)
	{
		// get character from pattern
		ch = Disk_GetChar(&pat);

		// end of pattern - rest of name must be ' '
		if (ch == 0) return ((name[i] == ' ') || ((i == 8) && !ext));

		// match one character
		ch2 = UpperCase(name[i]);
		if ((ch == '?') || (ch == ch2))
		{
			if ((i < 8) || ext) i++; // do not go from name to extension
			continue;
		}

		// dot, skip to extension
		if (ch == '.')
		{
			i = 8;
			ext = True;
			continue;
		}

		// star wildchar
		if (ch == '*')
		{
			if (ext) return True;
			i = 8;
			continue;
		}

		// not match
		return False;		
	}

	// match
	return True;
}

// check filename character and convert to uppercase (returns 0 if invalid character)
char Disk_CheckChar(char ch)
{
	if (	(ch < ' ') ||
		(ch == '*') ||
		(ch == ':') ||
		(ch == '\\') ||
		(ch == '/') ||
		(ch == '<') ||
		(ch == '>') ||
		(ch == '?') ||
		(ch == '|'))
		return 0;

	// convert to uppercase
	if ((ch >= 'a') && (ch <= 'z')) ch += 'A' - 'a';

	return ch;
}

// extract name segment from the path to 11-character short name (shifts path pointer to next segment; returns False on error)
Bool Disk_ExtractName(char* name, const char** path)
{
	// clear name
	memset(name, ' ', 11);

	// prepare pointer to the path
	const char* p;
	p = *path;
	u8 d, ch;
	d = 0;

	// skip double quotes
	while (*p == '"') p++;

	// dot entry (. = current directory, .. = parent directory)
	if (*p == '.')
	{
		for (;;)
		{
			// read one character
			ch = *p;

			// end of path
			if (ch < ' ') break;
			p++;

			// skip double quotes
			if (ch == '"') continue;

			// end of dot entry
			if ((ch != '.') || (d == 2)) break;

			// save the character
			name[d++] = ch;
		}

		// valid end of name segment
		if ((ch < ' ') || (ch == '/') || (ch == '\\'))
		{
			// save new path pointer
			*path = p;
			return True;
		}

		// invalid character
		return False;
	}

	// load name
	Bool ext = False;
	for (;;)
	{
		// read one character
		ch = *p;

		// end of path
		if (ch < ' ') break;
		p++;

		// found separator
		if ((ch == '/') || (ch == '\\'))
		{
			// skip duplicated separators
			while ((*p == '/') || (*p == '\\')) p++;
			break;
		}

		// start extension
		if (ch == '.')
		{
			// extension already started
			if (ext) return False;
			ext = True;
			d = 8;
			continue;
		}

		// skip double quotes
		if (ch == '"') continue;

		// check character
		ch = Disk_CheckChar(ch);
		if (ch == 0) return False; // invalid character

		// store character
		if ((d < 8) || (ext && (d < 11))) name[d++] = ch;
	}

	// save new path pointer
	*path = p;

	return True;
}

// follow file path (returns False on error)
//  - if True: dir->attr = attributes of last name segment
//  - if True and attr = file: found valid file, dir->name = filename, dir->sclust = parent directory start cluster, dir->dir contains valid entry
//  - if True and attr = ATTR_DIR: found valid directory, dir->name = dirname, dir->sclust = parent directory start cluster, dir->dir contains valid entry
//  - if True and attr = ATTR_NONE: last segment not found, dir->name = last name segment, dir->sclust = parent directory start cluster
//  - if True and attr = ATTR_DEFDIR: used root (slust = 0) or current directory (sclust > 0)
Bool Disk_FollowPath(sFile* dir, const char* path)
{
	// skip double quotes
	while (*path == '"') path++;

	// prepare start cluster
	if ((*path == '/') || (*path == '\\')) // root directory
	{
		while ((*path == '/') || (*path == '\\')) path++; // skip heading separator
		dir->sclust = 0; // start from root directory
	}
	else
		dir->sclust = CurDirClust; // current directory start cluster

	// no path, use start directory (= root directory or current directory)
	if (*path < ' ')
	{
		// rewind to start of directory
		if (!Disk_DirInx(dir, 0)) return False;

		// found directory
		dir->attr = ATTR_DEFDIR;
	}
	else
	{
		// follow path entries
		u8 i;
		for (i = 100; i > 0; i--) // nesting limitation
		{
			// extract name segment (from path to dir->name)
			if (!Disk_ExtractName(dir->name, &path)) return False; // False on syntax error

			// find directory entry by the name in dir->name (loads dir->attr if OK)
			if (!Disk_DirFind(dir))
			{
				// not found

				// no end of path or it is dot entry - this is error
				if ((*path >= ' ') || (dir->name[0] == '.')) return False;

				// file not exist (name is last segment of the path and it is not dot entry - it is OK)
				dir->attr = ATTR_NONE;
				break;
			}

			// end of path (last entry can be directory or file)
			if (*path < ' ') break;

			// not last name segment - so it must be directory
			if ((dir->attr & ATTR_DIR) == 0) return False;

			// open next sub-directory
			dir->sclust = Disk_LoadStartClust(dir->dir);
		}

		// disk error (nesting overflow)
		if (i == 0) return False;
	}
	return True;
}

// load boot sector and check FAT filesystem (returns filesystem FS_FAT12,... FS_NONE, or FS_NUM if invalid signature)
u8 Disk_CheckFS(u32 sect)
{
	// load boot sector
	if (!Disk_MoveBuf(sect)) return FS_NUM;
	sBoot16* b = (sBoot16*)DiskBuf;
	sBoot32* b2 = (sBoot32*)DiskBuf;

	// check boot signature
	if (b->bootsig != BOOTSIG) return FS_NUM;

	// check FAT system signature
	if (!Disk_CompFATName(b->filesys, FS_NUM) && // "FAT"
		!Disk_CompFATName(b2->filesys, FS_FAT32)) return FS_NONE;

	// number of bytes per sector
	if (b->sectsize != SECT_SIZE) return FS_NONE;

	// number of sectors per FAT
	u32 fatsize = b->fatsize;
	if (fatsize == 0) fatsize = b2->fatsize32;
	if (fatsize == 0) return FS_NONE;

	// number of FATs
	u8 fatnum = b->fatnum;
	if ((fatnum != 1) && (fatnum != 2)) return FS_NONE;
	fatsize *= fatnum; // number of sectors for all FATs

	// cluster size in number of sectors (and check if it is power of 2)
	u8 clustsize = b->clustsize;
	if ((clustsize == 0) || ((clustsize & (clustsize - 1)) != 0)) return FS_NONE;

	// number of root entries (and check if it is aligned to sector)
	u16 rootnum = b->rootent;
	if ((rootnum & ((SECT_SIZE / DIR_SIZE) - 1)) != 0) return FS_NONE;

	// total number of sectors of the disk
	u32 totsect = b->sectnum16;
	if (totsect == 0) totsect = b->sectnum32;

	// number of reserved sectors
	u16 ressect = b->reserved;
	if (ressect == 0) return FS_NONE;

	// number of system sectors
	u32 syssect = ressect + fatsize + rootnum/(SECT_SIZE/DIR_SIZE); // number of system sectors (BOOT + FAT + DIR)
	if (totsect < syssect) return FS_NONE; // invalid volume size

	// number of clusters
	u32 clustnum = (totsect - syssect) / clustsize;
	if (clustnum == 0) return FS_NONE; // invalid volume size

	// determine FAT type
	u8 fs = FS_FAT16;
	if (clustnum > MAX_FAT32) return FS_NONE;
	if (clustnum > MAX_FAT16) fs = FS_FAT32;
	if (clustnum <= MAX_FAT12) fs = FS_FAT12;

	return fs;
}

// --- public functions

// unmount disk
void DiskUnmount()
{
	DiskBufSect = SECT_NONE; // no sector in disk buffer
	DiskBufDirty = False; // no dirty data in disk buffer

	DiskFS = FS_NONE; // file system
	FSinfo = FSI_DISABLE; // no file system info
	FatNum = 0; // number of FATs
	ClustSizeSect = 0; // cluster size in sectors
	RootNum = 0; // number of root entries
	DiskSizeSect = 0; // disk size in number of sectors
	ClustSize = 0; // cluster size
	ClustLast = SECT_NONE; // last allocated cluster
	ClustFree = SECT_NONE; // number of free clusters
	ClustNum = 0; // number of clusters
	FatEntry = 0; // number of FAT entries
	FatSizeSect = 0; // size of FAT
	DiskBase = 0; // boot base sector
	FatBase = 0; // FAT base sector
	DirBase = 0; // root directory base sector
	DataBase = 0; // data base sector
	CurDirClust = 0; // current directory start cluster
	DiskSerial = 0; // disk serial number

	DirTmp.sclust = 0; // working directory start cluster
	DirTmp.sect = 0; // working directory current sector
}

// mount disk (returns False on error)
Bool DiskMount()
{
	// unmount disk (and reset variables)
	DiskUnmount();	

	// connect to SD card after inserting (returns False on error)
	if (!SDConnect()) return False;

	// find FAT partition
	u32 sect = 0;
	u8 fs = Disk_CheckFS(sect); // check boot sector 0
	u32 strt[4];
	if (fs == FS_NUM) return False; // error
	if (fs == FS_NONE) // none file system, but valid MBR
	{
		// load start sectors from master boot sector MBR
		u8 i;
		sMBR* m = (sMBR*)DiskBuf;
		sPart* p;
		for (i = 0; i < 4; i++)
		{
			p = &m->part[i];
			strt[i] = (p->system == 0) ? 0 : p->start;
		}

		// find first valid file system
		for (i = 0; i < 4; i++)
		{
			sect = strt[i];
			if (sect > 0)
			{
				fs = Disk_CheckFS(sect); // check boot sector
				if ((fs >= FS_FAT12) && (fs <= FS_FAT32)) break;
			}
		}
	}

	// no valid filesystem found
	if ((fs < FS_FAT12) || (fs > FS_FAT32)) return False;

	// check FAT structure
	sBoot16* b = (sBoot16*)DiskBuf;
	sBoot32* b2 = (sBoot32*)DiskBuf;

	// number of sectors per FAT
	u32 fatsize = b->fatsize;
	if (fatsize == 0) fatsize = b2->fatsize32;
	FatSizeSect = fatsize;

	// number of FATs
	FatNum = b->fatnum;
	fatsize *= FatNum; // number of sectors for all FATs

	// cluster size in number of sectors
	ClustSizeSect = b->clustsize;
	ClustSize = (u32)ClustSizeSect << SECT_SIZE_BITS;

	// number of root entries (and check if it is aligned to sector)
	RootNum = b->rootent;

	// total number of sectors of the disk
	u32 totsect = b->sectnum16;
	if (totsect == 0) totsect = b->sectnum32;
	DiskSizeSect = totsect;

	// number of reserved sectors
	u16 ressect = b->reserved;

	// number of system sectors
	u32 syssect = ressect + fatsize + RootNum/(SECT_SIZE/DIR_SIZE); // number of system sectors (BOOT + FAT + DIR)

	// number of clusters
	u32 clustnum = (totsect - syssect) / ClustSizeSect;
	ClustNum = clustnum;

	// other variables
	FatEntry = clustnum + 2; // number of FAT entries
	DiskBase = sect; // volume base sector
	FatBase = sect + ressect; // FAT start sector
	DataBase = sect + syssect; // data start sector

	// check FAT32
	u32 needfat;
	if (fs == FS_FAT32)
	{
		if (RootNum != 0) return False; // not using root directory
		DirBase = b2->rootclust; // start cluster of root directory
		needfat = FatEntry*4; // needed FAT size
		DiskSerial = b2->serial; // disk serial number
	}

	// check FAT12/FAT16
	else
	{
		if (RootNum == 0) return False; // invalid root directory
		DirBase = FatBase + fatsize; // root directory start sector
		needfat = FatEntry*2; // FAT16
		if (fs == FS_FAT12) needfat = FatEntry*3/2 + (FatEntry & 1); // FAT12
		DiskSerial = b->serial; // disk serial number
	}

	// check FAT size
	if (FatSizeSect < ((needfat + SECT_SIZE-1) / SECT_SIZE)) return False;

	// load FSinfo
	ClustLast = ClustFree = SECT_NONE;
	FSinfo = FSI_DISABLE;
	if ((fs == FS_FAT32) && (b2->fsinfo == 1))
	{
		if (Disk_MoveBuf(sect+1))
		{
			FSinfo = 0;
			sFSinfo* fi = (sFSinfo*)DiskBuf;
			if ((fi->leadsig == LEADSIG) &&
				(fi->strucsig == STRUCSIG) &&
				(fi->bootsig == BOOTSIG))
			{
				ClustFree = fi->freeclust;
				ClustLast = fi->lastclust;
			}
		}
	}
			
	// validate file system
	DiskFS = fs;

	return True;
}

// flush disk write buffers (should be called repeatedly after some time)
Bool DiskFlush()
{
	return Disk_SyncFS();
}

// get file system name
const char* DiskFATName()
{
	return FSName[DiskFS];
}

// get number of free clusters (returns -1 on error)
u32 DiskFreeClust()
{
	// invalid disk
	if (DiskFS == FS_NONE) return SECT_NONE;

	// entry is valid
	if (ClustFree <= ClustNum) return ClustFree;

	// scan FAT table
	u32 f = 0;
	u32 clust, s;
	for (clust = 2; clust < FatEntry; clust++)
	{
		s = Disk_ReadFat(clust);
		if (s == SECT_NONE)
		{
			return SECT_NONE;
		}
		if (s == 0) f++;
	}

	// update file info
	ClustFree = f;
	FSinfo |= FSI_DIRTY;

	return f;
}

// get size of free space in KB (returns -1 on error)
u32 DiskFreeKB()
{
	// invalid disk
	if (DiskFS == FS_NONE) return SECT_NONE;

	// get free space in clusters
	u32 fre = DiskFreeClust();
	if (fre == SECT_NONE) return SECT_NONE;

	// disk cluster size (in bytes)
	u32 siz = ClustSize;

	// recalc to KB
	if (siz < 1024) fre >>= (10-SECT_SIZE_BITS);
	if (siz > 1024) fre *= siz >> 10;

	return fre;
}

// get total size in KB (-1=uknown)
u32 DiskTotalKB()
{
	// invalid disk
	if (DiskFS == FS_NONE) return SECT_NONE;

	// get total space in clusters
	u32 tot = ClustNum;

	// disk cluster size (in bytes)
	u32 siz = ClustSize;

	// recalc to KB
	if (siz < 1024) tot >>= (10-SECT_SIZE_BITS);
	if (siz > 1024) tot *= siz >> 10;

	return tot;
}

// get number of used clusters (-1=uknown)
u32 DiskUsedClust()
{
	// invalid disk
	if (DiskFS == FS_NONE) return SECT_NONE;

	// get number of free clusters
	u32 fre = DiskFreeClust();
	if (fre == SECT_NONE) return SECT_NONE;

	return ClustNum - fre;
}

// get size of used space in KB (-1=uknown)
u32 DiskUsedKB()
{
	// get used space in clusters
	u32 use = DiskUsedClust();
	if (use == SECT_NONE) return SECT_NONE;

	// disk cluster size
	u32 siz = ClustSize;

	// recalc to KB
	if (siz < 1024) use >>= (10-SECT_SIZE_BITS);
	if (siz > 1024) use *= siz >> 10;

	return use;
}

// initialize file structure sFile (set as not-open)
void FileInit(sFile* file)
{
	file->name[0] = 0; // flag - file is not open
}

// check if file is open
Bool FileIsOpen(sFile* file)
{
	return (file != NULL) && (file->name[0] != 0);
}

// create new file (returns False on error, and name[0] = 0 on error)
Bool FileCreate(sFile* file, const char* path)
{
	// invalid disk
	if ((DiskFS == FS_NONE) || (file == NULL))
	{
FILECREATEERR:
		file->name[0] = 0; // flag - file is not open
		return False;
	}

	// follow path
	if (!Disk_FollowPath(file, path)) goto FILECREATEERR;

	// attributes of last segment
	u8 attr = file->attr;

	// file already exists
	if (attr != ATTR_NONE) goto FILECREATEERR;

	// not dot entry
	if (file->name[0] == '.') goto FILECREATEERR;

	// create the file of name f->name in directory f->sclust (dir->dir contains valid entry)
	if (!Disk_DirCreate(file)) goto FILECREATEERR;

	// file was modified
	file->attr = ATTR_ARCH | ATTR_MODI;

	// save directory sector
	file->dirsect = DiskBufSect;

	// start cluster
	file->sclust = 0;

	// file size
	file->size = 0;

	// invalidate current data sector
	file->sect = 0;

	// reset file pointer
	file->off = 0;

	// write disk buffer
	return Disk_FlushBuf();
}

// open existing file (returns False on error, and name[0] = 0 on error)
Bool FileOpen(sFile* file, const char* path)
{
	// invalid disk
	if ((DiskFS == FS_NONE) || (file == NULL))
	{
FILEOPENERR:
		file->name[0] = 0; // flag - file is not open
		return False;
	}

	// follow path
	if (!Disk_FollowPath(file, path)) goto FILEOPENERR;

	// attributes of last segment
	u8 attr = file->attr;

	// file does not exist
	if (attr == ATTR_NONE) goto FILEOPENERR;

	// cannot open directory
	if ((attr & ATTR_DIR) != 0) goto FILEOPENERR;

	// save directory sector
	file->dirsect = DiskBufSect;

	// start cluster
	file->sclust = Disk_LoadStartClust(file->dir);

	// file size
	file->size = file->dir->size;

	// invalidate current data sector
	file->sect = 0;

	// reset file pointer
	file->off = 0;

	return True;
}

// read file (returns number of bytes read, or less on error)
u32 FileRead(sFile* file, void* buf, u32 num)
{
	// check if file is open
	if ((file == NULL) || (file->name[0] == 0)) return 0;

	// remaining bytes
	u32 remain = file->size - file->off;

	// truncate bytes
	if (num > remain) num = remain;

	// repeat until some bytes to read
	u32 read = 0;
	u32 n, csect, clust, sect;
	for (; read < num; )
	{
		// sector boundary reached
		if ((file->off & SECT_MASK) == 0)
		{
			// sector offset in the cluster
			csect = (file->off >> SECT_SIZE_BITS) & (ClustSizeSect-1);

			// cluster boundary reached
			if (csect == 0)
			{
				// start of the file
				if (file->off == 0)
					clust = file->sclust;
				else
					// follow cluster chain
					clust = Disk_ReadFat(file->clust);

				// check next cluster
				if (!Disk_ClustValid(clust)) break;
				file->clust = clust;
			}

			// prepare new sector
			sect = Disk_ClustSect(file->clust);
			if (sect == 0) break;
			sect += csect;

			// read whole sector
			n = num - read;
			if (n >= SECT_SIZE)
			{
				if (!SDReadSect(sect, (u8*)buf)) break;
				n = SECT_SIZE;
			}
			else
			{
				// read rest of sector
				if (!Disk_MoveBuf(sect)) break;
				memcpy(buf, DiskBuf, n);
			}

			file->sect = sect;
		}
		else
		{
			// read start of data
			n = SECT_SIZE - (file->off & SECT_MASK);
			if (n > num - read) n = num - read;
			if (!Disk_MoveBuf(file->sect)) break;
			memcpy(buf, &DiskBuf[file->off & SECT_MASK], n);
		}

		// shift by 1 transfer
		read += n;
		buf = (void*)((u8*)buf + n);
		file->off += n;
	}

	return read;
}

// write file (returns number of bytes write, or less on error)
u32 FileWrite(sFile* file, const void* buf, u32 num)
{
	// check if file is open
	if ((file == NULL) || (file->name[0] == 0)) return 0;

	// limit to 4 GB
	u32 n = 0xffffffffUL - file->off;
	if (num > n) num = n;

	// repeat until some bytes to write
	u32 write = 0;
	u32 csect, clust, sect;
	for (; write < num; )
	{
		// sector boundary reached
		if ((file->off & SECT_MASK) == 0)
		{
			// sector offset in the cluster
			csect = (file->off >> SECT_SIZE_BITS) & (ClustSizeSect-1);

			// cluster boundary reached
			if (csect == 0)
			{
				// start of the file
				if (file->off == 0)
				{
					clust = file->sclust;
					if (clust == 0) clust = Disk_CreateFat(0);
				}
				else
					// follow or stretch the chain
					clust = Disk_CreateFat(file->clust);

				// check next cluster
				if (!Disk_ClustValid(clust)) break;
				file->clust = clust;
				if (file->sclust == 0) file->sclust = clust; // new start cluster
			}

			// prepare new sector
			sect = Disk_ClustSect(file->clust);
			if (sect == 0) break;
			sect += csect;

			// write whole sector
			n = num - write;
			if (n >= SECT_SIZE)
			{
				if (!SDWriteSect(sect, (const u8*)buf)) break;
				n = SECT_SIZE;
			}
			else
			{
				// write rest of sector
				if (!Disk_MoveBuf(sect)) break;
				memcpy(DiskBuf, buf, n);
				DiskBufDirty = True;
			}

			file->sect = sect;
		}
		else
		{
			// write start of data
			n = SECT_SIZE - (file->off & SECT_MASK);
			if (n > num - write) n = num - write;
			if (!Disk_MoveBuf(file->sect)) break;
			memcpy(&DiskBuf[file->off & SECT_MASK], buf, n);
			DiskBufDirty = True;
		}

		// shift by 1 transfer
		write += n;
		buf = (const void*)((u8*)buf + n);
		file->off += n;
		if (file->off > file->size) file->size = file->off;
	}

	// file was modified
	file->attr |= ATTR_MODI;

	return write;
}

// flush file writes and flush disk buffers (returns False on error)
Bool FileFlush(sFile* file)
{
	// check if file is open
	if ((file == NULL) || (file->name[0] == 0)) return False;

	// file was modified
	if ((file->attr & ATTR_MODI) != 0)
	{
		// move window to directory entry
		if (!Disk_MoveBuf(file->dirsect)) return False;
		sDir* d = file->dir;

		// set current date and time
		u16 ti = FATTIME();
		u16 da = FATDATE();

		d->ctime10 = 0;
		d->ctime = ti;
		d->cdate = da;
		d->adate = da;
		d->wtime = ti;
		d->wdate = da;

		// set attributes
		d->attr = (file->attr & ATTR_MASK) | ATTR_ARCH;

		// set cluster
		Disk_SaveStartClust(d, file->sclust);

		// set file size
		d->size = file->size;

		// set dirty flag
		DiskBufDirty = True;
	}

	// flush write buffers
	if (!Disk_SyncFS()) return False;

	// reset modified flag
	file->attr &= ~ATTR_MODI;

	return True;
}

// close file and flush disk buffers (returns False on error)
Bool FileClose(sFile* file)
{
	// check if file is open
	if ((file == NULL) || (file->name[0] == 0)) return False;

	// flush file
	if (!FileFlush(file)) return False;

	// invalidate file
	file->name[0] = 0;

	return True;
}

// change current directory (returns False on error)
//  - uses DirTmp
Bool SetDir(const char* path)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follor the path
	if (!Disk_FollowPath(&DirTmp, path)) return False;

	// last segment not found
	if (DirTmp.attr == ATTR_NONE) return False;

	// file is forbidden
	if ((DirTmp.attr & ATTR_DIR) == 0) return False;

	// this directory
	if (DirTmp.attr == ATTR_DEFDIR)
		CurDirClust = DirTmp.sclust;
	else
		// found directory
		CurDirClust = Disk_LoadStartClust(DirTmp.dir);

	return True;
}

// get current directory (returns length of path, or 0 on error)
//  - uses DirTmp and FileInfoTmp
u16 GetDir(char* buf, u16 len)
{
	u32 clust;

	// invalid disk or invalid buffer
	if ((DiskFS == FS_NONE) || (len == 0) || (buf == NULL)) return 0;

	// start from current directory
	DirTmp.sclust = CurDirClust;

	// until root
	u16 i = len; // index of start of string = end of buffer
	while ((DirTmp.sclust != 0) && ((DiskFS != FS_FAT32) || (DirTmp.sclust != DirBase)))
	{
		// current start cluster
		clust = DirTmp.sclust;

		// rewind to parent directory entry
		if (!Disk_DirInx(&DirTmp, 1 * DIR_SIZE)) return 0;

		// read directory entry
		if (!Disk_MoveBuf(DirTmp.sect)) return 0;

		// get parent cluster
		DirTmp.sclust = Disk_LoadStartClust(DirTmp.dir);

		// rewind to start of parent directory
		if (!Disk_DirInx(&DirTmp, 0)) return 0;

		// find link to current directory
		for (;;)
		{
			// read directory entry
			if (!Disk_DirRead(&DirTmp, ATTR_DIR_MASK)) return 0;

			// check cluster
			if (clust == Disk_LoadStartClust(DirTmp.dir)) break;

			// shift to next directory entry
			if (!Disk_DirNext(&DirTmp, False)) return 0;
		}

		// load directory name
		if (!Disk_GetFileInfo(&DirTmp, &FileInfoTmp)) return 0;

		// check free space in destination buffer
		if (i < FileInfoTmp.namelen + 1 + 1) return 0;

		// copy name into destination buffer
		memcpy(&buf[i - FileInfoTmp.namelen], FileInfoTmp.name, FileInfoTmp.namelen);
		i -= FileInfoTmp.namelen + 1;
		buf[i] = PATHCHAR;
	}

	// move path
	memmove(buf, &buf[i], len - i);
	len -= i;
	buf[len] = 0;
		
	return len;
}

// seek file read/write pointer (returns False on error)
Bool FileSeek(sFile* file, u32 off)
{
	// check if file is open
	if ((file == NULL) || (file->name[0] == 0)) return False;

	// limit offset to file size
	if (off > file->size) off = file->size;

	// not changed
	if (off == file->off) return True;

	// reset pointers
	file->sect = 0;
	file->off = off;

	// seek to required offset
	if (off > 0)
	{
		// find cluster with required offset
		u32 clust = file->sclust;
		while (off >= ClustSize)
		{
			// get next cluster
			clust = Disk_ReadFat(clust);
			if (!Disk_ClustValid(clust)) return False;
			off -= ClustSize;
		}

		// set current cluster
		file->clust = clust;
		file->sect = Disk_ClustSect(clust) + (off >> SECT_SIZE_BITS);
	}

	return True;
}

// open search files (returns False on error, and name[0] = 0 on error)
//  - path = path to directory (without search pattern)
//  - searching can be reopen (without close) to rewind search from the start again
Bool FindOpen(sFile* find, const char* path)
{
	// invalid disk
	if ((DiskFS == FS_NONE) || (find == NULL))
	{
DIROPENERR:
		find->name[0] = 0; // flag - directory is not open
		return False;
	}

	// follow path
	if (!Disk_FollowPath(find, path)) goto DIROPENERR;

	// attributes of last segment
	u8 attr = find->attr;

	// entry must exist
	if (attr == ATTR_NONE) goto DIROPENERR;

	// entry must be diretory
	if ((attr & ATTR_DIR) == 0) goto DIROPENERR;

	// found sub-directory
	if (attr != ATTR_DEFDIR)
		find->sclust = Disk_LoadStartClust(find->dir);
	else
		find->name[0] = '.';

	// rewind to start of directory
	if (!Disk_DirInx(find, 0)) goto DIROPENERR;

	return True;
}

// find next file (returns False on error or end of directory)
//  attr = attributes to search more to normal attributes (use ATTR_DIR_MASK to search all except volumes and long filenames)
//  pat = ASCIIZ pattern (?=one character matching, *=rest matching)
Bool FindNext(sFile* find, sFileInfo* fileinfo, u8 attr, const char* pat)
{
	for (;;)
	{
		// check end of directory
		if (find->sect == 0) return False;

		// read directory entry
		if (!Disk_DirRead(find, attr)) return False;

		// check pattern
		if (Disk_Match(pat, find->dir->name))
		{
			// load file info
			if (!Disk_GetFileInfo(find, fileinfo)) return False;

			// rewind to next entry (sets dir->sect = 0 on end of directory)
			Disk_DirNext(find, False);

			break;
		}

		// rewind to next entry (sets dir->sect = 0 on end of directory)
		Disk_DirNext(find, False);
	}

	return True;
}

// close file searching (returns False on error) - not needed to use
Bool FindClose(sFile* find)
{
	// check if directory is open
	if ((find == NULL) || (find->name[0] == 0)) return False;

	// invalidate directory
	find->name[0] = 0;

	return True;
}

// check if file/directory exists (returns False on error or if not exist)
//  - uses DirTmp
Bool FileExist(const char* path)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follow path
	if (!Disk_FollowPath(&DirTmp, path)) return False;

	// attributes of last segment
	u8 attr = DirTmp.attr;

	// entry must exist
	if (attr == ATTR_NONE) return False;

	// not sub-directory
	if (attr == ATTR_DEFDIR) return False;

	return True;
}

// get file/directory info (returns False on error)
//  - uses DirTmp
Bool FileInfo(const char* path, sFileInfo* fileinfo)
{
	if (!FileExist(path)) return False;

	// load file info
	return Disk_GetFileInfo(&DirTmp, fileinfo);
}

// set file size (truncate or enlarge; returns False on error)
Bool SetFileSize(sFile* file, u32 size)
{
	// check if file is open
	if ((file == NULL) || (file->name[0] == 0)) return False;

	// size not changed
	if (size == file->size) return True;

	// file was modified
	file->attr |= ATTR_MODI;

	// truncate file
	if (size < file->size)
	{
		// save current position
		u32 off = file->off;

		// remove entire cluster chain
		if (size == 0)
		{
			if (!Disk_ClearFat(file->sclust, 0)) return False;
			file->sclust = 0; // invalidate start cluster
		}
		else
		{
			// seek to required size (or to end of the file)
			if (!FileSeek(file, size)) return False;

			// remove remaining clusters
			u32 clust = Disk_ReadFat(file->clust); // get next cluster
			if (clust == SECT_NONE) return False; // error
			if (clust < 2) return False; // error
			if (Disk_ClustValid(clust))
			{
				// clear rest of chain
				if (!Disk_ClearFat(clust, file->clust)) return False;
			}
		}

		// set new size
		file->size = size;

		// seek to old position (with size limitation)
		FileSeek(file, off);
	}

	// enlarge file
	else
	{
		// create first cluster
		u32 n = 0;
		u32 clust = file->sclust;
		if (clust == 0)
		{
			clust = Disk_CreateFat(clust);
			if (!Disk_ClustValid(clust)) return False;
			file->sclust = clust; // set new start cluster
			n = ClustSize;
		}

		// find end of cluster chain and enlarge chain
		while (size > n)
		{
			// get next cluster (or enlarge chain)
			clust = Disk_CreateFat(clust);
			if (!Disk_ClustValid(clust)) return False;
			n += ClustSize;
		}
	
		// set new size
		file->size = size;
	}

	// write disk buffer
	return Disk_FlushBuf();
}

// delete file/directory (directory must be empty; returns False on error)
//  - uses DirTmp
Bool FileDelete(const char* path)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follow path
	if (!Disk_FollowPath(&DirTmp, path)) return False;

	// attributes of last segment
	u8 attr = DirTmp.attr;

	// entry must exist
	if (attr == ATTR_NONE) return False;

	// not default directory
	if (attr == ATTR_DEFDIR) return False;

	// not read-only
	if ((attr & ATTR_RO) != 0) return False;

	// not dot directory
	if (DirTmp.dir->name[0] == '.') return False;

	// get start cluster
	u32 clust = Disk_LoadStartClust(DirTmp.dir);

	// check if directory is empty
	if ((attr & ATTR_DIR) != 0)
	{
		// save directory pointers
		u32 sclust = DirTmp.sclust;
		u32 sect = DirTmp.sect;
		sDir* dir = DirTmp.dir;

		// rewind to start of directory (skip dot entries)
		DirTmp.sclust = clust;
		if (!Disk_DirInx(&DirTmp, 2 * DIR_SIZE)) return False;

		// try to find any valid file or directory
		if (Disk_DirRead(&DirTmp, ATTR_DIR_MASK)) return False; // directory is not empty

		// return directory pointers
		DirTmp.sclust = sclust;
		DirTmp.sect = sect;
		DirTmp.dir = dir;
	}

	// remove current directory
	if ((clust != 0) && (clust == CurDirClust)) CurDirClust = 0;

	// remove directory entry
	if (!Disk_DirRemove(&DirTmp)) return False;

	// remove cluster chain
	if (clust != 0)
	{
		if (!Disk_ClearFat(clust, 0)) return False;
	}

	// write disk buffer
	return Disk_FlushBuf();
}

// create directory (returns False on error)
//  - uses DirTmp
Bool DirCreate(const char* path)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follow path
	if (!Disk_FollowPath(&DirTmp, path)) return False;

	// attributes of last segment
	u8 attr = DirTmp.attr;

	// parent cluster
	u32 pclust = DirTmp.sclust;

	// entry must not exist
	if (attr != ATTR_NONE) return False;

	// not dot directory
	if (DirTmp.name[0] == '.') return False;

	// create new cluster chain
	u32 clust = Disk_CreateFat(0);
	if (!Disk_ClustValid(clust)) return False;

	// clear the cluster
	if (!Disk_DirClear(clust)) return False;

	// get current date and time
	u16 ti = FATTIME();
	u16 da = FATDATE();

	// create first entry '.' (this directory)
	sDir* dir = (sDir*)DiskBuf;
	memset(dir->name+1, ' ', 10); // name
	dir->name[0] = '.';
	dir->attr = ATTR_DIR;
	dir->ctime = ti;
	dir->cdate = da;
	dir->adate = da;
	dir->wtime = ti;
	dir->wdate = da;
	Disk_SaveStartClust(dir, clust); // current cluster

	// create second entry '..' (parent directory)
	sDir* dir2 = dir + 1;
	memcpy(dir2, dir, DIR_SIZE);
	dir2->name[1] = '.';
	Disk_SaveStartClust(dir2, pclust); // parent cluster

	// set dirty flag
	DiskBufDirty = True;

	// create directory entry
	if (!Disk_DirCreate(&DirTmp)) return False;

	// set directory entry
	dir = DirTmp.dir;
	Disk_SaveStartClust(dir, clust); // current cluster
	dir->attr = ATTR_DIR;

	// set dirty flag
	DiskBufDirty = True;

	// write disk buffer
	return Disk_FlushBuf();
}

// rename/move file/directory (returns False on error)
//  - uses DirTmp and FileInfoTmp
Bool FileMove(const char* oldpath, const char* newpath)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follow old path
	if (!Disk_FollowPath(&DirTmp, oldpath)) return False;

	// attributes of last segment
	u8 attr = DirTmp.attr;

	// entry must exist
	if (attr == ATTR_NONE) return False;

	// not dot directory
	if (DirTmp.name[0] == '.') return False;

	// not default directory
	if (attr == ATTR_DEFDIR) return False;

	// save old entry
	sDir* dir = DirTmp.dir;
	FileInfoTmp.size = dir->size;
	FileInfoTmp.wtime = dir->wtime;
	FileInfoTmp.wdate = dir->wdate;
	u16 ctime = dir->ctime;
	u16 cdate = dir->cdate;
	u16 adate = dir->adate;
	u32 clust = Disk_LoadStartClust(dir);

	// save parent
	u32 pclust = DirTmp.sclust;
	u32 sect = DirTmp.sect;

	// follow new path
	if (!Disk_FollowPath(&DirTmp, newpath)) return False;

	// new entry must not exist
	if (DirTmp.attr != ATTR_NONE) return False;

	// not dot directory
	if (DirTmp.name[0] == '.') return False;

	// create new entry
	if (!Disk_DirCreate(&DirTmp)) return False;

	// set new entry
	sDir* dir2 = DirTmp.dir;
	memcpy(dir2->name, DirTmp.name, 11);
	dir2->size = FileInfoTmp.size;
	dir2->wtime = FileInfoTmp.wtime;
	dir2->wdate = FileInfoTmp.wdate;
	dir2->attr = ((attr & ATTR_DIR) == 0) ? (attr | ATTR_ARCH) : attr;
	dir2->ctime = ctime;
	dir2->cdate = cdate;
	dir2->adate = adate;
	Disk_SaveStartClust(dir2, clust);

	// set dirty flag
	DiskBufDirty = True;

	// update parent entry '..' in directory
	if (((attr & ATTR_DIR) != 0) && (DirTmp.sclust != pclust))
	{
		// get start cluster of the directory
		u32 sect2 = Disk_ClustSect(clust);
		if (sect2 == 0) return False;

		// load start sector
		if (!Disk_MoveBuf(sect2)) return False;

		// second entry must be '..'
		dir2 = (sDir*)&DiskBuf[1 * DIR_SIZE];
		if (dir2->name[0] != '.') return False;

		// set new paret cluster
		Disk_SaveStartClust(dir2, DirTmp.sclust);

		// set dirty flag
		DiskBufDirty = True;
	}

	// remove old entry
	DirTmp.sect = sect;
	DirTmp.dir = dir;
	if (!Disk_DirRemove(&DirTmp)) return False;

	// write disk buffer
	return Disk_FlushBuf();
}

// get file size (returns SECT_NONE on error)
//  - uses DirTmp
u32 GetFileSize(const char* path)
{
	if (!FileExist(path)) return SECT_NONE;
	return DirTmp.dir->size;
}

// get file/directory attributes (returns ATTR_NONE on error)
//  - uses DirTmp
u8 GetFileAttr(const char* path)
{
	if (!FileExist(path)) return ATTR_NONE;
	return DirTmp.dir->attr & ATTR_MASK;
}

// set file/directory attributes (cannot change DIR or VOL attributes - bits ignored; returns False on error)
//  - uses DirTmp
Bool SetFileAttr(const char* path, u8 attr)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follow path
	if (!Disk_FollowPath(&DirTmp, path)) return False;

	// attributes of last segment
	u8 attr2 = DirTmp.attr;

	// entry must exist
	if (attr2 == ATTR_NONE) return False;

	// not dot directory
	if (DirTmp.name[0] == '.') return False;

	// not default directory
	if (attr2 == ATTR_DEFDIR) return False;

	// current entry
	sDir* dir = DirTmp.dir;

	// old and new attributes
	attr2 = dir->attr & ATTR_MASK;
	attr = (attr & (ATTR_RO | ATTR_HID | ATTR_SYS | ATTR_ARCH)) | (attr2 & (ATTR_DIR | ATTR_VOL));

	// attributes not changed
	if (attr == attr2) return True;

	// set new attributes
	dir->attr = attr;

	// set dirty flag
	DiskBufDirty = True;

	// write disk buffer
	return Disk_FlushBuf();
}

// get file/directory write time (returns (u16)-1 on error)
//  - uses DirTmp
u16 GetFileTime(const char* path)
{
	if (!FileExist(path)) return (u16)-1;
	return DirTmp.dir->wtime;
}

// get file/directory write date (returns (u16)-1 on error)
//  - uses DirTmp
u16 GetFileDate(const char* path)
{
	if (!FileExist(path)) return (u16)-1;
	return DirTmp.dir->wdate;
}

// set file/directory write time (returns False on error)
//  - uses DirTmp
Bool SetFileTime(const char* path, u16 time)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follow path
	if (!Disk_FollowPath(&DirTmp, path)) return False;

	// attributes of last segment
	u8 attr = DirTmp.attr;

	// entry must exist
	if (attr == ATTR_NONE) return False;

	// not dot directory
	if (DirTmp.name[0] == '.') return False;

	// not default directory
	if (attr == ATTR_DEFDIR) return False;

	// current entry
	sDir* dir = DirTmp.dir;

	// time not changed
	u16 time2 = dir->wtime;
	if (time == time2) return True;

	// set new time
	dir->wtime = time;

	// set dirty flag
	DiskBufDirty = True;

	// write disk buffer
	return Disk_FlushBuf();
}

// set file/directory write date (returns False on error)
//  - uses DirTmp
Bool SetFileDate(const char* path, u16 date)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// follow path
	if (!Disk_FollowPath(&DirTmp, path)) return False;

	// attributes of last segment
	u8 attr = DirTmp.attr;

	// entry must exist
	if (attr == ATTR_NONE) return False;

	// not dot directory
	if (DirTmp.name[0] == '.') return False;

	// not default directory
	if (attr == ATTR_DEFDIR) return False;

	// current entry
	sDir* dir = DirTmp.dir;

	// date not changed
	u16 date2 = dir->wdate;
	if (date == date2) return True;

	// set new date
	dir->wdate = date;

	// set dirty flag
	DiskBufDirty = True;

	// write disk buffer
	return Disk_FlushBuf();
}

// get disk volume label (returns label in FileInfoTmp; returns False on error or if label does not exists - sets empty label)
//  - uses DirTmp and FileInfoTmp
Bool GetDiskLabel()
{
	// sets empty label
	FileInfoTmp.namelen = 0;
	FileInfoTmp.name[0] = 0;

	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// open root directory
	DirTmp.sclust = 0;
	if (!Disk_DirInx(&DirTmp, 0)) return False;

	// search label
	if (!Disk_DirRead(&DirTmp, ATTR_VOL)) return False;

	// copy volume label
	memcpy(FileInfoTmp.name, DirTmp.dir->name, 11);

	// truncate trailing spaces
	u8 d = 11;
	while ((d > 0) && (FileInfoTmp.name[d-1] == ' ')) d--;
	FileInfoTmp.name[d] = 0;
	FileInfoTmp.namelen = d;

	return True;
}

// set disk volume label (empty = delete volume label; returns False on error)
//  - uses DirTmp
Bool SetDiskLabel(const char* label)
{
	// invalid disk
	if (DiskFS == FS_NONE) return False;

	// skip start spaces
	while (*label == ' ') label++;

	// prepare label
	memset(DirTmp.name, ' ', 11);
	u8 n;
	char ch;
	for (n = 0; n < 11; n++)
	{
		ch = Disk_CheckChar(*label++);
		if (ch == 0) break;
		DirTmp.name[n] = ch;
	}

	// open root directory
	DirTmp.sclust = 0;
	if (!Disk_DirInx(&DirTmp, 0)) return False;

	// search label
	if (Disk_DirRead(&DirTmp, ATTR_VOL))
	{
		// delete volume label
		if (DirTmp.name[0] == ' ')
			DirTmp.dir->name[0] = DIR_DEL;
		else
			// change volume label
			memcpy(DirTmp.dir->name, DirTmp.name, 11);

		// set dirty flag
		DiskBufDirty = True;
	}
	else
	{
		// if new volume label is valid
		if (DirTmp.name[0] != ' ')
		{
			// create new directory entry
			if (!Disk_DirCreate(&DirTmp)) return False;
			DirTmp.dir->attr = ATTR_VOL;
		}
	}

	// write disk buffer
	return Disk_FlushBuf();
}

// SD card format (returns False on error)
//  fs = filesystem FS_FAT12,... (FS_NONE = auto)
//  clust = cluster size in number of sectors 0,1,2,4,8,16,32,64,128 (must be power of 2, or 0 = auto)
//  mbr = use MBR
//  magic = FORMAT_MAGIC
Bool DiskFormat(u8 fs, u8 clust, Bool mbr, u32 magic)
{
	// check magic
	if (magic != FORMAT_MAGIC) return False;

	// check filesystem
	if (fs > FS_FAT32) return False;

	// check cluster size
	if (clust != 0)
	{
		if ((clust & (clust - 1)) != 0) return False;
	}

	// write disk buffer
	Disk_FlushBuf();

	// unmount the disk
	DiskUnmount();

	// SD disconnect
	SDDisconnect();

	// connect to SD card after inserting (returns False on error)
	if (!SDConnect())
	{
DISKFORMERR:
		return False;
	}

	// get media size (in number of sectors ... max. 0xFFFFFFF6 sectors = 2 TB)
	u32 mediasize = SDMediaSize();
	if ((mediasize < (mbr ? 10 : 100)) || (mediasize > (u32)-10)) goto DISKFORMERR;

	// hidden sectors
	u32 hsect = 0;

	// prepare CHS geometry (63 sectors per track, max. 1024 tracks, max. 255 heads)
	u8 heads = 16; // number of heads
	u16 cyl1; // number of sectors per one cylinder

	for (;;)
	{
		// number of sectors per one cylinder (63 = number of sectors per track)
		cyl1 = (u16)heads * 63;

		// check number of cylinders (max. 1024 cylinders)
		if ((mediasize + cyl1 - 1) / cyl1 <= 1024UL) break;

		// maximum heads reached
		if (heads == 128)
		{
			heads = 255;
			break;
		}

		// increase number of heads                    
		heads *= 2;
	}

	// create master boot sector MBR
	if (mbr)
	{
		// end cylinder
		u16 ecyl = (u16)((mediasize + cyl1 - 1) / cyl1 - 1);

		// reserve first track for MBR
		mediasize -= 63;

		// create partition table
		memset(DiskBuf, 0, SECT_SIZE);
		sMBR* mbr = (sMBR*)DiskBuf;
		sPart* p = mbr->part;

		p->shead = 1; // start head (skipped first track of cylinder 0)
		p->ssect = 1; // start sector
		p->scyl = 0; // start cylinder
		p->system = 6; // system type (temporary FAT16B)
		p->ehead = heads - 1; // end head
		p->esect = (u8)(63 | ((ecyl >> 2) & 0xc0)); // end sector, end cylinder high 2 bits
		p->ecyl = (u8)ecyl; // end cylinder
		p->start = 63; // start sector of partition
		p->size = mediasize; // size of partition

		// boot signature
		mbr->bootsig = BOOTSIG;

		// write sector to disk
		if (!SDWriteSect(0, DiskBuf)) goto DISKFORMERR;

		// hidden sectors
		hsect = 63;
	}

	// preset default setup
	u8 fs2 = fs;
	if (fs2 == FS_NONE) fs2 = FS_FAT32; // start with FAT32
	u8 clust2 = clust;

	// determine FAT type and cluster size
	u32 clustnum; // number of clusters
	u16 res; // reserved sectors (boot)
	u16 rootsect; // number of root sectors
	u16 fatsize; // number of sectors per FAT
	u32 n;
	for (;;)
	{
		clustnum = mediasize / clust2; // number of clusters
		res = 1; // number of reserved sectors (boot)

		// FAT32
		if (fs2 == FS_FAT32)
		{
			if (clust2 == 0) clust2 = 32; // default 16 KB
			res = 32; // number of reserved sectors (boot)
			rootsect = 0; // number of root sectors
			fatsize = (clustnum * 4 + 8 + SECT_SIZE - 1) / SECT_SIZE; // number of sectors per FAT
			clustnum = (mediasize - res - fatsize) / clust2; // correct number of clusters
			fatsize = (clustnum * 4 + 8 + SECT_SIZE - 1) / SECT_SIZE; // correct number of sectors per FAT

			if (clustnum > MAX_FAT32) // too much clusters
			{
				if (clust == 0)
				{
					// increase cluster size (cannot overflow)
					clust2 <<= 1;
					continue; // restart with new cluster size
				}
				clustnum = MAX_FAT32; // limit number of clusters
			}
			else if (clustnum <= MAX_FAT16) // too little clusters
			{
				if ((clust == 0) && (clust2 > 1))
				{
					// decrease cluster size
					clust2 >>= 1;
					continue; // restart with new cluster size
				}
				else
				{
					if (fs == FS_NONE)
					{
						// change to FAT16
						fs2 = FS_FAT16;
						clust2 = clust;
						continue; // restart with new filesystem
					}
					else
						goto DISKFORMERR; // disk is too small
				}
			}
		}

		// FAT16
		else if (fs2 == FS_FAT16)
		{
			if (clust2 == 0) clust2 = 8; // default 4 KB
			rootsect = 512 * DIR_SIZE / SECT_SIZE; // number of root sectors (512 entries)
			fatsize = (clustnum * 2 + 4 + SECT_SIZE - 1) / SECT_SIZE; // number of sectors per FAT
			clustnum = (mediasize - res - fatsize - rootsect) / clust2; // correct number of clusters
			fatsize = (clustnum * 2 + 4 + SECT_SIZE - 1) / SECT_SIZE; // correct number of sectors per FAT

			if (clustnum > MAX_FAT16) // too much clusters
			{
				if ((clust == 0) && (clust2 != 128)) // cluster max. 64 KB
				{
					// increase cluster size
					clust2 <<= 1;
					continue; // restart with new cluster size
				}
				clustnum = MAX_FAT16; // limit number of clusters
			}
			else if (clustnum <= MAX_FAT12) // too little clusters
			{
				if ((fs != FS_NONE) && (clust == 0) && (clust2 > 1)) // prefered FAT12
				{
					// decrease cluster size
					clust2 >>= 1;
					continue; // restart with new cluster size
				}
				else
				{
					if (fs == FS_NONE)
					{
						// change to FAT12
						fs2 = FS_FAT12;
						clust2 = clust;
						continue; // restart with new filesystem
					}
					else
						goto DISKFORMERR; // disk is too small
				}
			}
		}

		// FAT12
		else
		{
			if (clust2 == 0) clust2 = 2; // default 1 KB
			rootsect = 256 * DIR_SIZE / SECT_SIZE; // number of root sectors (256 entries)
			fatsize = ((clustnum * 3 + 1)/2 + 3 + SECT_SIZE - 1) / SECT_SIZE; // number of sectors per FAT
			clustnum = (mediasize - res - fatsize - rootsect) / clust2; // correct number of clusters
			fatsize = ((clustnum * 3 + 1)/2 + 3 + SECT_SIZE - 1) / SECT_SIZE; // correct number of sectors per FAT

			if (clustnum > MAX_FAT12) // too much clusters
			{
				if ((clust == 0) && (clust2 != 128)) // cluster max. 64 KB
				{
					// increase cluster size
					clust2 <<= 1;
					continue; // restart with new cluster size
				}
				clustnum = MAX_FAT12; // limit number of clusters
			}
		}

		break;
	}
	mediasize = res + fatsize + rootsect + clustnum*clust2; // correct media size

	// create boot sector
	memset(DiskBuf, 0, SECT_SIZE);
	sBoot16* b = (sBoot16*)DiskBuf;
	sBoot32* b2 = (sBoot32*)DiskBuf;

	b->jmp[0] = 0xeb; // jmp instruction
	b->jmp[1] = 0xfe;
	b->jmp[2] = 0x90;
	memcpy(b->oem, FSOEMText, 8); // OEM name
	b->sectsize = SECT_SIZE; // sector size
	b->clustsize = clust2; // cluster size (in sectors)
	b->reserved = res; // reserved sectors (boot)
	b->fatnum = 1; // number of FAT tables
	b->rootent = rootsect * (SECT_SIZE / DIR_SIZE); // number of root entries
	if (mediasize < 0x10000)
		b->sectnum16 = (u16)mediasize; // total number of sectors
	else
		b->sectnum32 = mediasize;
	b->media = 0xf8; // media descriptor
	b->tracksize = 63; // number of sectors per track
	b->headnum = heads; // number of heads
	b->hiddensect = hsect; // number of hidden sectors

	if (fs2 == FS_FAT32)
	{
		b2->fatsize32 = fatsize; // number of sectors per FAT
		b2->rootclust = 2; // root directory cluster
		b2->fsinfo = 1; // offset of FSINFO sector
		b2->backup = 6; // offset of backup boot sector
		b2->drive = 0x80; // drive number
		b2->extbootsig = 0x29; // extended boot signature
		b2->serial = 0; //RandU32(); // disk serial number
		memcpy(b2->label, FSNoNameText, 11); // label
		memcpy(b2->filesys, FSFat32Text, 8); // filesystem
	}
	else
	{
		b->fatsize = fatsize; // number of sectors per FAT
		b->drive = 0x80; // drive number
		b->extbootsig = 0x29; // extended boot signature
		b->serial = 0; //RandU32(); // disk serial number
		memcpy(b->label, FSNoNameText, 11); // label
		memcpy(b->filesys, (fs2 == FS_FAT16) ? FSFat16Text : FSFat12Text, 8); // filesystem
	}
	b->bootsig = BOOTSIG; // boot signature

	// write boot sector to disk
	if (!SDWriteSect(hsect, DiskBuf)) goto DISKFORMERR;

	// create FSINFO sector
	if (fs2 == FS_FAT32)
	{
		// write backup boot sector to disk
		if (!SDWriteSect(hsect + 6, DiskBuf)) goto DISKFORMERR;

		// prepare FSINFO sector
		memset(DiskBuf, 0, SECT_SIZE - 2); // clear buffer
		sFSinfo* fi = (sFSinfo*)DiskBuf;
		fi->leadsig = LEADSIG; // leading signature
		fi->strucsig = STRUCSIG; // structure signature
		fi->freeclust = clustnum - 1; // free clusters
		fi->lastclust = 2; // last allocated cluster

		// write FSINFO sector to disk
		if (!SDWriteSect(hsect + 1, DiskBuf)) goto DISKFORMERR;

		// write backup FSINFO sector to disk
		if (!SDWriteSect(hsect + 7, DiskBuf)) goto DISKFORMERR;
	}

	// prepare first sector of FAT table
	memset(DiskBuf, 0, SECT_SIZE);
	DiskBuf[0] = 0xf8;
	n = (fs2 == FS_FAT32) ? 10 : ((fs2 == FS_FAT16) ? 3 : ((fs2 == FS_FAT12) ? 2 : 1));
	memset(DiskBuf+1, 0xff, n);
	if (fs2 == FS_FAT32) DiskBuf[11] = 0x0f;
	hsect += res;

	// write sectors of FAT table
	for (; fatsize > 0; fatsize--)
	{
		if (!SDWriteSect(hsect, DiskBuf)) goto DISKFORMERR;
		hsect++;
		memset(DiskBuf, 0, SECT_SIZE);
	}

	// write root directory
	n = (fs2 == FS_FAT32) ? clust2 : rootsect; // size of root directory
	memset(DiskBuf, 0, SECT_SIZE);
	for (; n > 0; n--)
	{
		if (!SDWriteSect(hsect, DiskBuf)) goto DISKFORMERR;
		hsect++;
	}

	// update system ID in MBR table
	if (mbr)
	{
		// read sector from disk
		if (!SDReadSect(0, DiskBuf)) goto DISKFORMERR;

		// update MBR
		sMBR* mbr = (sMBR*)DiskBuf;
		sPart* p = mbr->part;
		p->system = (fs2 == FS_FAT32) ? 12 : ((mediasize >= 0x10000) ?  6 : ((fs2 == FS_FAT16) ? 4 : 1));
		u16 ecyl = (u16)((mediasize + cyl1 - 1) / cyl1 - 1);
		p->esect = (u8)(63 | ((ecyl >> 2) & 0xc0)); // end sector, end cylinder high 2 bits
		p->ecyl = (u8)ecyl; // end cylinder
		p->size = mediasize; // size of partition

		// write sector to disk
		if (!SDWriteSect(0, DiskBuf)) goto DISKFORMERR;
	}

	// remount the disk
	DiskMount();

	return True;
}

// check file extension
Bool FileCheckExt(sFileInfo* fi, const char* ext)
{
	// prepare length of extension
	int len = 0;
	const char* s = ext;
	while (*s++ != 0) len++;
	s--;

	// check filename length
	int i = fi->namelen;
	if (i < len) return False;

	// compare extension
	char* d = &fi->name[i];
	for (; len > 0; len--)
	{
		s--;
		d--;
		if (UpperCase(*s) != UpperCase(*d)) return False;
	}

	// check dot separator (if extension is not empty)
	if (ext[0] != 0)
	{
		if (d[-1] != '.') return False;
	}

	return True;
}

#endif // USE_FAT	// use FAT file system (lib_fat.c, lib_fat.h)
