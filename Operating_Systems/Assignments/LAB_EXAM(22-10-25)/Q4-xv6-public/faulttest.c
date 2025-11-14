#include "types.h"
#include "stat.h"
#include "user.h"
int main(void){
printf(1,"Page faults : %d\n",getpagefaults());
int pages=4;
int size=pages*4096;
char *mem= sbrk(size);
for(int i=0;i<size;i++)
{mem[i]=1;}
printf(1,"Page faults afte : %d\n",getpagefaults() );
exit();}




