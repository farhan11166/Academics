#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "procinfo.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_strrev(void) {
    char *str;
    int len, i;

    if (argstr(0, &str) < 0 || argint(1, &len) < 0)
        return -1;

    for (i = 0; i < len / 2; i++) {
        char tmp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = tmp;
    }

    return 0;
}

int
sys_setflag(void)
{
     int flag_value;

     if(argint(0, &flag_value)<0){
      	return -1;
     }

     myproc()->userflag=flag_value;
     return 0;
}

int 
sys_getflag(void)
{
      return myproc()->userflag;
}
int
sys_getstats(void)
{
    int *user_stats_ptr;

    if(argptr(0, (void*)&user_stats_ptr, sizeof(int) * 2) < 0)
        return -1;

    struct proc *p = myproc();
    int kernel_stats[2];

    kernel_stats[0] = p->sched_count;
    kernel_stats[1] = p->run_ticks;

    if(copyout(p->pgdir, (uint)user_stats_ptr, (char*)kernel_stats, sizeof(kernel_stats)) < 0)
        return -1;

    return 0; 
}

int
sys_get_proc_info(void)
{
  int pid;
  struct proc_info *info;

  if(argint(0, &pid) < 0)
    return -1;
  if(argptr(1, (char**)&info, sizeof(*info)) < 0)
    return -1;

  return get_proc_info(pid, info);

}

