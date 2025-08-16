#include "types.h"
#include "stat.h"
#include "user.h"
int main(void) {
char buf[32] = "Farhan Alam"; 
printf(1,"Before: %s\n", buf);
strrev(buf, strlen(buf)); 
printf(1, "After: %s\n", buf);
exit();
}
