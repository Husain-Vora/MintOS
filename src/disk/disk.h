#ifndef DISK_H
#define DISK_H

#include "fs/file.h"

typedef unsigned int MINTOS_DISK_TYPE;

// Represents real physical hard disk
#define MINTOS_DISK_TYPE_REAL 0

struct disk {
    MINTOS_DISK_TYPE type;
    int sector_size;

    // The id of the disk
    int id;

    struct filesystem* filesystem;

    // The private data of out filesystem
    void* fs_private;
};

void disk_search_and_init();
struct disk* disk_get( int index );
int disk_read_block( struct disk* idisk, unsigned int lba, int total, void* buf );

#endif