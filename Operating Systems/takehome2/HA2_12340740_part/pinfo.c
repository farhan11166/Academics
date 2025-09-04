#include "types.h"
#include "stat.h"
#include "procinfo.h"
#include "user.h"

int main(int argc,char*argv[]){
    if(argc!=2){
        printf(1,"Usage:pinfo <pid>\n");
        exit();
    }

    int pid=atoi(argv[1]);
    struct proc_info info;

    if(get_proc_info(pid,&info)<0){
        printf(1,"Error: No such process with PID %d\n", pid);
        exit();
    }

    printf(1,"Process Info:\n");
    printf(1,"PID: %d\n", info.pid);
    printf(1,"Name: %s\n", info.name);
    printf(1,"State: %s\n", info.state);
    printf(1,"Memory Size: %d bytes\n", info.sz);

    exit();
}