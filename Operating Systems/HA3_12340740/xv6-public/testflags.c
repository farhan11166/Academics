#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
    int flag;

    
    setflag(740);
    flag = getflag();
    printf(1, "After first setflag: %d\n", flag);

    
    setflag(480);
    flag = getflag();
    printf(1, "After second setflag: %d\n", flag);

    exit();
}