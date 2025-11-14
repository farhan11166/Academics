#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
  int pid1, pid2;

  printf(1, "Starting priority scheduling test...\n");

  pid1 = fork();
  if(pid1 == 0){
    setpriority(10); // High priority
    printf(1, "Child 1 (pid %d) with high priority (10) started.\n", getpid());
    for(int i = 0; i < 50000000; i++) {} // Busy loop
    printf(1, "Child 1 finished.\n");
    exit();
  }

  pid2 = fork();
  if(pid2 == 0){
    setpriority(50); // Low priority
    printf(1, "Child 2 (pid %d) with low priority (50) started.\n", getpid());
    for(int i = 0; i < 50000000; i++) {} // Busy loop
    printf(1, "Child 2 finished.\n");
    exit();
  }

  wait();
  wait();

  printf(1, "Priority scheduling test complete.\n");
  exit();
}
