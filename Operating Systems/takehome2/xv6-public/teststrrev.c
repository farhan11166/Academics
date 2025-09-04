#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
    char buf[32] = "Paritosh Lahre";

    printf(1, "Before: %s\n", buf);
    strrev(buf, strlen(buf));  // system call
    printf(1, "After: %s\n", buf);

    exit();
}

