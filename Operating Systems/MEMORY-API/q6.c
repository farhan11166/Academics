#include <stdio.h>
#include <stdlib.h>
int main(){
int *data=malloc(100*(sizeof(int)));

printf("%d\n",data[2]);
free(data);
return 0;





}