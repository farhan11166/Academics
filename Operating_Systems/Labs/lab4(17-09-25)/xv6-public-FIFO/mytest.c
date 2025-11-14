#include "types.h"
#include "user.h"
#define MAX_PAGES 3
// Number of physical pages available
#define TOTAL_ACCESSES 15 // Total virtual pages to access
int main(int argc, char *argv[])
{
int fifo[MAX_PAGES];
// Stores allocated virtual pages
int next_to_replace = 0; // FIFO pointer
int i, j;
int page;
int hit, miss;
// Initialize page table
for(i = 0; i < MAX_PAGES; i++)
fifo[i] = -1;
hit = 0;
miss = 0;
printf(1, "Starting FIFO page replacement simulation...\n");
// Simulated accesses
int accesses[TOTAL_ACCESSES] = {1,2,3,4,1,2,5,1,2,3,4,5};for(i = 0; i < TOTAL_ACCESSES; i++) {
page = accesses[i];
int found = 0;
// Check if page is already in memory (hit)
for(j = 0; j < MAX_PAGES; j++) {
if(fifo[j] == page) {
found = 1;
break;
}
}
if(found) {
hit++;
printf(1, "Access page %d: HIT\n", page);
} else {
miss++;
printf(1, "Access page %d: MISS, replacing page %d\n", page,
fifo[next_to_replace]);
fifo[next_to_replace] = page;
next_to_replace = (next_to_replace + 1) % MAX_PAGES;
}
}
printf(1, "FIFO simulation completed.\n");
printf(1, "Total hits: %d\n", hit);
printf(1, "Total misses: %d\n", miss);exit();
}