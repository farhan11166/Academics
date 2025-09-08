#include "types.h"
#include "user.h"
#include "stat.h"

int main(void) {
    int stats[2];   
    int i;

    for (i = 0; i < 5; i++) {  
        if (getstats(stats) == 0) {
            printf(1, "Scheduled %d times, ran for %d ticks\n", stats[0], stats[1]);
        } else {
            printf(1, "Error retrieving stats\n");
        }
        sleep(10);   
    }

    exit();
}
