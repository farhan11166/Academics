
_belady:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#define MAX_PAGES 3
// Number of physical pages available
#define TOTAL_ACCESSES 15 // Total virtual pages to access
int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	8d 75 ac             	lea    -0x54(%ebp),%esi
  12:	53                   	push   %ebx
fifo3[i] = -1;
hit = 0;
miss = 0;
printf(1, "Starting FIFO page replacement simulation...\n");
// Simulated accesses
int accesses[TOTAL_ACCESSES] = {1,2,3,4,1,2,5,1,2,3,4,5};for(i = 0; i < TOTAL_ACCESSES; i++) {
  13:	89 f3                	mov    %esi,%ebx
{
  15:	51                   	push   %ecx
  16:	83 c4 80             	add    $0xffffff80,%esp
fifo3[i] = -1;
  19:	c7 45 90 ff ff ff ff 	movl   $0xffffffff,-0x70(%ebp)
printf(1, "Starting FIFO page replacement simulation...\n");
  20:	68 48 09 00 00       	push   $0x948
  25:	6a 01                	push   $0x1
fifo3[i] = -1;
  27:	c7 45 94 ff ff ff ff 	movl   $0xffffffff,-0x6c(%ebp)
  2e:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
printf(1, "Starting FIFO page replacement simulation...\n");
  35:	e8 06 06 00 00       	call   640 <printf>
int next_to_replace = 0; // FIFO pointer
  3a:	31 d2                	xor    %edx,%edx
  3c:	83 c4 10             	add    $0x10,%esp
int accesses[TOTAL_ACCESSES] = {1,2,3,4,1,2,5,1,2,3,4,5};for(i = 0; i < TOTAL_ACCESSES; i++) {
  3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
} else {
miss++;
printf(1, "Access page %d: MISS, replacing page %d\n", page,
fifo3[next_to_replace]);
fifo3[next_to_replace] = page;
next_to_replace = (next_to_replace + 1) % MAX_PAGES;
  4b:	89 d7                	mov    %edx,%edi
int accesses[TOTAL_ACCESSES] = {1,2,3,4,1,2,5,1,2,3,4,5};for(i = 0; i < TOTAL_ACCESSES; i++) {
  4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  5b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  62:	c7 45 b0 02 00 00 00 	movl   $0x2,-0x50(%ebp)
  69:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
  70:	c7 45 b8 04 00 00 00 	movl   $0x4,-0x48(%ebp)
  77:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  7e:	c7 45 c0 02 00 00 00 	movl   $0x2,-0x40(%ebp)
  85:	c7 45 c4 05 00 00 00 	movl   $0x5,-0x3c(%ebp)
  8c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  93:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
  9a:	c7 45 d0 03 00 00 00 	movl   $0x3,-0x30(%ebp)
  a1:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
  a8:	c7 45 d8 05 00 00 00 	movl   $0x5,-0x28(%ebp)
miss = 0;
  af:	c7 45 80 00 00 00 00 	movl   $0x0,-0x80(%ebp)
hit = 0;
  b6:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  bd:	00 00 00 
next_to_replace = (next_to_replace + 1) % MAX_PAGES;
  c0:	89 b5 78 ff ff ff    	mov    %esi,-0x88(%ebp)
  c6:	eb 0b                	jmp    d3 <main+0xd3>
  c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  cf:	00 
if(fifo3[j] == page) {
  d0:	8b 45 90             	mov    -0x70(%ebp),%eax
page = accesses[i];
  d3:	8b 0b                	mov    (%ebx),%ecx
if(fifo3[j] == page) {
  d5:	39 c8                	cmp    %ecx,%eax
  d7:	0f 84 a3 01 00 00    	je     280 <main+0x280>
  dd:	3b 4d 94             	cmp    -0x6c(%ebp),%ecx
  e0:	0f 84 9a 01 00 00    	je     280 <main+0x280>
  e6:	3b 4d 98             	cmp    -0x68(%ebp),%ecx
  e9:	0f 84 91 01 00 00    	je     280 <main+0x280>
printf(1, "Access page %d: MISS, replacing page %d\n", page,
  ef:	ff 74 bd 90          	push   -0x70(%ebp,%edi,4)
  f3:	51                   	push   %ecx
  f4:	68 78 09 00 00       	push   $0x978
  f9:	6a 01                	push   $0x1
  fb:	89 4d 84             	mov    %ecx,-0x7c(%ebp)
miss++;
  fe:	83 45 80 01          	addl   $0x1,-0x80(%ebp)
printf(1, "Access page %d: MISS, replacing page %d\n", page,
 102:	e8 39 05 00 00       	call   640 <printf>
fifo3[next_to_replace] = page;
 107:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
next_to_replace = (next_to_replace + 1) % MAX_PAGES;
 10a:	b8 56 55 55 55       	mov    $0x55555556,%eax
 10f:	83 c4 10             	add    $0x10,%esp
fifo3[next_to_replace] = page;
 112:	89 4c bd 90          	mov    %ecx,-0x70(%ebp,%edi,4)
next_to_replace = (next_to_replace + 1) % MAX_PAGES;
 116:	8d 4f 01             	lea    0x1(%edi),%ecx
 119:	f7 e9                	imul   %ecx
 11b:	89 c8                	mov    %ecx,%eax
 11d:	c1 f8 1f             	sar    $0x1f,%eax
 120:	89 d7                	mov    %edx,%edi
 122:	29 c7                	sub    %eax,%edi
 124:	8d 04 7f             	lea    (%edi,%edi,2),%eax
 127:	29 c1                	sub    %eax,%ecx
 129:	89 cf                	mov    %ecx,%edi
int accesses[TOTAL_ACCESSES] = {1,2,3,4,1,2,5,1,2,3,4,5};for(i = 0; i < TOTAL_ACCESSES; i++) {
 12b:	83 c3 04             	add    $0x4,%ebx
 12e:	8d 45 e8             	lea    -0x18(%ebp),%eax
 131:	39 d8                	cmp    %ebx,%eax
 133:	75 9b                	jne    d0 <main+0xd0>
}
}
printf(1,"FOR SIZE 3\n");
 135:	83 ec 08             	sub    $0x8,%esp
 138:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
 13e:	68 b6 09 00 00       	push   $0x9b6
 143:	6a 01                	push   $0x1
 145:	e8 f6 04 00 00       	call   640 <printf>
printf(1, "FIFO simulation completed.\n");
 14a:	59                   	pop    %ecx
 14b:	5b                   	pop    %ebx
 14c:	68 c2 09 00 00       	push   $0x9c2
 151:	6a 01                	push   $0x1
printf(1, "Total hits: %d\n", hit);
printf(1, "Total misses: %d\n", miss);
int fifo4[MAX_PAGES+1];
next_to_replace = 0; // FIFO pointer
 153:	31 db                	xor    %ebx,%ebx
printf(1, "FIFO simulation completed.\n");
 155:	e8 e6 04 00 00       	call   640 <printf>
printf(1, "Total hits: %d\n", hit);
 15a:	83 c4 0c             	add    $0xc,%esp
 15d:	ff b5 7c ff ff ff    	push   -0x84(%ebp)
 163:	68 de 09 00 00       	push   $0x9de
 168:	6a 01                	push   $0x1
 16a:	e8 d1 04 00 00       	call   640 <printf>
printf(1, "Total misses: %d\n", miss);
 16f:	83 c4 0c             	add    $0xc,%esp
 172:	ff 75 80             	push   -0x80(%ebp)
 175:	68 ee 09 00 00       	push   $0x9ee
 17a:	6a 01                	push   $0x1
 17c:	e8 bf 04 00 00       	call   640 <printf>
// Initialize page table
for(i = 0; i < MAX_PAGES+1; i++)
fifo4[i] = -1;
hit = 0;
miss = 0;
printf(1, "Starting FIFO page replacement simulation...\n");
 181:	58                   	pop    %eax
 182:	5a                   	pop    %edx
 183:	68 48 09 00 00       	push   $0x948
 188:	6a 01                	push   $0x1
fifo4[i] = -1;
 18a:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%ebp)
 191:	c7 45 a0 ff ff ff ff 	movl   $0xffffffff,-0x60(%ebp)
 198:	c7 45 a4 ff ff ff ff 	movl   $0xffffffff,-0x5c(%ebp)
 19f:	c7 45 a8 ff ff ff ff 	movl   $0xffffffff,-0x58(%ebp)
printf(1, "Starting FIFO page replacement simulation...\n");
 1a6:	e8 95 04 00 00       	call   640 <printf>
 1ab:	83 c4 10             	add    $0x10,%esp
hit = 0;
 1ae:	c7 45 80 00 00 00 00 	movl   $0x0,-0x80(%ebp)
miss = 0;
 1b5:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
 1bc:	00 00 00 
 1bf:	90                   	nop
// Simulated accesses
for(i = 0; i < TOTAL_ACCESSES; i++) {
page = accesses[i];
 1c0:	8b 17                	mov    (%edi),%edx
int found = 0;
// Check if page is already in memory (hit)
for(j = 0; j < MAX_PAGES+1; j++) {
 1c2:	8d 45 9c             	lea    -0x64(%ebp),%eax
if(fifo4[j] == page) {
 1c5:	39 10                	cmp    %edx,(%eax)
 1c7:	0f 84 93 00 00 00    	je     260 <main+0x260>
for(j = 0; j < MAX_PAGES+1; j++) {
 1cd:	83 c0 04             	add    $0x4,%eax
 1d0:	39 c6                	cmp    %eax,%esi
 1d2:	75 f1                	jne    1c5 <main+0x1c5>
if(found) {
hit++;
printf(1, "Access page %d: HIT\n", page);
} else {
miss++;
printf(1, "Access page %d: MISS, replacing page %d\n", page,
 1d4:	ff 74 9d 9c          	push   -0x64(%ebp,%ebx,4)
 1d8:	52                   	push   %edx
 1d9:	68 78 09 00 00       	push   $0x978
 1de:	6a 01                	push   $0x1
 1e0:	89 55 84             	mov    %edx,-0x7c(%ebp)
miss++;
 1e3:	83 85 7c ff ff ff 01 	addl   $0x1,-0x84(%ebp)
printf(1, "Access page %d: MISS, replacing page %d\n", page,
 1ea:	e8 51 04 00 00       	call   640 <printf>
fifo4[next_to_replace]);
fifo4[next_to_replace] = page;
 1ef:	8b 55 84             	mov    -0x7c(%ebp),%edx
next_to_replace = (next_to_replace + 1) % (MAX_PAGES+1);
 1f2:	83 c4 10             	add    $0x10,%esp
fifo4[next_to_replace] = page;
 1f5:	89 54 9d 9c          	mov    %edx,-0x64(%ebp,%ebx,4)
next_to_replace = (next_to_replace + 1) % (MAX_PAGES+1);
 1f9:	83 c3 01             	add    $0x1,%ebx
 1fc:	89 d8                	mov    %ebx,%eax
 1fe:	c1 f8 1f             	sar    $0x1f,%eax
 201:	c1 e8 1e             	shr    $0x1e,%eax
 204:	01 c3                	add    %eax,%ebx
 206:	83 e3 03             	and    $0x3,%ebx
 209:	29 c3                	sub    %eax,%ebx
for(i = 0; i < TOTAL_ACCESSES; i++) {
 20b:	83 c7 04             	add    $0x4,%edi
 20e:	8d 45 e8             	lea    -0x18(%ebp),%eax
 211:	39 c7                	cmp    %eax,%edi
 213:	75 ab                	jne    1c0 <main+0x1c0>
}
}
printf(1,"FOR SIZE 4\n");
 215:	83 ec 08             	sub    $0x8,%esp
 218:	68 00 0a 00 00       	push   $0xa00
 21d:	6a 01                	push   $0x1
 21f:	e8 1c 04 00 00       	call   640 <printf>
printf(1, "FIFO simulation completed.\n");
 224:	58                   	pop    %eax
 225:	5a                   	pop    %edx
 226:	68 c2 09 00 00       	push   $0x9c2
 22b:	6a 01                	push   $0x1
 22d:	e8 0e 04 00 00       	call   640 <printf>
printf(1, "Total hits: %d\n", hit);
 232:	83 c4 0c             	add    $0xc,%esp
 235:	ff 75 80             	push   -0x80(%ebp)
 238:	68 de 09 00 00       	push   $0x9de
 23d:	6a 01                	push   $0x1
 23f:	e8 fc 03 00 00       	call   640 <printf>
printf(1, "Total misses: %d\n", miss);
 244:	83 c4 0c             	add    $0xc,%esp
 247:	ff b5 7c ff ff ff    	push   -0x84(%ebp)
 24d:	68 ee 09 00 00       	push   $0x9ee
 252:	6a 01                	push   $0x1
 254:	e8 e7 03 00 00       	call   640 <printf>

exit();
 259:	e8 85 02 00 00       	call   4e3 <exit>
 25e:	66 90                	xchg   %ax,%ax
printf(1, "Access page %d: HIT\n", page);
 260:	83 ec 04             	sub    $0x4,%esp
hit++;
 263:	83 45 80 01          	addl   $0x1,-0x80(%ebp)
printf(1, "Access page %d: HIT\n", page);
 267:	52                   	push   %edx
 268:	68 a1 09 00 00       	push   $0x9a1
 26d:	6a 01                	push   $0x1
 26f:	e8 cc 03 00 00       	call   640 <printf>
 274:	83 c4 10             	add    $0x10,%esp
 277:	eb 92                	jmp    20b <main+0x20b>
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
printf(1, "Access page %d: HIT\n", page);
 280:	83 ec 04             	sub    $0x4,%esp
hit++;
 283:	83 85 7c ff ff ff 01 	addl   $0x1,-0x84(%ebp)
printf(1, "Access page %d: HIT\n", page);
 28a:	51                   	push   %ecx
 28b:	68 a1 09 00 00       	push   $0x9a1
 290:	6a 01                	push   $0x1
 292:	e8 a9 03 00 00       	call   640 <printf>
 297:	83 c4 10             	add    $0x10,%esp
 29a:	e9 8c fe ff ff       	jmp    12b <main+0x12b>
 29f:	90                   	nop

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a1:	31 c0                	xor    %eax,%eax
{
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	53                   	push   %ebx
 2a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2b7:	83 c0 01             	add    $0x1,%eax
 2ba:	84 d2                	test   %dl,%dl
 2bc:	75 f2                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c1:	89 c8                	mov    %ecx,%eax
 2c3:	c9                   	leave
 2c4:	c3                   	ret
 2c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2cc:	00 
 2cd:	8d 76 00             	lea    0x0(%esi),%esi

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2da:	0f b6 02             	movzbl (%edx),%eax
 2dd:	84 c0                	test   %al,%al
 2df:	75 17                	jne    2f8 <strcmp+0x28>
 2e1:	eb 3a                	jmp    31d <strcmp+0x4d>
 2e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2ec:	83 c2 01             	add    $0x1,%edx
 2ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2f2:	84 c0                	test   %al,%al
 2f4:	74 1a                	je     310 <strcmp+0x40>
 2f6:	89 d9                	mov    %ebx,%ecx
 2f8:	0f b6 19             	movzbl (%ecx),%ebx
 2fb:	38 c3                	cmp    %al,%bl
 2fd:	74 e9                	je     2e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2ff:	29 d8                	sub    %ebx,%eax
}
 301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 304:	c9                   	leave
 305:	c3                   	ret
 306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 30d:	00 
 30e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 310:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 314:	31 c0                	xor    %eax,%eax
 316:	29 d8                	sub    %ebx,%eax
}
 318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 31b:	c9                   	leave
 31c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 31d:	0f b6 19             	movzbl (%ecx),%ebx
 320:	31 c0                	xor    %eax,%eax
 322:	eb db                	jmp    2ff <strcmp+0x2f>
 324:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32b:	00 
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000330 <strlen>:

uint
strlen(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 336:	80 3a 00             	cmpb   $0x0,(%edx)
 339:	74 15                	je     350 <strlen+0x20>
 33b:	31 c0                	xor    %eax,%eax
 33d:	8d 76 00             	lea    0x0(%esi),%esi
 340:	83 c0 01             	add    $0x1,%eax
 343:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 347:	89 c1                	mov    %eax,%ecx
 349:	75 f5                	jne    340 <strlen+0x10>
    ;
  return n;
}
 34b:	89 c8                	mov    %ecx,%eax
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret
 34f:	90                   	nop
  for(n = 0; s[n]; n++)
 350:	31 c9                	xor    %ecx,%ecx
}
 352:	5d                   	pop    %ebp
 353:	89 c8                	mov    %ecx,%eax
 355:	c3                   	ret
 356:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35d:	00 
 35e:	66 90                	xchg   %ax,%ax

00000360 <memset>:

void*
memset(void *dst, int c, uint n)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 367:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 d7                	mov    %edx,%edi
 36f:	fc                   	cld
 370:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 372:	8b 7d fc             	mov    -0x4(%ebp),%edi
 375:	89 d0                	mov    %edx,%eax
 377:	c9                   	leave
 378:	c3                   	ret
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <strchr>:

char*
strchr(const char *s, char c)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 38a:	0f b6 10             	movzbl (%eax),%edx
 38d:	84 d2                	test   %dl,%dl
 38f:	75 12                	jne    3a3 <strchr+0x23>
 391:	eb 1d                	jmp    3b0 <strchr+0x30>
 393:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 398:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 39c:	83 c0 01             	add    $0x1,%eax
 39f:	84 d2                	test   %dl,%dl
 3a1:	74 0d                	je     3b0 <strchr+0x30>
    if(*s == c)
 3a3:	38 d1                	cmp    %dl,%cl
 3a5:	75 f1                	jne    398 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3b0:	31 c0                	xor    %eax,%eax
}
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret
 3b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3bb:	00 
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <gets>:

char*
gets(char *buf, int max)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 3c5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 3c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 3c9:	31 db                	xor    %ebx,%ebx
{
 3cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3ce:	eb 27                	jmp    3f7 <gets+0x37>
    cc = read(0, &c, 1);
 3d0:	83 ec 04             	sub    $0x4,%esp
 3d3:	6a 01                	push   $0x1
 3d5:	56                   	push   %esi
 3d6:	6a 00                	push   $0x0
 3d8:	e8 1e 01 00 00       	call   4fb <read>
    if(cc < 1)
 3dd:	83 c4 10             	add    $0x10,%esp
 3e0:	85 c0                	test   %eax,%eax
 3e2:	7e 1d                	jle    401 <gets+0x41>
      break;
    buf[i++] = c;
 3e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e8:	8b 55 08             	mov    0x8(%ebp),%edx
 3eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3ef:	3c 0a                	cmp    $0xa,%al
 3f1:	74 10                	je     403 <gets+0x43>
 3f3:	3c 0d                	cmp    $0xd,%al
 3f5:	74 0c                	je     403 <gets+0x43>
  for(i=0; i+1 < max; ){
 3f7:	89 df                	mov    %ebx,%edi
 3f9:	83 c3 01             	add    $0x1,%ebx
 3fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ff:	7c cf                	jl     3d0 <gets+0x10>
 401:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 40a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40d:	5b                   	pop    %ebx
 40e:	5e                   	pop    %esi
 40f:	5f                   	pop    %edi
 410:	5d                   	pop    %ebp
 411:	c3                   	ret
 412:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 419:	00 
 41a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000420 <stat>:

int
stat(const char *n, struct stat *st)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 425:	83 ec 08             	sub    $0x8,%esp
 428:	6a 00                	push   $0x0
 42a:	ff 75 08             	push   0x8(%ebp)
 42d:	e8 f1 00 00 00       	call   523 <open>
  if(fd < 0)
 432:	83 c4 10             	add    $0x10,%esp
 435:	85 c0                	test   %eax,%eax
 437:	78 27                	js     460 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	ff 75 0c             	push   0xc(%ebp)
 43f:	89 c3                	mov    %eax,%ebx
 441:	50                   	push   %eax
 442:	e8 f4 00 00 00       	call   53b <fstat>
  close(fd);
 447:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 44a:	89 c6                	mov    %eax,%esi
  close(fd);
 44c:	e8 ba 00 00 00       	call   50b <close>
  return r;
 451:	83 c4 10             	add    $0x10,%esp
}
 454:	8d 65 f8             	lea    -0x8(%ebp),%esp
 457:	89 f0                	mov    %esi,%eax
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret
 45d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 460:	be ff ff ff ff       	mov    $0xffffffff,%esi
 465:	eb ed                	jmp    454 <stat+0x34>
 467:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 46e:	00 
 46f:	90                   	nop

00000470 <atoi>:

int
atoi(const char *s)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 477:	0f be 02             	movsbl (%edx),%eax
 47a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 47d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 480:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 485:	77 1e                	ja     4a5 <atoi+0x35>
 487:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48e:	00 
 48f:	90                   	nop
    n = n*10 + *s++ - '0';
 490:	83 c2 01             	add    $0x1,%edx
 493:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 496:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 49a:	0f be 02             	movsbl (%edx),%eax
 49d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4a0:	80 fb 09             	cmp    $0x9,%bl
 4a3:	76 eb                	jbe    490 <atoi+0x20>
  return n;
}
 4a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a8:	89 c8                	mov    %ecx,%eax
 4aa:	c9                   	leave
 4ab:	c3                   	ret
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	8b 45 10             	mov    0x10(%ebp),%eax
 4b7:	8b 55 08             	mov    0x8(%ebp),%edx
 4ba:	56                   	push   %esi
 4bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4be:	85 c0                	test   %eax,%eax
 4c0:	7e 13                	jle    4d5 <memmove+0x25>
 4c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4c4:	89 d7                	mov    %edx,%edi
 4c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4cd:	00 
 4ce:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4d1:	39 f8                	cmp    %edi,%eax
 4d3:	75 fb                	jne    4d0 <memmove+0x20>
  return vdst;
}
 4d5:	5e                   	pop    %esi
 4d6:	89 d0                	mov    %edx,%eax
 4d8:	5f                   	pop    %edi
 4d9:	5d                   	pop    %ebp
 4da:	c3                   	ret

000004db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4db:	b8 01 00 00 00       	mov    $0x1,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <exit>:
SYSCALL(exit)
 4e3:	b8 02 00 00 00       	mov    $0x2,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <wait>:
SYSCALL(wait)
 4eb:	b8 03 00 00 00       	mov    $0x3,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <pipe>:
SYSCALL(pipe)
 4f3:	b8 04 00 00 00       	mov    $0x4,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <read>:
SYSCALL(read)
 4fb:	b8 05 00 00 00       	mov    $0x5,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <write>:
SYSCALL(write)
 503:	b8 10 00 00 00       	mov    $0x10,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <close>:
SYSCALL(close)
 50b:	b8 15 00 00 00       	mov    $0x15,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <kill>:
SYSCALL(kill)
 513:	b8 06 00 00 00       	mov    $0x6,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <exec>:
SYSCALL(exec)
 51b:	b8 07 00 00 00       	mov    $0x7,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <open>:
SYSCALL(open)
 523:	b8 0f 00 00 00       	mov    $0xf,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <mknod>:
SYSCALL(mknod)
 52b:	b8 11 00 00 00       	mov    $0x11,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <unlink>:
SYSCALL(unlink)
 533:	b8 12 00 00 00       	mov    $0x12,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <fstat>:
SYSCALL(fstat)
 53b:	b8 08 00 00 00       	mov    $0x8,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <link>:
SYSCALL(link)
 543:	b8 13 00 00 00       	mov    $0x13,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <mkdir>:
SYSCALL(mkdir)
 54b:	b8 14 00 00 00       	mov    $0x14,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <chdir>:
SYSCALL(chdir)
 553:	b8 09 00 00 00       	mov    $0x9,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <dup>:
SYSCALL(dup)
 55b:	b8 0a 00 00 00       	mov    $0xa,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <getpid>:
SYSCALL(getpid)
 563:	b8 0b 00 00 00       	mov    $0xb,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <sbrk>:
SYSCALL(sbrk)
 56b:	b8 0c 00 00 00       	mov    $0xc,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <sleep>:
SYSCALL(sleep)
 573:	b8 0d 00 00 00       	mov    $0xd,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <uptime>:
SYSCALL(uptime)
 57b:	b8 0e 00 00 00       	mov    $0xe,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <getyear>:
SYSCALL(getyear)
 583:	b8 16 00 00 00       	mov    $0x16,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <strrev>:
SYSCALL(strrev)
 58b:	b8 17 00 00 00       	mov    $0x17,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret
 593:	66 90                	xchg   %ax,%ax
 595:	66 90                	xchg   %ax,%ax
 597:	66 90                	xchg   %ax,%ax
 599:	66 90                	xchg   %ax,%ax
 59b:	66 90                	xchg   %ax,%ax
 59d:	66 90                	xchg   %ax,%ax
 59f:	90                   	nop

000005a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5a8:	89 d1                	mov    %edx,%ecx
{
 5aa:	83 ec 3c             	sub    $0x3c,%esp
 5ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5b0:	85 d2                	test   %edx,%edx
 5b2:	0f 89 80 00 00 00    	jns    638 <printint+0x98>
 5b8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5bc:	74 7a                	je     638 <printint+0x98>
    x = -xx;
 5be:	f7 d9                	neg    %ecx
    neg = 1;
 5c0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5c8:	31 f6                	xor    %esi,%esi
 5ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5d0:	89 c8                	mov    %ecx,%eax
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	89 f7                	mov    %esi,%edi
 5d6:	f7 f3                	div    %ebx
 5d8:	8d 76 01             	lea    0x1(%esi),%esi
 5db:	0f b6 92 6c 0a 00 00 	movzbl 0xa6c(%edx),%edx
 5e2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5e6:	89 ca                	mov    %ecx,%edx
 5e8:	89 c1                	mov    %eax,%ecx
 5ea:	39 da                	cmp    %ebx,%edx
 5ec:	73 e2                	jae    5d0 <printint+0x30>
  if(neg)
 5ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5f1:	85 c0                	test   %eax,%eax
 5f3:	74 07                	je     5fc <printint+0x5c>
    buf[i++] = '-';
 5f5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 5fa:	89 f7                	mov    %esi,%edi
 5fc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 5ff:	8b 75 c0             	mov    -0x40(%ebp),%esi
 602:	01 df                	add    %ebx,%edi
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 608:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 60b:	83 ec 04             	sub    $0x4,%esp
 60e:	88 45 d7             	mov    %al,-0x29(%ebp)
 611:	8d 45 d7             	lea    -0x29(%ebp),%eax
 614:	6a 01                	push   $0x1
 616:	50                   	push   %eax
 617:	56                   	push   %esi
 618:	e8 e6 fe ff ff       	call   503 <write>
  while(--i >= 0)
 61d:	89 f8                	mov    %edi,%eax
 61f:	83 c4 10             	add    $0x10,%esp
 622:	83 ef 01             	sub    $0x1,%edi
 625:	39 c3                	cmp    %eax,%ebx
 627:	75 df                	jne    608 <printint+0x68>
}
 629:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62c:	5b                   	pop    %ebx
 62d:	5e                   	pop    %esi
 62e:	5f                   	pop    %edi
 62f:	5d                   	pop    %ebp
 630:	c3                   	ret
 631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 638:	31 c0                	xor    %eax,%eax
 63a:	eb 89                	jmp    5c5 <printint+0x25>
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000640 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 649:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 64c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 64f:	0f b6 1e             	movzbl (%esi),%ebx
 652:	83 c6 01             	add    $0x1,%esi
 655:	84 db                	test   %bl,%bl
 657:	74 67                	je     6c0 <printf+0x80>
 659:	8d 4d 10             	lea    0x10(%ebp),%ecx
 65c:	31 d2                	xor    %edx,%edx
 65e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 661:	eb 34                	jmp    697 <printf+0x57>
 663:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 668:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 66b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 670:	83 f8 25             	cmp    $0x25,%eax
 673:	74 18                	je     68d <printf+0x4d>
  write(fd, &c, 1);
 675:	83 ec 04             	sub    $0x4,%esp
 678:	8d 45 e7             	lea    -0x19(%ebp),%eax
 67b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 67e:	6a 01                	push   $0x1
 680:	50                   	push   %eax
 681:	57                   	push   %edi
 682:	e8 7c fe ff ff       	call   503 <write>
 687:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 68a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 68d:	0f b6 1e             	movzbl (%esi),%ebx
 690:	83 c6 01             	add    $0x1,%esi
 693:	84 db                	test   %bl,%bl
 695:	74 29                	je     6c0 <printf+0x80>
    c = fmt[i] & 0xff;
 697:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 69a:	85 d2                	test   %edx,%edx
 69c:	74 ca                	je     668 <printf+0x28>
      }
    } else if(state == '%'){
 69e:	83 fa 25             	cmp    $0x25,%edx
 6a1:	75 ea                	jne    68d <printf+0x4d>
      if(c == 'd'){
 6a3:	83 f8 25             	cmp    $0x25,%eax
 6a6:	0f 84 04 01 00 00    	je     7b0 <printf+0x170>
 6ac:	83 e8 63             	sub    $0x63,%eax
 6af:	83 f8 15             	cmp    $0x15,%eax
 6b2:	77 1c                	ja     6d0 <printf+0x90>
 6b4:	ff 24 85 14 0a 00 00 	jmp    *0xa14(,%eax,4)
 6bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c3:	5b                   	pop    %ebx
 6c4:	5e                   	pop    %esi
 6c5:	5f                   	pop    %edi
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret
 6c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6cf:	00 
  write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6d6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6da:	6a 01                	push   $0x1
 6dc:	52                   	push   %edx
 6dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6e0:	57                   	push   %edi
 6e1:	e8 1d fe ff ff       	call   503 <write>
 6e6:	83 c4 0c             	add    $0xc,%esp
 6e9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6ec:	6a 01                	push   $0x1
 6ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6f1:	52                   	push   %edx
 6f2:	57                   	push   %edi
 6f3:	e8 0b fe ff ff       	call   503 <write>
        putc(fd, c);
 6f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fb:	31 d2                	xor    %edx,%edx
 6fd:	eb 8e                	jmp    68d <printf+0x4d>
 6ff:	90                   	nop
        printint(fd, *ap, 16, 0);
 700:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 703:	83 ec 0c             	sub    $0xc,%esp
 706:	b9 10 00 00 00       	mov    $0x10,%ecx
 70b:	8b 13                	mov    (%ebx),%edx
 70d:	6a 00                	push   $0x0
 70f:	89 f8                	mov    %edi,%eax
        ap++;
 711:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 714:	e8 87 fe ff ff       	call   5a0 <printint>
        ap++;
 719:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 71c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71f:	31 d2                	xor    %edx,%edx
 721:	e9 67 ff ff ff       	jmp    68d <printf+0x4d>
        s = (char*)*ap;
 726:	8b 45 d0             	mov    -0x30(%ebp),%eax
 729:	8b 18                	mov    (%eax),%ebx
        ap++;
 72b:	83 c0 04             	add    $0x4,%eax
 72e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 731:	85 db                	test   %ebx,%ebx
 733:	0f 84 87 00 00 00    	je     7c0 <printf+0x180>
        while(*s != 0){
 739:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 73c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 73e:	84 c0                	test   %al,%al
 740:	0f 84 47 ff ff ff    	je     68d <printf+0x4d>
 746:	8d 55 e7             	lea    -0x19(%ebp),%edx
 749:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 74c:	89 de                	mov    %ebx,%esi
 74e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 756:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 759:	6a 01                	push   $0x1
 75b:	53                   	push   %ebx
 75c:	57                   	push   %edi
 75d:	e8 a1 fd ff ff       	call   503 <write>
        while(*s != 0){
 762:	0f b6 06             	movzbl (%esi),%eax
 765:	83 c4 10             	add    $0x10,%esp
 768:	84 c0                	test   %al,%al
 76a:	75 e4                	jne    750 <printf+0x110>
      state = 0;
 76c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 76f:	31 d2                	xor    %edx,%edx
 771:	e9 17 ff ff ff       	jmp    68d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 776:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 779:	83 ec 0c             	sub    $0xc,%esp
 77c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 781:	8b 13                	mov    (%ebx),%edx
 783:	6a 01                	push   $0x1
 785:	eb 88                	jmp    70f <printf+0xcf>
        putc(fd, *ap);
 787:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 78a:	83 ec 04             	sub    $0x4,%esp
 78d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 790:	8b 03                	mov    (%ebx),%eax
        ap++;
 792:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 795:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 798:	6a 01                	push   $0x1
 79a:	52                   	push   %edx
 79b:	57                   	push   %edi
 79c:	e8 62 fd ff ff       	call   503 <write>
        ap++;
 7a1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7a4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7a7:	31 d2                	xor    %edx,%edx
 7a9:	e9 df fe ff ff       	jmp    68d <printf+0x4d>
 7ae:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
 7b3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7b9:	6a 01                	push   $0x1
 7bb:	e9 31 ff ff ff       	jmp    6f1 <printf+0xb1>
 7c0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7c5:	bb 0c 0a 00 00       	mov    $0xa0c,%ebx
 7ca:	e9 77 ff ff ff       	jmp    746 <printf+0x106>
 7cf:	90                   	nop

000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	a1 18 0d 00 00       	mov    0xd18,%eax
{
 7d6:	89 e5                	mov    %esp,%ebp
 7d8:	57                   	push   %edi
 7d9:	56                   	push   %esi
 7da:	53                   	push   %ebx
 7db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	39 c8                	cmp    %ecx,%eax
 7ec:	73 32                	jae    820 <free+0x50>
 7ee:	39 d1                	cmp    %edx,%ecx
 7f0:	72 04                	jb     7f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	39 d0                	cmp    %edx,%eax
 7f4:	72 32                	jb     828 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7fc:	39 fa                	cmp    %edi,%edx
 7fe:	74 30                	je     830 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 803:	8b 50 04             	mov    0x4(%eax),%edx
 806:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 809:	39 f1                	cmp    %esi,%ecx
 80b:	74 3a                	je     847 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 80d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 80f:	5b                   	pop    %ebx
  freep = p;
 810:	a3 18 0d 00 00       	mov    %eax,0xd18
}
 815:	5e                   	pop    %esi
 816:	5f                   	pop    %edi
 817:	5d                   	pop    %ebp
 818:	c3                   	ret
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	39 d0                	cmp    %edx,%eax
 822:	72 04                	jb     828 <free+0x58>
 824:	39 d1                	cmp    %edx,%ecx
 826:	72 ce                	jb     7f6 <free+0x26>
{
 828:	89 d0                	mov    %edx,%eax
 82a:	eb bc                	jmp    7e8 <free+0x18>
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 830:	03 72 04             	add    0x4(%edx),%esi
 833:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	8b 10                	mov    (%eax),%edx
 838:	8b 12                	mov    (%edx),%edx
 83a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 83d:	8b 50 04             	mov    0x4(%eax),%edx
 840:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 843:	39 f1                	cmp    %esi,%ecx
 845:	75 c6                	jne    80d <free+0x3d>
    p->s.size += bp->s.size;
 847:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 84a:	a3 18 0d 00 00       	mov    %eax,0xd18
    p->s.size += bp->s.size;
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 852:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 855:	89 08                	mov    %ecx,(%eax)
}
 857:	5b                   	pop    %ebx
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	57                   	push   %edi
 864:	56                   	push   %esi
 865:	53                   	push   %ebx
 866:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 869:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 86c:	8b 15 18 0d 00 00    	mov    0xd18,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	8d 78 07             	lea    0x7(%eax),%edi
 875:	c1 ef 03             	shr    $0x3,%edi
 878:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 87b:	85 d2                	test   %edx,%edx
 87d:	0f 84 8d 00 00 00    	je     910 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 883:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 885:	8b 48 04             	mov    0x4(%eax),%ecx
 888:	39 f9                	cmp    %edi,%ecx
 88a:	73 64                	jae    8f0 <malloc+0x90>
  if(nu < 4096)
 88c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 891:	39 df                	cmp    %ebx,%edi
 893:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 896:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 89d:	eb 0a                	jmp    8a9 <malloc+0x49>
 89f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8a2:	8b 48 04             	mov    0x4(%eax),%ecx
 8a5:	39 f9                	cmp    %edi,%ecx
 8a7:	73 47                	jae    8f0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a9:	89 c2                	mov    %eax,%edx
 8ab:	3b 05 18 0d 00 00    	cmp    0xd18,%eax
 8b1:	75 ed                	jne    8a0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8b3:	83 ec 0c             	sub    $0xc,%esp
 8b6:	56                   	push   %esi
 8b7:	e8 af fc ff ff       	call   56b <sbrk>
  if(p == (char*)-1)
 8bc:	83 c4 10             	add    $0x10,%esp
 8bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 8c2:	74 1c                	je     8e0 <malloc+0x80>
  hp->s.size = nu;
 8c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8c7:	83 ec 0c             	sub    $0xc,%esp
 8ca:	83 c0 08             	add    $0x8,%eax
 8cd:	50                   	push   %eax
 8ce:	e8 fd fe ff ff       	call   7d0 <free>
  return freep;
 8d3:	8b 15 18 0d 00 00    	mov    0xd18,%edx
      if((p = morecore(nunits)) == 0)
 8d9:	83 c4 10             	add    $0x10,%esp
 8dc:	85 d2                	test   %edx,%edx
 8de:	75 c0                	jne    8a0 <malloc+0x40>
        return 0;
  }
}
 8e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8e3:	31 c0                	xor    %eax,%eax
}
 8e5:	5b                   	pop    %ebx
 8e6:	5e                   	pop    %esi
 8e7:	5f                   	pop    %edi
 8e8:	5d                   	pop    %ebp
 8e9:	c3                   	ret
 8ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8f0:	39 cf                	cmp    %ecx,%edi
 8f2:	74 4c                	je     940 <malloc+0xe0>
        p->s.size -= nunits;
 8f4:	29 f9                	sub    %edi,%ecx
 8f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8fc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8ff:	89 15 18 0d 00 00    	mov    %edx,0xd18
}
 905:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 908:	83 c0 08             	add    $0x8,%eax
}
 90b:	5b                   	pop    %ebx
 90c:	5e                   	pop    %esi
 90d:	5f                   	pop    %edi
 90e:	5d                   	pop    %ebp
 90f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 18 0d 00 00 1c 	movl   $0xd1c,0xd18
 917:	0d 00 00 
    base.s.size = 0;
 91a:	b8 1c 0d 00 00       	mov    $0xd1c,%eax
    base.s.ptr = freep = prevp = &base;
 91f:	c7 05 1c 0d 00 00 1c 	movl   $0xd1c,0xd1c
 926:	0d 00 00 
    base.s.size = 0;
 929:	c7 05 20 0d 00 00 00 	movl   $0x0,0xd20
 930:	00 00 00 
    if(p->s.size >= nunits){
 933:	e9 54 ff ff ff       	jmp    88c <malloc+0x2c>
 938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 93f:	00 
        prevp->s.ptr = p->s.ptr;
 940:	8b 08                	mov    (%eax),%ecx
 942:	89 0a                	mov    %ecx,(%edx)
 944:	eb b9                	jmp    8ff <malloc+0x9f>
