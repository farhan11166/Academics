#ifndef PROCINFO_H
#define PROCINFO_H
#include "types.h"
#include "param.h" 

struct proc_info{
    int pid;
    char name[16];
    char state[16];
    uint sz;
};

#endif