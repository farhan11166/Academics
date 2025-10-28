
_testtoupper:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
 char stringArray[32]="Write Your FUll Name Here";
 printf(1,"Before: %s\n",stringArray);
   f:	8d 75 c8             	lea    -0x38(%ebp),%esi
 toupper(stringArray,strlen(stringArray));
 //printf(1,"After: %s\n ",stringArray);
 for(int i=0;i<strlen(stringArray);i++){
  12:	31 db                	xor    %ebx,%ebx
int main(void){
  14:	51                   	push   %ecx
  15:	83 ec 30             	sub    $0x30,%esp
 char stringArray[32]="Write Your FUll Name Here";
  18:	c7 45 c8 57 72 69 74 	movl   $0x74697257,-0x38(%ebp)
 printf(1,"Before: %s\n",stringArray);
  1f:	56                   	push   %esi
  20:	68 48 07 00 00       	push   $0x748
  25:	6a 01                	push   $0x1
 char stringArray[32]="Write Your FUll Name Here";
  27:	c7 45 cc 65 20 59 6f 	movl   $0x6f592065,-0x34(%ebp)
  2e:	c7 45 d0 75 72 20 46 	movl   $0x46207275,-0x30(%ebp)
  35:	c7 45 d4 55 6c 6c 20 	movl   $0x206c6c55,-0x2c(%ebp)
  3c:	c7 45 d8 4e 61 6d 65 	movl   $0x656d614e,-0x28(%ebp)
  43:	c7 45 dc 20 48 65 72 	movl   $0x72654820,-0x24(%ebp)
  4a:	c7 45 e0 65 00 00 00 	movl   $0x65,-0x20(%ebp)
  51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 printf(1,"Before: %s\n",stringArray);
  58:	e8 e3 03 00 00       	call   440 <printf>
 toupper(stringArray,strlen(stringArray));
  5d:	89 34 24             	mov    %esi,(%esp)
  60:	e8 db 00 00 00       	call   140 <strlen>
  65:	5a                   	pop    %edx
  66:	59                   	pop    %ecx
  67:	50                   	push   %eax
  68:	56                   	push   %esi
  69:	e8 25 03 00 00       	call   393 <toupper>
 for(int i=0;i<strlen(stringArray);i++){
  6e:	83 c4 10             	add    $0x10,%esp
  71:	eb 1f                	jmp    92 <main+0x92>
  73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    printf(1,"%s",stringArray[i]);
  78:	0f be 04 1e          	movsbl (%esi,%ebx,1),%eax
  7c:	83 ec 04             	sub    $0x4,%esp
 for(int i=0;i<strlen(stringArray);i++){
  7f:	83 c3 01             	add    $0x1,%ebx
    printf(1,"%s",stringArray[i]);
  82:	50                   	push   %eax
  83:	68 54 07 00 00       	push   $0x754
  88:	6a 01                	push   $0x1
  8a:	e8 b1 03 00 00       	call   440 <printf>
 for(int i=0;i<strlen(stringArray);i++){
  8f:	83 c4 10             	add    $0x10,%esp
  92:	83 ec 0c             	sub    $0xc,%esp
  95:	56                   	push   %esi
  96:	e8 a5 00 00 00       	call   140 <strlen>
  9b:	83 c4 10             	add    $0x10,%esp
  9e:	39 c3                	cmp    %eax,%ebx
  a0:	72 d6                	jb     78 <main+0x78>
 }
 exit();
  a2:	e8 4c 02 00 00       	call   2f3 <exit>
  a7:	66 90                	xchg   %ax,%ax
  a9:	66 90                	xchg   %ax,%ax
  ab:	66 90                	xchg   %ax,%ax
  ad:	66 90                	xchg   %ax,%ax
  af:	90                   	nop

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b1:	31 c0                	xor    %eax,%eax
{
  b3:	89 e5                	mov    %esp,%ebp
  b5:	53                   	push   %ebx
  b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  c7:	83 c0 01             	add    $0x1,%eax
  ca:	84 d2                	test   %dl,%dl
  cc:	75 f2                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d1:	89 c8                	mov    %ecx,%eax
  d3:	c9                   	leave
  d4:	c3                   	ret
  d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  dc:	00 
  dd:	8d 76 00             	lea    0x0(%esi),%esi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 55 08             	mov    0x8(%ebp),%edx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	84 c0                	test   %al,%al
  ef:	75 17                	jne    108 <strcmp+0x28>
  f1:	eb 3a                	jmp    12d <strcmp+0x4d>
  f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  fc:	83 c2 01             	add    $0x1,%edx
  ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 102:	84 c0                	test   %al,%al
 104:	74 1a                	je     120 <strcmp+0x40>
 106:	89 d9                	mov    %ebx,%ecx
 108:	0f b6 19             	movzbl (%ecx),%ebx
 10b:	38 c3                	cmp    %al,%bl
 10d:	74 e9                	je     f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 10f:	29 d8                	sub    %ebx,%eax
}
 111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 114:	c9                   	leave
 115:	c3                   	ret
 116:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 11d:	00 
 11e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 120:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 124:	31 c0                	xor    %eax,%eax
 126:	29 d8                	sub    %ebx,%eax
}
 128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 12b:	c9                   	leave
 12c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 12d:	0f b6 19             	movzbl (%ecx),%ebx
 130:	31 c0                	xor    %eax,%eax
 132:	eb db                	jmp    10f <strcmp+0x2f>
 134:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 13b:	00 
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000140 <strlen>:

uint
strlen(const char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 3a 00             	cmpb   $0x0,(%edx)
 149:	74 15                	je     160 <strlen+0x20>
 14b:	31 c0                	xor    %eax,%eax
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c0 01             	add    $0x1,%eax
 153:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 157:	89 c1                	mov    %eax,%ecx
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	89 c8                	mov    %ecx,%eax
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret
 15f:	90                   	nop
  for(n = 0; s[n]; n++)
 160:	31 c9                	xor    %ecx,%ecx
}
 162:	5d                   	pop    %ebp
 163:	89 c8                	mov    %ecx,%eax
 165:	c3                   	ret
 166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 16d:	00 
 16e:	66 90                	xchg   %ax,%ax

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	8b 7d fc             	mov    -0x4(%ebp),%edi
 185:	89 d0                	mov    %edx,%eax
 187:	c9                   	leave
 188:	c3                   	ret
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 19a:	0f b6 10             	movzbl (%eax),%edx
 19d:	84 d2                	test   %dl,%dl
 19f:	75 12                	jne    1b3 <strchr+0x23>
 1a1:	eb 1d                	jmp    1c0 <strchr+0x30>
 1a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1ac:	83 c0 01             	add    $0x1,%eax
 1af:	84 d2                	test   %dl,%dl
 1b1:	74 0d                	je     1c0 <strchr+0x30>
    if(*s == c)
 1b3:	38 d1                	cmp    %dl,%cl
 1b5:	75 f1                	jne    1a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1c0:	31 c0                	xor    %eax,%eax
}
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret
 1c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1cb:	00 
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1d5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 1d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1d9:	31 db                	xor    %ebx,%ebx
{
 1db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1de:	eb 27                	jmp    207 <gets+0x37>
    cc = read(0, &c, 1);
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	6a 01                	push   $0x1
 1e5:	56                   	push   %esi
 1e6:	6a 00                	push   $0x0
 1e8:	e8 1e 01 00 00       	call   30b <read>
    if(cc < 1)
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	85 c0                	test   %eax,%eax
 1f2:	7e 1d                	jle    211 <gets+0x41>
      break;
    buf[i++] = c;
 1f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
 1fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ff:	3c 0a                	cmp    $0xa,%al
 201:	74 10                	je     213 <gets+0x43>
 203:	3c 0d                	cmp    $0xd,%al
 205:	74 0c                	je     213 <gets+0x43>
  for(i=0; i+1 < max; ){
 207:	89 df                	mov    %ebx,%edi
 209:	83 c3 01             	add    $0x1,%ebx
 20c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 20f:	7c cf                	jl     1e0 <gets+0x10>
 211:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 21a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21d:	5b                   	pop    %ebx
 21e:	5e                   	pop    %esi
 21f:	5f                   	pop    %edi
 220:	5d                   	pop    %ebp
 221:	c3                   	ret
 222:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 229:	00 
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	push   0x8(%ebp)
 23d:	e8 f1 00 00 00       	call   333 <open>
  if(fd < 0)
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 27                	js     270 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	ff 75 0c             	push   0xc(%ebp)
 24f:	89 c3                	mov    %eax,%ebx
 251:	50                   	push   %eax
 252:	e8 f4 00 00 00       	call   34b <fstat>
  close(fd);
 257:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 25a:	89 c6                	mov    %eax,%esi
  close(fd);
 25c:	e8 ba 00 00 00       	call   31b <close>
  return r;
 261:	83 c4 10             	add    $0x10,%esp
}
 264:	8d 65 f8             	lea    -0x8(%ebp),%esp
 267:	89 f0                	mov    %esi,%eax
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb ed                	jmp    264 <stat+0x34>
 277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27e:	00 
 27f:	90                   	nop

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 02             	movsbl (%edx),%eax
 28a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 28d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 290:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 295:	77 1e                	ja     2b5 <atoi+0x35>
 297:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 29e:	00 
 29f:	90                   	nop
    n = n*10 + *s++ - '0';
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2aa:	0f be 02             	movsbl (%edx),%eax
 2ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b8:	89 c8                	mov    %ecx,%eax
 2ba:	c9                   	leave
 2bb:	c3                   	ret
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 45 10             	mov    0x10(%ebp),%eax
 2c7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ca:	56                   	push   %esi
 2cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	85 c0                	test   %eax,%eax
 2d0:	7e 13                	jle    2e5 <memmove+0x25>
 2d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2d4:	89 d7                	mov    %edx,%edi
 2d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2dd:	00 
 2de:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e1:	39 f8                	cmp    %edi,%eax
 2e3:	75 fb                	jne    2e0 <memmove+0x20>
  return vdst;
}
 2e5:	5e                   	pop    %esi
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <sbrk>:
SYSCALL(sbrk)
 37b:	b8 0c 00 00 00       	mov    $0xc,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <sleep>:
SYSCALL(sleep)
 383:	b8 0d 00 00 00       	mov    $0xd,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <uptime>:
SYSCALL(uptime)
 38b:	b8 0e 00 00 00       	mov    $0xe,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <toupper>:
SYSCALL(toupper)
 393:	b8 16 00 00 00       	mov    $0x16,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3a8:	89 d1                	mov    %edx,%ecx
{
 3aa:	83 ec 3c             	sub    $0x3c,%esp
 3ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3b0:	85 d2                	test   %edx,%edx
 3b2:	0f 89 80 00 00 00    	jns    438 <printint+0x98>
 3b8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3bc:	74 7a                	je     438 <printint+0x98>
    x = -xx;
 3be:	f7 d9                	neg    %ecx
    neg = 1;
 3c0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3c8:	31 f6                	xor    %esi,%esi
 3ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3d0:	89 c8                	mov    %ecx,%eax
 3d2:	31 d2                	xor    %edx,%edx
 3d4:	89 f7                	mov    %esi,%edi
 3d6:	f7 f3                	div    %ebx
 3d8:	8d 76 01             	lea    0x1(%esi),%esi
 3db:	0f b6 92 b8 07 00 00 	movzbl 0x7b8(%edx),%edx
 3e2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3e6:	89 ca                	mov    %ecx,%edx
 3e8:	89 c1                	mov    %eax,%ecx
 3ea:	39 da                	cmp    %ebx,%edx
 3ec:	73 e2                	jae    3d0 <printint+0x30>
  if(neg)
 3ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3f1:	85 c0                	test   %eax,%eax
 3f3:	74 07                	je     3fc <printint+0x5c>
    buf[i++] = '-';
 3f5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 3fa:	89 f7                	mov    %esi,%edi
 3fc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3ff:	8b 75 c0             	mov    -0x40(%ebp),%esi
 402:	01 df                	add    %ebx,%edi
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 408:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 40b:	83 ec 04             	sub    $0x4,%esp
 40e:	88 45 d7             	mov    %al,-0x29(%ebp)
 411:	8d 45 d7             	lea    -0x29(%ebp),%eax
 414:	6a 01                	push   $0x1
 416:	50                   	push   %eax
 417:	56                   	push   %esi
 418:	e8 f6 fe ff ff       	call   313 <write>
  while(--i >= 0)
 41d:	89 f8                	mov    %edi,%eax
 41f:	83 c4 10             	add    $0x10,%esp
 422:	83 ef 01             	sub    $0x1,%edi
 425:	39 c3                	cmp    %eax,%ebx
 427:	75 df                	jne    408 <printint+0x68>
}
 429:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42c:	5b                   	pop    %ebx
 42d:	5e                   	pop    %esi
 42e:	5f                   	pop    %edi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 438:	31 c0                	xor    %eax,%eax
 43a:	eb 89                	jmp    3c5 <printint+0x25>
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 449:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 44c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 44f:	0f b6 1e             	movzbl (%esi),%ebx
 452:	83 c6 01             	add    $0x1,%esi
 455:	84 db                	test   %bl,%bl
 457:	74 67                	je     4c0 <printf+0x80>
 459:	8d 4d 10             	lea    0x10(%ebp),%ecx
 45c:	31 d2                	xor    %edx,%edx
 45e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 461:	eb 34                	jmp    497 <printf+0x57>
 463:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 468:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 46b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 470:	83 f8 25             	cmp    $0x25,%eax
 473:	74 18                	je     48d <printf+0x4d>
  write(fd, &c, 1);
 475:	83 ec 04             	sub    $0x4,%esp
 478:	8d 45 e7             	lea    -0x19(%ebp),%eax
 47b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 47e:	6a 01                	push   $0x1
 480:	50                   	push   %eax
 481:	57                   	push   %edi
 482:	e8 8c fe ff ff       	call   313 <write>
 487:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 48a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 48d:	0f b6 1e             	movzbl (%esi),%ebx
 490:	83 c6 01             	add    $0x1,%esi
 493:	84 db                	test   %bl,%bl
 495:	74 29                	je     4c0 <printf+0x80>
    c = fmt[i] & 0xff;
 497:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 49a:	85 d2                	test   %edx,%edx
 49c:	74 ca                	je     468 <printf+0x28>
      }
    } else if(state == '%'){
 49e:	83 fa 25             	cmp    $0x25,%edx
 4a1:	75 ea                	jne    48d <printf+0x4d>
      if(c == 'd'){
 4a3:	83 f8 25             	cmp    $0x25,%eax
 4a6:	0f 84 04 01 00 00    	je     5b0 <printf+0x170>
 4ac:	83 e8 63             	sub    $0x63,%eax
 4af:	83 f8 15             	cmp    $0x15,%eax
 4b2:	77 1c                	ja     4d0 <printf+0x90>
 4b4:	ff 24 85 60 07 00 00 	jmp    *0x760(,%eax,4)
 4bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c3:	5b                   	pop    %ebx
 4c4:	5e                   	pop    %esi
 4c5:	5f                   	pop    %edi
 4c6:	5d                   	pop    %ebp
 4c7:	c3                   	ret
 4c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4cf:	00 
  write(fd, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4d6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4da:	6a 01                	push   $0x1
 4dc:	52                   	push   %edx
 4dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4e0:	57                   	push   %edi
 4e1:	e8 2d fe ff ff       	call   313 <write>
 4e6:	83 c4 0c             	add    $0xc,%esp
 4e9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4ec:	6a 01                	push   $0x1
 4ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4f1:	52                   	push   %edx
 4f2:	57                   	push   %edi
 4f3:	e8 1b fe ff ff       	call   313 <write>
        putc(fd, c);
 4f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4fb:	31 d2                	xor    %edx,%edx
 4fd:	eb 8e                	jmp    48d <printf+0x4d>
 4ff:	90                   	nop
        printint(fd, *ap, 16, 0);
 500:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 503:	83 ec 0c             	sub    $0xc,%esp
 506:	b9 10 00 00 00       	mov    $0x10,%ecx
 50b:	8b 13                	mov    (%ebx),%edx
 50d:	6a 00                	push   $0x0
 50f:	89 f8                	mov    %edi,%eax
        ap++;
 511:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 514:	e8 87 fe ff ff       	call   3a0 <printint>
        ap++;
 519:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 51c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51f:	31 d2                	xor    %edx,%edx
 521:	e9 67 ff ff ff       	jmp    48d <printf+0x4d>
        s = (char*)*ap;
 526:	8b 45 d0             	mov    -0x30(%ebp),%eax
 529:	8b 18                	mov    (%eax),%ebx
        ap++;
 52b:	83 c0 04             	add    $0x4,%eax
 52e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 531:	85 db                	test   %ebx,%ebx
 533:	0f 84 87 00 00 00    	je     5c0 <printf+0x180>
        while(*s != 0){
 539:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 53c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 53e:	84 c0                	test   %al,%al
 540:	0f 84 47 ff ff ff    	je     48d <printf+0x4d>
 546:	8d 55 e7             	lea    -0x19(%ebp),%edx
 549:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 54c:	89 de                	mov    %ebx,%esi
 54e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 550:	83 ec 04             	sub    $0x4,%esp
 553:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 556:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 559:	6a 01                	push   $0x1
 55b:	53                   	push   %ebx
 55c:	57                   	push   %edi
 55d:	e8 b1 fd ff ff       	call   313 <write>
        while(*s != 0){
 562:	0f b6 06             	movzbl (%esi),%eax
 565:	83 c4 10             	add    $0x10,%esp
 568:	84 c0                	test   %al,%al
 56a:	75 e4                	jne    550 <printf+0x110>
      state = 0;
 56c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 56f:	31 d2                	xor    %edx,%edx
 571:	e9 17 ff ff ff       	jmp    48d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 576:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 579:	83 ec 0c             	sub    $0xc,%esp
 57c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 581:	8b 13                	mov    (%ebx),%edx
 583:	6a 01                	push   $0x1
 585:	eb 88                	jmp    50f <printf+0xcf>
        putc(fd, *ap);
 587:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 58a:	83 ec 04             	sub    $0x4,%esp
 58d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 590:	8b 03                	mov    (%ebx),%eax
        ap++;
 592:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 595:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 598:	6a 01                	push   $0x1
 59a:	52                   	push   %edx
 59b:	57                   	push   %edi
 59c:	e8 72 fd ff ff       	call   313 <write>
        ap++;
 5a1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5a4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a7:	31 d2                	xor    %edx,%edx
 5a9:	e9 df fe ff ff       	jmp    48d <printf+0x4d>
 5ae:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5b9:	6a 01                	push   $0x1
 5bb:	e9 31 ff ff ff       	jmp    4f1 <printf+0xb1>
 5c0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5c5:	bb 57 07 00 00       	mov    $0x757,%ebx
 5ca:	e9 77 ff ff ff       	jmp    546 <printf+0x106>
 5cf:	90                   	nop

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 5c 0a 00 00       	mov    0xa5c,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ea:	39 c8                	cmp    %ecx,%eax
 5ec:	73 32                	jae    620 <free+0x50>
 5ee:	39 d1                	cmp    %edx,%ecx
 5f0:	72 04                	jb     5f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f2:	39 d0                	cmp    %edx,%eax
 5f4:	72 32                	jb     628 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fc:	39 fa                	cmp    %edi,%edx
 5fe:	74 30                	je     630 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 600:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 603:	8b 50 04             	mov    0x4(%eax),%edx
 606:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 609:	39 f1                	cmp    %esi,%ecx
 60b:	74 3a                	je     647 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 60d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 60f:	5b                   	pop    %ebx
  freep = p;
 610:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 615:	5e                   	pop    %esi
 616:	5f                   	pop    %edi
 617:	5d                   	pop    %ebp
 618:	c3                   	ret
 619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 d0                	cmp    %edx,%eax
 622:	72 04                	jb     628 <free+0x58>
 624:	39 d1                	cmp    %edx,%ecx
 626:	72 ce                	jb     5f6 <free+0x26>
{
 628:	89 d0                	mov    %edx,%eax
 62a:	eb bc                	jmp    5e8 <free+0x18>
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 630:	03 72 04             	add    0x4(%edx),%esi
 633:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 636:	8b 10                	mov    (%eax),%edx
 638:	8b 12                	mov    (%edx),%edx
 63a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 643:	39 f1                	cmp    %esi,%ecx
 645:	75 c6                	jne    60d <free+0x3d>
    p->s.size += bp->s.size;
 647:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 64a:	a3 5c 0a 00 00       	mov    %eax,0xa5c
    p->s.size += bp->s.size;
 64f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 652:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 655:	89 08                	mov    %ecx,(%eax)
}
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 15 5c 0a 00 00    	mov    0xa5c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	8d 78 07             	lea    0x7(%eax),%edi
 675:	c1 ef 03             	shr    $0x3,%edi
 678:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 67b:	85 d2                	test   %edx,%edx
 67d:	0f 84 8d 00 00 00    	je     710 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 685:	8b 48 04             	mov    0x4(%eax),%ecx
 688:	39 f9                	cmp    %edi,%ecx
 68a:	73 64                	jae    6f0 <malloc+0x90>
  if(nu < 4096)
 68c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 691:	39 df                	cmp    %ebx,%edi
 693:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 696:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 69d:	eb 0a                	jmp    6a9 <malloc+0x49>
 69f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6a2:	8b 48 04             	mov    0x4(%eax),%ecx
 6a5:	39 f9                	cmp    %edi,%ecx
 6a7:	73 47                	jae    6f0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6a9:	89 c2                	mov    %eax,%edx
 6ab:	3b 05 5c 0a 00 00    	cmp    0xa5c,%eax
 6b1:	75 ed                	jne    6a0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6b3:	83 ec 0c             	sub    $0xc,%esp
 6b6:	56                   	push   %esi
 6b7:	e8 bf fc ff ff       	call   37b <sbrk>
  if(p == (char*)-1)
 6bc:	83 c4 10             	add    $0x10,%esp
 6bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 6c2:	74 1c                	je     6e0 <malloc+0x80>
  hp->s.size = nu;
 6c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6c7:	83 ec 0c             	sub    $0xc,%esp
 6ca:	83 c0 08             	add    $0x8,%eax
 6cd:	50                   	push   %eax
 6ce:	e8 fd fe ff ff       	call   5d0 <free>
  return freep;
 6d3:	8b 15 5c 0a 00 00    	mov    0xa5c,%edx
      if((p = morecore(nunits)) == 0)
 6d9:	83 c4 10             	add    $0x10,%esp
 6dc:	85 d2                	test   %edx,%edx
 6de:	75 c0                	jne    6a0 <malloc+0x40>
        return 0;
  }
}
 6e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6e3:	31 c0                	xor    %eax,%eax
}
 6e5:	5b                   	pop    %ebx
 6e6:	5e                   	pop    %esi
 6e7:	5f                   	pop    %edi
 6e8:	5d                   	pop    %ebp
 6e9:	c3                   	ret
 6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6f0:	39 cf                	cmp    %ecx,%edi
 6f2:	74 4c                	je     740 <malloc+0xe0>
        p->s.size -= nunits;
 6f4:	29 f9                	sub    %edi,%ecx
 6f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6fc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6ff:	89 15 5c 0a 00 00    	mov    %edx,0xa5c
}
 705:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 708:	83 c0 08             	add    $0x8,%eax
}
 70b:	5b                   	pop    %ebx
 70c:	5e                   	pop    %esi
 70d:	5f                   	pop    %edi
 70e:	5d                   	pop    %ebp
 70f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 710:	c7 05 5c 0a 00 00 60 	movl   $0xa60,0xa5c
 717:	0a 00 00 
    base.s.size = 0;
 71a:	b8 60 0a 00 00       	mov    $0xa60,%eax
    base.s.ptr = freep = prevp = &base;
 71f:	c7 05 60 0a 00 00 60 	movl   $0xa60,0xa60
 726:	0a 00 00 
    base.s.size = 0;
 729:	c7 05 64 0a 00 00 00 	movl   $0x0,0xa64
 730:	00 00 00 
    if(p->s.size >= nunits){
 733:	e9 54 ff ff ff       	jmp    68c <malloc+0x2c>
 738:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 73f:	00 
        prevp->s.ptr = p->s.ptr;
 740:	8b 08                	mov    (%eax),%ecx
 742:	89 0a                	mov    %ecx,(%edx)
 744:	eb b9                	jmp    6ff <malloc+0x9f>
