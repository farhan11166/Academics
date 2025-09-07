#include <stdio.h>
#include <stdlib.h>
int main(){
int *data=malloc(100*(sizeof(int)));
data[100]=0;
printf("%d\n",data[100]);
free(data);
return 0;





}