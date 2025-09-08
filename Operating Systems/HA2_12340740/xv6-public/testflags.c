#include "types.h"
#include "stat.h"
#include "user.h"

int main(){
     int val;

     if(setflag(1234)<0){
     	printf(1,"Error: setflag failed\n");
	exit();
     }
     val=getflag();
     printf(1,"After first setflag:%d\n",val);

     if (setflag(690) < 0) {
        printf(1,"Error: setflag failed\n");
        exit();
    }
    val = getflag();
    printf(1,"After second setflag: %d\n", val);

    exit();
}
