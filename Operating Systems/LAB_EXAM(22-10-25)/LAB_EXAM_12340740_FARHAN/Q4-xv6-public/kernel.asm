
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 55 11 80       	mov    $0x801155d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 72 10 80       	push   $0x801072e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 75 43 00 00       	call   801043d0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 72 10 80       	push   $0x801072e7
80100097:	50                   	push   %eax
80100098:	e8 03 42 00 00       	call   801042a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 d7 44 00 00       	call   801045c0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 f9 43 00 00       	call   80104560 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 41 00 00       	call   801042e0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 72 10 80       	push   $0x801072ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 bd 41 00 00       	call   80104380 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 72 10 80       	push   $0x801072ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 41 00 00       	call   80104380 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 41 00 00       	call   80104340 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 a0 43 00 00       	call   801045c0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 f2 42 00 00       	jmp    80104560 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 06 73 10 80       	push   $0x80107306
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 1b 43 00 00       	call   801045c0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 6e 3d 00 00       	call   80104040 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 36 00 00       	call   80103980 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 65 42 00 00       	call   80104560 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 0f 42 00 00       	call   80104560 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 25 00 00       	call   801028d0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 73 10 80       	push   $0x8010730d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 d3 77 10 80 	movl   $0x801077d3,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 40 00 00       	call   801043f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 73 10 80       	push   $0x80107321
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 0c 5a 00 00       	call   80105e30 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 41 59 00 00       	call   80105e30 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 35 59 00 00       	call   80105e30 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 29 59 00 00       	call   80105e30 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ea 41 00 00       	call   80104750 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 45 41 00 00       	call   801046c0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 25 73 10 80       	push   $0x80107325
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 f0 3f 00 00       	call   801045c0 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 57 3f 00 00       	call   80104560 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 24 78 10 80 	movzbl -0x7fef87dc(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 e3 3d 00 00       	call   801045c0 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ef 10 80       	push   $0x8010ef20
801007fb:	e8 60 3d 00 00       	call   80104560 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 38 73 10 80       	mov    $0x80107338,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 3f 73 10 80       	push   $0x8010733f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ef 10 80       	push   $0x8010ef20
801008b3:	e8 08 3d 00 00       	call   801045c0 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ef 10 80       	push   $0x8010ef20
801008ed:	e8 6e 3c 00 00       	call   80104560 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100914:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100933:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010094a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010095e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100998:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a05:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a27:	68 00 ef 10 80       	push   $0x8010ef00
80100a2c:	e8 cf 36 00 00       	call   80104100 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 8c 37 00 00       	jmp    801041e0 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 73 10 80       	push   $0x80107348
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 5b 39 00 00       	call   801043d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 bf 2e 00 00       	call   80103980 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 81 64 00 00       	call   80106fa0 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 40 62 00 00       	call   80106dd0 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 3a 61 00 00       	call   80106d00 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 18 63 00 00       	call   80106f20 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 97 21 00 00       	call   80102db0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 5a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 69 61 00 00       	call   80106dd0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 b8 63 00 00       	call   80107040 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 e1 3b 00 00       	call   801048b0 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 d0 3b 00 00       	call   801048b0 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 1d 65 00 00       	call   80107210 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 18 62 00 00       	call   80106f20 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 ac 64 00 00       	call   80107210 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 cc 3a 00 00       	call   80104870 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 a0 5d 00 00       	call   80106b70 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 48 61 00 00       	call   80106f20 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 99 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 50 73 10 80       	push   $0x80107350
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 5c 73 10 80       	push   $0x8010735c
80100e3b:	68 60 ef 10 80       	push   $0x8010ef60
80100e40:	e8 8b 35 00 00       	call   801043d0 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ef 10 80       	push   $0x8010ef60
80100e61:	e8 5a 37 00 00       	call   801045c0 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 ca 36 00 00       	call   80104560 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ef 10 80       	push   $0x8010ef60
80100eaa:	e8 b1 36 00 00       	call   80104560 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ef 10 80       	push   $0x8010ef60
80100ecf:	e8 ec 36 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ef 10 80       	push   $0x8010ef60
80100eec:	e8 6f 36 00 00       	call   80104560 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 63 73 10 80       	push   $0x80107363
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ef 10 80       	push   $0x8010ef60
80100f21:	e8 9a 36 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 ef 10 80       	push   $0x8010ef60
80100f5c:	e8 ff 35 00 00       	call   80104560 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 cd 35 00 00       	jmp    80104560 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 a3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 f9 1d 00 00       	jmp    80102db0 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 42 25 00 00       	call   80103510 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 6b 73 10 80       	push   $0x8010736b
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 1e 26 00 00       	jmp    801036d0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 75 73 10 80       	push   $0x80107375
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 82 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 ed 1b 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 26 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 7e 73 10 80       	push   $0x8010737e
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 e2 23 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 84 73 10 80       	push   $0x80107384
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 8e 73 10 80       	push   $0x8010738e
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 76 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 ee 33 00 00       	call   801046c0 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 46 1c 00 00       	call   80102f20 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 f9 10 80       	push   $0x8010f960
8010130a:	e8 b1 32 00 00       	call   801045c0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 f9 10 80       	push   $0x8010f960
80101377:	e8 e4 31 00 00       	call   80104560 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 f9 10 80       	push   $0x8010f960
801013a5:	e8 b6 31 00 00       	call   80104560 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 a4 73 10 80       	push   $0x801073a4
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 de 1a 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 b4 73 10 80       	push   $0x801073b4
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 36 1a 00 00       	call   80102f20 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 c7 73 10 80       	push   $0x801073c7
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 ea 31 00 00       	call   80104750 <memmove>
  brelse(bp);
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 da 73 10 80       	push   $0x801073da
80101591:	68 60 f9 10 80       	push   $0x8010f960
80101596:	e8 35 2e 00 00       	call   801043d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 e1 73 10 80       	push   $0x801073e1
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 ec 2c 00 00       	call   801042a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 15 11 80       	push   $0x801115b4
801015dc:	e8 6f 31 00 00       	call   80104750 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 15 11 80    	push   0x801115cc
801015ef:	ff 35 c8 15 11 80    	push   0x801115c8
801015f5:	ff 35 c4 15 11 80    	push   0x801115c4
801015fb:	ff 35 c0 15 11 80    	push   0x801115c0
80101601:	ff 35 bc 15 11 80    	push   0x801115bc
80101607:	ff 35 b8 15 11 80    	push   0x801115b8
8010160d:	ff 35 b4 15 11 80    	push   0x801115b4
80101613:	68 38 78 10 80       	push   $0x80107838
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 0d 30 00 00       	call   801046c0 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 5b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 e7 73 10 80       	push   $0x801073e7
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 fa 2f 00 00       	call   80104750 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 c2 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 f9 10 80       	push   $0x8010f960
8010177f:	e8 3c 2e 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010178f:	e8 cc 2d 00 00       	call   80104560 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 19 2b 00 00       	call   801042e0 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 13 2f 00 00       	call   80104750 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 ff 73 10 80       	push   $0x801073ff
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 f9 73 10 80       	push   $0x801073f9
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 e8 2a 00 00       	call   80104380 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 8c 2a 00 00       	jmp    80104340 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 0e 74 10 80       	push   $0x8010740e
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 fb 29 00 00       	call   801042e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 41 2a 00 00       	call   80104340 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101906:	e8 b5 2c 00 00       	call   801045c0 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 3b 2c 00 00       	jmp    80104560 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 f9 10 80       	push   $0x8010f960
80101930:	e8 8b 2c 00 00       	call   801045c0 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010193f:	e8 1c 2c 00 00       	call   80104560 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	83 c4 10             	add    $0x10,%esp
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 38 29 00 00       	call   80104380 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 e1 28 00 00       	call   80104340 <releasesleep>
  iput(ip);
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 0e 74 10 80       	push   $0x8010740e
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 f4 2b 00 00       	call   80104750 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 f6 2a 00 00       	call   80104750 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 be 12 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 dd 2a 00 00       	call   801047c0 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 7e 2a 00 00       	call   801047c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 28 74 10 80       	push   $0x80107428
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 16 74 10 80       	push   $0x80107416
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 c1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 f9 10 80       	push   $0x8010f960
80101dca:	e8 f1 27 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dda:	e8 81 27 00 00       	call   80104560 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 14 29 00 00       	call   80104750 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 df 24 00 00       	call   80104380 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 7d 24 00 00       	call   80104340 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 60 28 00 00       	call   80104750 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 56 24 00 00       	call   80104380 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 ff 23 00 00       	call   80104340 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 06 24 00 00       	call   80104380 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 af 23 00 00       	call   80104340 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 0e 74 10 80       	push   $0x8010740e
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 ee 27 00 00       	call   80104810 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 37 74 10 80       	push   $0x80107437
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 93 76 10 80       	push   $0x80107693
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ee:	00 
801020ef:	90                   	nop
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 4d 74 10 80       	push   $0x8010744d
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 44 74 10 80       	push   $0x80107444
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102199:	00 
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 5f 74 10 80       	push   $0x8010745f
801021ab:	68 00 16 11 80       	push   $0x80111600
801021b0:	e8 1b 22 00 00       	call   801043d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021fd:	00 
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102228:	00 
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 16 11 80       	push   $0x80111600
8010223e:	e8 7d 23 00 00       	call   801045c0 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 5e 1e 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 16 11 80       	push   $0x80111600
801022bb:	e8 a0 22 00 00       	call   80104560 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cf:	00 

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 9d 20 00 00       	call   80104380 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 16 11 80       	push   $0x80111600
80102318:	e8 a3 22 00 00       	call   801045c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 16 11 80       	push   $0x80111600
80102358:	53                   	push   %ebx
80102359:	e8 e2 1c 00 00       	call   80104040 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 e5 21 00 00       	jmp    80104560 <release>
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 8e 74 10 80       	push   $0x8010748e
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 79 74 10 80       	push   $0x80107479
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 63 74 10 80       	push   $0x80107463
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 8c 78 10 80       	push   $0x8010788c
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024b0:	75 76                	jne    80102528 <kfree+0x88>
801024b2:	81 fb d0 55 11 80    	cmp    $0x801155d0,%ebx
801024b8:	72 6e                	jb     80102528 <kfree+0x88>
801024ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024c5:	77 61                	ja     80102528 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024c7:	83 ec 04             	sub    $0x4,%esp
801024ca:	68 00 10 00 00       	push   $0x1000
801024cf:	6a 01                	push   $0x1
801024d1:	53                   	push   %ebx
801024d2:	e8 e9 21 00 00       	call   801046c0 <memset>

  if(kmem.use_lock)
801024d7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	85 d2                	test   %edx,%edx
801024e2:	75 1c                	jne    80102500 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024e4:	a1 78 16 11 80       	mov    0x80111678,%eax
801024e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024eb:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
801024f0:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
801024f6:	85 c0                	test   %eax,%eax
801024f8:	75 1e                	jne    80102518 <kfree+0x78>
    release(&kmem.lock);
}
801024fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fd:	c9                   	leave
801024fe:	c3                   	ret
801024ff:	90                   	nop
    acquire(&kmem.lock);
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 40 16 11 80       	push   $0x80111640
80102508:	e8 b3 20 00 00       	call   801045c0 <acquire>
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	eb d2                	jmp    801024e4 <kfree+0x44>
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102518:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010251f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102522:	c9                   	leave
    release(&kmem.lock);
80102523:	e9 38 20 00 00       	jmp    80104560 <release>
    panic("kfree");
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 ac 74 10 80       	push   $0x801074ac
80102530:	e8 4b de ff ff       	call   80100380 <panic>
80102535:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010253c:	00 
8010253d:	8d 76 00             	lea    0x0(%esi),%esi

80102540 <freerange>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102548:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <freerange+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 23 ff ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <freerange+0x28>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret
8010258b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102590 <kinit2>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <kinit2+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 d3 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit2+0x28>
  kmem.use_lock = 1;
801025d4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801025db:	00 00 00 
}
801025de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret
801025e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ec:	00 
801025ed:	8d 76 00             	lea    0x0(%esi),%esi

801025f0 <kinit1>:
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	68 b2 74 10 80       	push   $0x801074b2
80102600:	68 40 16 11 80       	push   $0x80111640
80102605:	e8 c6 1d 00 00       	call   801043d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102610:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102617:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010261a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102620:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102626:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262c:	39 de                	cmp    %ebx,%esi
8010262e:	72 1c                	jb     8010264c <kinit1+0x5c>
    kfree(p);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010263f:	50                   	push   %eax
80102640:	e8 5b fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	39 de                	cmp    %ebx,%esi
8010264a:	73 e4                	jae    80102630 <kinit1+0x40>
}
8010264c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010264f:	5b                   	pop    %ebx
80102650:	5e                   	pop    %esi
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret
80102653:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265a:	00 
8010265b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102660 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	53                   	push   %ebx
80102664:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102667:	a1 74 16 11 80       	mov    0x80111674,%eax
8010266c:	85 c0                	test   %eax,%eax
8010266e:	75 20                	jne    80102690 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102670:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102676:	85 db                	test   %ebx,%ebx
80102678:	74 07                	je     80102681 <kalloc+0x21>
    kmem.freelist = r->next;
8010267a:	8b 03                	mov    (%ebx),%eax
8010267c:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102681:	89 d8                	mov    %ebx,%eax
80102683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102686:	c9                   	leave
80102687:	c3                   	ret
80102688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268f:	00 
    acquire(&kmem.lock);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 40 16 11 80       	push   $0x80111640
80102698:	e8 23 1f 00 00       	call   801045c0 <acquire>
  r = kmem.freelist;
8010269d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801026a3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801026a8:	83 c4 10             	add    $0x10,%esp
801026ab:	85 db                	test   %ebx,%ebx
801026ad:	74 08                	je     801026b7 <kalloc+0x57>
    kmem.freelist = r->next;
801026af:	8b 13                	mov    (%ebx),%edx
801026b1:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801026b7:	85 c0                	test   %eax,%eax
801026b9:	74 c6                	je     80102681 <kalloc+0x21>
    release(&kmem.lock);
801026bb:	83 ec 0c             	sub    $0xc,%esp
801026be:	68 40 16 11 80       	push   $0x80111640
801026c3:	e8 98 1e 00 00       	call   80104560 <release>
}
801026c8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026ca:	83 c4 10             	add    $0x10,%esp
}
801026cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d0:	c9                   	leave
801026d1:	c3                   	ret
801026d2:	66 90                	xchg   %ax,%ax
801026d4:	66 90                	xchg   %ax,%ax
801026d6:	66 90                	xchg   %ax,%ax
801026d8:	66 90                	xchg   %ax,%ax
801026da:	66 90                	xchg   %ax,%ax
801026dc:	66 90                	xchg   %ax,%ax
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e0:	ba 64 00 00 00       	mov    $0x64,%edx
801026e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026e6:	a8 01                	test   $0x1,%al
801026e8:	0f 84 c2 00 00 00    	je     801027b0 <kbdgetc+0xd0>
{
801026ee:	55                   	push   %ebp
801026ef:	ba 60 00 00 00       	mov    $0x60,%edx
801026f4:	89 e5                	mov    %esp,%ebp
801026f6:	53                   	push   %ebx
801026f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026f8:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
801026fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102701:	3c e0                	cmp    $0xe0,%al
80102703:	74 5b                	je     80102760 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102705:	89 da                	mov    %ebx,%edx
80102707:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010270a:	84 c0                	test   %al,%al
8010270c:	78 62                	js     80102770 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010270e:	85 d2                	test   %edx,%edx
80102710:	74 09                	je     8010271b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102712:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102715:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102718:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010271b:	0f b6 91 00 7b 10 80 	movzbl -0x7fef8500(%ecx),%edx
  shift ^= togglecode[data];
80102722:	0f b6 81 00 7a 10 80 	movzbl -0x7fef8600(%ecx),%eax
  shift |= shiftcode[data];
80102729:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010272b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010272f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102735:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102738:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273b:	8b 04 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%eax
80102742:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102746:	74 0b                	je     80102753 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102748:	8d 50 9f             	lea    -0x61(%eax),%edx
8010274b:	83 fa 19             	cmp    $0x19,%edx
8010274e:	77 48                	ja     80102798 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102750:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102756:	c9                   	leave
80102757:	c3                   	ret
80102758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010275f:	00 
    shift |= E0ESC;
80102760:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102763:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102765:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010276b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276e:	c9                   	leave
8010276f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102770:	83 e0 7f             	and    $0x7f,%eax
80102773:	85 d2                	test   %edx,%edx
80102775:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102778:	0f b6 81 00 7b 10 80 	movzbl -0x7fef8500(%ecx),%eax
8010277f:	83 c8 40             	or     $0x40,%eax
80102782:	0f b6 c0             	movzbl %al,%eax
80102785:	f7 d0                	not    %eax
80102787:	21 d8                	and    %ebx,%eax
80102789:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
8010278e:	31 c0                	xor    %eax,%eax
80102790:	eb d9                	jmp    8010276b <kbdgetc+0x8b>
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102798:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010279b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010279e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a1:	c9                   	leave
      c += 'a' - 'A';
801027a2:	83 f9 1a             	cmp    $0x1a,%ecx
801027a5:	0f 42 c2             	cmovb  %edx,%eax
}
801027a8:	c3                   	ret
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret
801027b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027bd:	00 
801027be:	66 90                	xchg   %ax,%ax

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027c6:	68 e0 26 10 80       	push   $0x801026e0
801027cb:	e8 d0 e0 ff ff       	call   801008a0 <consoleintr>
}
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	c9                   	leave
801027d4:	c3                   	ret
801027d5:	66 90                	xchg   %ax,%ax
801027d7:	66 90                	xchg   %ax,%ax
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027e0:	a1 80 16 11 80       	mov    0x80111680,%eax
801027e5:	85 c0                	test   %eax,%eax
801027e7:	0f 84 c3 00 00 00    	je     801028b0 <lapicinit+0xd0>
  lapic[index] = value;
801027ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102801:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010280e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010281b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102835:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102838:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010283b:	8b 50 30             	mov    0x30(%eax),%edx
8010283e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102844:	75 72                	jne    801028b8 <lapicinit+0xd8>
  lapic[index] = value;
80102846:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010288e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102898:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010289e:	80 e6 10             	and    $0x10,%dh
801028a1:	75 f5                	jne    80102898 <lapicinit+0xb8>
  lapic[index] = value;
801028a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b0:	c3                   	ret
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801028c5:	e9 7c ff ff ff       	jmp    80102846 <lapicinit+0x66>
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	74 07                	je     801028e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028d9:	8b 40 20             	mov    0x20(%eax),%eax
801028dc:	c1 e8 18             	shr    $0x18,%eax
801028df:	c3                   	ret
    return 0;
801028e0:	31 c0                	xor    %eax,%eax
}
801028e2:	c3                   	ret
801028e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028ea:	00 
801028eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 0d                	je     80102906 <lapiceoi+0x16>
  lapic[index] = value;
801028f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102900:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102906:	c3                   	ret
80102907:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010290e:	00 
8010290f:	90                   	nop

80102910 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102910:	c3                   	ret
80102911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102918:	00 
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102950:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102952:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ad:	c9                   	leave
801029ae:	c3                   	ret
801029af:	90                   	nop

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bf 70 00 00 00       	mov    $0x70,%edi
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 fa                	mov    %edi,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 fa                	mov    %edi,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 fa                	mov    %edi,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 fa                	mov    %edi,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 fa                	mov    %edi,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2d:	89 fa                	mov    %edi,%edx
80102a2f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a35:	89 ca                	mov    %ecx,%edx
80102a37:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a38:	84 c0                	test   %al,%al
80102a3a:	78 9c                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a40:	89 f2                	mov    %esi,%edx
80102a42:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 fa                	mov    %edi,%edx
80102a4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a4d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a51:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102a54:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a57:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a65:	31 c0                	xor    %eax,%eax
80102a67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a68:	89 ca                	mov    %ecx,%edx
80102a6a:	ec                   	in     (%dx),%al
80102a6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6e:	89 fa                	mov    %edi,%edx
80102a70:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a73:	b8 02 00 00 00       	mov    $0x2,%eax
80102a78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a79:	89 ca                	mov    %ecx,%edx
80102a7b:	ec                   	in     (%dx),%al
80102a7c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a84:	b8 04 00 00 00       	mov    $0x4,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 fa                	mov    %edi,%edx
80102a92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a95:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9b:	89 ca                	mov    %ecx,%edx
80102a9d:	ec                   	in     (%dx),%al
80102a9e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	89 fa                	mov    %edi,%edx
80102aa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa6:	b8 08 00 00 00       	mov    $0x8,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 fa                	mov    %edi,%edx
80102ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab7:	b8 09 00 00 00       	mov    $0x9,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102acc:	6a 18                	push   $0x18
80102ace:	50                   	push   %eax
80102acf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad2:	50                   	push   %eax
80102ad3:	e8 28 1c 00 00       	call   80104700 <memcmp>
80102ad8:	83 c4 10             	add    $0x10,%esp
80102adb:	85 c0                	test   %eax,%eax
80102add:	0f 85 f5 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102aea:	89 f0                	mov    %esi,%eax
80102aec:	84 c0                	test   %al,%al
80102aee:	75 78                	jne    80102b68 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102af0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af3:	89 c2                	mov    %eax,%edx
80102af5:	83 e0 0f             	and    $0xf,%eax
80102af8:	c1 ea 04             	shr    $0x4,%edx
80102afb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b01:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b04:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b07:	89 c2                	mov    %eax,%edx
80102b09:	83 e0 0f             	and    $0xf,%eax
80102b0c:	c1 ea 04             	shr    $0x4,%edx
80102b0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b18:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b1b:	89 c2                	mov    %eax,%edx
80102b1d:	83 e0 0f             	and    $0xf,%eax
80102b20:	c1 ea 04             	shr    $0x4,%edx
80102b23:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b26:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2f:	89 c2                	mov    %eax,%edx
80102b31:	83 e0 0f             	and    $0xf,%eax
80102b34:	c1 ea 04             	shr    $0x4,%edx
80102b37:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b40:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	83 e0 0f             	and    $0xf,%eax
80102b48:	c1 ea 04             	shr    $0x4,%edx
80102b4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b51:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b57:	89 c2                	mov    %eax,%edx
80102b59:	83 e0 0f             	and    $0xf,%eax
80102b5c:	c1 ea 04             	shr    $0x4,%edx
80102b5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b65:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 03                	mov    %eax,(%ebx)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 43 04             	mov    %eax,0x4(%ebx)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 43 08             	mov    %eax,0x8(%ebx)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 43 10             	mov    %eax,0x10(%ebx)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102b8b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 e4 16 11 80    	push   0x801116e4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102be4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 47 1b 00 00       	call   80104750 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 d4 16 11 80    	push   0x801116d4
80102c4d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave
80102c9a:	c3                   	ret
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 b7 74 10 80       	push   $0x801074b7
80102caf:	68 a0 16 11 80       	push   $0x801116a0
80102cb4:	e8 17 17 00 00       	call   801043d0 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 7b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cc8:	59                   	pop    %ecx
  log.dev = dev;
80102cc9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102ccf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102cd7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 eb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ce8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ceb:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102cf1:	85 db                	test   %ebx,%ebx
80102cf3:	7e 1d                	jle    80102d12 <initlog+0x72>
80102cf5:	31 d2                	xor    %edx,%edx
80102cf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cfe:	00 
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d04:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d3                	cmp    %edx,%ebx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave
80102d36:	c3                   	ret
80102d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d3e:	00 
80102d3f:	90                   	nop

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 a0 16 11 80       	push   $0x801116a0
80102d4b:	e8 70 18 00 00       	call   801045c0 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 a0 16 11 80       	push   $0x801116a0
80102d60:	68 a0 16 11 80       	push   $0x801116a0
80102d65:	e8 d6 12 00 00       	call   80104040 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102d7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102d97:	68 a0 16 11 80       	push   $0x801116a0
80102d9c:	e8 bf 17 00 00       	call   80104560 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave
80102da5:	c3                   	ret
80102da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dad:	00 
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 a0 16 11 80       	push   $0x801116a0
80102dbe:	e8 fd 17 00 00       	call   801045c0 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102dc8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102dda:	85 f6                	test   %esi,%esi
80102ddc:	0f 85 22 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 f6 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dea:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102df1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df4:	83 ec 0c             	sub    $0xc,%esp
80102df7:	68 a0 16 11 80       	push   $0x801116a0
80102dfc:	e8 5f 17 00 00       	call   80104560 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	7f 42                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 a0 16 11 80       	push   $0x801116a0
80102e16:	e8 a5 17 00 00       	call   801045c0 <acquire>
    log.committing = 0;
80102e1b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e22:	00 00 00 
    wakeup(&log);
80102e25:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e2c:	e8 cf 12 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102e31:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e38:	e8 23 17 00 00       	call   80104560 <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
}
80102e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e43:	5b                   	pop    %ebx
80102e44:	5e                   	pop    %esi
80102e45:	5f                   	pop    %edi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret
80102e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e4f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102e74:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 b7 18 00 00       	call   80104750 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 34 ff ff ff       	jmp    80102e0e <end_op+0x5e>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 a0 16 11 80       	push   $0x801116a0
80102ee8:	e8 13 12 00 00       	call   80104100 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ef4:	e8 67 16 00 00       	call   80104560 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 bb 74 10 80       	push   $0x801074bb
80102f0c:	e8 6f d4 ff ff       	call   80100380 <panic>
80102f11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f18:	00 
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f27:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	7f 7d                	jg     80102fb2 <log_write+0x92>
80102f35:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f3a:	83 e8 01             	sub    $0x1,%eax
80102f3d:	39 c2                	cmp    %eax,%edx
80102f3f:	7d 71                	jge    80102fb2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f41:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	7e 75                	jle    80102fbf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 16 11 80       	push   $0x801116a0
80102f52:	e8 69 16 00 00       	call   801045c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f57:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	31 c0                	xor    %eax,%eax
80102f5f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f65:	85 d2                	test   %edx,%edx
80102f67:	7f 0e                	jg     80102f77 <log_write+0x57>
80102f69:	eb 15                	jmp    80102f80 <log_write+0x60>
80102f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102f87:	39 c2                	cmp    %eax,%edx
80102f89:	74 1c                	je     80102fa7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f8b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f91:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102f98:	c9                   	leave
  release(&log.lock);
80102f99:	e9 c2 15 00 00       	jmp    80104560 <release>
80102f9e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fb0:	eb d9                	jmp    80102f8b <log_write+0x6b>
    panic("too big a transaction");
80102fb2:	83 ec 0c             	sub    $0xc,%esp
80102fb5:	68 ca 74 10 80       	push   $0x801074ca
80102fba:	e8 c1 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fbf:	83 ec 0c             	sub    $0xc,%esp
80102fc2:	68 e0 74 10 80       	push   $0x801074e0
80102fc7:	e8 b4 d3 ff ff       	call   80100380 <panic>
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fd7:	e8 84 09 00 00       	call   80103960 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 7d 09 00 00       	call   80103960 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 fb 74 10 80       	push   $0x801074fb
80102fed:	e8 be d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102ff2:	e8 99 29 00 00       	call   80105990 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ff7:	e8 04 09 00 00       	call   80103900 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010300a:	e8 21 0c 00 00       	call   80103c30 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103016:	e8 45 3b 00 00       	call   80106b60 <switchkvm>
  seginit();
8010301b:	e8 c0 39 00 00       	call   801069e0 <seginit>
  lapicinit();
80103020:	e8 bb f7 ff ff       	call   801027e0 <lapicinit>
  mpmain();
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
{
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	push   -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 d0 55 11 80       	push   $0x801155d0
8010304c:	e8 9f f5 ff ff       	call   801025f0 <kinit1>
  kvmalloc();      // kernel page table
80103051:	e8 ca 3f 00 00       	call   80107020 <kvmalloc>
  mpinit();        // detect other processors
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010305b:	e8 80 f7 ff ff       	call   801027e0 <lapicinit>
  seginit();       // segment descriptors
80103060:	e8 7b 39 00 00       	call   801069e0 <seginit>
  picinit();       // disable pic
80103065:	e8 96 03 00 00       	call   80103400 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 51 f3 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010306f:	e8 ec d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103074:	e8 c7 2c 00 00       	call   80105d40 <uartinit>
  pinit();         // process table
80103079:	e8 62 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
8010307e:	e8 8d 28 00 00       	call   80105910 <tvinit>
  binit();         // buffer cache
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103088:	e8 a3 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
8010308d:	e8 0e f1 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c a4 10 80       	push   $0x8010a48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 a7 16 00 00       	call   80104750 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030b3:	00 00 00 
801030b6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030bb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
    if(c == mycpu())  // We've started already.
801030e9:	e8 12 08 00 00       	call   80103900 <mycpu>
801030ee:	39 c3                	cmp    %eax,%ebx
801030f0:	74 de                	je     801030d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f2:	e8 69 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010310b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 fa f7 ff ff       	call   80102920 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 3e f4 ff ff       	call   80102590 <kinit2>
  userinit();      // first user process
80103152:	e8 59 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010317f:	00 
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 df                	cmp    %ebx,%edi
80103184:	73 42                	jae    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 0f 75 10 80       	push   $0x8010750f
80103193:	56                   	push   %esi
80103194:	e8 67 15 00 00       	call   80104700 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f2                	mov    %esi,%edx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031b0:	39 fa                	cmp    %edi,%edx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret
801031d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031db:	00 
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 2c             	sub    $0x2c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	85 c0                	test   %eax,%eax
80103228:	0f 84 6a 01 00 00    	je     80103398 <mpinit+0x1b8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010322e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103234:	8b 40 04             	mov    0x4(%eax),%eax
80103237:	85 c0                	test   %eax,%eax
80103239:	0f 84 e9 00 00 00    	je     80103328 <mpinit+0x148>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103242:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103245:	8b 40 04             	mov    0x4(%eax),%eax
80103248:	05 00 00 00 80       	add    $0x80000000,%eax
8010324d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103250:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103253:	6a 04                	push   $0x4
80103255:	68 2c 75 10 80       	push   $0x8010752c
8010325a:	50                   	push   %eax
8010325b:	e8 a0 14 00 00       	call   80104700 <memcmp>
80103260:	83 c4 10             	add    $0x10,%esp
80103263:	85 c0                	test   %eax,%eax
80103265:	0f 85 bd 00 00 00    	jne    80103328 <mpinit+0x148>
  if(conf->version != 1 && conf->version != 4)
8010326b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010326e:	80 78 06 01          	cmpb   $0x1,0x6(%eax)
80103272:	74 0d                	je     80103281 <mpinit+0xa1>
80103274:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103277:	80 78 06 04          	cmpb   $0x4,0x6(%eax)
8010327b:	0f 85 a7 00 00 00    	jne    80103328 <mpinit+0x148>
  if(sum((uchar*)conf, conf->length) != 0)
80103281:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103284:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80103288:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(i=0; i<len; i++)
8010328b:	66 85 d2             	test   %dx,%dx
8010328e:	74 1c                	je     801032ac <mpinit+0xcc>
80103290:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
  sum = 0;
80103293:	31 d2                	xor    %edx,%edx
80103295:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103298:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
8010329b:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010329e:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032a0:	39 c3                	cmp    %eax,%ebx
801032a2:	75 f4                	jne    80103298 <mpinit+0xb8>
  if(sum((uchar*)conf, conf->length) != 0)
801032a4:	84 d2                	test   %dl,%dl
801032a6:	0f 85 7c 00 00 00    	jne    80103328 <mpinit+0x148>
  *pmp = mp;
801032ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  return conf;
801032af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032b2:	85 d2                	test   %edx,%edx
801032b4:	74 72                	je     80103328 <mpinit+0x148>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b6:	8b 42 24             	mov    0x24(%edx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b9:	0f b7 4a 04          	movzwl 0x4(%edx),%ecx
801032bd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  ismp = 1;
801032c0:	be 01 00 00 00       	mov    $0x1,%esi
  lapic = (uint*)conf->lapicaddr;
801032c5:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ca:	8d 42 2c             	lea    0x2c(%edx),%eax
801032cd:	01 ca                	add    %ecx,%edx
801032cf:	90                   	nop
801032d0:	39 d0                	cmp    %edx,%eax
801032d2:	73 19                	jae    801032ed <mpinit+0x10d>
    switch(*p){
801032d4:	0f b6 08             	movzbl (%eax),%ecx
801032d7:	80 f9 02             	cmp    $0x2,%cl
801032da:	74 5c                	je     80103338 <mpinit+0x158>
801032dc:	0f 87 9e 00 00 00    	ja     80103380 <mpinit+0x1a0>
801032e2:	84 c9                	test   %cl,%cl
801032e4:	74 6a                	je     80103350 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032e6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e9:	39 d0                	cmp    %edx,%eax
801032eb:	72 e7                	jb     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032ed:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801032f0:	85 f6                	test   %esi,%esi
801032f2:	0f 84 f0 00 00 00    	je     801033e8 <mpinit+0x208>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801032fc:	74 15                	je     80103313 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fe:	b8 70 00 00 00       	mov    $0x70,%eax
80103303:	ba 22 00 00 00       	mov    $0x22,%edx
80103308:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103309:	ba 23 00 00 00       	mov    $0x23,%edx
8010330e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010330f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103312:	ee                   	out    %al,(%dx)
  }
}
80103313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5f                   	pop    %edi
80103319:	5d                   	pop    %ebp
8010331a:	c3                   	ret
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010331b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103328:	83 ec 0c             	sub    $0xc,%esp
8010332b:	68 14 75 10 80       	push   $0x80107514
80103330:	e8 4b d0 ff ff       	call   80100380 <panic>
80103335:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103338:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010333c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010333f:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
80103345:	eb 89                	jmp    801032d0 <mpinit+0xf0>
80103347:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010334e:	00 
8010334f:	90                   	nop
      if(ncpu < NCPU) {
80103350:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103356:	83 f9 07             	cmp    $0x7,%ecx
80103359:	7f 19                	jg     80103374 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010335b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103361:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103365:	83 c1 01             	add    $0x1,%ecx
80103368:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103374:	83 c0 14             	add    $0x14,%eax
      continue;
80103377:	e9 54 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103380:	83 e9 03             	sub    $0x3,%ecx
80103383:	80 f9 01             	cmp    $0x1,%cl
80103386:	0f 86 5a ff ff ff    	jbe    801032e6 <mpinit+0x106>
8010338c:	31 f6                	xor    %esi,%esi
8010338e:	e9 3d ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103393:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
{
80103398:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010339d:	eb 0f                	jmp    801033ae <mpinit+0x1ce>
8010339f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801033a0:	89 f3                	mov    %esi,%ebx
801033a2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033a8:	0f 84 6d ff ff ff    	je     8010331b <mpinit+0x13b>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ae:	83 ec 04             	sub    $0x4,%esp
801033b1:	8d 73 10             	lea    0x10(%ebx),%esi
801033b4:	6a 04                	push   $0x4
801033b6:	68 0f 75 10 80       	push   $0x8010750f
801033bb:	53                   	push   %ebx
801033bc:	e8 3f 13 00 00       	call   80104700 <memcmp>
801033c1:	83 c4 10             	add    $0x10,%esp
801033c4:	85 c0                	test   %eax,%eax
801033c6:	75 d8                	jne    801033a0 <mpinit+0x1c0>
801033c8:	89 da                	mov    %ebx,%edx
801033ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033d0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033d3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033d6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033d8:	39 f2                	cmp    %esi,%edx
801033da:	75 f4                	jne    801033d0 <mpinit+0x1f0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033dc:	84 c0                	test   %al,%al
801033de:	75 c0                	jne    801033a0 <mpinit+0x1c0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801033e3:	e9 49 fe ff ff       	jmp    80103231 <mpinit+0x51>
    panic("Didn't find a suitable machine");
801033e8:	83 ec 0c             	sub    $0xc,%esp
801033eb:	68 c0 78 10 80       	push   $0x801078c0
801033f0:	e8 8b cf ff ff       	call   80100380 <panic>
801033f5:	66 90                	xchg   %ax,%ax
801033f7:	66 90                	xchg   %ax,%ax
801033f9:	66 90                	xchg   %ax,%ax
801033fb:	66 90                	xchg   %ax,%ax
801033fd:	66 90                	xchg   %ax,%ax
801033ff:	90                   	nop

80103400 <picinit>:
80103400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103405:	ba 21 00 00 00       	mov    $0x21,%edx
8010340a:	ee                   	out    %al,(%dx)
8010340b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103410:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103411:	c3                   	ret
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 0c             	sub    $0xc,%esp
80103429:	8b 75 08             	mov    0x8(%ebp),%esi
8010342c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010342f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103435:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010343b:	e8 10 da ff ff       	call   80100e50 <filealloc>
80103440:	89 06                	mov    %eax,(%esi)
80103442:	85 c0                	test   %eax,%eax
80103444:	0f 84 a5 00 00 00    	je     801034ef <pipealloc+0xcf>
8010344a:	e8 01 da ff ff       	call   80100e50 <filealloc>
8010344f:	89 07                	mov    %eax,(%edi)
80103451:	85 c0                	test   %eax,%eax
80103453:	0f 84 84 00 00 00    	je     801034dd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103459:	e8 02 f2 ff ff       	call   80102660 <kalloc>
8010345e:	89 c3                	mov    %eax,%ebx
80103460:	85 c0                	test   %eax,%eax
80103462:	0f 84 a0 00 00 00    	je     80103508 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103468:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010346f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103472:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103475:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010347c:	00 00 00 
  p->nwrite = 0;
8010347f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103486:	00 00 00 
  p->nread = 0;
80103489:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103490:	00 00 00 
  initlock(&p->lock, "pipe");
80103493:	68 31 75 10 80       	push   $0x80107531
80103498:	50                   	push   %eax
80103499:	e8 32 0f 00 00       	call   801043d0 <initlock>
  (*f0)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034a0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034a9:	8b 06                	mov    (%esi),%eax
801034ab:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034af:	8b 06                	mov    (%esi),%eax
801034b1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034b5:	8b 06                	mov    (%esi),%eax
801034b7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ba:	8b 07                	mov    (%edi),%eax
801034bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034c2:	8b 07                	mov    (%edi),%eax
801034c4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034c8:	8b 07                	mov    (%edi),%eax
801034ca:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ce:	8b 07                	mov    (%edi),%eax
801034d0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801034d3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d8:	5b                   	pop    %ebx
801034d9:	5e                   	pop    %esi
801034da:	5f                   	pop    %edi
801034db:	5d                   	pop    %ebp
801034dc:	c3                   	ret
  if(*f0)
801034dd:	8b 06                	mov    (%esi),%eax
801034df:	85 c0                	test   %eax,%eax
801034e1:	74 1e                	je     80103501 <pipealloc+0xe1>
    fileclose(*f0);
801034e3:	83 ec 0c             	sub    $0xc,%esp
801034e6:	50                   	push   %eax
801034e7:	e8 24 da ff ff       	call   80100f10 <fileclose>
801034ec:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ef:	8b 07                	mov    (%edi),%eax
801034f1:	85 c0                	test   %eax,%eax
801034f3:	74 0c                	je     80103501 <pipealloc+0xe1>
    fileclose(*f1);
801034f5:	83 ec 0c             	sub    $0xc,%esp
801034f8:	50                   	push   %eax
801034f9:	e8 12 da ff ff       	call   80100f10 <fileclose>
801034fe:	83 c4 10             	add    $0x10,%esp
  return -1;
80103501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103506:	eb cd                	jmp    801034d5 <pipealloc+0xb5>
  if(*f0)
80103508:	8b 06                	mov    (%esi),%eax
8010350a:	85 c0                	test   %eax,%eax
8010350c:	75 d5                	jne    801034e3 <pipealloc+0xc3>
8010350e:	eb df                	jmp    801034ef <pipealloc+0xcf>

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	56                   	push   %esi
80103514:	53                   	push   %ebx
80103515:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103518:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	53                   	push   %ebx
8010351f:	e8 9c 10 00 00       	call   801045c0 <acquire>
  if(writable){
80103524:	83 c4 10             	add    $0x10,%esp
80103527:	85 f6                	test   %esi,%esi
80103529:	74 65                	je     80103590 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352b:	83 ec 0c             	sub    $0xc,%esp
8010352e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103534:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353b:	00 00 00 
    wakeup(&p->nread);
8010353e:	50                   	push   %eax
8010353f:	e8 bc 0b 00 00       	call   80104100 <wakeup>
80103544:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103547:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010354d:	85 d2                	test   %edx,%edx
8010354f:	75 0a                	jne    8010355b <pipeclose+0x4b>
80103551:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103557:	85 c0                	test   %eax,%eax
80103559:	74 15                	je     80103570 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010355e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103561:	5b                   	pop    %ebx
80103562:	5e                   	pop    %esi
80103563:	5d                   	pop    %ebp
    release(&p->lock);
80103564:	e9 f7 0f 00 00       	jmp    80104560 <release>
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	53                   	push   %ebx
80103574:	e8 e7 0f 00 00       	call   80104560 <release>
    kfree((char*)p);
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103582:	5b                   	pop    %ebx
80103583:	5e                   	pop    %esi
80103584:	5d                   	pop    %ebp
    kfree((char*)p);
80103585:	e9 16 ef ff ff       	jmp    801024a0 <kfree>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103599:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035a0:	00 00 00 
    wakeup(&p->nwrite);
801035a3:	50                   	push   %eax
801035a4:	e8 57 0b 00 00       	call   80104100 <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	eb 99                	jmp    80103547 <pipeclose+0x37>
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 28             	sub    $0x28,%esp
801035b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035bf:	53                   	push   %ebx
801035c0:	e8 fb 0f 00 00       	call   801045c0 <acquire>
  for(i = 0; i < n; i++){
801035c5:	83 c4 10             	add    $0x10,%esp
801035c8:	85 ff                	test   %edi,%edi
801035ca:	0f 8e ce 00 00 00    	jle    8010369e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035d0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035d9:	89 7d 10             	mov    %edi,0x10(%ebp)
801035dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035df:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801035e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035e5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035eb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801035fd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103600:	0f 85 b6 00 00 00    	jne    801036bc <pipewrite+0x10c>
80103606:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103609:	eb 3b                	jmp    80103646 <pipewrite+0x96>
8010360b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103610:	e8 6b 03 00 00       	call   80103980 <myproc>
80103615:	8b 48 24             	mov    0x24(%eax),%ecx
80103618:	85 c9                	test   %ecx,%ecx
8010361a:	75 34                	jne    80103650 <pipewrite+0xa0>
      wakeup(&p->nread);
8010361c:	83 ec 0c             	sub    $0xc,%esp
8010361f:	56                   	push   %esi
80103620:	e8 db 0a 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103625:	58                   	pop    %eax
80103626:	5a                   	pop    %edx
80103627:	53                   	push   %ebx
80103628:	57                   	push   %edi
80103629:	e8 12 0a 00 00       	call   80104040 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010362e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103634:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010363a:	83 c4 10             	add    $0x10,%esp
8010363d:	05 00 02 00 00       	add    $0x200,%eax
80103642:	39 c2                	cmp    %eax,%edx
80103644:	75 2a                	jne    80103670 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103646:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010364c:	85 c0                	test   %eax,%eax
8010364e:	75 c0                	jne    80103610 <pipewrite+0x60>
        release(&p->lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	53                   	push   %ebx
80103654:	e8 07 0f 00 00       	call   80104560 <release>
        return -1;
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103661:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103664:	5b                   	pop    %ebx
80103665:	5e                   	pop    %esi
80103666:	5f                   	pop    %edi
80103667:	5d                   	pop    %ebp
80103668:	c3                   	ret
80103669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103670:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103673:	8d 42 01             	lea    0x1(%edx),%eax
80103676:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010367c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010367f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103685:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103688:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010368c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103690:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103693:	39 c1                	cmp    %eax,%ecx
80103695:	0f 85 50 ff ff ff    	jne    801035eb <pipewrite+0x3b>
8010369b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010369e:	83 ec 0c             	sub    $0xc,%esp
801036a1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036a7:	50                   	push   %eax
801036a8:	e8 53 0a 00 00       	call   80104100 <wakeup>
  release(&p->lock);
801036ad:	89 1c 24             	mov    %ebx,(%esp)
801036b0:	e8 ab 0e 00 00       	call   80104560 <release>
  return n;
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	89 f8                	mov    %edi,%eax
801036ba:	eb a5                	jmp    80103661 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036bf:	eb b2                	jmp    80103673 <pipewrite+0xc3>
801036c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036c8:	00 
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 d5 0e 00 00       	call   801045c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 7b 02 00 00       	call   80103980 <myproc>
80103705:	8b 40 24             	mov    0x24(%eax),%eax
80103708:	85 c0                	test   %eax,%eax
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 26 09 00 00       	call   80104040 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103731:	85 d2                	test   %edx,%edx
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 c9                	test   %ecx,%ecx
8010373c:	7f 26                	jg     80103764 <piperead+0x94>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 85 09 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 dd 0d 00 00       	call   80104560 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 c2 0d 00 00       	call   80104560 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 1d 11 80       	push   $0x80111d20
801037c1:	e8 fa 0d 00 00       	call   801045c0 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 14                	jmp    801037df <allocproc+0x2f>
801037cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	83 eb 80             	sub    $0xffffff80,%ebx
801037d3:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
801037d9:	0f 84 81 00 00 00    	je     80103860 <allocproc+0xb0>
    if(p->state == UNUSED)
801037df:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e2:	85 c0                	test   %eax,%eax
801037e4:	75 ea                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e6:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->page_faults=0;

  release(&ptable.lock);
801037eb:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ee:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->page_faults=0;
801037f5:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801037fc:	89 43 10             	mov    %eax,0x10(%ebx)
801037ff:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103802:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103807:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010380d:	e8 4e 0d 00 00       	call   80104560 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103812:	e8 49 ee ff ff       	call   80102660 <kalloc>
80103817:	83 c4 10             	add    $0x10,%esp
8010381a:	89 43 08             	mov    %eax,0x8(%ebx)
8010381d:	85 c0                	test   %eax,%eax
8010381f:	74 58                	je     80103879 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103821:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103827:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010382a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010382f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103832:	c7 40 14 f8 58 10 80 	movl   $0x801058f8,0x14(%eax)
  p->context = (struct context*)sp;
80103839:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010383c:	6a 14                	push   $0x14
8010383e:	6a 00                	push   $0x0
80103840:	50                   	push   %eax
80103841:	e8 7a 0e 00 00       	call   801046c0 <memset>
  p->context->eip = (uint)forkret;
80103846:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103849:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010384c:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
}
80103853:	89 d8                	mov    %ebx,%eax
80103855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103858:	c9                   	leave
80103859:	c3                   	ret
8010385a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103863:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103865:	68 20 1d 11 80       	push   $0x80111d20
8010386a:	e8 f1 0c 00 00       	call   80104560 <release>
  return 0;
8010386f:	83 c4 10             	add    $0x10,%esp
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave
80103878:	c3                   	ret
    p->state = UNUSED;
80103879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103880:	31 db                	xor    %ebx,%ebx
80103882:	eb ee                	jmp    80103872 <allocproc+0xc2>
80103884:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010388b:	00 
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 20 1d 11 80       	push   $0x80111d20
8010389b:	e8 c0 0c 00 00       	call   80104560 <release>

  if (first) {
801038a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave
801038ad:	c3                   	ret
801038ae:	66 90                	xchg   %ax,%ax
    first = 0;
801038b0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038b7:	00 00 00 
    iinit(ROOTDEV);
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	6a 01                	push   $0x1
801038bf:	e8 bc dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 d0 f3 ff ff       	call   80102ca0 <initlog>
}
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	c9                   	leave
801038d4:	c3                   	ret
801038d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038dc:	00 
801038dd:	8d 76 00             	lea    0x0(%esi),%esi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 36 75 10 80       	push   $0x80107536
801038eb:	68 20 1d 11 80       	push   $0x80111d20
801038f0:	e8 db 0a 00 00       	call   801043d0 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave
801038f9:	c3                   	ret
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 46                	jne    80103952 <mycpu+0x52>
  apicid = lapicid();
8010390c:	e8 bf ef ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 2a                	jle    80103945 <mycpu+0x45>
8010391b:	31 d2                	xor    %edx,%edx
8010391d:	eb 08                	jmp    80103927 <mycpu+0x27>
8010391f:	90                   	nop
80103920:	83 c2 01             	add    $0x1,%edx
80103923:	39 f2                	cmp    %esi,%edx
80103925:	74 1e                	je     80103945 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103927:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010392d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103934:	39 c3                	cmp    %eax,%ebx
80103936:	75 e8                	jne    80103920 <mycpu+0x20>
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010393b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret
  panic("unknown apicid\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 3d 75 10 80       	push   $0x8010753d
8010394d:	e8 2e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103952:	83 ec 0c             	sub    $0xc,%esp
80103955:	68 e0 78 10 80       	push   $0x801078e0
8010395a:	e8 21 ca ff ff       	call   80100380 <panic>
8010395f:	90                   	nop

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 95 ff ff ff       	call   80103900 <mycpu>
}
8010396b:	c9                   	leave
  return mycpu()-cpus;
8010396c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret
8010397b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 e4 0a 00 00       	call   80104470 <pushcli>
  c = mycpu();
8010398c:	e8 6f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 24 0b 00 00       	call   801044c0 <popcli>
}
8010399c:	89 d8                	mov    %ebx,%eax
8010399e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a1:	c9                   	leave
801039a2:	c3                   	ret
801039a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039aa:	00 
801039ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 f4 fd ff ff       	call   801037b0 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 54 3d 11 80       	mov    %eax,0x80113d54
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 d8 35 00 00       	call   80106fa0 <setupkvm>
801039c8:	89 43 04             	mov    %eax,0x4(%ebx)
801039cb:	85 c0                	test   %eax,%eax
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 a4 10 80       	push   $0x8010a460
801039e0:	50                   	push   %eax
801039e1:	e8 9a 32 00 00       	call   80106c80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	push   0x18(%ebx)
801039f6:	e8 c5 0c 00 00       	call   801046c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 66 75 10 80       	push   $0x80107566
80103a54:	50                   	push   %eax
80103a55:	e8 16 0e 00 00       	call   80104870 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 6f 75 10 80 	movl   $0x8010756f,(%esp)
80103a61:	e8 1a e6 ff ff       	call   80102080 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a70:	e8 4b 0b 00 00       	call   801045c0 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a83:	e8 d8 0a 00 00       	call   80104560 <release>
}
80103a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	c9                   	leave
80103a8f:	c3                   	ret
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 4d 75 10 80       	push   $0x8010754d
80103a98:	e8 e3 c8 ff ff       	call   80100380 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 c3 09 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103aad:	e8 4e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 03 0a 00 00       	call   801044c0 <popcli>
  sz = curproc->sz;
80103abd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103abf:	85 f6                	test   %esi,%esi
80103ac1:	7f 1d                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac3:	75 3b                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aca:	53                   	push   %ebx
80103acb:	e8 a0 30 00 00       	call   80106b70 <switchuvm>
  return 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	31 c0                	xor    %eax,%eax
}
80103ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5d                   	pop    %ebp
80103adb:	c3                   	ret
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	push   0x4(%ebx)
80103aea:	e8 e1 32 00 00       	call   80106dd0 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 cf                	jne    80103ac5 <growproc+0x25>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d8                	jmp    80103ad5 <growproc+0x35>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 e1 33 00 00       	call   80106ef0 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 af                	jne    80103ac5 <growproc+0x25>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b1f:	00 

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 42 09 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103b2e:	e8 cd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 82 09 00 00       	call   801044c0 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 6d fc ff ff       	call   801037b0 <allocproc>
80103b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 d6 00 00 00    	je     80103c24 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	push   (%ebx)
80103b53:	89 c7                	mov    %eax,%edi
80103b55:	ff 73 04             	push   0x4(%ebx)
80103b58:	e8 33 35 00 00       	call   80107090 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 47 04             	mov    %eax,0x4(%edi)
80103b63:	85 c0                	test   %eax,%eax
80103b65:	0f 84 9a 00 00 00    	je     80103c05 <fork+0xe5>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b75:	89 c8                	mov    %ecx,%eax
80103b77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b86:	8b 40 18             	mov    0x18(%eax),%eax
80103b89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 1f d3 ff ff       	call   80100ec0 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bb3:	83 ec 0c             	sub    $0xc,%esp
80103bb6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bbc:	e8 af db ff ff       	call   80101770 <idup>
80103bc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bcd:	6a 10                	push   $0x10
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	e8 9a 0c 00 00       	call   80104870 <safestrcpy>
  pid = np->pid;
80103bd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bd9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103be0:	e8 db 09 00 00       	call   801045c0 <acquire>
  np->state = RUNNABLE;
80103be5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bec:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bf3:	e8 68 09 00 00       	call   80104560 <release>
  return pid;
80103bf8:	83 c4 10             	add    $0x10,%esp
}
80103bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfe:	89 d8                	mov    %ebx,%eax
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret
    kfree(np->kstack);
80103c05:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c08:	83 ec 0c             	sub    $0xc,%esp
80103c0b:	ff 73 08             	push   0x8(%ebx)
80103c0e:	e8 8d e8 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103c13:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c1a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c1d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c24:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c29:	eb d0                	jmp    80103bfb <fork+0xdb>
80103c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c30 <scheduler>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c39:	e8 c2 fc ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103c3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c45:	00 00 00 
  struct cpu *c = mycpu();
80103c48:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c4a:	8d 78 04             	lea    0x4(%eax),%edi
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c50:	fb                   	sti
    acquire(&ptable.lock);
80103c51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c54:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c59:	68 20 1d 11 80       	push   $0x80111d20
80103c5e:	e8 5d 09 00 00       	call   801045c0 <acquire>
80103c63:	83 c4 10             	add    $0x10,%esp
80103c66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c6d:	00 
80103c6e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c70:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c74:	75 33                	jne    80103ca9 <scheduler+0x79>
      switchuvm(p);
80103c76:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c79:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c7f:	53                   	push   %ebx
80103c80:	e8 eb 2e 00 00       	call   80106b70 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c85:	58                   	pop    %eax
80103c86:	5a                   	pop    %edx
80103c87:	ff 73 1c             	push   0x1c(%ebx)
80103c8a:	57                   	push   %edi
      p->state = RUNNING;
80103c8b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c92:	e8 34 0c 00 00       	call   801048cb <swtch>
      switchkvm();
80103c97:	e8 c4 2e 00 00       	call   80106b60 <switchkvm>
      c->proc = 0;
80103c9c:	83 c4 10             	add    $0x10,%esp
80103c9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ca6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca9:	83 eb 80             	sub    $0xffffff80,%ebx
80103cac:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103cb2:	75 bc                	jne    80103c70 <scheduler+0x40>
    release(&ptable.lock);
80103cb4:	83 ec 0c             	sub    $0xc,%esp
80103cb7:	68 20 1d 11 80       	push   $0x80111d20
80103cbc:	e8 9f 08 00 00       	call   80104560 <release>
    sti();
80103cc1:	83 c4 10             	add    $0x10,%esp
80103cc4:	eb 8a                	jmp    80103c50 <scheduler+0x20>
80103cc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ccd:	00 
80103cce:	66 90                	xchg   %ax,%ax

80103cd0 <sched>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
  pushcli();
80103cd5:	e8 96 07 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103cda:	e8 21 fc ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103cdf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce5:	e8 d6 07 00 00       	call   801044c0 <popcli>
  if(!holding(&ptable.lock))
80103cea:	83 ec 0c             	sub    $0xc,%esp
80103ced:	68 20 1d 11 80       	push   $0x80111d20
80103cf2:	e8 29 08 00 00       	call   80104520 <holding>
80103cf7:	83 c4 10             	add    $0x10,%esp
80103cfa:	85 c0                	test   %eax,%eax
80103cfc:	74 4f                	je     80103d4d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cfe:	e8 fd fb ff ff       	call   80103900 <mycpu>
80103d03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d0a:	75 68                	jne    80103d74 <sched+0xa4>
  if(p->state == RUNNING)
80103d0c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d10:	74 55                	je     80103d67 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d12:	9c                   	pushf
80103d13:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d14:	f6 c4 02             	test   $0x2,%ah
80103d17:	75 41                	jne    80103d5a <sched+0x8a>
  intena = mycpu()->intena;
80103d19:	e8 e2 fb ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d1e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d27:	e8 d4 fb ff ff       	call   80103900 <mycpu>
80103d2c:	83 ec 08             	sub    $0x8,%esp
80103d2f:	ff 70 04             	push   0x4(%eax)
80103d32:	53                   	push   %ebx
80103d33:	e8 93 0b 00 00       	call   801048cb <swtch>
  mycpu()->intena = intena;
80103d38:	e8 c3 fb ff ff       	call   80103900 <mycpu>
}
80103d3d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d49:	5b                   	pop    %ebx
80103d4a:	5e                   	pop    %esi
80103d4b:	5d                   	pop    %ebp
80103d4c:	c3                   	ret
    panic("sched ptable.lock");
80103d4d:	83 ec 0c             	sub    $0xc,%esp
80103d50:	68 71 75 10 80       	push   $0x80107571
80103d55:	e8 26 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 9d 75 10 80       	push   $0x8010759d
80103d62:	e8 19 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d67:	83 ec 0c             	sub    $0xc,%esp
80103d6a:	68 8f 75 10 80       	push   $0x8010758f
80103d6f:	e8 0c c6 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 83 75 10 80       	push   $0x80107583
80103d7c:	e8 ff c5 ff ff       	call   80100380 <panic>
80103d81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d88:	00 
80103d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d90 <exit>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103d99:	e8 e2 fb ff ff       	call   80103980 <myproc>
  if(curproc == initproc)
80103d9e:	39 05 54 3d 11 80    	cmp    %eax,0x80113d54
80103da4:	0f 84 fd 00 00 00    	je     80103ea7 <exit+0x117>
80103daa:	89 c3                	mov    %eax,%ebx
80103dac:	8d 70 28             	lea    0x28(%eax),%esi
80103daf:	8d 78 68             	lea    0x68(%eax),%edi
80103db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103db8:	8b 06                	mov    (%esi),%eax
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 12                	je     80103dd0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dbe:	83 ec 0c             	sub    $0xc,%esp
80103dc1:	50                   	push   %eax
80103dc2:	e8 49 d1 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103dc7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dcd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103dd0:	83 c6 04             	add    $0x4,%esi
80103dd3:	39 f7                	cmp    %esi,%edi
80103dd5:	75 e1                	jne    80103db8 <exit+0x28>
  begin_op();
80103dd7:	e8 64 ef ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103ddc:	83 ec 0c             	sub    $0xc,%esp
80103ddf:	ff 73 68             	push   0x68(%ebx)
80103de2:	e8 e9 da ff ff       	call   801018d0 <iput>
  end_op();
80103de7:	e8 c4 ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103dec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103df3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103dfa:	e8 c1 07 00 00       	call   801045c0 <acquire>
  wakeup1(curproc->parent);
80103dff:	8b 53 14             	mov    0x14(%ebx),%edx
80103e02:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e05:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e0a:	eb 0e                	jmp    80103e1a <exit+0x8a>
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e10:	83 e8 80             	sub    $0xffffff80,%eax
80103e13:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e18:	74 1c                	je     80103e36 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e1e:	75 f0                	jne    80103e10 <exit+0x80>
80103e20:	3b 50 20             	cmp    0x20(%eax),%edx
80103e23:	75 eb                	jne    80103e10 <exit+0x80>
      p->state = RUNNABLE;
80103e25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2c:	83 e8 80             	sub    $0xffffff80,%eax
80103e2f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e34:	75 e4                	jne    80103e1a <exit+0x8a>
      p->parent = initproc;
80103e36:	8b 0d 54 3d 11 80    	mov    0x80113d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e41:	eb 10                	jmp    80103e53 <exit+0xc3>
80103e43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e48:	83 ea 80             	sub    $0xffffff80,%edx
80103e4b:	81 fa 54 3d 11 80    	cmp    $0x80113d54,%edx
80103e51:	74 3b                	je     80103e8e <exit+0xfe>
    if(p->parent == curproc){
80103e53:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e56:	75 f0                	jne    80103e48 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e58:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e5c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e5f:	75 e7                	jne    80103e48 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e61:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e66:	eb 12                	jmp    80103e7a <exit+0xea>
80103e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e6f:	00 
80103e70:	83 e8 80             	sub    $0xffffff80,%eax
80103e73:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103e78:	74 ce                	je     80103e48 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e7e:	75 f0                	jne    80103e70 <exit+0xe0>
80103e80:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e83:	75 eb                	jne    80103e70 <exit+0xe0>
      p->state = RUNNABLE;
80103e85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e8c:	eb e2                	jmp    80103e70 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e8e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103e95:	e8 36 fe ff ff       	call   80103cd0 <sched>
  panic("zombie exit");
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 be 75 10 80       	push   $0x801075be
80103ea2:	e8 d9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ea7:	83 ec 0c             	sub    $0xc,%esp
80103eaa:	68 b1 75 10 80       	push   $0x801075b1
80103eaf:	e8 cc c4 ff ff       	call   80100380 <panic>
80103eb4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ebb:	00 
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ec0 <wait>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  pushcli();
80103ec5:	e8 a6 05 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103eca:	e8 31 fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ecf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ed5:	e8 e6 05 00 00       	call   801044c0 <popcli>
  acquire(&ptable.lock);
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 20 1d 11 80       	push   $0x80111d20
80103ee2:	e8 d9 06 00 00       	call   801045c0 <acquire>
80103ee7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103ef1:	eb 10                	jmp    80103f03 <wait+0x43>
80103ef3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ef8:	83 eb 80             	sub    $0xffffff80,%ebx
80103efb:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103f01:	74 1b                	je     80103f1e <wait+0x5e>
      if(p->parent != curproc)
80103f03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f06:	75 f0                	jne    80103ef8 <wait+0x38>
      if(p->state == ZOMBIE){
80103f08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f0c:	74 62                	je     80103f70 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103f11:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f16:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103f1c:	75 e5                	jne    80103f03 <wait+0x43>
    if(!havekids || curproc->killed){
80103f1e:	85 c0                	test   %eax,%eax
80103f20:	0f 84 a0 00 00 00    	je     80103fc6 <wait+0x106>
80103f26:	8b 46 24             	mov    0x24(%esi),%eax
80103f29:	85 c0                	test   %eax,%eax
80103f2b:	0f 85 95 00 00 00    	jne    80103fc6 <wait+0x106>
  pushcli();
80103f31:	e8 3a 05 00 00       	call   80104470 <pushcli>
  c = mycpu();
80103f36:	e8 c5 f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f3b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f41:	e8 7a 05 00 00       	call   801044c0 <popcli>
  if(p == 0)
80103f46:	85 db                	test   %ebx,%ebx
80103f48:	0f 84 8f 00 00 00    	je     80103fdd <wait+0x11d>
  p->chan = chan;
80103f4e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f51:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f58:	e8 73 fd ff ff       	call   80103cd0 <sched>
  p->chan = 0;
80103f5d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f64:	eb 84                	jmp    80103eea <wait+0x2a>
80103f66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f6d:	00 
80103f6e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80103f70:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f73:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f76:	ff 73 08             	push   0x8(%ebx)
80103f79:	e8 22 e5 ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
80103f7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f85:	5a                   	pop    %edx
80103f86:	ff 73 04             	push   0x4(%ebx)
80103f89:	e8 92 2f 00 00       	call   80106f20 <freevm>
        p->pid = 0;
80103f8e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f95:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f9c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fa0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fa7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fae:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fb5:	e8 a6 05 00 00       	call   80104560 <release>
        return pid;
80103fba:	83 c4 10             	add    $0x10,%esp
}
80103fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fc0:	89 f0                	mov    %esi,%eax
80103fc2:	5b                   	pop    %ebx
80103fc3:	5e                   	pop    %esi
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret
      release(&ptable.lock);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fc9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fce:	68 20 1d 11 80       	push   $0x80111d20
80103fd3:	e8 88 05 00 00       	call   80104560 <release>
      return -1;
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	eb e0                	jmp    80103fbd <wait+0xfd>
    panic("sleep");
80103fdd:	83 ec 0c             	sub    $0xc,%esp
80103fe0:	68 ca 75 10 80       	push   $0x801075ca
80103fe5:	e8 96 c3 ff ff       	call   80100380 <panic>
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ff0 <yield>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ff7:	68 20 1d 11 80       	push   $0x80111d20
80103ffc:	e8 bf 05 00 00       	call   801045c0 <acquire>
  pushcli();
80104001:	e8 6a 04 00 00       	call   80104470 <pushcli>
  c = mycpu();
80104006:	e8 f5 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010400b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104011:	e8 aa 04 00 00       	call   801044c0 <popcli>
  myproc()->state = RUNNABLE;
80104016:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010401d:	e8 ae fc ff ff       	call   80103cd0 <sched>
  release(&ptable.lock);
80104022:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104029:	e8 32 05 00 00       	call   80104560 <release>
}
8010402e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104031:	83 c4 10             	add    $0x10,%esp
80104034:	c9                   	leave
80104035:	c3                   	ret
80104036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010403d:	00 
8010403e:	66 90                	xchg   %ax,%ax

80104040 <sleep>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	8b 7d 08             	mov    0x8(%ebp),%edi
8010404c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010404f:	e8 1c 04 00 00       	call   80104470 <pushcli>
  c = mycpu();
80104054:	e8 a7 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80104059:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010405f:	e8 5c 04 00 00       	call   801044c0 <popcli>
  if(p == 0)
80104064:	85 db                	test   %ebx,%ebx
80104066:	0f 84 87 00 00 00    	je     801040f3 <sleep+0xb3>
  if(lk == 0)
8010406c:	85 f6                	test   %esi,%esi
8010406e:	74 76                	je     801040e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104070:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104076:	74 50                	je     801040c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	68 20 1d 11 80       	push   $0x80111d20
80104080:	e8 3b 05 00 00       	call   801045c0 <acquire>
    release(lk);
80104085:	89 34 24             	mov    %esi,(%esp)
80104088:	e8 d3 04 00 00       	call   80104560 <release>
  p->chan = chan;
8010408d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104090:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104097:	e8 34 fc ff ff       	call   80103cd0 <sched>
  p->chan = 0;
8010409c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040a3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040aa:	e8 b1 04 00 00       	call   80104560 <release>
    acquire(lk);
801040af:	83 c4 10             	add    $0x10,%esp
801040b2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b8:	5b                   	pop    %ebx
801040b9:	5e                   	pop    %esi
801040ba:	5f                   	pop    %edi
801040bb:	5d                   	pop    %ebp
    acquire(lk);
801040bc:	e9 ff 04 00 00       	jmp    801045c0 <acquire>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040d2:	e8 f9 fb ff ff       	call   80103cd0 <sched>
  p->chan = 0;
801040d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5f                   	pop    %edi
801040e4:	5d                   	pop    %ebp
801040e5:	c3                   	ret
    panic("sleep without lk");
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	68 d0 75 10 80       	push   $0x801075d0
801040ee:	e8 8d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
801040f3:	83 ec 0c             	sub    $0xc,%esp
801040f6:	68 ca 75 10 80       	push   $0x801075ca
801040fb:	e8 80 c2 ff ff       	call   80100380 <panic>

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410a:	68 20 1d 11 80       	push   $0x80111d20
8010410f:	e8 ac 04 00 00       	call   801045c0 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104117:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010411c:	eb 0c                	jmp    8010412a <wakeup+0x2a>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	83 e8 80             	sub    $0xffffff80,%eax
80104123:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104128:	74 1c                	je     80104146 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010412a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010412e:	75 f0                	jne    80104120 <wakeup+0x20>
80104130:	3b 58 20             	cmp    0x20(%eax),%ebx
80104133:	75 eb                	jne    80104120 <wakeup+0x20>
      p->state = RUNNABLE;
80104135:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413c:	83 e8 80             	sub    $0xffffff80,%eax
8010413f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104144:	75 e4                	jne    8010412a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104146:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010414d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104150:	c9                   	leave
  release(&ptable.lock);
80104151:	e9 0a 04 00 00       	jmp    80104560 <release>
80104156:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010415d:	00 
8010415e:	66 90                	xchg   %ax,%ax

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416a:	68 20 1d 11 80       	push   $0x80111d20
8010416f:	e8 4c 04 00 00       	call   801045c0 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104177:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010417c:	eb 0c                	jmp    8010418a <kill+0x2a>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	83 e8 80             	sub    $0xffffff80,%eax
80104183:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104188:	74 36                	je     801041c0 <kill+0x60>
    if(p->pid == pid){
8010418a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010418d:	75 f1                	jne    80104180 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010418f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104193:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010419a:	75 07                	jne    801041a3 <kill+0x43>
        p->state = RUNNABLE;
8010419c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 20 1d 11 80       	push   $0x80111d20
801041ab:	e8 b0 03 00 00       	call   80104560 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041b3:	83 c4 10             	add    $0x10,%esp
801041b6:	31 c0                	xor    %eax,%eax
}
801041b8:	c9                   	leave
801041b9:	c3                   	ret
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041c0:	83 ec 0c             	sub    $0xc,%esp
801041c3:	68 20 1d 11 80       	push   $0x80111d20
801041c8:	e8 93 03 00 00       	call   80104560 <release>
}
801041cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041d0:	83 c4 10             	add    $0x10,%esp
801041d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041d8:	c9                   	leave
801041d9:	c3                   	ret
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041e8:	53                   	push   %ebx
801041e9:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
801041ee:	83 ec 3c             	sub    $0x3c,%esp
801041f1:	eb 24                	jmp    80104217 <procdump+0x37>
801041f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 d3 77 10 80       	push   $0x801077d3
80104200:	e8 ab c4 ff ff       	call   801006b0 <cprintf>
80104205:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104208:	83 eb 80             	sub    $0xffffff80,%ebx
8010420b:	81 fb c0 3d 11 80    	cmp    $0x80113dc0,%ebx
80104211:	0f 84 81 00 00 00    	je     80104298 <procdump+0xb8>
    if(p->state == UNUSED)
80104217:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010421a:	85 c0                	test   %eax,%eax
8010421c:	74 ea                	je     80104208 <procdump+0x28>
      state = "???";
8010421e:	ba e1 75 10 80       	mov    $0x801075e1,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104223:	83 f8 05             	cmp    $0x5,%eax
80104226:	77 11                	ja     80104239 <procdump+0x59>
80104228:	8b 14 85 00 7c 10 80 	mov    -0x7fef8400(,%eax,4),%edx
      state = "???";
8010422f:	b8 e1 75 10 80       	mov    $0x801075e1,%eax
80104234:	85 d2                	test   %edx,%edx
80104236:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104239:	53                   	push   %ebx
8010423a:	52                   	push   %edx
8010423b:	ff 73 a4             	push   -0x5c(%ebx)
8010423e:	68 e5 75 10 80       	push   $0x801075e5
80104243:	e8 68 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104248:	83 c4 10             	add    $0x10,%esp
8010424b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010424f:	75 a7                	jne    801041f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104251:	83 ec 08             	sub    $0x8,%esp
80104254:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104257:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010425a:	50                   	push   %eax
8010425b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010425e:	8b 40 0c             	mov    0xc(%eax),%eax
80104261:	83 c0 08             	add    $0x8,%eax
80104264:	50                   	push   %eax
80104265:	e8 86 01 00 00       	call   801043f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010426a:	83 c4 10             	add    $0x10,%esp
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
80104270:	8b 17                	mov    (%edi),%edx
80104272:	85 d2                	test   %edx,%edx
80104274:	74 82                	je     801041f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104276:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104279:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010427c:	52                   	push   %edx
8010427d:	68 21 73 10 80       	push   $0x80107321
80104282:	e8 29 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	39 f7                	cmp    %esi,%edi
8010428c:	75 e2                	jne    80104270 <procdump+0x90>
8010428e:	e9 65 ff ff ff       	jmp    801041f8 <procdump+0x18>
80104293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010429b:	5b                   	pop    %ebx
8010429c:	5e                   	pop    %esi
8010429d:	5f                   	pop    %edi
8010429e:	5d                   	pop    %ebp
8010429f:	c3                   	ret

801042a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042aa:	68 18 76 10 80       	push   $0x80107618
801042af:	8d 43 04             	lea    0x4(%ebx),%eax
801042b2:	50                   	push   %eax
801042b3:	e8 18 01 00 00       	call   801043d0 <initlock>
  lk->name = name;
801042b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d1:	c9                   	leave
801042d2:	c3                   	ret
801042d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042da:	00 
801042db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801042e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	56                   	push   %esi
801042e4:	53                   	push   %ebx
801042e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042e8:	8d 73 04             	lea    0x4(%ebx),%esi
801042eb:	83 ec 0c             	sub    $0xc,%esp
801042ee:	56                   	push   %esi
801042ef:	e8 cc 02 00 00       	call   801045c0 <acquire>
  while (lk->locked) {
801042f4:	8b 13                	mov    (%ebx),%edx
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	85 d2                	test   %edx,%edx
801042fb:	74 16                	je     80104313 <acquiresleep+0x33>
801042fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104300:	83 ec 08             	sub    $0x8,%esp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	e8 36 fd ff ff       	call   80104040 <sleep>
  while (lk->locked) {
8010430a:	8b 03                	mov    (%ebx),%eax
8010430c:	83 c4 10             	add    $0x10,%esp
8010430f:	85 c0                	test   %eax,%eax
80104311:	75 ed                	jne    80104300 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104313:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104319:	e8 62 f6 ff ff       	call   80103980 <myproc>
8010431e:	8b 40 10             	mov    0x10(%eax),%eax
80104321:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104324:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104327:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010432a:	5b                   	pop    %ebx
8010432b:	5e                   	pop    %esi
8010432c:	5d                   	pop    %ebp
  release(&lk->lk);
8010432d:	e9 2e 02 00 00       	jmp    80104560 <release>
80104332:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104339:	00 
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104348:	8d 73 04             	lea    0x4(%ebx),%esi
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	56                   	push   %esi
8010434f:	e8 6c 02 00 00       	call   801045c0 <acquire>
  lk->locked = 0;
80104354:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010435a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104361:	89 1c 24             	mov    %ebx,(%esp)
80104364:	e8 97 fd ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
80104369:	83 c4 10             	add    $0x10,%esp
8010436c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010436f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104372:	5b                   	pop    %ebx
80104373:	5e                   	pop    %esi
80104374:	5d                   	pop    %ebp
  release(&lk->lk);
80104375:	e9 e6 01 00 00       	jmp    80104560 <release>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104380 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	31 ff                	xor    %edi,%edi
80104386:	56                   	push   %esi
80104387:	53                   	push   %ebx
80104388:	83 ec 18             	sub    $0x18,%esp
8010438b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010438e:	8d 73 04             	lea    0x4(%ebx),%esi
80104391:	56                   	push   %esi
80104392:	e8 29 02 00 00       	call   801045c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104397:	8b 03                	mov    (%ebx),%eax
80104399:	83 c4 10             	add    $0x10,%esp
8010439c:	85 c0                	test   %eax,%eax
8010439e:	75 18                	jne    801043b8 <holdingsleep+0x38>
  release(&lk->lk);
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	56                   	push   %esi
801043a4:	e8 b7 01 00 00       	call   80104560 <release>
  return r;
}
801043a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ac:	89 f8                	mov    %edi,%eax
801043ae:	5b                   	pop    %ebx
801043af:	5e                   	pop    %esi
801043b0:	5f                   	pop    %edi
801043b1:	5d                   	pop    %ebp
801043b2:	c3                   	ret
801043b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801043b8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043bb:	e8 c0 f5 ff ff       	call   80103980 <myproc>
801043c0:	39 58 10             	cmp    %ebx,0x10(%eax)
801043c3:	0f 94 c0             	sete   %al
801043c6:	0f b6 c0             	movzbl %al,%eax
801043c9:	89 c7                	mov    %eax,%edi
801043cb:	eb d3                	jmp    801043a0 <holdingsleep+0x20>
801043cd:	66 90                	xchg   %ax,%ax
801043cf:	90                   	nop

801043d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043e9:	5d                   	pop    %ebp
801043ea:	c3                   	ret
801043eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801043f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	8b 45 08             	mov    0x8(%ebp),%eax
801043f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801043fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043fd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104402:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104407:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010440c:	76 10                	jbe    8010441e <getcallerpcs+0x2e>
8010440e:	eb 28                	jmp    80104438 <getcallerpcs+0x48>
80104410:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104416:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010441c:	77 1a                	ja     80104438 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010441e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104421:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104424:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104427:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104429:	83 f8 0a             	cmp    $0xa,%eax
8010442c:	75 e2                	jne    80104410 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010442e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104431:	c9                   	leave
80104432:	c3                   	ret
80104433:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104438:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010443b:	83 c1 28             	add    $0x28,%ecx
8010443e:	89 ca                	mov    %ecx,%edx
80104440:	29 c2                	sub    %eax,%edx
80104442:	83 e2 04             	and    $0x4,%edx
80104445:	74 11                	je     80104458 <getcallerpcs+0x68>
    pcs[i] = 0;
80104447:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010444d:	83 c0 04             	add    $0x4,%eax
80104450:	39 c1                	cmp    %eax,%ecx
80104452:	74 da                	je     8010442e <getcallerpcs+0x3e>
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010445e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104461:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104468:	39 c1                	cmp    %eax,%ecx
8010446a:	75 ec                	jne    80104458 <getcallerpcs+0x68>
8010446c:	eb c0                	jmp    8010442e <getcallerpcs+0x3e>
8010446e:	66 90                	xchg   %ax,%ax

80104470 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 04             	sub    $0x4,%esp
80104477:	9c                   	pushf
80104478:	5b                   	pop    %ebx
  asm volatile("cli");
80104479:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010447a:	e8 81 f4 ff ff       	call   80103900 <mycpu>
8010447f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104485:	85 c0                	test   %eax,%eax
80104487:	74 17                	je     801044a0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104489:	e8 72 f4 ff ff       	call   80103900 <mycpu>
8010448e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104498:	c9                   	leave
80104499:	c3                   	ret
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044a0:	e8 5b f4 ff ff       	call   80103900 <mycpu>
801044a5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044ab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044b1:	eb d6                	jmp    80104489 <pushcli+0x19>
801044b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ba:	00 
801044bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044c0 <popcli>:

void
popcli(void)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044c6:	9c                   	pushf
801044c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044c8:	f6 c4 02             	test   $0x2,%ah
801044cb:	75 35                	jne    80104502 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044cd:	e8 2e f4 ff ff       	call   80103900 <mycpu>
801044d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044d9:	78 34                	js     8010450f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044db:	e8 20 f4 ff ff       	call   80103900 <mycpu>
801044e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044e6:	85 d2                	test   %edx,%edx
801044e8:	74 06                	je     801044f0 <popcli+0x30>
    sti();
}
801044ea:	c9                   	leave
801044eb:	c3                   	ret
801044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044f0:	e8 0b f4 ff ff       	call   80103900 <mycpu>
801044f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044fb:	85 c0                	test   %eax,%eax
801044fd:	74 eb                	je     801044ea <popcli+0x2a>
  asm volatile("sti");
801044ff:	fb                   	sti
}
80104500:	c9                   	leave
80104501:	c3                   	ret
    panic("popcli - interruptible");
80104502:	83 ec 0c             	sub    $0xc,%esp
80104505:	68 23 76 10 80       	push   $0x80107623
8010450a:	e8 71 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010450f:	83 ec 0c             	sub    $0xc,%esp
80104512:	68 3a 76 10 80       	push   $0x8010763a
80104517:	e8 64 be ff ff       	call   80100380 <panic>
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <holding>:
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	8b 75 08             	mov    0x8(%ebp),%esi
80104528:	31 db                	xor    %ebx,%ebx
  pushcli();
8010452a:	e8 41 ff ff ff       	call   80104470 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010452f:	8b 06                	mov    (%esi),%eax
80104531:	85 c0                	test   %eax,%eax
80104533:	75 0b                	jne    80104540 <holding+0x20>
  popcli();
80104535:	e8 86 ff ff ff       	call   801044c0 <popcli>
}
8010453a:	89 d8                	mov    %ebx,%eax
8010453c:	5b                   	pop    %ebx
8010453d:	5e                   	pop    %esi
8010453e:	5d                   	pop    %ebp
8010453f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104540:	8b 5e 08             	mov    0x8(%esi),%ebx
80104543:	e8 b8 f3 ff ff       	call   80103900 <mycpu>
80104548:	39 c3                	cmp    %eax,%ebx
8010454a:	0f 94 c3             	sete   %bl
  popcli();
8010454d:	e8 6e ff ff ff       	call   801044c0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104552:	0f b6 db             	movzbl %bl,%ebx
}
80104555:	89 d8                	mov    %ebx,%eax
80104557:	5b                   	pop    %ebx
80104558:	5e                   	pop    %esi
80104559:	5d                   	pop    %ebp
8010455a:	c3                   	ret
8010455b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104560 <release>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104568:	e8 03 ff ff ff       	call   80104470 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010456d:	8b 03                	mov    (%ebx),%eax
8010456f:	85 c0                	test   %eax,%eax
80104571:	75 15                	jne    80104588 <release+0x28>
  popcli();
80104573:	e8 48 ff ff ff       	call   801044c0 <popcli>
    panic("release");
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	68 41 76 10 80       	push   $0x80107641
80104580:	e8 fb bd ff ff       	call   80100380 <panic>
80104585:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104588:	8b 73 08             	mov    0x8(%ebx),%esi
8010458b:	e8 70 f3 ff ff       	call   80103900 <mycpu>
80104590:	39 c6                	cmp    %eax,%esi
80104592:	75 df                	jne    80104573 <release+0x13>
  popcli();
80104594:	e8 27 ff ff ff       	call   801044c0 <popcli>
  lk->pcs[0] = 0;
80104599:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045a0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045a7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b5:	5b                   	pop    %ebx
801045b6:	5e                   	pop    %esi
801045b7:	5d                   	pop    %ebp
  popcli();
801045b8:	e9 03 ff ff ff       	jmp    801044c0 <popcli>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi

801045c0 <acquire>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045c7:	e8 a4 fe ff ff       	call   80104470 <pushcli>
  if(holding(lk))
801045cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045cf:	e8 9c fe ff ff       	call   80104470 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045d4:	8b 03                	mov    (%ebx),%eax
801045d6:	85 c0                	test   %eax,%eax
801045d8:	0f 85 b2 00 00 00    	jne    80104690 <acquire+0xd0>
  popcli();
801045de:	e8 dd fe ff ff       	call   801044c0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801045e3:	b9 01 00 00 00       	mov    $0x1,%ecx
801045e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045ef:	00 
  while(xchg(&lk->locked, 1) != 0)
801045f0:	8b 55 08             	mov    0x8(%ebp),%edx
801045f3:	89 c8                	mov    %ecx,%eax
801045f5:	f0 87 02             	lock xchg %eax,(%edx)
801045f8:	85 c0                	test   %eax,%eax
801045fa:	75 f4                	jne    801045f0 <acquire+0x30>
  __sync_synchronize();
801045fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104601:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104604:	e8 f7 f2 ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010460c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010460e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104611:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104617:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010461c:	77 32                	ja     80104650 <acquire+0x90>
  ebp = (uint*)v - 2;
8010461e:	89 e8                	mov    %ebp,%eax
80104620:	eb 14                	jmp    80104636 <acquire+0x76>
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104628:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010462e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104634:	77 1a                	ja     80104650 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104636:	8b 58 04             	mov    0x4(%eax),%ebx
80104639:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010463d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104640:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104642:	83 fa 0a             	cmp    $0xa,%edx
80104645:	75 e1                	jne    80104628 <acquire+0x68>
}
80104647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010464a:	c9                   	leave
8010464b:	c3                   	ret
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104650:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104654:	83 c1 34             	add    $0x34,%ecx
80104657:	89 ca                	mov    %ecx,%edx
80104659:	29 c2                	sub    %eax,%edx
8010465b:	83 e2 04             	and    $0x4,%edx
8010465e:	74 10                	je     80104670 <acquire+0xb0>
    pcs[i] = 0;
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 c1                	cmp    %eax,%ecx
8010466b:	74 da                	je     80104647 <acquire+0x87>
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104676:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104679:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104680:	39 c1                	cmp    %eax,%ecx
80104682:	75 ec                	jne    80104670 <acquire+0xb0>
80104684:	eb c1                	jmp    80104647 <acquire+0x87>
80104686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010468d:	00 
8010468e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104690:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104693:	e8 68 f2 ff ff       	call   80103900 <mycpu>
80104698:	39 c3                	cmp    %eax,%ebx
8010469a:	0f 85 3e ff ff ff    	jne    801045de <acquire+0x1e>
  popcli();
801046a0:	e8 1b fe ff ff       	call   801044c0 <popcli>
    panic("acquire");
801046a5:	83 ec 0c             	sub    $0xc,%esp
801046a8:	68 49 76 10 80       	push   $0x80107649
801046ad:	e8 ce bc ff ff       	call   80100380 <panic>
801046b2:	66 90                	xchg   %ax,%ax
801046b4:	66 90                	xchg   %ax,%ax
801046b6:	66 90                	xchg   %ax,%ax
801046b8:	66 90                	xchg   %ax,%ax
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	8b 55 08             	mov    0x8(%ebp),%edx
801046c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046ca:	89 d0                	mov    %edx,%eax
801046cc:	09 c8                	or     %ecx,%eax
801046ce:	a8 03                	test   $0x3,%al
801046d0:	75 1e                	jne    801046f0 <memset+0x30>
    c &= 0xFF;
801046d2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046d6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801046d9:	89 d7                	mov    %edx,%edi
801046db:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801046e1:	fc                   	cld
801046e2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046e4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801046e7:	89 d0                	mov    %edx,%eax
801046e9:	c9                   	leave
801046ea:	c3                   	ret
801046eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801046f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801046f3:	89 d7                	mov    %edx,%edi
801046f5:	fc                   	cld
801046f6:	f3 aa                	rep stos %al,%es:(%edi)
801046f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801046fb:	89 d0                	mov    %edx,%eax
801046fd:	c9                   	leave
801046fe:	c3                   	ret
801046ff:	90                   	nop

80104700 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	8b 75 10             	mov    0x10(%ebp),%esi
80104707:	8b 45 08             	mov    0x8(%ebp),%eax
8010470a:	53                   	push   %ebx
8010470b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010470e:	85 f6                	test   %esi,%esi
80104710:	74 2e                	je     80104740 <memcmp+0x40>
80104712:	01 c6                	add    %eax,%esi
80104714:	eb 14                	jmp    8010472a <memcmp+0x2a>
80104716:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010471d:	00 
8010471e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104720:	83 c0 01             	add    $0x1,%eax
80104723:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104726:	39 f0                	cmp    %esi,%eax
80104728:	74 16                	je     80104740 <memcmp+0x40>
    if(*s1 != *s2)
8010472a:	0f b6 08             	movzbl (%eax),%ecx
8010472d:	0f b6 1a             	movzbl (%edx),%ebx
80104730:	38 d9                	cmp    %bl,%cl
80104732:	74 ec                	je     80104720 <memcmp+0x20>
      return *s1 - *s2;
80104734:	0f b6 c1             	movzbl %cl,%eax
80104737:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104739:	5b                   	pop    %ebx
8010473a:	5e                   	pop    %esi
8010473b:	5d                   	pop    %ebp
8010473c:	c3                   	ret
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
80104740:	5b                   	pop    %ebx
  return 0;
80104741:	31 c0                	xor    %eax,%eax
}
80104743:	5e                   	pop    %esi
80104744:	5d                   	pop    %ebp
80104745:	c3                   	ret
80104746:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474d:	00 
8010474e:	66 90                	xchg   %ax,%ax

80104750 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	8b 55 08             	mov    0x8(%ebp),%edx
80104757:	8b 45 10             	mov    0x10(%ebp),%eax
8010475a:	56                   	push   %esi
8010475b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010475e:	39 d6                	cmp    %edx,%esi
80104760:	73 26                	jae    80104788 <memmove+0x38>
80104762:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104765:	39 ca                	cmp    %ecx,%edx
80104767:	73 1f                	jae    80104788 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104769:	85 c0                	test   %eax,%eax
8010476b:	74 0f                	je     8010477c <memmove+0x2c>
8010476d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104770:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104774:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104777:	83 e8 01             	sub    $0x1,%eax
8010477a:	73 f4                	jae    80104770 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010477c:	5e                   	pop    %esi
8010477d:	89 d0                	mov    %edx,%eax
8010477f:	5f                   	pop    %edi
80104780:	5d                   	pop    %ebp
80104781:	c3                   	ret
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104788:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010478b:	89 d7                	mov    %edx,%edi
8010478d:	85 c0                	test   %eax,%eax
8010478f:	74 eb                	je     8010477c <memmove+0x2c>
80104791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104798:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104799:	39 ce                	cmp    %ecx,%esi
8010479b:	75 fb                	jne    80104798 <memmove+0x48>
}
8010479d:	5e                   	pop    %esi
8010479e:	89 d0                	mov    %edx,%eax
801047a0:	5f                   	pop    %edi
801047a1:	5d                   	pop    %ebp
801047a2:	c3                   	ret
801047a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047aa:	00 
801047ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047b0:	eb 9e                	jmp    80104750 <memmove>
801047b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047b9:	00 
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	8b 55 10             	mov    0x10(%ebp),%edx
801047c7:	8b 45 08             	mov    0x8(%ebp),%eax
801047ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801047cd:	85 d2                	test   %edx,%edx
801047cf:	75 16                	jne    801047e7 <strncmp+0x27>
801047d1:	eb 2d                	jmp    80104800 <strncmp+0x40>
801047d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801047d8:	3a 19                	cmp    (%ecx),%bl
801047da:	75 12                	jne    801047ee <strncmp+0x2e>
    n--, p++, q++;
801047dc:	83 c0 01             	add    $0x1,%eax
801047df:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047e2:	83 ea 01             	sub    $0x1,%edx
801047e5:	74 19                	je     80104800 <strncmp+0x40>
801047e7:	0f b6 18             	movzbl (%eax),%ebx
801047ea:	84 db                	test   %bl,%bl
801047ec:	75 ea                	jne    801047d8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047ee:	0f b6 00             	movzbl (%eax),%eax
801047f1:	0f b6 11             	movzbl (%ecx),%edx
}
801047f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801047f8:	29 d0                	sub    %edx,%eax
}
801047fa:	c3                   	ret
801047fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104803:	31 c0                	xor    %eax,%eax
}
80104805:	c9                   	leave
80104806:	c3                   	ret
80104807:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010480e:	00 
8010480f:	90                   	nop

80104810 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	8b 75 08             	mov    0x8(%ebp),%esi
80104818:	53                   	push   %ebx
80104819:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010481c:	89 f0                	mov    %esi,%eax
8010481e:	eb 15                	jmp    80104835 <strncpy+0x25>
80104820:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104824:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104827:	83 c0 01             	add    $0x1,%eax
8010482a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010482e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104831:	84 c9                	test   %cl,%cl
80104833:	74 13                	je     80104848 <strncpy+0x38>
80104835:	89 d3                	mov    %edx,%ebx
80104837:	83 ea 01             	sub    $0x1,%edx
8010483a:	85 db                	test   %ebx,%ebx
8010483c:	7f e2                	jg     80104820 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010483e:	5b                   	pop    %ebx
8010483f:	89 f0                	mov    %esi,%eax
80104841:	5e                   	pop    %esi
80104842:	5f                   	pop    %edi
80104843:	5d                   	pop    %ebp
80104844:	c3                   	ret
80104845:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104848:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010484b:	83 e9 01             	sub    $0x1,%ecx
8010484e:	85 d2                	test   %edx,%edx
80104850:	74 ec                	je     8010483e <strncpy+0x2e>
80104852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104858:	83 c0 01             	add    $0x1,%eax
8010485b:	89 ca                	mov    %ecx,%edx
8010485d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104861:	29 c2                	sub    %eax,%edx
80104863:	85 d2                	test   %edx,%edx
80104865:	7f f1                	jg     80104858 <strncpy+0x48>
}
80104867:	5b                   	pop    %ebx
80104868:	89 f0                	mov    %esi,%eax
8010486a:	5e                   	pop    %esi
8010486b:	5f                   	pop    %edi
8010486c:	5d                   	pop    %ebp
8010486d:	c3                   	ret
8010486e:	66 90                	xchg   %ax,%ax

80104870 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	8b 55 10             	mov    0x10(%ebp),%edx
80104877:	8b 75 08             	mov    0x8(%ebp),%esi
8010487a:	53                   	push   %ebx
8010487b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010487e:	85 d2                	test   %edx,%edx
80104880:	7e 25                	jle    801048a7 <safestrcpy+0x37>
80104882:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104886:	89 f2                	mov    %esi,%edx
80104888:	eb 16                	jmp    801048a0 <safestrcpy+0x30>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104890:	0f b6 08             	movzbl (%eax),%ecx
80104893:	83 c0 01             	add    $0x1,%eax
80104896:	83 c2 01             	add    $0x1,%edx
80104899:	88 4a ff             	mov    %cl,-0x1(%edx)
8010489c:	84 c9                	test   %cl,%cl
8010489e:	74 04                	je     801048a4 <safestrcpy+0x34>
801048a0:	39 d8                	cmp    %ebx,%eax
801048a2:	75 ec                	jne    80104890 <safestrcpy+0x20>
    ;
  *s = 0;
801048a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048a7:	89 f0                	mov    %esi,%eax
801048a9:	5b                   	pop    %ebx
801048aa:	5e                   	pop    %esi
801048ab:	5d                   	pop    %ebp
801048ac:	c3                   	ret
801048ad:	8d 76 00             	lea    0x0(%esi),%esi

801048b0 <strlen>:

int
strlen(const char *s)
{
801048b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048b1:	31 c0                	xor    %eax,%eax
{
801048b3:	89 e5                	mov    %esp,%ebp
801048b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048b8:	80 3a 00             	cmpb   $0x0,(%edx)
801048bb:	74 0c                	je     801048c9 <strlen+0x19>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048c7:	75 f7                	jne    801048c0 <strlen+0x10>
    ;
  return n;
}
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret

801048cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048d3:	55                   	push   %ebp
  pushl %ebx
801048d4:	53                   	push   %ebx
  pushl %esi
801048d5:	56                   	push   %esi
  pushl %edi
801048d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048db:	5f                   	pop    %edi
  popl %esi
801048dc:	5e                   	pop    %esi
  popl %ebx
801048dd:	5b                   	pop    %ebx
  popl %ebp
801048de:	5d                   	pop    %ebp
  ret
801048df:	c3                   	ret

801048e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ea:	e8 91 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ef:	8b 00                	mov    (%eax),%eax
801048f1:	39 c3                	cmp    %eax,%ebx
801048f3:	73 1b                	jae    80104910 <fetchint+0x30>
801048f5:	8d 53 04             	lea    0x4(%ebx),%edx
801048f8:	39 d0                	cmp    %edx,%eax
801048fa:	72 14                	jb     80104910 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ff:	8b 13                	mov    (%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104908:	c9                   	leave
80104909:	c3                   	ret
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104915:	eb ee                	jmp    80104905 <fetchint+0x25>
80104917:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010491e:	00 
8010491f:	90                   	nop

80104920 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010492a:	e8 51 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
8010492f:	3b 18                	cmp    (%eax),%ebx
80104931:	73 2d                	jae    80104960 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104933:	8b 55 0c             	mov    0xc(%ebp),%edx
80104936:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104938:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010493a:	39 d3                	cmp    %edx,%ebx
8010493c:	73 22                	jae    80104960 <fetchstr+0x40>
8010493e:	89 d8                	mov    %ebx,%eax
80104940:	eb 0d                	jmp    8010494f <fetchstr+0x2f>
80104942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104948:	83 c0 01             	add    $0x1,%eax
8010494b:	39 d0                	cmp    %edx,%eax
8010494d:	73 11                	jae    80104960 <fetchstr+0x40>
    if(*s == 0)
8010494f:	80 38 00             	cmpb   $0x0,(%eax)
80104952:	75 f4                	jne    80104948 <fetchstr+0x28>
      return s - *pp;
80104954:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104959:	c9                   	leave
8010495a:	c3                   	ret
8010495b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104968:	c9                   	leave
80104969:	c3                   	ret
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104975:	e8 06 f0 ff ff       	call   80103980 <myproc>
8010497a:	8b 55 08             	mov    0x8(%ebp),%edx
8010497d:	8b 40 18             	mov    0x18(%eax),%eax
80104980:	8b 40 44             	mov    0x44(%eax),%eax
80104983:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104986:	e8 f5 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010498e:	8b 00                	mov    (%eax),%eax
80104990:	39 c6                	cmp    %eax,%esi
80104992:	73 1c                	jae    801049b0 <argint+0x40>
80104994:	8d 53 08             	lea    0x8(%ebx),%edx
80104997:	39 d0                	cmp    %edx,%eax
80104999:	72 15                	jb     801049b0 <argint+0x40>
  *ip = *(int*)(addr);
8010499b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010499e:	8b 53 04             	mov    0x4(%ebx),%edx
801049a1:	89 10                	mov    %edx,(%eax)
  return 0;
801049a3:	31 c0                	xor    %eax,%eax
}
801049a5:	5b                   	pop    %ebx
801049a6:	5e                   	pop    %esi
801049a7:	5d                   	pop    %ebp
801049a8:	c3                   	ret
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b5:	eb ee                	jmp    801049a5 <argint+0x35>
801049b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049be:	00 
801049bf:	90                   	nop

801049c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	53                   	push   %ebx
801049c6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049c9:	e8 b2 ef ff ff       	call   80103980 <myproc>
801049ce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049d0:	e8 ab ef ff ff       	call   80103980 <myproc>
801049d5:	8b 55 08             	mov    0x8(%ebp),%edx
801049d8:	8b 40 18             	mov    0x18(%eax),%eax
801049db:	8b 40 44             	mov    0x44(%eax),%eax
801049de:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049e1:	e8 9a ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049e9:	8b 00                	mov    (%eax),%eax
801049eb:	39 c7                	cmp    %eax,%edi
801049ed:	73 31                	jae    80104a20 <argptr+0x60>
801049ef:	8d 4b 08             	lea    0x8(%ebx),%ecx
801049f2:	39 c8                	cmp    %ecx,%eax
801049f4:	72 2a                	jb     80104a20 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049f6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801049f9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049fc:	85 d2                	test   %edx,%edx
801049fe:	78 20                	js     80104a20 <argptr+0x60>
80104a00:	8b 16                	mov    (%esi),%edx
80104a02:	39 d0                	cmp    %edx,%eax
80104a04:	73 1a                	jae    80104a20 <argptr+0x60>
80104a06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a09:	01 c3                	add    %eax,%ebx
80104a0b:	39 da                	cmp    %ebx,%edx
80104a0d:	72 11                	jb     80104a20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a12:	89 02                	mov    %eax,(%edx)
  return 0;
80104a14:	31 c0                	xor    %eax,%eax
}
80104a16:	83 c4 0c             	add    $0xc,%esp
80104a19:	5b                   	pop    %ebx
80104a1a:	5e                   	pop    %esi
80104a1b:	5f                   	pop    %edi
80104a1c:	5d                   	pop    %ebp
80104a1d:	c3                   	ret
80104a1e:	66 90                	xchg   %ax,%ax
    return -1;
80104a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a25:	eb ef                	jmp    80104a16 <argptr+0x56>
80104a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a2e:	00 
80104a2f:	90                   	nop

80104a30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a35:	e8 46 ef ff ff       	call   80103980 <myproc>
80104a3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a3d:	8b 40 18             	mov    0x18(%eax),%eax
80104a40:	8b 40 44             	mov    0x44(%eax),%eax
80104a43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a46:	e8 35 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a4e:	8b 00                	mov    (%eax),%eax
80104a50:	39 c6                	cmp    %eax,%esi
80104a52:	73 44                	jae    80104a98 <argstr+0x68>
80104a54:	8d 53 08             	lea    0x8(%ebx),%edx
80104a57:	39 d0                	cmp    %edx,%eax
80104a59:	72 3d                	jb     80104a98 <argstr+0x68>
  *ip = *(int*)(addr);
80104a5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a5e:	e8 1d ef ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz)
80104a63:	3b 18                	cmp    (%eax),%ebx
80104a65:	73 31                	jae    80104a98 <argstr+0x68>
  *pp = (char*)addr;
80104a67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a6e:	39 d3                	cmp    %edx,%ebx
80104a70:	73 26                	jae    80104a98 <argstr+0x68>
80104a72:	89 d8                	mov    %ebx,%eax
80104a74:	eb 11                	jmp    80104a87 <argstr+0x57>
80104a76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7d:	00 
80104a7e:	66 90                	xchg   %ax,%ax
80104a80:	83 c0 01             	add    $0x1,%eax
80104a83:	39 d0                	cmp    %edx,%eax
80104a85:	73 11                	jae    80104a98 <argstr+0x68>
    if(*s == 0)
80104a87:	80 38 00             	cmpb   $0x0,(%eax)
80104a8a:	75 f4                	jne    80104a80 <argstr+0x50>
      return s - *pp;
80104a8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a8e:	5b                   	pop    %ebx
80104a8f:	5e                   	pop    %esi
80104a90:	5d                   	pop    %ebp
80104a91:	c3                   	ret
80104a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a98:	5b                   	pop    %ebx
    return -1;
80104a99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a9e:	5e                   	pop    %esi
80104a9f:	5d                   	pop    %ebp
80104aa0:	c3                   	ret
80104aa1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aa8:	00 
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <syscall>:
[SYS_getpagefaults] sys_getpagefaults,
};

void
syscall(void)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ab7:	e8 c4 ee ff ff       	call   80103980 <myproc>
80104abc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104abe:	8b 40 18             	mov    0x18(%eax),%eax
80104ac1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ac4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ac7:	83 fa 16             	cmp    $0x16,%edx
80104aca:	77 24                	ja     80104af0 <syscall+0x40>
80104acc:	8b 14 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%edx
80104ad3:	85 d2                	test   %edx,%edx
80104ad5:	74 19                	je     80104af0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ad7:	ff d2                	call   *%edx
80104ad9:	89 c2                	mov    %eax,%edx
80104adb:	8b 43 18             	mov    0x18(%ebx),%eax
80104ade:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae4:	c9                   	leave
80104ae5:	c3                   	ret
80104ae6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aed:	00 
80104aee:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104af0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104af1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104af4:	50                   	push   %eax
80104af5:	ff 73 10             	push   0x10(%ebx)
80104af8:	68 51 76 10 80       	push   $0x80107651
80104afd:	e8 ae bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104b02:	8b 43 18             	mov    0x18(%ebx),%eax
80104b05:	83 c4 10             	add    $0x10,%esp
80104b08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b12:	c9                   	leave
80104b13:	c3                   	ret
80104b14:	66 90                	xchg   %ax,%ax
80104b16:	66 90                	xchg   %ax,%ax
80104b18:	66 90                	xchg   %ax,%ax
80104b1a:	66 90                	xchg   %ax,%ax
80104b1c:	66 90                	xchg   %ax,%ax
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b28:	53                   	push   %ebx
80104b29:	83 ec 34             	sub    $0x34,%esp
80104b2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b32:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b35:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b38:	57                   	push   %edi
80104b39:	50                   	push   %eax
80104b3a:	e8 61 d5 ff ff       	call   801020a0 <nameiparent>
80104b3f:	83 c4 10             	add    $0x10,%esp
80104b42:	85 c0                	test   %eax,%eax
80104b44:	74 5e                	je     80104ba4 <create+0x84>
    return 0;
  ilock(dp);
80104b46:	83 ec 0c             	sub    $0xc,%esp
80104b49:	89 c3                	mov    %eax,%ebx
80104b4b:	50                   	push   %eax
80104b4c:	e8 4f cc ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b51:	83 c4 0c             	add    $0xc,%esp
80104b54:	6a 00                	push   $0x0
80104b56:	57                   	push   %edi
80104b57:	53                   	push   %ebx
80104b58:	e8 93 d1 ff ff       	call   80101cf0 <dirlookup>
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	89 c6                	mov    %eax,%esi
80104b62:	85 c0                	test   %eax,%eax
80104b64:	74 4a                	je     80104bb0 <create+0x90>
    iunlockput(dp);
80104b66:	83 ec 0c             	sub    $0xc,%esp
80104b69:	53                   	push   %ebx
80104b6a:	e8 c1 ce ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104b6f:	89 34 24             	mov    %esi,(%esp)
80104b72:	e8 29 cc ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b77:	83 c4 10             	add    $0x10,%esp
80104b7a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b7f:	75 17                	jne    80104b98 <create+0x78>
80104b81:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b86:	75 10                	jne    80104b98 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b8b:	89 f0                	mov    %esi,%eax
80104b8d:	5b                   	pop    %ebx
80104b8e:	5e                   	pop    %esi
80104b8f:	5f                   	pop    %edi
80104b90:	5d                   	pop    %ebp
80104b91:	c3                   	ret
80104b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	56                   	push   %esi
80104b9c:	e8 8f ce ff ff       	call   80101a30 <iunlockput>
    return 0;
80104ba1:	83 c4 10             	add    $0x10,%esp
}
80104ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ba7:	31 f6                	xor    %esi,%esi
}
80104ba9:	5b                   	pop    %ebx
80104baa:	89 f0                	mov    %esi,%eax
80104bac:	5e                   	pop    %esi
80104bad:	5f                   	pop    %edi
80104bae:	5d                   	pop    %ebp
80104baf:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104bb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bb4:	83 ec 08             	sub    $0x8,%esp
80104bb7:	50                   	push   %eax
80104bb8:	ff 33                	push   (%ebx)
80104bba:	e8 71 ca ff ff       	call   80101630 <ialloc>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	89 c6                	mov    %eax,%esi
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	0f 84 bc 00 00 00    	je     80104c88 <create+0x168>
  ilock(ip);
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	50                   	push   %eax
80104bd0:	e8 cb cb ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104bd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104be1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104be5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bee:	89 34 24             	mov    %esi,(%esp)
80104bf1:	e8 fa ca ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bfe:	74 30                	je     80104c30 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104c00:	83 ec 04             	sub    $0x4,%esp
80104c03:	ff 76 04             	push   0x4(%esi)
80104c06:	57                   	push   %edi
80104c07:	53                   	push   %ebx
80104c08:	e8 b3 d3 ff ff       	call   80101fc0 <dirlink>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 67                	js     80104c7b <create+0x15b>
  iunlockput(dp);
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	53                   	push   %ebx
80104c18:	e8 13 ce ff ff       	call   80101a30 <iunlockput>
  return ip;
80104c1d:	83 c4 10             	add    $0x10,%esp
}
80104c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c23:	89 f0                	mov    %esi,%eax
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5f                   	pop    %edi
80104c28:	5d                   	pop    %ebp
80104c29:	c3                   	ret
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c38:	53                   	push   %ebx
80104c39:	e8 b2 ca ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c3e:	83 c4 0c             	add    $0xc,%esp
80104c41:	ff 76 04             	push   0x4(%esi)
80104c44:	68 89 76 10 80       	push   $0x80107689
80104c49:	56                   	push   %esi
80104c4a:	e8 71 d3 ff ff       	call   80101fc0 <dirlink>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 18                	js     80104c6e <create+0x14e>
80104c56:	83 ec 04             	sub    $0x4,%esp
80104c59:	ff 73 04             	push   0x4(%ebx)
80104c5c:	68 88 76 10 80       	push   $0x80107688
80104c61:	56                   	push   %esi
80104c62:	e8 59 d3 ff ff       	call   80101fc0 <dirlink>
80104c67:	83 c4 10             	add    $0x10,%esp
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	79 92                	jns    80104c00 <create+0xe0>
      panic("create dots");
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	68 7c 76 10 80       	push   $0x8010767c
80104c76:	e8 05 b7 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104c7b:	83 ec 0c             	sub    $0xc,%esp
80104c7e:	68 8b 76 10 80       	push   $0x8010768b
80104c83:	e8 f8 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104c88:	83 ec 0c             	sub    $0xc,%esp
80104c8b:	68 6d 76 10 80       	push   $0x8010766d
80104c90:	e8 eb b6 ff ff       	call   80100380 <panic>
80104c95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c9c:	00 
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ca0 <sys_dup>:
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ca8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cab:	50                   	push   %eax
80104cac:	6a 00                	push   $0x0
80104cae:	e8 bd fc ff ff       	call   80104970 <argint>
80104cb3:	83 c4 10             	add    $0x10,%esp
80104cb6:	85 c0                	test   %eax,%eax
80104cb8:	78 36                	js     80104cf0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cbe:	77 30                	ja     80104cf0 <sys_dup+0x50>
80104cc0:	e8 bb ec ff ff       	call   80103980 <myproc>
80104cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ccc:	85 f6                	test   %esi,%esi
80104cce:	74 20                	je     80104cf0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104cd0:	e8 ab ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104cd5:	31 db                	xor    %ebx,%ebx
80104cd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cde:	00 
80104cdf:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104ce0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ce4:	85 d2                	test   %edx,%edx
80104ce6:	74 18                	je     80104d00 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ce8:	83 c3 01             	add    $0x1,%ebx
80104ceb:	83 fb 10             	cmp    $0x10,%ebx
80104cee:	75 f0                	jne    80104ce0 <sys_dup+0x40>
}
80104cf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104cf3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104cf8:	89 d8                	mov    %ebx,%eax
80104cfa:	5b                   	pop    %ebx
80104cfb:	5e                   	pop    %esi
80104cfc:	5d                   	pop    %ebp
80104cfd:	c3                   	ret
80104cfe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d00:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d03:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d07:	56                   	push   %esi
80104d08:	e8 b3 c1 ff ff       	call   80100ec0 <filedup>
  return fd;
80104d0d:	83 c4 10             	add    $0x10,%esp
}
80104d10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d13:	89 d8                	mov    %ebx,%eax
80104d15:	5b                   	pop    %ebx
80104d16:	5e                   	pop    %esi
80104d17:	5d                   	pop    %ebp
80104d18:	c3                   	ret
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d20 <sys_read>:
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d2b:	53                   	push   %ebx
80104d2c:	6a 00                	push   $0x0
80104d2e:	e8 3d fc ff ff       	call   80104970 <argint>
80104d33:	83 c4 10             	add    $0x10,%esp
80104d36:	85 c0                	test   %eax,%eax
80104d38:	78 5e                	js     80104d98 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d3e:	77 58                	ja     80104d98 <sys_read+0x78>
80104d40:	e8 3b ec ff ff       	call   80103980 <myproc>
80104d45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d4c:	85 f6                	test   %esi,%esi
80104d4e:	74 48                	je     80104d98 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d50:	83 ec 08             	sub    $0x8,%esp
80104d53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d56:	50                   	push   %eax
80104d57:	6a 02                	push   $0x2
80104d59:	e8 12 fc ff ff       	call   80104970 <argint>
80104d5e:	83 c4 10             	add    $0x10,%esp
80104d61:	85 c0                	test   %eax,%eax
80104d63:	78 33                	js     80104d98 <sys_read+0x78>
80104d65:	83 ec 04             	sub    $0x4,%esp
80104d68:	ff 75 f0             	push   -0x10(%ebp)
80104d6b:	53                   	push   %ebx
80104d6c:	6a 01                	push   $0x1
80104d6e:	e8 4d fc ff ff       	call   801049c0 <argptr>
80104d73:	83 c4 10             	add    $0x10,%esp
80104d76:	85 c0                	test   %eax,%eax
80104d78:	78 1e                	js     80104d98 <sys_read+0x78>
  return fileread(f, p, n);
80104d7a:	83 ec 04             	sub    $0x4,%esp
80104d7d:	ff 75 f0             	push   -0x10(%ebp)
80104d80:	ff 75 f4             	push   -0xc(%ebp)
80104d83:	56                   	push   %esi
80104d84:	e8 b7 c2 ff ff       	call   80101040 <fileread>
80104d89:	83 c4 10             	add    $0x10,%esp
}
80104d8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d8f:	5b                   	pop    %ebx
80104d90:	5e                   	pop    %esi
80104d91:	5d                   	pop    %ebp
80104d92:	c3                   	ret
80104d93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d9d:	eb ed                	jmp    80104d8c <sys_read+0x6c>
80104d9f:	90                   	nop

80104da0 <sys_write>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104da5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104da8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dab:	53                   	push   %ebx
80104dac:	6a 00                	push   $0x0
80104dae:	e8 bd fb ff ff       	call   80104970 <argint>
80104db3:	83 c4 10             	add    $0x10,%esp
80104db6:	85 c0                	test   %eax,%eax
80104db8:	78 5e                	js     80104e18 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dbe:	77 58                	ja     80104e18 <sys_write+0x78>
80104dc0:	e8 bb eb ff ff       	call   80103980 <myproc>
80104dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dcc:	85 f6                	test   %esi,%esi
80104dce:	74 48                	je     80104e18 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd0:	83 ec 08             	sub    $0x8,%esp
80104dd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dd6:	50                   	push   %eax
80104dd7:	6a 02                	push   $0x2
80104dd9:	e8 92 fb ff ff       	call   80104970 <argint>
80104dde:	83 c4 10             	add    $0x10,%esp
80104de1:	85 c0                	test   %eax,%eax
80104de3:	78 33                	js     80104e18 <sys_write+0x78>
80104de5:	83 ec 04             	sub    $0x4,%esp
80104de8:	ff 75 f0             	push   -0x10(%ebp)
80104deb:	53                   	push   %ebx
80104dec:	6a 01                	push   $0x1
80104dee:	e8 cd fb ff ff       	call   801049c0 <argptr>
80104df3:	83 c4 10             	add    $0x10,%esp
80104df6:	85 c0                	test   %eax,%eax
80104df8:	78 1e                	js     80104e18 <sys_write+0x78>
  return filewrite(f, p, n);
80104dfa:	83 ec 04             	sub    $0x4,%esp
80104dfd:	ff 75 f0             	push   -0x10(%ebp)
80104e00:	ff 75 f4             	push   -0xc(%ebp)
80104e03:	56                   	push   %esi
80104e04:	e8 c7 c2 ff ff       	call   801010d0 <filewrite>
80104e09:	83 c4 10             	add    $0x10,%esp
}
80104e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e0f:	5b                   	pop    %ebx
80104e10:	5e                   	pop    %esi
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret
80104e13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e1d:	eb ed                	jmp    80104e0c <sys_write+0x6c>
80104e1f:	90                   	nop

80104e20 <sys_close>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e2b:	50                   	push   %eax
80104e2c:	6a 00                	push   $0x0
80104e2e:	e8 3d fb ff ff       	call   80104970 <argint>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	85 c0                	test   %eax,%eax
80104e38:	78 3e                	js     80104e78 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e3e:	77 38                	ja     80104e78 <sys_close+0x58>
80104e40:	e8 3b eb ff ff       	call   80103980 <myproc>
80104e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e48:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e4b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e4f:	85 f6                	test   %esi,%esi
80104e51:	74 25                	je     80104e78 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e53:	e8 28 eb ff ff       	call   80103980 <myproc>
  fileclose(f);
80104e58:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e5b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e62:	00 
  fileclose(f);
80104e63:	56                   	push   %esi
80104e64:	e8 a7 c0 ff ff       	call   80100f10 <fileclose>
  return 0;
80104e69:	83 c4 10             	add    $0x10,%esp
80104e6c:	31 c0                	xor    %eax,%eax
}
80104e6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e71:	5b                   	pop    %ebx
80104e72:	5e                   	pop    %esi
80104e73:	5d                   	pop    %ebp
80104e74:	c3                   	ret
80104e75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7d:	eb ef                	jmp    80104e6e <sys_close+0x4e>
80104e7f:	90                   	nop

80104e80 <sys_fstat>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e8b:	53                   	push   %ebx
80104e8c:	6a 00                	push   $0x0
80104e8e:	e8 dd fa ff ff       	call   80104970 <argint>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 46                	js     80104ee0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e9e:	77 40                	ja     80104ee0 <sys_fstat+0x60>
80104ea0:	e8 db ea ff ff       	call   80103980 <myproc>
80104ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eac:	85 f6                	test   %esi,%esi
80104eae:	74 30                	je     80104ee0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104eb0:	83 ec 04             	sub    $0x4,%esp
80104eb3:	6a 14                	push   $0x14
80104eb5:	53                   	push   %ebx
80104eb6:	6a 01                	push   $0x1
80104eb8:	e8 03 fb ff ff       	call   801049c0 <argptr>
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	78 1c                	js     80104ee0 <sys_fstat+0x60>
  return filestat(f, st);
80104ec4:	83 ec 08             	sub    $0x8,%esp
80104ec7:	ff 75 f4             	push   -0xc(%ebp)
80104eca:	56                   	push   %esi
80104ecb:	e8 20 c1 ff ff       	call   80100ff0 <filestat>
80104ed0:	83 c4 10             	add    $0x10,%esp
}
80104ed3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed6:	5b                   	pop    %ebx
80104ed7:	5e                   	pop    %esi
80104ed8:	5d                   	pop    %ebp
80104ed9:	c3                   	ret
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	eb ec                	jmp    80104ed3 <sys_fstat+0x53>
80104ee7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104eee:	00 
80104eef:	90                   	nop

80104ef0 <sys_link>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	57                   	push   %edi
80104ef4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ef5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ef8:	53                   	push   %ebx
80104ef9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104efc:	50                   	push   %eax
80104efd:	6a 00                	push   $0x0
80104eff:	e8 2c fb ff ff       	call   80104a30 <argstr>
80104f04:	83 c4 10             	add    $0x10,%esp
80104f07:	85 c0                	test   %eax,%eax
80104f09:	0f 88 fb 00 00 00    	js     8010500a <sys_link+0x11a>
80104f0f:	83 ec 08             	sub    $0x8,%esp
80104f12:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f15:	50                   	push   %eax
80104f16:	6a 01                	push   $0x1
80104f18:	e8 13 fb ff ff       	call   80104a30 <argstr>
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	85 c0                	test   %eax,%eax
80104f22:	0f 88 e2 00 00 00    	js     8010500a <sys_link+0x11a>
  begin_op();
80104f28:	e8 13 de ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80104f2d:	83 ec 0c             	sub    $0xc,%esp
80104f30:	ff 75 d4             	push   -0x2c(%ebp)
80104f33:	e8 48 d1 ff ff       	call   80102080 <namei>
80104f38:	83 c4 10             	add    $0x10,%esp
80104f3b:	89 c3                	mov    %eax,%ebx
80104f3d:	85 c0                	test   %eax,%eax
80104f3f:	0f 84 df 00 00 00    	je     80105024 <sys_link+0x134>
  ilock(ip);
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	50                   	push   %eax
80104f49:	e8 52 c8 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f56:	0f 84 b5 00 00 00    	je     80105011 <sys_link+0x121>
  iupdate(ip);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f5f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f64:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f67:	53                   	push   %ebx
80104f68:	e8 83 c7 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
80104f6d:	89 1c 24             	mov    %ebx,(%esp)
80104f70:	e8 0b c9 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f75:	58                   	pop    %eax
80104f76:	5a                   	pop    %edx
80104f77:	57                   	push   %edi
80104f78:	ff 75 d0             	push   -0x30(%ebp)
80104f7b:	e8 20 d1 ff ff       	call   801020a0 <nameiparent>
80104f80:	83 c4 10             	add    $0x10,%esp
80104f83:	89 c6                	mov    %eax,%esi
80104f85:	85 c0                	test   %eax,%eax
80104f87:	74 5b                	je     80104fe4 <sys_link+0xf4>
  ilock(dp);
80104f89:	83 ec 0c             	sub    $0xc,%esp
80104f8c:	50                   	push   %eax
80104f8d:	e8 0e c8 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f92:	8b 03                	mov    (%ebx),%eax
80104f94:	83 c4 10             	add    $0x10,%esp
80104f97:	39 06                	cmp    %eax,(%esi)
80104f99:	75 3d                	jne    80104fd8 <sys_link+0xe8>
80104f9b:	83 ec 04             	sub    $0x4,%esp
80104f9e:	ff 73 04             	push   0x4(%ebx)
80104fa1:	57                   	push   %edi
80104fa2:	56                   	push   %esi
80104fa3:	e8 18 d0 ff ff       	call   80101fc0 <dirlink>
80104fa8:	83 c4 10             	add    $0x10,%esp
80104fab:	85 c0                	test   %eax,%eax
80104fad:	78 29                	js     80104fd8 <sys_link+0xe8>
  iunlockput(dp);
80104faf:	83 ec 0c             	sub    $0xc,%esp
80104fb2:	56                   	push   %esi
80104fb3:	e8 78 ca ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80104fb8:	89 1c 24             	mov    %ebx,(%esp)
80104fbb:	e8 10 c9 ff ff       	call   801018d0 <iput>
  end_op();
80104fc0:	e8 eb dd ff ff       	call   80102db0 <end_op>
  return 0;
80104fc5:	83 c4 10             	add    $0x10,%esp
80104fc8:	31 c0                	xor    %eax,%eax
}
80104fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fcd:	5b                   	pop    %ebx
80104fce:	5e                   	pop    %esi
80104fcf:	5f                   	pop    %edi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	56                   	push   %esi
80104fdc:	e8 4f ca ff ff       	call   80101a30 <iunlockput>
    goto bad;
80104fe1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fe4:	83 ec 0c             	sub    $0xc,%esp
80104fe7:	53                   	push   %ebx
80104fe8:	e8 b3 c7 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
80104fed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ff2:	89 1c 24             	mov    %ebx,(%esp)
80104ff5:	e8 f6 c6 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80104ffa:	89 1c 24             	mov    %ebx,(%esp)
80104ffd:	e8 2e ca ff ff       	call   80101a30 <iunlockput>
  end_op();
80105002:	e8 a9 dd ff ff       	call   80102db0 <end_op>
  return -1;
80105007:	83 c4 10             	add    $0x10,%esp
    return -1;
8010500a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010500f:	eb b9                	jmp    80104fca <sys_link+0xda>
    iunlockput(ip);
80105011:	83 ec 0c             	sub    $0xc,%esp
80105014:	53                   	push   %ebx
80105015:	e8 16 ca ff ff       	call   80101a30 <iunlockput>
    end_op();
8010501a:	e8 91 dd ff ff       	call   80102db0 <end_op>
    return -1;
8010501f:	83 c4 10             	add    $0x10,%esp
80105022:	eb e6                	jmp    8010500a <sys_link+0x11a>
    end_op();
80105024:	e8 87 dd ff ff       	call   80102db0 <end_op>
    return -1;
80105029:	eb df                	jmp    8010500a <sys_link+0x11a>
8010502b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105030 <sys_unlink>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105035:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105038:	53                   	push   %ebx
80105039:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010503c:	50                   	push   %eax
8010503d:	6a 00                	push   $0x0
8010503f:	e8 ec f9 ff ff       	call   80104a30 <argstr>
80105044:	83 c4 10             	add    $0x10,%esp
80105047:	85 c0                	test   %eax,%eax
80105049:	0f 88 54 01 00 00    	js     801051a3 <sys_unlink+0x173>
  begin_op();
8010504f:	e8 ec dc ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105054:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105057:	83 ec 08             	sub    $0x8,%esp
8010505a:	53                   	push   %ebx
8010505b:	ff 75 c0             	push   -0x40(%ebp)
8010505e:	e8 3d d0 ff ff       	call   801020a0 <nameiparent>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105069:	85 c0                	test   %eax,%eax
8010506b:	0f 84 58 01 00 00    	je     801051c9 <sys_unlink+0x199>
  ilock(dp);
80105071:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105074:	83 ec 0c             	sub    $0xc,%esp
80105077:	57                   	push   %edi
80105078:	e8 23 c7 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010507d:	58                   	pop    %eax
8010507e:	5a                   	pop    %edx
8010507f:	68 89 76 10 80       	push   $0x80107689
80105084:	53                   	push   %ebx
80105085:	e8 46 cc ff ff       	call   80101cd0 <namecmp>
8010508a:	83 c4 10             	add    $0x10,%esp
8010508d:	85 c0                	test   %eax,%eax
8010508f:	0f 84 fb 00 00 00    	je     80105190 <sys_unlink+0x160>
80105095:	83 ec 08             	sub    $0x8,%esp
80105098:	68 88 76 10 80       	push   $0x80107688
8010509d:	53                   	push   %ebx
8010509e:	e8 2d cc ff ff       	call   80101cd0 <namecmp>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	0f 84 e2 00 00 00    	je     80105190 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050ae:	83 ec 04             	sub    $0x4,%esp
801050b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050b4:	50                   	push   %eax
801050b5:	53                   	push   %ebx
801050b6:	57                   	push   %edi
801050b7:	e8 34 cc ff ff       	call   80101cf0 <dirlookup>
801050bc:	83 c4 10             	add    $0x10,%esp
801050bf:	89 c3                	mov    %eax,%ebx
801050c1:	85 c0                	test   %eax,%eax
801050c3:	0f 84 c7 00 00 00    	je     80105190 <sys_unlink+0x160>
  ilock(ip);
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	50                   	push   %eax
801050cd:	e8 ce c6 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
801050d2:	83 c4 10             	add    $0x10,%esp
801050d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050da:	0f 8e 0a 01 00 00    	jle    801051ea <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050e8:	74 66                	je     80105150 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050ea:	83 ec 04             	sub    $0x4,%esp
801050ed:	6a 10                	push   $0x10
801050ef:	6a 00                	push   $0x0
801050f1:	57                   	push   %edi
801050f2:	e8 c9 f5 ff ff       	call   801046c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050f7:	6a 10                	push   $0x10
801050f9:	ff 75 c4             	push   -0x3c(%ebp)
801050fc:	57                   	push   %edi
801050fd:	ff 75 b4             	push   -0x4c(%ebp)
80105100:	e8 ab ca ff ff       	call   80101bb0 <writei>
80105105:	83 c4 20             	add    $0x20,%esp
80105108:	83 f8 10             	cmp    $0x10,%eax
8010510b:	0f 85 cc 00 00 00    	jne    801051dd <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105111:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105116:	0f 84 94 00 00 00    	je     801051b0 <sys_unlink+0x180>
  iunlockput(dp);
8010511c:	83 ec 0c             	sub    $0xc,%esp
8010511f:	ff 75 b4             	push   -0x4c(%ebp)
80105122:	e8 09 c9 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
80105127:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010512c:	89 1c 24             	mov    %ebx,(%esp)
8010512f:	e8 bc c5 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105134:	89 1c 24             	mov    %ebx,(%esp)
80105137:	e8 f4 c8 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010513c:	e8 6f dc ff ff       	call   80102db0 <end_op>
  return 0;
80105141:	83 c4 10             	add    $0x10,%esp
80105144:	31 c0                	xor    %eax,%eax
}
80105146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret
8010514e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105150:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105154:	76 94                	jbe    801050ea <sys_unlink+0xba>
80105156:	be 20 00 00 00       	mov    $0x20,%esi
8010515b:	eb 0b                	jmp    80105168 <sys_unlink+0x138>
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
80105160:	83 c6 10             	add    $0x10,%esi
80105163:	3b 73 58             	cmp    0x58(%ebx),%esi
80105166:	73 82                	jae    801050ea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105168:	6a 10                	push   $0x10
8010516a:	56                   	push   %esi
8010516b:	57                   	push   %edi
8010516c:	53                   	push   %ebx
8010516d:	e8 3e c9 ff ff       	call   80101ab0 <readi>
80105172:	83 c4 10             	add    $0x10,%esp
80105175:	83 f8 10             	cmp    $0x10,%eax
80105178:	75 56                	jne    801051d0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010517a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010517f:	74 df                	je     80105160 <sys_unlink+0x130>
    iunlockput(ip);
80105181:	83 ec 0c             	sub    $0xc,%esp
80105184:	53                   	push   %ebx
80105185:	e8 a6 c8 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010518a:	83 c4 10             	add    $0x10,%esp
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	ff 75 b4             	push   -0x4c(%ebp)
80105196:	e8 95 c8 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010519b:	e8 10 dc ff ff       	call   80102db0 <end_op>
  return -1;
801051a0:	83 c4 10             	add    $0x10,%esp
    return -1;
801051a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a8:	eb 9c                	jmp    80105146 <sys_unlink+0x116>
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801051b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051b3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051b6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051bb:	50                   	push   %eax
801051bc:	e8 2f c5 ff ff       	call   801016f0 <iupdate>
801051c1:	83 c4 10             	add    $0x10,%esp
801051c4:	e9 53 ff ff ff       	jmp    8010511c <sys_unlink+0xec>
    end_op();
801051c9:	e8 e2 db ff ff       	call   80102db0 <end_op>
    return -1;
801051ce:	eb d3                	jmp    801051a3 <sys_unlink+0x173>
      panic("isdirempty: readi");
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	68 ad 76 10 80       	push   $0x801076ad
801051d8:	e8 a3 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801051dd:	83 ec 0c             	sub    $0xc,%esp
801051e0:	68 bf 76 10 80       	push   $0x801076bf
801051e5:	e8 96 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801051ea:	83 ec 0c             	sub    $0xc,%esp
801051ed:	68 9b 76 10 80       	push   $0x8010769b
801051f2:	e8 89 b1 ff ff       	call   80100380 <panic>
801051f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051fe:	00 
801051ff:	90                   	nop

80105200 <sys_open>:

int
sys_open(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105205:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105208:	53                   	push   %ebx
80105209:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 1c f8 ff ff       	call   80104a30 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 8e 00 00 00    	js     801052ad <sys_open+0xad>
8010521f:	83 ec 08             	sub    $0x8,%esp
80105222:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105225:	50                   	push   %eax
80105226:	6a 01                	push   $0x1
80105228:	e8 43 f7 ff ff       	call   80104970 <argint>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	78 79                	js     801052ad <sys_open+0xad>
    return -1;

  begin_op();
80105234:	e8 07 db ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
80105239:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010523d:	75 79                	jne    801052b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010523f:	83 ec 0c             	sub    $0xc,%esp
80105242:	ff 75 e0             	push   -0x20(%ebp)
80105245:	e8 36 ce ff ff       	call   80102080 <namei>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	89 c6                	mov    %eax,%esi
8010524f:	85 c0                	test   %eax,%eax
80105251:	0f 84 7e 00 00 00    	je     801052d5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105257:	83 ec 0c             	sub    $0xc,%esp
8010525a:	50                   	push   %eax
8010525b:	e8 40 c5 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105268:	0f 84 ba 00 00 00    	je     80105328 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010526e:	e8 dd bb ff ff       	call   80100e50 <filealloc>
80105273:	89 c7                	mov    %eax,%edi
80105275:	85 c0                	test   %eax,%eax
80105277:	74 23                	je     8010529c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105279:	e8 02 e7 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010527e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105280:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105284:	85 d2                	test   %edx,%edx
80105286:	74 58                	je     801052e0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105288:	83 c3 01             	add    $0x1,%ebx
8010528b:	83 fb 10             	cmp    $0x10,%ebx
8010528e:	75 f0                	jne    80105280 <sys_open+0x80>
    if(f)
      fileclose(f);
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	57                   	push   %edi
80105294:	e8 77 bc ff ff       	call   80100f10 <fileclose>
80105299:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	56                   	push   %esi
801052a0:	e8 8b c7 ff ff       	call   80101a30 <iunlockput>
    end_op();
801052a5:	e8 06 db ff ff       	call   80102db0 <end_op>
    return -1;
801052aa:	83 c4 10             	add    $0x10,%esp
    return -1;
801052ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052b2:	eb 65                	jmp    80105319 <sys_open+0x119>
801052b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052b8:	83 ec 0c             	sub    $0xc,%esp
801052bb:	31 c9                	xor    %ecx,%ecx
801052bd:	ba 02 00 00 00       	mov    $0x2,%edx
801052c2:	6a 00                	push   $0x0
801052c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052c7:	e8 54 f8 ff ff       	call   80104b20 <create>
    if(ip == 0){
801052cc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052d1:	85 c0                	test   %eax,%eax
801052d3:	75 99                	jne    8010526e <sys_open+0x6e>
      end_op();
801052d5:	e8 d6 da ff ff       	call   80102db0 <end_op>
      return -1;
801052da:	eb d1                	jmp    801052ad <sys_open+0xad>
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801052e0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052e3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052e7:	56                   	push   %esi
801052e8:	e8 93 c5 ff ff       	call   80101880 <iunlock>
  end_op();
801052ed:	e8 be da ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
801052f2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052fb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801052fe:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105301:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105303:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010530a:	f7 d0                	not    %eax
8010530c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010530f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105312:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105315:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105319:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010531c:	89 d8                	mov    %ebx,%eax
8010531e:	5b                   	pop    %ebx
8010531f:	5e                   	pop    %esi
80105320:	5f                   	pop    %edi
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret
80105323:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105328:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010532b:	85 c9                	test   %ecx,%ecx
8010532d:	0f 84 3b ff ff ff    	je     8010526e <sys_open+0x6e>
80105333:	e9 64 ff ff ff       	jmp    8010529c <sys_open+0x9c>
80105338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010533f:	00 

80105340 <sys_mkdir>:

int
sys_mkdir(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105346:	e8 f5 d9 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010534b:	83 ec 08             	sub    $0x8,%esp
8010534e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105351:	50                   	push   %eax
80105352:	6a 00                	push   $0x0
80105354:	e8 d7 f6 ff ff       	call   80104a30 <argstr>
80105359:	83 c4 10             	add    $0x10,%esp
8010535c:	85 c0                	test   %eax,%eax
8010535e:	78 30                	js     80105390 <sys_mkdir+0x50>
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105366:	31 c9                	xor    %ecx,%ecx
80105368:	ba 01 00 00 00       	mov    $0x1,%edx
8010536d:	6a 00                	push   $0x0
8010536f:	e8 ac f7 ff ff       	call   80104b20 <create>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	74 15                	je     80105390 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010537b:	83 ec 0c             	sub    $0xc,%esp
8010537e:	50                   	push   %eax
8010537f:	e8 ac c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105384:	e8 27 da ff ff       	call   80102db0 <end_op>
  return 0;
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	31 c0                	xor    %eax,%eax
}
8010538e:	c9                   	leave
8010538f:	c3                   	ret
    end_op();
80105390:	e8 1b da ff ff       	call   80102db0 <end_op>
    return -1;
80105395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010539a:	c9                   	leave
8010539b:	c3                   	ret
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_mknod>:

int
sys_mknod(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053a6:	e8 95 d9 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053ab:	83 ec 08             	sub    $0x8,%esp
801053ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053b1:	50                   	push   %eax
801053b2:	6a 00                	push   $0x0
801053b4:	e8 77 f6 ff ff       	call   80104a30 <argstr>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	85 c0                	test   %eax,%eax
801053be:	78 60                	js     80105420 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053c0:	83 ec 08             	sub    $0x8,%esp
801053c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c6:	50                   	push   %eax
801053c7:	6a 01                	push   $0x1
801053c9:	e8 a2 f5 ff ff       	call   80104970 <argint>
  if((argstr(0, &path)) < 0 ||
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	85 c0                	test   %eax,%eax
801053d3:	78 4b                	js     80105420 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053d5:	83 ec 08             	sub    $0x8,%esp
801053d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053db:	50                   	push   %eax
801053dc:	6a 02                	push   $0x2
801053de:	e8 8d f5 ff ff       	call   80104970 <argint>
     argint(1, &major) < 0 ||
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	78 36                	js     80105420 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053ee:	83 ec 0c             	sub    $0xc,%esp
801053f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053f5:	ba 03 00 00 00       	mov    $0x3,%edx
801053fa:	50                   	push   %eax
801053fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053fe:	e8 1d f7 ff ff       	call   80104b20 <create>
     argint(2, &minor) < 0 ||
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	85 c0                	test   %eax,%eax
80105408:	74 16                	je     80105420 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010540a:	83 ec 0c             	sub    $0xc,%esp
8010540d:	50                   	push   %eax
8010540e:	e8 1d c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105413:	e8 98 d9 ff ff       	call   80102db0 <end_op>
  return 0;
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	31 c0                	xor    %eax,%eax
}
8010541d:	c9                   	leave
8010541e:	c3                   	ret
8010541f:	90                   	nop
    end_op();
80105420:	e8 8b d9 ff ff       	call   80102db0 <end_op>
    return -1;
80105425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010542a:	c9                   	leave
8010542b:	c3                   	ret
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_chdir>:

int
sys_chdir(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	56                   	push   %esi
80105434:	53                   	push   %ebx
80105435:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105438:	e8 43 e5 ff ff       	call   80103980 <myproc>
8010543d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010543f:	e8 fc d8 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105444:	83 ec 08             	sub    $0x8,%esp
80105447:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544a:	50                   	push   %eax
8010544b:	6a 00                	push   $0x0
8010544d:	e8 de f5 ff ff       	call   80104a30 <argstr>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	85 c0                	test   %eax,%eax
80105457:	78 77                	js     801054d0 <sys_chdir+0xa0>
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	ff 75 f4             	push   -0xc(%ebp)
8010545f:	e8 1c cc ff ff       	call   80102080 <namei>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	89 c3                	mov    %eax,%ebx
80105469:	85 c0                	test   %eax,%eax
8010546b:	74 63                	je     801054d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010546d:	83 ec 0c             	sub    $0xc,%esp
80105470:	50                   	push   %eax
80105471:	e8 2a c3 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105476:	83 c4 10             	add    $0x10,%esp
80105479:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010547e:	75 30                	jne    801054b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	53                   	push   %ebx
80105484:	e8 f7 c3 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105489:	58                   	pop    %eax
8010548a:	ff 76 68             	push   0x68(%esi)
8010548d:	e8 3e c4 ff ff       	call   801018d0 <iput>
  end_op();
80105492:	e8 19 d9 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105497:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	31 c0                	xor    %eax,%eax
}
8010549f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a2:	5b                   	pop    %ebx
801054a3:	5e                   	pop    %esi
801054a4:	5d                   	pop    %ebp
801054a5:	c3                   	ret
801054a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054ad:	00 
801054ae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	53                   	push   %ebx
801054b4:	e8 77 c5 ff ff       	call   80101a30 <iunlockput>
    end_op();
801054b9:	e8 f2 d8 ff ff       	call   80102db0 <end_op>
    return -1;
801054be:	83 c4 10             	add    $0x10,%esp
    return -1;
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c6:	eb d7                	jmp    8010549f <sys_chdir+0x6f>
801054c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054cf:	00 
    end_op();
801054d0:	e8 db d8 ff ff       	call   80102db0 <end_op>
    return -1;
801054d5:	eb ea                	jmp    801054c1 <sys_chdir+0x91>
801054d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054de:	00 
801054df:	90                   	nop

801054e0 <sys_exec>:

int
sys_exec(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054e5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054eb:	53                   	push   %ebx
801054ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054f2:	50                   	push   %eax
801054f3:	6a 00                	push   $0x0
801054f5:	e8 36 f5 ff ff       	call   80104a30 <argstr>
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	85 c0                	test   %eax,%eax
801054ff:	0f 88 87 00 00 00    	js     8010558c <sys_exec+0xac>
80105505:	83 ec 08             	sub    $0x8,%esp
80105508:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010550e:	50                   	push   %eax
8010550f:	6a 01                	push   $0x1
80105511:	e8 5a f4 ff ff       	call   80104970 <argint>
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	85 c0                	test   %eax,%eax
8010551b:	78 6f                	js     8010558c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010551d:	83 ec 04             	sub    $0x4,%esp
80105520:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105526:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105528:	68 80 00 00 00       	push   $0x80
8010552d:	6a 00                	push   $0x0
8010552f:	56                   	push   %esi
80105530:	e8 8b f1 ff ff       	call   801046c0 <memset>
80105535:	83 c4 10             	add    $0x10,%esp
80105538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010553f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105540:	83 ec 08             	sub    $0x8,%esp
80105543:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105549:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105550:	50                   	push   %eax
80105551:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105557:	01 f8                	add    %edi,%eax
80105559:	50                   	push   %eax
8010555a:	e8 81 f3 ff ff       	call   801048e0 <fetchint>
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	85 c0                	test   %eax,%eax
80105564:	78 26                	js     8010558c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105566:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010556c:	85 c0                	test   %eax,%eax
8010556e:	74 30                	je     801055a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105576:	52                   	push   %edx
80105577:	50                   	push   %eax
80105578:	e8 a3 f3 ff ff       	call   80104920 <fetchstr>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	78 08                	js     8010558c <sys_exec+0xac>
  for(i=0;; i++){
80105584:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105587:	83 fb 20             	cmp    $0x20,%ebx
8010558a:	75 b4                	jne    80105540 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010558c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010558f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105594:	5b                   	pop    %ebx
80105595:	5e                   	pop    %esi
80105596:	5f                   	pop    %edi
80105597:	5d                   	pop    %ebp
80105598:	c3                   	ret
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055a7:	00 00 00 00 
  return exec(path, argv);
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	56                   	push   %esi
801055af:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801055b5:	e8 f6 b4 ff ff       	call   80100ab0 <exec>
801055ba:	83 c4 10             	add    $0x10,%esp
}
801055bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c0:	5b                   	pop    %ebx
801055c1:	5e                   	pop    %esi
801055c2:	5f                   	pop    %edi
801055c3:	5d                   	pop    %ebp
801055c4:	c3                   	ret
801055c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055cc:	00 
801055cd:	8d 76 00             	lea    0x0(%esi),%esi

801055d0 <sys_pipe>:

int
sys_pipe(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055d8:	53                   	push   %ebx
801055d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055dc:	6a 08                	push   $0x8
801055de:	50                   	push   %eax
801055df:	6a 00                	push   $0x0
801055e1:	e8 da f3 ff ff       	call   801049c0 <argptr>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	0f 88 8b 00 00 00    	js     8010567c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801055f1:	83 ec 08             	sub    $0x8,%esp
801055f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055f7:	50                   	push   %eax
801055f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055fb:	50                   	push   %eax
801055fc:	e8 1f de ff ff       	call   80103420 <pipealloc>
80105601:	83 c4 10             	add    $0x10,%esp
80105604:	85 c0                	test   %eax,%eax
80105606:	78 74                	js     8010567c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105608:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010560b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010560d:	e8 6e e3 ff ff       	call   80103980 <myproc>
    if(curproc->ofile[fd] == 0){
80105612:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105616:	85 f6                	test   %esi,%esi
80105618:	74 16                	je     80105630 <sys_pipe+0x60>
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105620:	83 c3 01             	add    $0x1,%ebx
80105623:	83 fb 10             	cmp    $0x10,%ebx
80105626:	74 3d                	je     80105665 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105628:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010562c:	85 f6                	test   %esi,%esi
8010562e:	75 f0                	jne    80105620 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105630:	8d 73 08             	lea    0x8(%ebx),%esi
80105633:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105637:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010563a:	e8 41 e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010563f:	31 d2                	xor    %edx,%edx
80105641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105648:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010564c:	85 c9                	test   %ecx,%ecx
8010564e:	74 38                	je     80105688 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105650:	83 c2 01             	add    $0x1,%edx
80105653:	83 fa 10             	cmp    $0x10,%edx
80105656:	75 f0                	jne    80105648 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105658:	e8 23 e3 ff ff       	call   80103980 <myproc>
8010565d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105664:	00 
    fileclose(rf);
80105665:	83 ec 0c             	sub    $0xc,%esp
80105668:	ff 75 e0             	push   -0x20(%ebp)
8010566b:	e8 a0 b8 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105670:	58                   	pop    %eax
80105671:	ff 75 e4             	push   -0x1c(%ebp)
80105674:	e8 97 b8 ff ff       	call   80100f10 <fileclose>
    return -1;
80105679:	83 c4 10             	add    $0x10,%esp
    return -1;
8010567c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105681:	eb 16                	jmp    80105699 <sys_pipe+0xc9>
80105683:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105688:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010568c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010568f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105691:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105694:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105697:	31 c0                	xor    %eax,%eax
}
80105699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010569c:	5b                   	pop    %ebx
8010569d:	5e                   	pop    %esi
8010569e:	5f                   	pop    %edi
8010569f:	5d                   	pop    %ebp
801056a0:	c3                   	ret
801056a1:	66 90                	xchg   %ax,%ax
801056a3:	66 90                	xchg   %ax,%ax
801056a5:	66 90                	xchg   %ax,%ax
801056a7:	66 90                	xchg   %ax,%ax
801056a9:	66 90                	xchg   %ax,%ax
801056ab:	66 90                	xchg   %ax,%ax
801056ad:	66 90                	xchg   %ax,%ax
801056af:	90                   	nop

801056b0 <sys_fork>:


int
sys_fork(void)
{
  return fork();
801056b0:	e9 6b e4 ff ff       	jmp    80103b20 <fork>
801056b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056bc:	00 
801056bd:	8d 76 00             	lea    0x0(%esi),%esi

801056c0 <sys_exit>:
}

int
sys_exit(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056c6:	e8 c5 e6 ff ff       	call   80103d90 <exit>
  return 0;  // not reached
}
801056cb:	31 c0                	xor    %eax,%eax
801056cd:	c9                   	leave
801056ce:	c3                   	ret
801056cf:	90                   	nop

801056d0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801056d0:	e9 eb e7 ff ff       	jmp    80103ec0 <wait>
801056d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056dc:	00 
801056dd:	8d 76 00             	lea    0x0(%esi),%esi

801056e0 <sys_kill>:
}

int
sys_kill(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801056e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	6a 00                	push   $0x0
801056ec:	e8 7f f2 ff ff       	call   80104970 <argint>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	78 18                	js     80105710 <sys_kill+0x30>
    return -1;
  return kill(pid);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	ff 75 f4             	push   -0xc(%ebp)
801056fe:	e8 5d ea ff ff       	call   80104160 <kill>
80105703:	83 c4 10             	add    $0x10,%esp
}
80105706:	c9                   	leave
80105707:	c3                   	ret
80105708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010570f:	00 
80105710:	c9                   	leave
    return -1;
80105711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105716:	c3                   	ret
80105717:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010571e:	00 
8010571f:	90                   	nop

80105720 <sys_getpid>:

int
sys_getpid(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105726:	e8 55 e2 ff ff       	call   80103980 <myproc>
8010572b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010572e:	c9                   	leave
8010572f:	c3                   	ret

80105730 <sys_sbrk>:

int
sys_sbrk(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105734:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105737:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010573a:	50                   	push   %eax
8010573b:	6a 00                	push   $0x0
8010573d:	e8 2e f2 ff ff       	call   80104970 <argint>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	78 2f                	js     80105778 <sys_sbrk+0x48>
    return -1;
  addr = myproc()->sz;
80105749:	e8 32 e2 ff ff       	call   80103980 <myproc>
8010574e:	8b 18                	mov    (%eax),%ebx
  myproc()->sz+=n;
80105750:	e8 2b e2 ff ff       	call   80103980 <myproc>
80105755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  if(growproc(n) < 0)
80105758:	83 ec 0c             	sub    $0xc,%esp
  myproc()->sz+=n;
8010575b:	01 10                	add    %edx,(%eax)
  if(growproc(n) < 0)
8010575d:	ff 75 f4             	push   -0xc(%ebp)
80105760:	e8 3b e3 ff ff       	call   80103aa0 <growproc>
80105765:	83 c4 10             	add    $0x10,%esp
80105768:	85 c0                	test   %eax,%eax
8010576a:	78 0c                	js     80105778 <sys_sbrk+0x48>
    return -1;
  return addr;
}
8010576c:	89 d8                	mov    %ebx,%eax
8010576e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105771:	c9                   	leave
80105772:	c3                   	ret
80105773:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105778:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010577d:	eb ed                	jmp    8010576c <sys_sbrk+0x3c>
8010577f:	90                   	nop

80105780 <sys_sleep>:

int
sys_sleep(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105784:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105787:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010578a:	50                   	push   %eax
8010578b:	6a 00                	push   $0x0
8010578d:	e8 de f1 ff ff       	call   80104970 <argint>
80105792:	83 c4 10             	add    $0x10,%esp
80105795:	85 c0                	test   %eax,%eax
80105797:	78 64                	js     801057fd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	68 80 3d 11 80       	push   $0x80113d80
801057a1:	e8 1a ee ff ff       	call   801045c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801057a9:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  while(ticks - ticks0 < n){
801057af:	83 c4 10             	add    $0x10,%esp
801057b2:	85 d2                	test   %edx,%edx
801057b4:	75 2b                	jne    801057e1 <sys_sleep+0x61>
801057b6:	eb 58                	jmp    80105810 <sys_sleep+0x90>
801057b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057bf:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057c0:	83 ec 08             	sub    $0x8,%esp
801057c3:	68 80 3d 11 80       	push   $0x80113d80
801057c8:	68 60 3d 11 80       	push   $0x80113d60
801057cd:	e8 6e e8 ff ff       	call   80104040 <sleep>
  while(ticks - ticks0 < n){
801057d2:	a1 60 3d 11 80       	mov    0x80113d60,%eax
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	29 d8                	sub    %ebx,%eax
801057dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057df:	73 2f                	jae    80105810 <sys_sleep+0x90>
    if(myproc()->killed){
801057e1:	e8 9a e1 ff ff       	call   80103980 <myproc>
801057e6:	8b 40 24             	mov    0x24(%eax),%eax
801057e9:	85 c0                	test   %eax,%eax
801057eb:	74 d3                	je     801057c0 <sys_sleep+0x40>
      release(&tickslock);
801057ed:	83 ec 0c             	sub    $0xc,%esp
801057f0:	68 80 3d 11 80       	push   $0x80113d80
801057f5:	e8 66 ed ff ff       	call   80104560 <release>
      return -1;
801057fa:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801057fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105805:	c9                   	leave
80105806:	c3                   	ret
80105807:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010580e:	00 
8010580f:	90                   	nop
  release(&tickslock);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	68 80 3d 11 80       	push   $0x80113d80
80105818:	e8 43 ed ff ff       	call   80104560 <release>
}
8010581d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105820:	83 c4 10             	add    $0x10,%esp
80105823:	31 c0                	xor    %eax,%eax
}
80105825:	c9                   	leave
80105826:	c3                   	ret
80105827:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010582e:	00 
8010582f:	90                   	nop

80105830 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	53                   	push   %ebx
80105834:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105837:	68 80 3d 11 80       	push   $0x80113d80
8010583c:	e8 7f ed ff ff       	call   801045c0 <acquire>
  xticks = ticks;
80105841:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  release(&tickslock);
80105847:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
8010584e:	e8 0d ed ff ff       	call   80104560 <release>
  return xticks;
}
80105853:	89 d8                	mov    %ebx,%eax
80105855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105858:	c9                   	leave
80105859:	c3                   	ret
8010585a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105860 <sys_toupper>:
int sys_toupper(void){
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
  char *str;
  int len;
  if(argstr(0,&str)<0 || argint(1,&len)<0)
80105864:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_toupper(void){
80105867:	83 ec 1c             	sub    $0x1c,%esp
  if(argstr(0,&str)<0 || argint(1,&len)<0)
8010586a:	50                   	push   %eax
8010586b:	6a 00                	push   $0x0
8010586d:	e8 be f1 ff ff       	call   80104a30 <argstr>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	78 4d                	js     801058c6 <sys_toupper+0x66>
80105879:	83 ec 08             	sub    $0x8,%esp
8010587c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587f:	50                   	push   %eax
80105880:	6a 01                	push   $0x1
80105882:	e8 e9 f0 ff ff       	call   80104970 <argint>
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	85 c0                	test   %eax,%eax
8010588c:	78 38                	js     801058c6 <sys_toupper+0x66>
  return -1;
  int k= 'a';
  for(int i=0;i<len;i++){
8010588e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105891:	31 c0                	xor    %eax,%eax
80105893:	85 d2                	test   %edx,%edx
80105895:	7e 28                	jle    801058bf <sys_toupper+0x5f>
80105897:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589e:	00 
8010589f:	90                   	nop
    

    if(str[i]-k<=26 && str[i]-k>=0){
801058a0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
801058a3:	01 c3                	add    %eax,%ebx
801058a5:	0f be 13             	movsbl (%ebx),%edx
801058a8:	89 d1                	mov    %edx,%ecx
801058aa:	83 ea 61             	sub    $0x61,%edx
801058ad:	83 fa 1a             	cmp    $0x1a,%edx
801058b0:	77 05                	ja     801058b7 <sys_toupper+0x57>
      
      
      str[i]+=32;
801058b2:	83 c1 20             	add    $0x20,%ecx
801058b5:	88 0b                	mov    %cl,(%ebx)
  for(int i=0;i<len;i++){
801058b7:	83 c0 01             	add    $0x1,%eax
801058ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801058bd:	7f e1                	jg     801058a0 <sys_toupper+0x40>
      

    }
    
  }return 0;
801058bf:	31 c0                	xor    %eax,%eax

}
801058c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c4:	c9                   	leave
801058c5:	c3                   	ret
  return -1;
801058c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cb:	eb f4                	jmp    801058c1 <sys_toupper+0x61>
801058cd:	8d 76 00             	lea    0x0(%esi),%esi

801058d0 <sys_getpagefaults>:
int 
sys_getpagefaults(void) {
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 08             	sub    $0x8,%esp
struct proc *p = myproc();
801058d6:	e8 a5 e0 ff ff       	call   80103980 <myproc>
return p->page_faults;
801058db:	8b 40 7c             	mov    0x7c(%eax),%eax
801058de:	c9                   	leave
801058df:	c3                   	ret

801058e0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058e0:	1e                   	push   %ds
  pushl %es
801058e1:	06                   	push   %es
  pushl %fs
801058e2:	0f a0                	push   %fs
  pushl %gs
801058e4:	0f a8                	push   %gs
  pushal
801058e6:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058e7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058eb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058ed:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058ef:	54                   	push   %esp
  call trap
801058f0:	e8 cb 00 00 00       	call   801059c0 <trap>
  addl $4, %esp
801058f5:	83 c4 04             	add    $0x4,%esp

801058f8 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058f8:	61                   	popa
  popl %gs
801058f9:	0f a9                	pop    %gs
  popl %fs
801058fb:	0f a1                	pop    %fs
  popl %es
801058fd:	07                   	pop    %es
  popl %ds
801058fe:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058ff:	83 c4 08             	add    $0x8,%esp
  iret
80105902:	cf                   	iret
80105903:	66 90                	xchg   %ax,%ax
80105905:	66 90                	xchg   %ax,%ax
80105907:	66 90                	xchg   %ax,%ax
80105909:	66 90                	xchg   %ax,%ax
8010590b:	66 90                	xchg   %ax,%ax
8010590d:	66 90                	xchg   %ax,%ax
8010590f:	90                   	nop

80105910 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105910:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105911:	31 c0                	xor    %eax,%eax
{
80105913:	89 e5                	mov    %esp,%ebp
80105915:	83 ec 08             	sub    $0x8,%esp
80105918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010591f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105920:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105927:	c7 04 c5 c2 3d 11 80 	movl   $0x8e000008,-0x7feec23e(,%eax,8)
8010592e:	08 00 00 8e 
80105932:	66 89 14 c5 c0 3d 11 	mov    %dx,-0x7feec240(,%eax,8)
80105939:	80 
8010593a:	c1 ea 10             	shr    $0x10,%edx
8010593d:	66 89 14 c5 c6 3d 11 	mov    %dx,-0x7feec23a(,%eax,8)
80105944:	80 
  for(i = 0; i < 256; i++)
80105945:	83 c0 01             	add    $0x1,%eax
80105948:	3d 00 01 00 00       	cmp    $0x100,%eax
8010594d:	75 d1                	jne    80105920 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010594f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105952:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105957:	c7 05 c2 3f 11 80 08 	movl   $0xef000008,0x80113fc2
8010595e:	00 00 ef 
  initlock(&tickslock, "time");
80105961:	68 ce 76 10 80       	push   $0x801076ce
80105966:	68 80 3d 11 80       	push   $0x80113d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010596b:	66 a3 c0 3f 11 80    	mov    %ax,0x80113fc0
80105971:	c1 e8 10             	shr    $0x10,%eax
80105974:	66 a3 c6 3f 11 80    	mov    %ax,0x80113fc6
  initlock(&tickslock, "time");
8010597a:	e8 51 ea ff ff       	call   801043d0 <initlock>
}
8010597f:	83 c4 10             	add    $0x10,%esp
80105982:	c9                   	leave
80105983:	c3                   	ret
80105984:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010598b:	00 
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <idtinit>:

void
idtinit(void)
{
80105990:	55                   	push   %ebp
  pd[0] = size-1;
80105991:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105996:	89 e5                	mov    %esp,%ebp
80105998:	83 ec 10             	sub    $0x10,%esp
8010599b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010599f:	b8 c0 3d 11 80       	mov    $0x80113dc0,%eax
801059a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059a8:	c1 e8 10             	shr    $0x10,%eax
801059ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059b5:	c9                   	leave
801059b6:	c3                   	ret
801059b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059be:	00 
801059bf:	90                   	nop

801059c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
801059c6:	83 ec 1c             	sub    $0x1c,%esp
801059c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059cc:	8b 43 30             	mov    0x30(%ebx),%eax
801059cf:	83 f8 40             	cmp    $0x40,%eax
801059d2:	0f 84 30 01 00 00    	je     80105b08 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059d8:	83 e8 0e             	sub    $0xe,%eax
801059db:	83 f8 31             	cmp    $0x31,%eax
801059de:	0f 87 8c 00 00 00    	ja     80105a70 <trap+0xb0>
801059e4:	ff 24 85 80 7c 10 80 	jmp    *-0x7fef8380(,%eax,4)
801059eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801059f0:	e8 6b df ff ff       	call   80103960 <cpuid>
801059f5:	85 c0                	test   %eax,%eax
801059f7:	0f 84 a3 02 00 00    	je     80105ca0 <trap+0x2e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801059fd:	e8 ee ce ff ff       	call   801028f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a02:	e8 79 df ff ff       	call   80103980 <myproc>
80105a07:	85 c0                	test   %eax,%eax
80105a09:	74 1a                	je     80105a25 <trap+0x65>
80105a0b:	e8 70 df ff ff       	call   80103980 <myproc>
80105a10:	8b 50 24             	mov    0x24(%eax),%edx
80105a13:	85 d2                	test   %edx,%edx
80105a15:	74 0e                	je     80105a25 <trap+0x65>
80105a17:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a1b:	f7 d0                	not    %eax
80105a1d:	a8 03                	test   $0x3,%al
80105a1f:	0f 84 3b 02 00 00    	je     80105c60 <trap+0x2a0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a25:	e8 56 df ff ff       	call   80103980 <myproc>
80105a2a:	85 c0                	test   %eax,%eax
80105a2c:	74 0f                	je     80105a3d <trap+0x7d>
80105a2e:	e8 4d df ff ff       	call   80103980 <myproc>
80105a33:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a37:	0f 84 b3 00 00 00    	je     80105af0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a3d:	e8 3e df ff ff       	call   80103980 <myproc>
80105a42:	85 c0                	test   %eax,%eax
80105a44:	74 1a                	je     80105a60 <trap+0xa0>
80105a46:	e8 35 df ff ff       	call   80103980 <myproc>
80105a4b:	8b 40 24             	mov    0x24(%eax),%eax
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	74 0e                	je     80105a60 <trap+0xa0>
80105a52:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a56:	f7 d0                	not    %eax
80105a58:	a8 03                	test   $0x3,%al
80105a5a:	0f 84 d5 00 00 00    	je     80105b35 <trap+0x175>
    exit();
}
80105a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a63:	5b                   	pop    %ebx
80105a64:	5e                   	pop    %esi
80105a65:	5f                   	pop    %edi
80105a66:	5d                   	pop    %ebp
80105a67:	c3                   	ret
80105a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6f:	00 
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a70:	e8 0b df ff ff       	call   80103980 <myproc>
80105a75:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a78:	85 c0                	test   %eax,%eax
80105a7a:	0f 84 54 02 00 00    	je     80105cd4 <trap+0x314>
80105a80:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a84:	0f 84 4a 02 00 00    	je     80105cd4 <trap+0x314>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a8a:	0f 20 d1             	mov    %cr2,%ecx
80105a8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a90:	e8 cb de ff ff       	call   80103960 <cpuid>
80105a95:	8b 73 30             	mov    0x30(%ebx),%esi
80105a98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a9b:	8b 43 34             	mov    0x34(%ebx),%eax
80105a9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105aa1:	e8 da de ff ff       	call   80103980 <myproc>
80105aa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105aa9:	e8 d2 de ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ab1:	51                   	push   %ecx
80105ab2:	57                   	push   %edi
80105ab3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ab6:	52                   	push   %edx
80105ab7:	ff 75 e4             	push   -0x1c(%ebp)
80105aba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105abb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105abe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ac1:	56                   	push   %esi
80105ac2:	ff 70 10             	push   0x10(%eax)
80105ac5:	68 60 79 10 80       	push   $0x80107960
80105aca:	e8 e1 ab ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105acf:	83 c4 20             	add    $0x20,%esp
80105ad2:	e8 a9 de ff ff       	call   80103980 <myproc>
80105ad7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ade:	e8 9d de ff ff       	call   80103980 <myproc>
80105ae3:	85 c0                	test   %eax,%eax
80105ae5:	0f 85 20 ff ff ff    	jne    80105a0b <trap+0x4b>
80105aeb:	e9 35 ff ff ff       	jmp    80105a25 <trap+0x65>
  if(myproc() && myproc()->state == RUNNING &&
80105af0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105af4:	0f 85 43 ff ff ff    	jne    80105a3d <trap+0x7d>
    yield();
80105afa:	e8 f1 e4 ff ff       	call   80103ff0 <yield>
80105aff:	e9 39 ff ff ff       	jmp    80105a3d <trap+0x7d>
80105b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b08:	e8 73 de ff ff       	call   80103980 <myproc>
80105b0d:	8b 70 24             	mov    0x24(%eax),%esi
80105b10:	85 f6                	test   %esi,%esi
80105b12:	0f 85 78 01 00 00    	jne    80105c90 <trap+0x2d0>
    myproc()->tf = tf;
80105b18:	e8 63 de ff ff       	call   80103980 <myproc>
80105b1d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b20:	e8 8b ef ff ff       	call   80104ab0 <syscall>
    if(myproc()->killed)
80105b25:	e8 56 de ff ff       	call   80103980 <myproc>
80105b2a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b2d:	85 c9                	test   %ecx,%ecx
80105b2f:	0f 84 2b ff ff ff    	je     80105a60 <trap+0xa0>
}
80105b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b38:	5b                   	pop    %ebx
80105b39:	5e                   	pop    %esi
80105b3a:	5f                   	pop    %edi
80105b3b:	5d                   	pop    %ebp
      exit();
80105b3c:	e9 4f e2 ff ff       	jmp    80103d90 <exit>
80105b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b48:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b4f:	e8 0c de ff ff       	call   80103960 <cpuid>
80105b54:	57                   	push   %edi
80105b55:	56                   	push   %esi
80105b56:	50                   	push   %eax
80105b57:	68 08 79 10 80       	push   $0x80107908
80105b5c:	e8 4f ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105b61:	e8 8a cd ff ff       	call   801028f0 <lapiceoi>
    break;
80105b66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b69:	e8 12 de ff ff       	call   80103980 <myproc>
80105b6e:	85 c0                	test   %eax,%eax
80105b70:	0f 85 95 fe ff ff    	jne    80105a0b <trap+0x4b>
80105b76:	e9 aa fe ff ff       	jmp    80105a25 <trap+0x65>
80105b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b80:	e8 3b cc ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80105b85:	e8 66 cd ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b8a:	e8 f1 dd ff ff       	call   80103980 <myproc>
80105b8f:	85 c0                	test   %eax,%eax
80105b91:	0f 85 74 fe ff ff    	jne    80105a0b <trap+0x4b>
80105b97:	e9 89 fe ff ff       	jmp    80105a25 <trap+0x65>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ba0:	e8 eb 02 00 00       	call   80105e90 <uartintr>
    lapiceoi();
80105ba5:	e8 46 cd ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105baa:	e8 d1 dd ff ff       	call   80103980 <myproc>
80105baf:	85 c0                	test   %eax,%eax
80105bb1:	0f 85 54 fe ff ff    	jne    80105a0b <trap+0x4b>
80105bb7:	e9 69 fe ff ff       	jmp    80105a25 <trap+0x65>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105bc0:	e8 6b c6 ff ff       	call   80102230 <ideintr>
80105bc5:	e9 33 fe ff ff       	jmp    801059fd <trap+0x3d>
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    struct proc *p=myproc();
80105bd0:	e8 ab dd ff ff       	call   80103980 <myproc>
80105bd5:	89 c6                	mov    %eax,%esi
    if(p==0)
80105bd7:	85 c0                	test   %eax,%eax
80105bd9:	0f 84 1d 01 00 00    	je     80105cfc <trap+0x33c>
80105bdf:	0f 20 d7             	mov    %cr2,%edi
    va=PGROUNDDOWN(va);
80105be2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if(va>=p->sz){
80105be8:	3b 38                	cmp    (%eax),%edi
80105bea:	72 24                	jb     80105c10 <trap+0x250>
      cprintf("Invalid page fault at %x\n",va);
80105bec:	83 ec 08             	sub    $0x8,%esp
80105bef:	57                   	push   %edi
80105bf0:	68 ee 76 10 80       	push   $0x801076ee
80105bf5:	e8 b6 aa ff ff       	call   801006b0 <cprintf>
      p->killed=1;
80105bfa:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
      break;
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	e9 f9 fd ff ff       	jmp    80105a02 <trap+0x42>
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    char *mem= kalloc();
80105c10:	e8 4b ca ff ff       	call   80102660 <kalloc>
    if(mem==0){
80105c15:	85 c0                	test   %eax,%eax
80105c17:	74 57                	je     80105c70 <trap+0x2b0>
    memset(mem,0,PGSIZE);
80105c19:	83 ec 04             	sub    $0x4,%esp
80105c1c:	68 00 10 00 00       	push   $0x1000
80105c21:	6a 00                	push   $0x0
80105c23:	50                   	push   %eax
80105c24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105c27:	e8 94 ea ff ff       	call   801046c0 <memset>
    mappages(p->pgdir,(char*)va,PGSIZE,V2P(mem),PTE_W| PTE_U);
80105c2c:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80105c33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105c36:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80105c3c:	52                   	push   %edx
80105c3d:	68 00 10 00 00       	push   $0x1000
80105c42:	57                   	push   %edi
80105c43:	ff 76 04             	push   0x4(%esi)
80105c46:	e8 25 0e 00 00       	call   80106a70 <mappages>
    p->page_faults++;
80105c4b:	83 46 7c 01          	addl   $0x1,0x7c(%esi)
    break;
80105c4f:	83 c4 20             	add    $0x20,%esp
80105c52:	e9 ab fd ff ff       	jmp    80105a02 <trap+0x42>
80105c57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c5e:	00 
80105c5f:	90                   	nop
    exit();
80105c60:	e8 2b e1 ff ff       	call   80103d90 <exit>
80105c65:	e9 bb fd ff ff       	jmp    80105a25 <trap+0x65>
80105c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("kalloc failed\n");
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	68 08 77 10 80       	push   $0x80107708
80105c78:	e8 33 aa ff ff       	call   801006b0 <cprintf>
      p->killed=1;
80105c7d:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
      break;
80105c84:	83 c4 10             	add    $0x10,%esp
80105c87:	e9 76 fd ff ff       	jmp    80105a02 <trap+0x42>
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105c90:	e8 fb e0 ff ff       	call   80103d90 <exit>
80105c95:	e9 7e fe ff ff       	jmp    80105b18 <trap+0x158>
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	68 80 3d 11 80       	push   $0x80113d80
80105ca8:	e8 13 e9 ff ff       	call   801045c0 <acquire>
      ticks++;
80105cad:	83 05 60 3d 11 80 01 	addl   $0x1,0x80113d60
      wakeup(&ticks);
80105cb4:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80105cbb:	e8 40 e4 ff ff       	call   80104100 <wakeup>
      release(&tickslock);
80105cc0:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105cc7:	e8 94 e8 ff ff       	call   80104560 <release>
80105ccc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105ccf:	e9 29 fd ff ff       	jmp    801059fd <trap+0x3d>
80105cd4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105cd7:	e8 84 dc ff ff       	call   80103960 <cpuid>
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	56                   	push   %esi
80105ce0:	57                   	push   %edi
80105ce1:	50                   	push   %eax
80105ce2:	ff 73 30             	push   0x30(%ebx)
80105ce5:	68 2c 79 10 80       	push   $0x8010792c
80105cea:	e8 c1 a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105cef:	83 c4 14             	add    $0x14,%esp
80105cf2:	68 17 77 10 80       	push   $0x80107717
80105cf7:	e8 84 a6 ff ff       	call   80100380 <panic>
    panic("page fault with no process");
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	68 d3 76 10 80       	push   $0x801076d3
80105d04:	e8 77 a6 ff ff       	call   80100380 <panic>
80105d09:	66 90                	xchg   %ax,%ax
80105d0b:	66 90                	xchg   %ax,%ax
80105d0d:	66 90                	xchg   %ax,%ax
80105d0f:	90                   	nop

80105d10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d10:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105d15:	85 c0                	test   %eax,%eax
80105d17:	74 17                	je     80105d30 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d19:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d1e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d1f:	a8 01                	test   $0x1,%al
80105d21:	74 0d                	je     80105d30 <uartgetc+0x20>
80105d23:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d28:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d29:	0f b6 c0             	movzbl %al,%eax
80105d2c:	c3                   	ret
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d35:	c3                   	ret
80105d36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d3d:	00 
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <uartinit>:
{
80105d40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d41:	31 c9                	xor    %ecx,%ecx
80105d43:	89 c8                	mov    %ecx,%eax
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	57                   	push   %edi
80105d48:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105d4d:	56                   	push   %esi
80105d4e:	89 fa                	mov    %edi,%edx
80105d50:	53                   	push   %ebx
80105d51:	83 ec 1c             	sub    $0x1c,%esp
80105d54:	ee                   	out    %al,(%dx)
80105d55:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d5f:	89 f2                	mov    %esi,%edx
80105d61:	ee                   	out    %al,(%dx)
80105d62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d6c:	ee                   	out    %al,(%dx)
80105d6d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d72:	89 c8                	mov    %ecx,%eax
80105d74:	89 da                	mov    %ebx,%edx
80105d76:	ee                   	out    %al,(%dx)
80105d77:	b8 03 00 00 00       	mov    $0x3,%eax
80105d7c:	89 f2                	mov    %esi,%edx
80105d7e:	ee                   	out    %al,(%dx)
80105d7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d84:	89 c8                	mov    %ecx,%eax
80105d86:	ee                   	out    %al,(%dx)
80105d87:	b8 01 00 00 00       	mov    $0x1,%eax
80105d8c:	89 da                	mov    %ebx,%edx
80105d8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d95:	3c ff                	cmp    $0xff,%al
80105d97:	0f 84 7c 00 00 00    	je     80105e19 <uartinit+0xd9>
  uart = 1;
80105d9d:	c7 05 c0 45 11 80 01 	movl   $0x1,0x801145c0
80105da4:	00 00 00 
80105da7:	89 fa                	mov    %edi,%edx
80105da9:	ec                   	in     (%dx),%al
80105daa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105daf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105db0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105db3:	bf 1c 77 10 80       	mov    $0x8010771c,%edi
80105db8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105dbd:	6a 00                	push   $0x0
80105dbf:	6a 04                	push   $0x4
80105dc1:	e8 9a c6 ff ff       	call   80102460 <ioapicenable>
80105dc6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105dc9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105dd0:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	74 32                	je     80105e0b <uartinit+0xcb>
80105dd9:	89 f2                	mov    %esi,%edx
80105ddb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ddc:	a8 20                	test   $0x20,%al
80105dde:	75 21                	jne    80105e01 <uartinit+0xc1>
80105de0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105de5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105de8:	83 ec 0c             	sub    $0xc,%esp
80105deb:	6a 0a                	push   $0xa
80105ded:	e8 1e cb ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	83 eb 01             	sub    $0x1,%ebx
80105df8:	74 07                	je     80105e01 <uartinit+0xc1>
80105dfa:	89 f2                	mov    %esi,%edx
80105dfc:	ec                   	in     (%dx),%al
80105dfd:	a8 20                	test   $0x20,%al
80105dff:	74 e7                	je     80105de8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e01:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e06:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105e0a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105e0b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105e0f:	83 c7 01             	add    $0x1,%edi
80105e12:	88 45 e7             	mov    %al,-0x19(%ebp)
80105e15:	84 c0                	test   %al,%al
80105e17:	75 b7                	jne    80105dd0 <uartinit+0x90>
}
80105e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e1c:	5b                   	pop    %ebx
80105e1d:	5e                   	pop    %esi
80105e1e:	5f                   	pop    %edi
80105e1f:	5d                   	pop    %ebp
80105e20:	c3                   	ret
80105e21:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e28:	00 
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e30 <uartputc>:
  if(!uart)
80105e30:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105e35:	85 c0                	test   %eax,%eax
80105e37:	74 4f                	je     80105e88 <uartputc+0x58>
{
80105e39:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e3a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e3f:	89 e5                	mov    %esp,%ebp
80105e41:	56                   	push   %esi
80105e42:	53                   	push   %ebx
80105e43:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e44:	a8 20                	test   $0x20,%al
80105e46:	75 29                	jne    80105e71 <uartputc+0x41>
80105e48:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e4d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105e58:	83 ec 0c             	sub    $0xc,%esp
80105e5b:	6a 0a                	push   $0xa
80105e5d:	e8 ae ca ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e62:	83 c4 10             	add    $0x10,%esp
80105e65:	83 eb 01             	sub    $0x1,%ebx
80105e68:	74 07                	je     80105e71 <uartputc+0x41>
80105e6a:	89 f2                	mov    %esi,%edx
80105e6c:	ec                   	in     (%dx),%al
80105e6d:	a8 20                	test   $0x20,%al
80105e6f:	74 e7                	je     80105e58 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e71:	8b 45 08             	mov    0x8(%ebp),%eax
80105e74:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e79:	ee                   	out    %al,(%dx)
}
80105e7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e7d:	5b                   	pop    %ebx
80105e7e:	5e                   	pop    %esi
80105e7f:	5d                   	pop    %ebp
80105e80:	c3                   	ret
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e88:	c3                   	ret
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e90 <uartintr>:

void
uartintr(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e96:	68 10 5d 10 80       	push   $0x80105d10
80105e9b:	e8 00 aa ff ff       	call   801008a0 <consoleintr>
}
80105ea0:	83 c4 10             	add    $0x10,%esp
80105ea3:	c9                   	leave
80105ea4:	c3                   	ret

80105ea5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $0
80105ea7:	6a 00                	push   $0x0
  jmp alltraps
80105ea9:	e9 32 fa ff ff       	jmp    801058e0 <alltraps>

80105eae <vector1>:
.globl vector1
vector1:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $1
80105eb0:	6a 01                	push   $0x1
  jmp alltraps
80105eb2:	e9 29 fa ff ff       	jmp    801058e0 <alltraps>

80105eb7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $2
80105eb9:	6a 02                	push   $0x2
  jmp alltraps
80105ebb:	e9 20 fa ff ff       	jmp    801058e0 <alltraps>

80105ec0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $3
80105ec2:	6a 03                	push   $0x3
  jmp alltraps
80105ec4:	e9 17 fa ff ff       	jmp    801058e0 <alltraps>

80105ec9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $4
80105ecb:	6a 04                	push   $0x4
  jmp alltraps
80105ecd:	e9 0e fa ff ff       	jmp    801058e0 <alltraps>

80105ed2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $5
80105ed4:	6a 05                	push   $0x5
  jmp alltraps
80105ed6:	e9 05 fa ff ff       	jmp    801058e0 <alltraps>

80105edb <vector6>:
.globl vector6
vector6:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $6
80105edd:	6a 06                	push   $0x6
  jmp alltraps
80105edf:	e9 fc f9 ff ff       	jmp    801058e0 <alltraps>

80105ee4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $7
80105ee6:	6a 07                	push   $0x7
  jmp alltraps
80105ee8:	e9 f3 f9 ff ff       	jmp    801058e0 <alltraps>

80105eed <vector8>:
.globl vector8
vector8:
  pushl $8
80105eed:	6a 08                	push   $0x8
  jmp alltraps
80105eef:	e9 ec f9 ff ff       	jmp    801058e0 <alltraps>

80105ef4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $9
80105ef6:	6a 09                	push   $0x9
  jmp alltraps
80105ef8:	e9 e3 f9 ff ff       	jmp    801058e0 <alltraps>

80105efd <vector10>:
.globl vector10
vector10:
  pushl $10
80105efd:	6a 0a                	push   $0xa
  jmp alltraps
80105eff:	e9 dc f9 ff ff       	jmp    801058e0 <alltraps>

80105f04 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f04:	6a 0b                	push   $0xb
  jmp alltraps
80105f06:	e9 d5 f9 ff ff       	jmp    801058e0 <alltraps>

80105f0b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f0b:	6a 0c                	push   $0xc
  jmp alltraps
80105f0d:	e9 ce f9 ff ff       	jmp    801058e0 <alltraps>

80105f12 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f12:	6a 0d                	push   $0xd
  jmp alltraps
80105f14:	e9 c7 f9 ff ff       	jmp    801058e0 <alltraps>

80105f19 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f19:	6a 0e                	push   $0xe
  jmp alltraps
80105f1b:	e9 c0 f9 ff ff       	jmp    801058e0 <alltraps>

80105f20 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $15
80105f22:	6a 0f                	push   $0xf
  jmp alltraps
80105f24:	e9 b7 f9 ff ff       	jmp    801058e0 <alltraps>

80105f29 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $16
80105f2b:	6a 10                	push   $0x10
  jmp alltraps
80105f2d:	e9 ae f9 ff ff       	jmp    801058e0 <alltraps>

80105f32 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f32:	6a 11                	push   $0x11
  jmp alltraps
80105f34:	e9 a7 f9 ff ff       	jmp    801058e0 <alltraps>

80105f39 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $18
80105f3b:	6a 12                	push   $0x12
  jmp alltraps
80105f3d:	e9 9e f9 ff ff       	jmp    801058e0 <alltraps>

80105f42 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $19
80105f44:	6a 13                	push   $0x13
  jmp alltraps
80105f46:	e9 95 f9 ff ff       	jmp    801058e0 <alltraps>

80105f4b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $20
80105f4d:	6a 14                	push   $0x14
  jmp alltraps
80105f4f:	e9 8c f9 ff ff       	jmp    801058e0 <alltraps>

80105f54 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $21
80105f56:	6a 15                	push   $0x15
  jmp alltraps
80105f58:	e9 83 f9 ff ff       	jmp    801058e0 <alltraps>

80105f5d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $22
80105f5f:	6a 16                	push   $0x16
  jmp alltraps
80105f61:	e9 7a f9 ff ff       	jmp    801058e0 <alltraps>

80105f66 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $23
80105f68:	6a 17                	push   $0x17
  jmp alltraps
80105f6a:	e9 71 f9 ff ff       	jmp    801058e0 <alltraps>

80105f6f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $24
80105f71:	6a 18                	push   $0x18
  jmp alltraps
80105f73:	e9 68 f9 ff ff       	jmp    801058e0 <alltraps>

80105f78 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $25
80105f7a:	6a 19                	push   $0x19
  jmp alltraps
80105f7c:	e9 5f f9 ff ff       	jmp    801058e0 <alltraps>

80105f81 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $26
80105f83:	6a 1a                	push   $0x1a
  jmp alltraps
80105f85:	e9 56 f9 ff ff       	jmp    801058e0 <alltraps>

80105f8a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $27
80105f8c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f8e:	e9 4d f9 ff ff       	jmp    801058e0 <alltraps>

80105f93 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $28
80105f95:	6a 1c                	push   $0x1c
  jmp alltraps
80105f97:	e9 44 f9 ff ff       	jmp    801058e0 <alltraps>

80105f9c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $29
80105f9e:	6a 1d                	push   $0x1d
  jmp alltraps
80105fa0:	e9 3b f9 ff ff       	jmp    801058e0 <alltraps>

80105fa5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $30
80105fa7:	6a 1e                	push   $0x1e
  jmp alltraps
80105fa9:	e9 32 f9 ff ff       	jmp    801058e0 <alltraps>

80105fae <vector31>:
.globl vector31
vector31:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $31
80105fb0:	6a 1f                	push   $0x1f
  jmp alltraps
80105fb2:	e9 29 f9 ff ff       	jmp    801058e0 <alltraps>

80105fb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $32
80105fb9:	6a 20                	push   $0x20
  jmp alltraps
80105fbb:	e9 20 f9 ff ff       	jmp    801058e0 <alltraps>

80105fc0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $33
80105fc2:	6a 21                	push   $0x21
  jmp alltraps
80105fc4:	e9 17 f9 ff ff       	jmp    801058e0 <alltraps>

80105fc9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $34
80105fcb:	6a 22                	push   $0x22
  jmp alltraps
80105fcd:	e9 0e f9 ff ff       	jmp    801058e0 <alltraps>

80105fd2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $35
80105fd4:	6a 23                	push   $0x23
  jmp alltraps
80105fd6:	e9 05 f9 ff ff       	jmp    801058e0 <alltraps>

80105fdb <vector36>:
.globl vector36
vector36:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $36
80105fdd:	6a 24                	push   $0x24
  jmp alltraps
80105fdf:	e9 fc f8 ff ff       	jmp    801058e0 <alltraps>

80105fe4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $37
80105fe6:	6a 25                	push   $0x25
  jmp alltraps
80105fe8:	e9 f3 f8 ff ff       	jmp    801058e0 <alltraps>

80105fed <vector38>:
.globl vector38
vector38:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $38
80105fef:	6a 26                	push   $0x26
  jmp alltraps
80105ff1:	e9 ea f8 ff ff       	jmp    801058e0 <alltraps>

80105ff6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $39
80105ff8:	6a 27                	push   $0x27
  jmp alltraps
80105ffa:	e9 e1 f8 ff ff       	jmp    801058e0 <alltraps>

80105fff <vector40>:
.globl vector40
vector40:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $40
80106001:	6a 28                	push   $0x28
  jmp alltraps
80106003:	e9 d8 f8 ff ff       	jmp    801058e0 <alltraps>

80106008 <vector41>:
.globl vector41
vector41:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $41
8010600a:	6a 29                	push   $0x29
  jmp alltraps
8010600c:	e9 cf f8 ff ff       	jmp    801058e0 <alltraps>

80106011 <vector42>:
.globl vector42
vector42:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $42
80106013:	6a 2a                	push   $0x2a
  jmp alltraps
80106015:	e9 c6 f8 ff ff       	jmp    801058e0 <alltraps>

8010601a <vector43>:
.globl vector43
vector43:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $43
8010601c:	6a 2b                	push   $0x2b
  jmp alltraps
8010601e:	e9 bd f8 ff ff       	jmp    801058e0 <alltraps>

80106023 <vector44>:
.globl vector44
vector44:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $44
80106025:	6a 2c                	push   $0x2c
  jmp alltraps
80106027:	e9 b4 f8 ff ff       	jmp    801058e0 <alltraps>

8010602c <vector45>:
.globl vector45
vector45:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $45
8010602e:	6a 2d                	push   $0x2d
  jmp alltraps
80106030:	e9 ab f8 ff ff       	jmp    801058e0 <alltraps>

80106035 <vector46>:
.globl vector46
vector46:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $46
80106037:	6a 2e                	push   $0x2e
  jmp alltraps
80106039:	e9 a2 f8 ff ff       	jmp    801058e0 <alltraps>

8010603e <vector47>:
.globl vector47
vector47:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $47
80106040:	6a 2f                	push   $0x2f
  jmp alltraps
80106042:	e9 99 f8 ff ff       	jmp    801058e0 <alltraps>

80106047 <vector48>:
.globl vector48
vector48:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $48
80106049:	6a 30                	push   $0x30
  jmp alltraps
8010604b:	e9 90 f8 ff ff       	jmp    801058e0 <alltraps>

80106050 <vector49>:
.globl vector49
vector49:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $49
80106052:	6a 31                	push   $0x31
  jmp alltraps
80106054:	e9 87 f8 ff ff       	jmp    801058e0 <alltraps>

80106059 <vector50>:
.globl vector50
vector50:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $50
8010605b:	6a 32                	push   $0x32
  jmp alltraps
8010605d:	e9 7e f8 ff ff       	jmp    801058e0 <alltraps>

80106062 <vector51>:
.globl vector51
vector51:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $51
80106064:	6a 33                	push   $0x33
  jmp alltraps
80106066:	e9 75 f8 ff ff       	jmp    801058e0 <alltraps>

8010606b <vector52>:
.globl vector52
vector52:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $52
8010606d:	6a 34                	push   $0x34
  jmp alltraps
8010606f:	e9 6c f8 ff ff       	jmp    801058e0 <alltraps>

80106074 <vector53>:
.globl vector53
vector53:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $53
80106076:	6a 35                	push   $0x35
  jmp alltraps
80106078:	e9 63 f8 ff ff       	jmp    801058e0 <alltraps>

8010607d <vector54>:
.globl vector54
vector54:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $54
8010607f:	6a 36                	push   $0x36
  jmp alltraps
80106081:	e9 5a f8 ff ff       	jmp    801058e0 <alltraps>

80106086 <vector55>:
.globl vector55
vector55:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $55
80106088:	6a 37                	push   $0x37
  jmp alltraps
8010608a:	e9 51 f8 ff ff       	jmp    801058e0 <alltraps>

8010608f <vector56>:
.globl vector56
vector56:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $56
80106091:	6a 38                	push   $0x38
  jmp alltraps
80106093:	e9 48 f8 ff ff       	jmp    801058e0 <alltraps>

80106098 <vector57>:
.globl vector57
vector57:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $57
8010609a:	6a 39                	push   $0x39
  jmp alltraps
8010609c:	e9 3f f8 ff ff       	jmp    801058e0 <alltraps>

801060a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $58
801060a3:	6a 3a                	push   $0x3a
  jmp alltraps
801060a5:	e9 36 f8 ff ff       	jmp    801058e0 <alltraps>

801060aa <vector59>:
.globl vector59
vector59:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $59
801060ac:	6a 3b                	push   $0x3b
  jmp alltraps
801060ae:	e9 2d f8 ff ff       	jmp    801058e0 <alltraps>

801060b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $60
801060b5:	6a 3c                	push   $0x3c
  jmp alltraps
801060b7:	e9 24 f8 ff ff       	jmp    801058e0 <alltraps>

801060bc <vector61>:
.globl vector61
vector61:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $61
801060be:	6a 3d                	push   $0x3d
  jmp alltraps
801060c0:	e9 1b f8 ff ff       	jmp    801058e0 <alltraps>

801060c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $62
801060c7:	6a 3e                	push   $0x3e
  jmp alltraps
801060c9:	e9 12 f8 ff ff       	jmp    801058e0 <alltraps>

801060ce <vector63>:
.globl vector63
vector63:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $63
801060d0:	6a 3f                	push   $0x3f
  jmp alltraps
801060d2:	e9 09 f8 ff ff       	jmp    801058e0 <alltraps>

801060d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $64
801060d9:	6a 40                	push   $0x40
  jmp alltraps
801060db:	e9 00 f8 ff ff       	jmp    801058e0 <alltraps>

801060e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $65
801060e2:	6a 41                	push   $0x41
  jmp alltraps
801060e4:	e9 f7 f7 ff ff       	jmp    801058e0 <alltraps>

801060e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $66
801060eb:	6a 42                	push   $0x42
  jmp alltraps
801060ed:	e9 ee f7 ff ff       	jmp    801058e0 <alltraps>

801060f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $67
801060f4:	6a 43                	push   $0x43
  jmp alltraps
801060f6:	e9 e5 f7 ff ff       	jmp    801058e0 <alltraps>

801060fb <vector68>:
.globl vector68
vector68:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $68
801060fd:	6a 44                	push   $0x44
  jmp alltraps
801060ff:	e9 dc f7 ff ff       	jmp    801058e0 <alltraps>

80106104 <vector69>:
.globl vector69
vector69:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $69
80106106:	6a 45                	push   $0x45
  jmp alltraps
80106108:	e9 d3 f7 ff ff       	jmp    801058e0 <alltraps>

8010610d <vector70>:
.globl vector70
vector70:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $70
8010610f:	6a 46                	push   $0x46
  jmp alltraps
80106111:	e9 ca f7 ff ff       	jmp    801058e0 <alltraps>

80106116 <vector71>:
.globl vector71
vector71:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $71
80106118:	6a 47                	push   $0x47
  jmp alltraps
8010611a:	e9 c1 f7 ff ff       	jmp    801058e0 <alltraps>

8010611f <vector72>:
.globl vector72
vector72:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $72
80106121:	6a 48                	push   $0x48
  jmp alltraps
80106123:	e9 b8 f7 ff ff       	jmp    801058e0 <alltraps>

80106128 <vector73>:
.globl vector73
vector73:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $73
8010612a:	6a 49                	push   $0x49
  jmp alltraps
8010612c:	e9 af f7 ff ff       	jmp    801058e0 <alltraps>

80106131 <vector74>:
.globl vector74
vector74:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $74
80106133:	6a 4a                	push   $0x4a
  jmp alltraps
80106135:	e9 a6 f7 ff ff       	jmp    801058e0 <alltraps>

8010613a <vector75>:
.globl vector75
vector75:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $75
8010613c:	6a 4b                	push   $0x4b
  jmp alltraps
8010613e:	e9 9d f7 ff ff       	jmp    801058e0 <alltraps>

80106143 <vector76>:
.globl vector76
vector76:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $76
80106145:	6a 4c                	push   $0x4c
  jmp alltraps
80106147:	e9 94 f7 ff ff       	jmp    801058e0 <alltraps>

8010614c <vector77>:
.globl vector77
vector77:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $77
8010614e:	6a 4d                	push   $0x4d
  jmp alltraps
80106150:	e9 8b f7 ff ff       	jmp    801058e0 <alltraps>

80106155 <vector78>:
.globl vector78
vector78:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $78
80106157:	6a 4e                	push   $0x4e
  jmp alltraps
80106159:	e9 82 f7 ff ff       	jmp    801058e0 <alltraps>

8010615e <vector79>:
.globl vector79
vector79:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $79
80106160:	6a 4f                	push   $0x4f
  jmp alltraps
80106162:	e9 79 f7 ff ff       	jmp    801058e0 <alltraps>

80106167 <vector80>:
.globl vector80
vector80:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $80
80106169:	6a 50                	push   $0x50
  jmp alltraps
8010616b:	e9 70 f7 ff ff       	jmp    801058e0 <alltraps>

80106170 <vector81>:
.globl vector81
vector81:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $81
80106172:	6a 51                	push   $0x51
  jmp alltraps
80106174:	e9 67 f7 ff ff       	jmp    801058e0 <alltraps>

80106179 <vector82>:
.globl vector82
vector82:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $82
8010617b:	6a 52                	push   $0x52
  jmp alltraps
8010617d:	e9 5e f7 ff ff       	jmp    801058e0 <alltraps>

80106182 <vector83>:
.globl vector83
vector83:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $83
80106184:	6a 53                	push   $0x53
  jmp alltraps
80106186:	e9 55 f7 ff ff       	jmp    801058e0 <alltraps>

8010618b <vector84>:
.globl vector84
vector84:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $84
8010618d:	6a 54                	push   $0x54
  jmp alltraps
8010618f:	e9 4c f7 ff ff       	jmp    801058e0 <alltraps>

80106194 <vector85>:
.globl vector85
vector85:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $85
80106196:	6a 55                	push   $0x55
  jmp alltraps
80106198:	e9 43 f7 ff ff       	jmp    801058e0 <alltraps>

8010619d <vector86>:
.globl vector86
vector86:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $86
8010619f:	6a 56                	push   $0x56
  jmp alltraps
801061a1:	e9 3a f7 ff ff       	jmp    801058e0 <alltraps>

801061a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $87
801061a8:	6a 57                	push   $0x57
  jmp alltraps
801061aa:	e9 31 f7 ff ff       	jmp    801058e0 <alltraps>

801061af <vector88>:
.globl vector88
vector88:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $88
801061b1:	6a 58                	push   $0x58
  jmp alltraps
801061b3:	e9 28 f7 ff ff       	jmp    801058e0 <alltraps>

801061b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $89
801061ba:	6a 59                	push   $0x59
  jmp alltraps
801061bc:	e9 1f f7 ff ff       	jmp    801058e0 <alltraps>

801061c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $90
801061c3:	6a 5a                	push   $0x5a
  jmp alltraps
801061c5:	e9 16 f7 ff ff       	jmp    801058e0 <alltraps>

801061ca <vector91>:
.globl vector91
vector91:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $91
801061cc:	6a 5b                	push   $0x5b
  jmp alltraps
801061ce:	e9 0d f7 ff ff       	jmp    801058e0 <alltraps>

801061d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $92
801061d5:	6a 5c                	push   $0x5c
  jmp alltraps
801061d7:	e9 04 f7 ff ff       	jmp    801058e0 <alltraps>

801061dc <vector93>:
.globl vector93
vector93:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $93
801061de:	6a 5d                	push   $0x5d
  jmp alltraps
801061e0:	e9 fb f6 ff ff       	jmp    801058e0 <alltraps>

801061e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $94
801061e7:	6a 5e                	push   $0x5e
  jmp alltraps
801061e9:	e9 f2 f6 ff ff       	jmp    801058e0 <alltraps>

801061ee <vector95>:
.globl vector95
vector95:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $95
801061f0:	6a 5f                	push   $0x5f
  jmp alltraps
801061f2:	e9 e9 f6 ff ff       	jmp    801058e0 <alltraps>

801061f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $96
801061f9:	6a 60                	push   $0x60
  jmp alltraps
801061fb:	e9 e0 f6 ff ff       	jmp    801058e0 <alltraps>

80106200 <vector97>:
.globl vector97
vector97:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $97
80106202:	6a 61                	push   $0x61
  jmp alltraps
80106204:	e9 d7 f6 ff ff       	jmp    801058e0 <alltraps>

80106209 <vector98>:
.globl vector98
vector98:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $98
8010620b:	6a 62                	push   $0x62
  jmp alltraps
8010620d:	e9 ce f6 ff ff       	jmp    801058e0 <alltraps>

80106212 <vector99>:
.globl vector99
vector99:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $99
80106214:	6a 63                	push   $0x63
  jmp alltraps
80106216:	e9 c5 f6 ff ff       	jmp    801058e0 <alltraps>

8010621b <vector100>:
.globl vector100
vector100:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $100
8010621d:	6a 64                	push   $0x64
  jmp alltraps
8010621f:	e9 bc f6 ff ff       	jmp    801058e0 <alltraps>

80106224 <vector101>:
.globl vector101
vector101:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $101
80106226:	6a 65                	push   $0x65
  jmp alltraps
80106228:	e9 b3 f6 ff ff       	jmp    801058e0 <alltraps>

8010622d <vector102>:
.globl vector102
vector102:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $102
8010622f:	6a 66                	push   $0x66
  jmp alltraps
80106231:	e9 aa f6 ff ff       	jmp    801058e0 <alltraps>

80106236 <vector103>:
.globl vector103
vector103:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $103
80106238:	6a 67                	push   $0x67
  jmp alltraps
8010623a:	e9 a1 f6 ff ff       	jmp    801058e0 <alltraps>

8010623f <vector104>:
.globl vector104
vector104:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $104
80106241:	6a 68                	push   $0x68
  jmp alltraps
80106243:	e9 98 f6 ff ff       	jmp    801058e0 <alltraps>

80106248 <vector105>:
.globl vector105
vector105:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $105
8010624a:	6a 69                	push   $0x69
  jmp alltraps
8010624c:	e9 8f f6 ff ff       	jmp    801058e0 <alltraps>

80106251 <vector106>:
.globl vector106
vector106:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $106
80106253:	6a 6a                	push   $0x6a
  jmp alltraps
80106255:	e9 86 f6 ff ff       	jmp    801058e0 <alltraps>

8010625a <vector107>:
.globl vector107
vector107:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $107
8010625c:	6a 6b                	push   $0x6b
  jmp alltraps
8010625e:	e9 7d f6 ff ff       	jmp    801058e0 <alltraps>

80106263 <vector108>:
.globl vector108
vector108:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $108
80106265:	6a 6c                	push   $0x6c
  jmp alltraps
80106267:	e9 74 f6 ff ff       	jmp    801058e0 <alltraps>

8010626c <vector109>:
.globl vector109
vector109:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $109
8010626e:	6a 6d                	push   $0x6d
  jmp alltraps
80106270:	e9 6b f6 ff ff       	jmp    801058e0 <alltraps>

80106275 <vector110>:
.globl vector110
vector110:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $110
80106277:	6a 6e                	push   $0x6e
  jmp alltraps
80106279:	e9 62 f6 ff ff       	jmp    801058e0 <alltraps>

8010627e <vector111>:
.globl vector111
vector111:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $111
80106280:	6a 6f                	push   $0x6f
  jmp alltraps
80106282:	e9 59 f6 ff ff       	jmp    801058e0 <alltraps>

80106287 <vector112>:
.globl vector112
vector112:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $112
80106289:	6a 70                	push   $0x70
  jmp alltraps
8010628b:	e9 50 f6 ff ff       	jmp    801058e0 <alltraps>

80106290 <vector113>:
.globl vector113
vector113:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $113
80106292:	6a 71                	push   $0x71
  jmp alltraps
80106294:	e9 47 f6 ff ff       	jmp    801058e0 <alltraps>

80106299 <vector114>:
.globl vector114
vector114:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $114
8010629b:	6a 72                	push   $0x72
  jmp alltraps
8010629d:	e9 3e f6 ff ff       	jmp    801058e0 <alltraps>

801062a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $115
801062a4:	6a 73                	push   $0x73
  jmp alltraps
801062a6:	e9 35 f6 ff ff       	jmp    801058e0 <alltraps>

801062ab <vector116>:
.globl vector116
vector116:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $116
801062ad:	6a 74                	push   $0x74
  jmp alltraps
801062af:	e9 2c f6 ff ff       	jmp    801058e0 <alltraps>

801062b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $117
801062b6:	6a 75                	push   $0x75
  jmp alltraps
801062b8:	e9 23 f6 ff ff       	jmp    801058e0 <alltraps>

801062bd <vector118>:
.globl vector118
vector118:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $118
801062bf:	6a 76                	push   $0x76
  jmp alltraps
801062c1:	e9 1a f6 ff ff       	jmp    801058e0 <alltraps>

801062c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $119
801062c8:	6a 77                	push   $0x77
  jmp alltraps
801062ca:	e9 11 f6 ff ff       	jmp    801058e0 <alltraps>

801062cf <vector120>:
.globl vector120
vector120:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $120
801062d1:	6a 78                	push   $0x78
  jmp alltraps
801062d3:	e9 08 f6 ff ff       	jmp    801058e0 <alltraps>

801062d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $121
801062da:	6a 79                	push   $0x79
  jmp alltraps
801062dc:	e9 ff f5 ff ff       	jmp    801058e0 <alltraps>

801062e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $122
801062e3:	6a 7a                	push   $0x7a
  jmp alltraps
801062e5:	e9 f6 f5 ff ff       	jmp    801058e0 <alltraps>

801062ea <vector123>:
.globl vector123
vector123:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $123
801062ec:	6a 7b                	push   $0x7b
  jmp alltraps
801062ee:	e9 ed f5 ff ff       	jmp    801058e0 <alltraps>

801062f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $124
801062f5:	6a 7c                	push   $0x7c
  jmp alltraps
801062f7:	e9 e4 f5 ff ff       	jmp    801058e0 <alltraps>

801062fc <vector125>:
.globl vector125
vector125:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $125
801062fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106300:	e9 db f5 ff ff       	jmp    801058e0 <alltraps>

80106305 <vector126>:
.globl vector126
vector126:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $126
80106307:	6a 7e                	push   $0x7e
  jmp alltraps
80106309:	e9 d2 f5 ff ff       	jmp    801058e0 <alltraps>

8010630e <vector127>:
.globl vector127
vector127:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $127
80106310:	6a 7f                	push   $0x7f
  jmp alltraps
80106312:	e9 c9 f5 ff ff       	jmp    801058e0 <alltraps>

80106317 <vector128>:
.globl vector128
vector128:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $128
80106319:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010631e:	e9 bd f5 ff ff       	jmp    801058e0 <alltraps>

80106323 <vector129>:
.globl vector129
vector129:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $129
80106325:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010632a:	e9 b1 f5 ff ff       	jmp    801058e0 <alltraps>

8010632f <vector130>:
.globl vector130
vector130:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $130
80106331:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106336:	e9 a5 f5 ff ff       	jmp    801058e0 <alltraps>

8010633b <vector131>:
.globl vector131
vector131:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $131
8010633d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106342:	e9 99 f5 ff ff       	jmp    801058e0 <alltraps>

80106347 <vector132>:
.globl vector132
vector132:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $132
80106349:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010634e:	e9 8d f5 ff ff       	jmp    801058e0 <alltraps>

80106353 <vector133>:
.globl vector133
vector133:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $133
80106355:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010635a:	e9 81 f5 ff ff       	jmp    801058e0 <alltraps>

8010635f <vector134>:
.globl vector134
vector134:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $134
80106361:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106366:	e9 75 f5 ff ff       	jmp    801058e0 <alltraps>

8010636b <vector135>:
.globl vector135
vector135:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $135
8010636d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106372:	e9 69 f5 ff ff       	jmp    801058e0 <alltraps>

80106377 <vector136>:
.globl vector136
vector136:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $136
80106379:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010637e:	e9 5d f5 ff ff       	jmp    801058e0 <alltraps>

80106383 <vector137>:
.globl vector137
vector137:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $137
80106385:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010638a:	e9 51 f5 ff ff       	jmp    801058e0 <alltraps>

8010638f <vector138>:
.globl vector138
vector138:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $138
80106391:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106396:	e9 45 f5 ff ff       	jmp    801058e0 <alltraps>

8010639b <vector139>:
.globl vector139
vector139:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $139
8010639d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063a2:	e9 39 f5 ff ff       	jmp    801058e0 <alltraps>

801063a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $140
801063a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063ae:	e9 2d f5 ff ff       	jmp    801058e0 <alltraps>

801063b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $141
801063b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063ba:	e9 21 f5 ff ff       	jmp    801058e0 <alltraps>

801063bf <vector142>:
.globl vector142
vector142:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $142
801063c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801063c6:	e9 15 f5 ff ff       	jmp    801058e0 <alltraps>

801063cb <vector143>:
.globl vector143
vector143:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $143
801063cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063d2:	e9 09 f5 ff ff       	jmp    801058e0 <alltraps>

801063d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $144
801063d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063de:	e9 fd f4 ff ff       	jmp    801058e0 <alltraps>

801063e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $145
801063e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801063ea:	e9 f1 f4 ff ff       	jmp    801058e0 <alltraps>

801063ef <vector146>:
.globl vector146
vector146:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $146
801063f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801063f6:	e9 e5 f4 ff ff       	jmp    801058e0 <alltraps>

801063fb <vector147>:
.globl vector147
vector147:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $147
801063fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106402:	e9 d9 f4 ff ff       	jmp    801058e0 <alltraps>

80106407 <vector148>:
.globl vector148
vector148:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $148
80106409:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010640e:	e9 cd f4 ff ff       	jmp    801058e0 <alltraps>

80106413 <vector149>:
.globl vector149
vector149:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $149
80106415:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010641a:	e9 c1 f4 ff ff       	jmp    801058e0 <alltraps>

8010641f <vector150>:
.globl vector150
vector150:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $150
80106421:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106426:	e9 b5 f4 ff ff       	jmp    801058e0 <alltraps>

8010642b <vector151>:
.globl vector151
vector151:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $151
8010642d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106432:	e9 a9 f4 ff ff       	jmp    801058e0 <alltraps>

80106437 <vector152>:
.globl vector152
vector152:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $152
80106439:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010643e:	e9 9d f4 ff ff       	jmp    801058e0 <alltraps>

80106443 <vector153>:
.globl vector153
vector153:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $153
80106445:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010644a:	e9 91 f4 ff ff       	jmp    801058e0 <alltraps>

8010644f <vector154>:
.globl vector154
vector154:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $154
80106451:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106456:	e9 85 f4 ff ff       	jmp    801058e0 <alltraps>

8010645b <vector155>:
.globl vector155
vector155:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $155
8010645d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106462:	e9 79 f4 ff ff       	jmp    801058e0 <alltraps>

80106467 <vector156>:
.globl vector156
vector156:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $156
80106469:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010646e:	e9 6d f4 ff ff       	jmp    801058e0 <alltraps>

80106473 <vector157>:
.globl vector157
vector157:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $157
80106475:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010647a:	e9 61 f4 ff ff       	jmp    801058e0 <alltraps>

8010647f <vector158>:
.globl vector158
vector158:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $158
80106481:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106486:	e9 55 f4 ff ff       	jmp    801058e0 <alltraps>

8010648b <vector159>:
.globl vector159
vector159:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $159
8010648d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106492:	e9 49 f4 ff ff       	jmp    801058e0 <alltraps>

80106497 <vector160>:
.globl vector160
vector160:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $160
80106499:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010649e:	e9 3d f4 ff ff       	jmp    801058e0 <alltraps>

801064a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $161
801064a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064aa:	e9 31 f4 ff ff       	jmp    801058e0 <alltraps>

801064af <vector162>:
.globl vector162
vector162:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $162
801064b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064b6:	e9 25 f4 ff ff       	jmp    801058e0 <alltraps>

801064bb <vector163>:
.globl vector163
vector163:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $163
801064bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801064c2:	e9 19 f4 ff ff       	jmp    801058e0 <alltraps>

801064c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $164
801064c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801064ce:	e9 0d f4 ff ff       	jmp    801058e0 <alltraps>

801064d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $165
801064d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064da:	e9 01 f4 ff ff       	jmp    801058e0 <alltraps>

801064df <vector166>:
.globl vector166
vector166:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $166
801064e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801064e6:	e9 f5 f3 ff ff       	jmp    801058e0 <alltraps>

801064eb <vector167>:
.globl vector167
vector167:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $167
801064ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801064f2:	e9 e9 f3 ff ff       	jmp    801058e0 <alltraps>

801064f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $168
801064f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801064fe:	e9 dd f3 ff ff       	jmp    801058e0 <alltraps>

80106503 <vector169>:
.globl vector169
vector169:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $169
80106505:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010650a:	e9 d1 f3 ff ff       	jmp    801058e0 <alltraps>

8010650f <vector170>:
.globl vector170
vector170:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $170
80106511:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106516:	e9 c5 f3 ff ff       	jmp    801058e0 <alltraps>

8010651b <vector171>:
.globl vector171
vector171:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $171
8010651d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106522:	e9 b9 f3 ff ff       	jmp    801058e0 <alltraps>

80106527 <vector172>:
.globl vector172
vector172:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $172
80106529:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010652e:	e9 ad f3 ff ff       	jmp    801058e0 <alltraps>

80106533 <vector173>:
.globl vector173
vector173:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $173
80106535:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010653a:	e9 a1 f3 ff ff       	jmp    801058e0 <alltraps>

8010653f <vector174>:
.globl vector174
vector174:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $174
80106541:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106546:	e9 95 f3 ff ff       	jmp    801058e0 <alltraps>

8010654b <vector175>:
.globl vector175
vector175:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $175
8010654d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106552:	e9 89 f3 ff ff       	jmp    801058e0 <alltraps>

80106557 <vector176>:
.globl vector176
vector176:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $176
80106559:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010655e:	e9 7d f3 ff ff       	jmp    801058e0 <alltraps>

80106563 <vector177>:
.globl vector177
vector177:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $177
80106565:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010656a:	e9 71 f3 ff ff       	jmp    801058e0 <alltraps>

8010656f <vector178>:
.globl vector178
vector178:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $178
80106571:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106576:	e9 65 f3 ff ff       	jmp    801058e0 <alltraps>

8010657b <vector179>:
.globl vector179
vector179:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $179
8010657d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106582:	e9 59 f3 ff ff       	jmp    801058e0 <alltraps>

80106587 <vector180>:
.globl vector180
vector180:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $180
80106589:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010658e:	e9 4d f3 ff ff       	jmp    801058e0 <alltraps>

80106593 <vector181>:
.globl vector181
vector181:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $181
80106595:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010659a:	e9 41 f3 ff ff       	jmp    801058e0 <alltraps>

8010659f <vector182>:
.globl vector182
vector182:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $182
801065a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065a6:	e9 35 f3 ff ff       	jmp    801058e0 <alltraps>

801065ab <vector183>:
.globl vector183
vector183:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $183
801065ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065b2:	e9 29 f3 ff ff       	jmp    801058e0 <alltraps>

801065b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $184
801065b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065be:	e9 1d f3 ff ff       	jmp    801058e0 <alltraps>

801065c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $185
801065c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801065ca:	e9 11 f3 ff ff       	jmp    801058e0 <alltraps>

801065cf <vector186>:
.globl vector186
vector186:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $186
801065d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065d6:	e9 05 f3 ff ff       	jmp    801058e0 <alltraps>

801065db <vector187>:
.globl vector187
vector187:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $187
801065dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801065e2:	e9 f9 f2 ff ff       	jmp    801058e0 <alltraps>

801065e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $188
801065e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801065ee:	e9 ed f2 ff ff       	jmp    801058e0 <alltraps>

801065f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $189
801065f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801065fa:	e9 e1 f2 ff ff       	jmp    801058e0 <alltraps>

801065ff <vector190>:
.globl vector190
vector190:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $190
80106601:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106606:	e9 d5 f2 ff ff       	jmp    801058e0 <alltraps>

8010660b <vector191>:
.globl vector191
vector191:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $191
8010660d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106612:	e9 c9 f2 ff ff       	jmp    801058e0 <alltraps>

80106617 <vector192>:
.globl vector192
vector192:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $192
80106619:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010661e:	e9 bd f2 ff ff       	jmp    801058e0 <alltraps>

80106623 <vector193>:
.globl vector193
vector193:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $193
80106625:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010662a:	e9 b1 f2 ff ff       	jmp    801058e0 <alltraps>

8010662f <vector194>:
.globl vector194
vector194:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $194
80106631:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106636:	e9 a5 f2 ff ff       	jmp    801058e0 <alltraps>

8010663b <vector195>:
.globl vector195
vector195:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $195
8010663d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106642:	e9 99 f2 ff ff       	jmp    801058e0 <alltraps>

80106647 <vector196>:
.globl vector196
vector196:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $196
80106649:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010664e:	e9 8d f2 ff ff       	jmp    801058e0 <alltraps>

80106653 <vector197>:
.globl vector197
vector197:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $197
80106655:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010665a:	e9 81 f2 ff ff       	jmp    801058e0 <alltraps>

8010665f <vector198>:
.globl vector198
vector198:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $198
80106661:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106666:	e9 75 f2 ff ff       	jmp    801058e0 <alltraps>

8010666b <vector199>:
.globl vector199
vector199:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $199
8010666d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106672:	e9 69 f2 ff ff       	jmp    801058e0 <alltraps>

80106677 <vector200>:
.globl vector200
vector200:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $200
80106679:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010667e:	e9 5d f2 ff ff       	jmp    801058e0 <alltraps>

80106683 <vector201>:
.globl vector201
vector201:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $201
80106685:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010668a:	e9 51 f2 ff ff       	jmp    801058e0 <alltraps>

8010668f <vector202>:
.globl vector202
vector202:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $202
80106691:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106696:	e9 45 f2 ff ff       	jmp    801058e0 <alltraps>

8010669b <vector203>:
.globl vector203
vector203:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $203
8010669d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066a2:	e9 39 f2 ff ff       	jmp    801058e0 <alltraps>

801066a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $204
801066a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066ae:	e9 2d f2 ff ff       	jmp    801058e0 <alltraps>

801066b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $205
801066b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066ba:	e9 21 f2 ff ff       	jmp    801058e0 <alltraps>

801066bf <vector206>:
.globl vector206
vector206:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $206
801066c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801066c6:	e9 15 f2 ff ff       	jmp    801058e0 <alltraps>

801066cb <vector207>:
.globl vector207
vector207:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $207
801066cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066d2:	e9 09 f2 ff ff       	jmp    801058e0 <alltraps>

801066d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $208
801066d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066de:	e9 fd f1 ff ff       	jmp    801058e0 <alltraps>

801066e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $209
801066e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801066ea:	e9 f1 f1 ff ff       	jmp    801058e0 <alltraps>

801066ef <vector210>:
.globl vector210
vector210:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $210
801066f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801066f6:	e9 e5 f1 ff ff       	jmp    801058e0 <alltraps>

801066fb <vector211>:
.globl vector211
vector211:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $211
801066fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106702:	e9 d9 f1 ff ff       	jmp    801058e0 <alltraps>

80106707 <vector212>:
.globl vector212
vector212:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $212
80106709:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010670e:	e9 cd f1 ff ff       	jmp    801058e0 <alltraps>

80106713 <vector213>:
.globl vector213
vector213:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $213
80106715:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010671a:	e9 c1 f1 ff ff       	jmp    801058e0 <alltraps>

8010671f <vector214>:
.globl vector214
vector214:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $214
80106721:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106726:	e9 b5 f1 ff ff       	jmp    801058e0 <alltraps>

8010672b <vector215>:
.globl vector215
vector215:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $215
8010672d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106732:	e9 a9 f1 ff ff       	jmp    801058e0 <alltraps>

80106737 <vector216>:
.globl vector216
vector216:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $216
80106739:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010673e:	e9 9d f1 ff ff       	jmp    801058e0 <alltraps>

80106743 <vector217>:
.globl vector217
vector217:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $217
80106745:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010674a:	e9 91 f1 ff ff       	jmp    801058e0 <alltraps>

8010674f <vector218>:
.globl vector218
vector218:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $218
80106751:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106756:	e9 85 f1 ff ff       	jmp    801058e0 <alltraps>

8010675b <vector219>:
.globl vector219
vector219:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $219
8010675d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106762:	e9 79 f1 ff ff       	jmp    801058e0 <alltraps>

80106767 <vector220>:
.globl vector220
vector220:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $220
80106769:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010676e:	e9 6d f1 ff ff       	jmp    801058e0 <alltraps>

80106773 <vector221>:
.globl vector221
vector221:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $221
80106775:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010677a:	e9 61 f1 ff ff       	jmp    801058e0 <alltraps>

8010677f <vector222>:
.globl vector222
vector222:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $222
80106781:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106786:	e9 55 f1 ff ff       	jmp    801058e0 <alltraps>

8010678b <vector223>:
.globl vector223
vector223:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $223
8010678d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106792:	e9 49 f1 ff ff       	jmp    801058e0 <alltraps>

80106797 <vector224>:
.globl vector224
vector224:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $224
80106799:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010679e:	e9 3d f1 ff ff       	jmp    801058e0 <alltraps>

801067a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $225
801067a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067aa:	e9 31 f1 ff ff       	jmp    801058e0 <alltraps>

801067af <vector226>:
.globl vector226
vector226:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $226
801067b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067b6:	e9 25 f1 ff ff       	jmp    801058e0 <alltraps>

801067bb <vector227>:
.globl vector227
vector227:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $227
801067bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801067c2:	e9 19 f1 ff ff       	jmp    801058e0 <alltraps>

801067c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $228
801067c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801067ce:	e9 0d f1 ff ff       	jmp    801058e0 <alltraps>

801067d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $229
801067d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067da:	e9 01 f1 ff ff       	jmp    801058e0 <alltraps>

801067df <vector230>:
.globl vector230
vector230:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $230
801067e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801067e6:	e9 f5 f0 ff ff       	jmp    801058e0 <alltraps>

801067eb <vector231>:
.globl vector231
vector231:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $231
801067ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801067f2:	e9 e9 f0 ff ff       	jmp    801058e0 <alltraps>

801067f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $232
801067f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801067fe:	e9 dd f0 ff ff       	jmp    801058e0 <alltraps>

80106803 <vector233>:
.globl vector233
vector233:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $233
80106805:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010680a:	e9 d1 f0 ff ff       	jmp    801058e0 <alltraps>

8010680f <vector234>:
.globl vector234
vector234:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $234
80106811:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106816:	e9 c5 f0 ff ff       	jmp    801058e0 <alltraps>

8010681b <vector235>:
.globl vector235
vector235:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $235
8010681d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106822:	e9 b9 f0 ff ff       	jmp    801058e0 <alltraps>

80106827 <vector236>:
.globl vector236
vector236:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $236
80106829:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010682e:	e9 ad f0 ff ff       	jmp    801058e0 <alltraps>

80106833 <vector237>:
.globl vector237
vector237:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $237
80106835:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010683a:	e9 a1 f0 ff ff       	jmp    801058e0 <alltraps>

8010683f <vector238>:
.globl vector238
vector238:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $238
80106841:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106846:	e9 95 f0 ff ff       	jmp    801058e0 <alltraps>

8010684b <vector239>:
.globl vector239
vector239:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $239
8010684d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106852:	e9 89 f0 ff ff       	jmp    801058e0 <alltraps>

80106857 <vector240>:
.globl vector240
vector240:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $240
80106859:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010685e:	e9 7d f0 ff ff       	jmp    801058e0 <alltraps>

80106863 <vector241>:
.globl vector241
vector241:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $241
80106865:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010686a:	e9 71 f0 ff ff       	jmp    801058e0 <alltraps>

8010686f <vector242>:
.globl vector242
vector242:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $242
80106871:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106876:	e9 65 f0 ff ff       	jmp    801058e0 <alltraps>

8010687b <vector243>:
.globl vector243
vector243:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $243
8010687d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106882:	e9 59 f0 ff ff       	jmp    801058e0 <alltraps>

80106887 <vector244>:
.globl vector244
vector244:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $244
80106889:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010688e:	e9 4d f0 ff ff       	jmp    801058e0 <alltraps>

80106893 <vector245>:
.globl vector245
vector245:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $245
80106895:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010689a:	e9 41 f0 ff ff       	jmp    801058e0 <alltraps>

8010689f <vector246>:
.globl vector246
vector246:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $246
801068a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068a6:	e9 35 f0 ff ff       	jmp    801058e0 <alltraps>

801068ab <vector247>:
.globl vector247
vector247:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $247
801068ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068b2:	e9 29 f0 ff ff       	jmp    801058e0 <alltraps>

801068b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $248
801068b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068be:	e9 1d f0 ff ff       	jmp    801058e0 <alltraps>

801068c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $249
801068c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801068ca:	e9 11 f0 ff ff       	jmp    801058e0 <alltraps>

801068cf <vector250>:
.globl vector250
vector250:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $250
801068d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068d6:	e9 05 f0 ff ff       	jmp    801058e0 <alltraps>

801068db <vector251>:
.globl vector251
vector251:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $251
801068dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801068e2:	e9 f9 ef ff ff       	jmp    801058e0 <alltraps>

801068e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $252
801068e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801068ee:	e9 ed ef ff ff       	jmp    801058e0 <alltraps>

801068f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $253
801068f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801068fa:	e9 e1 ef ff ff       	jmp    801058e0 <alltraps>

801068ff <vector254>:
.globl vector254
vector254:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $254
80106901:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106906:	e9 d5 ef ff ff       	jmp    801058e0 <alltraps>

8010690b <vector255>:
.globl vector255
vector255:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $255
8010690d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106912:	e9 c9 ef ff ff       	jmp    801058e0 <alltraps>
80106917:	66 90                	xchg   %ax,%ax
80106919:	66 90                	xchg   %ax,%ax
8010691b:	66 90                	xchg   %ax,%ax
8010691d:	66 90                	xchg   %ax,%ax
8010691f:	90                   	nop

80106920 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	57                   	push   %edi
80106924:	56                   	push   %esi
80106925:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106926:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010692c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106932:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106935:	39 d3                	cmp    %edx,%ebx
80106937:	73 56                	jae    8010698f <deallocuvm.part.0+0x6f>
80106939:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010693c:	89 c6                	mov    %eax,%esi
8010693e:	89 d7                	mov    %edx,%edi
80106940:	eb 12                	jmp    80106954 <deallocuvm.part.0+0x34>
80106942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106948:	83 c2 01             	add    $0x1,%edx
8010694b:	89 d3                	mov    %edx,%ebx
8010694d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106950:	39 fb                	cmp    %edi,%ebx
80106952:	73 38                	jae    8010698c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106954:	89 da                	mov    %ebx,%edx
80106956:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106959:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010695c:	a8 01                	test   $0x1,%al
8010695e:	74 e8                	je     80106948 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106960:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106967:	c1 e9 0a             	shr    $0xa,%ecx
8010696a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106970:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106977:	85 c0                	test   %eax,%eax
80106979:	74 cd                	je     80106948 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010697b:	8b 10                	mov    (%eax),%edx
8010697d:	f6 c2 01             	test   $0x1,%dl
80106980:	75 1e                	jne    801069a0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106982:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106988:	39 fb                	cmp    %edi,%ebx
8010698a:	72 c8                	jb     80106954 <deallocuvm.part.0+0x34>
8010698c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010698f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106992:	89 c8                	mov    %ecx,%eax
80106994:	5b                   	pop    %ebx
80106995:	5e                   	pop    %esi
80106996:	5f                   	pop    %edi
80106997:	5d                   	pop    %ebp
80106998:	c3                   	ret
80106999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801069a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801069a6:	74 26                	je     801069ce <deallocuvm.part.0+0xae>
      kfree(v);
801069a8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801069ab:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801069b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069b4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801069ba:	52                   	push   %edx
801069bb:	e8 e0 ba ff ff       	call   801024a0 <kfree>
      *pte = 0;
801069c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
801069c3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801069c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801069cc:	eb 82                	jmp    80106950 <deallocuvm.part.0+0x30>
        panic("kfree");
801069ce:	83 ec 0c             	sub    $0xc,%esp
801069d1:	68 ac 74 10 80       	push   $0x801074ac
801069d6:	e8 a5 99 ff ff       	call   80100380 <panic>
801069db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801069e0 <seginit>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069e6:	e8 75 cf ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
801069eb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069f0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
801069fa:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106a01:	ff 00 00 
80106a04:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106a0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a0e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106a15:	ff 00 00 
80106a18:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106a1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a22:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106a29:	ff 00 00 
80106a2c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106a33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a36:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106a3d:	ff 00 00 
80106a40:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106a47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a4a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106a4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a53:	c1 e8 10             	shr    $0x10,%eax
80106a56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a5d:	0f 01 10             	lgdtl  (%eax)
}
80106a60:	c9                   	leave
80106a61:	c3                   	ret
80106a62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a69:	00 
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a70 <mappages>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
80106a76:	83 ec 1c             	sub    $0x1c,%esp
80106a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a7c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
80106a7f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a81:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106a85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106a8a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a93:	8b 45 14             	mov    0x14(%ebp),%eax
80106a96:	29 d8                	sub    %ebx,%eax
80106a98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a9b:	eb 3c                	jmp    80106ad9 <mappages+0x69>
80106a9d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106aa0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106aa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106aa7:	c1 ea 0a             	shr    $0xa,%edx
80106aaa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ab0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ab7:	85 c0                	test   %eax,%eax
80106ab9:	74 75                	je     80106b30 <mappages+0xc0>
    if(*pte & PTE_P)
80106abb:	f6 00 01             	testb  $0x1,(%eax)
80106abe:	0f 85 86 00 00 00    	jne    80106b4a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ac4:	0b 75 18             	or     0x18(%ebp),%esi
80106ac7:	83 ce 01             	or     $0x1,%esi
80106aca:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106acf:	39 c3                	cmp    %eax,%ebx
80106ad1:	74 6d                	je     80106b40 <mappages+0xd0>
    a += PGSIZE;
80106ad3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106adc:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106adf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106ae2:	89 d8                	mov    %ebx,%eax
80106ae4:	c1 e8 16             	shr    $0x16,%eax
80106ae7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106aea:	8b 07                	mov    (%edi),%eax
80106aec:	a8 01                	test   $0x1,%al
80106aee:	75 b0                	jne    80106aa0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106af0:	e8 6b bb ff ff       	call   80102660 <kalloc>
80106af5:	85 c0                	test   %eax,%eax
80106af7:	74 37                	je     80106b30 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106af9:	83 ec 04             	sub    $0x4,%esp
80106afc:	68 00 10 00 00       	push   $0x1000
80106b01:	6a 00                	push   $0x0
80106b03:	50                   	push   %eax
80106b04:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b07:	e8 b4 db ff ff       	call   801046c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80106b0f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b12:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b18:	83 c8 07             	or     $0x7,%eax
80106b1b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b1d:	89 d8                	mov    %ebx,%eax
80106b1f:	c1 e8 0a             	shr    $0xa,%eax
80106b22:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b27:	01 d0                	add    %edx,%eax
80106b29:	eb 90                	jmp    80106abb <mappages+0x4b>
80106b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b38:	5b                   	pop    %ebx
80106b39:	5e                   	pop    %esi
80106b3a:	5f                   	pop    %edi
80106b3b:	5d                   	pop    %ebp
80106b3c:	c3                   	ret
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b43:	31 c0                	xor    %eax,%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret
      panic("remap");
80106b4a:	83 ec 0c             	sub    $0xc,%esp
80106b4d:	68 24 77 10 80       	push   $0x80107724
80106b52:	e8 29 98 ff ff       	call   80100380 <panic>
80106b57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b5e:	00 
80106b5f:	90                   	nop

80106b60 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b60:	a1 c4 45 11 80       	mov    0x801145c4,%eax
80106b65:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b6a:	0f 22 d8             	mov    %eax,%cr3
}
80106b6d:	c3                   	ret
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <switchuvm>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 1c             	sub    $0x1c,%esp
80106b79:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b7c:	85 f6                	test   %esi,%esi
80106b7e:	0f 84 cb 00 00 00    	je     80106c4f <switchuvm+0xdf>
  if(p->kstack == 0)
80106b84:	8b 46 08             	mov    0x8(%esi),%eax
80106b87:	85 c0                	test   %eax,%eax
80106b89:	0f 84 da 00 00 00    	je     80106c69 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b8f:	8b 46 04             	mov    0x4(%esi),%eax
80106b92:	85 c0                	test   %eax,%eax
80106b94:	0f 84 c2 00 00 00    	je     80106c5c <switchuvm+0xec>
  pushcli();
80106b9a:	e8 d1 d8 ff ff       	call   80104470 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b9f:	e8 5c cd ff ff       	call   80103900 <mycpu>
80106ba4:	89 c3                	mov    %eax,%ebx
80106ba6:	e8 55 cd ff ff       	call   80103900 <mycpu>
80106bab:	89 c7                	mov    %eax,%edi
80106bad:	e8 4e cd ff ff       	call   80103900 <mycpu>
80106bb2:	83 c7 08             	add    $0x8,%edi
80106bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bb8:	e8 43 cd ff ff       	call   80103900 <mycpu>
80106bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bc0:	ba 67 00 00 00       	mov    $0x67,%edx
80106bc5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106bcc:	83 c0 08             	add    $0x8,%eax
80106bcf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bd6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bdb:	83 c1 08             	add    $0x8,%ecx
80106bde:	c1 e8 18             	shr    $0x18,%eax
80106be1:	c1 e9 10             	shr    $0x10,%ecx
80106be4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106bea:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106bf0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bf5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bfc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c01:	e8 fa cc ff ff       	call   80103900 <mycpu>
80106c06:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c0d:	e8 ee cc ff ff       	call   80103900 <mycpu>
80106c12:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c16:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c1f:	e8 dc cc ff ff       	call   80103900 <mycpu>
80106c24:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c27:	e8 d4 cc ff ff       	call   80103900 <mycpu>
80106c2c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c30:	b8 28 00 00 00       	mov    $0x28,%eax
80106c35:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c38:	8b 46 04             	mov    0x4(%esi),%eax
80106c3b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c40:	0f 22 d8             	mov    %eax,%cr3
}
80106c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c46:	5b                   	pop    %ebx
80106c47:	5e                   	pop    %esi
80106c48:	5f                   	pop    %edi
80106c49:	5d                   	pop    %ebp
  popcli();
80106c4a:	e9 71 d8 ff ff       	jmp    801044c0 <popcli>
    panic("switchuvm: no process");
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 2a 77 10 80       	push   $0x8010772a
80106c57:	e8 24 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106c5c:	83 ec 0c             	sub    $0xc,%esp
80106c5f:	68 55 77 10 80       	push   $0x80107755
80106c64:	e8 17 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106c69:	83 ec 0c             	sub    $0xc,%esp
80106c6c:	68 40 77 10 80       	push   $0x80107740
80106c71:	e8 0a 97 ff ff       	call   80100380 <panic>
80106c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c7d:	00 
80106c7e:	66 90                	xchg   %ax,%ax

80106c80 <inituvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	8b 75 10             	mov    0x10(%ebp),%esi
80106c8c:	8b 55 08             	mov    0x8(%ebp),%edx
80106c8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106c92:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c98:	77 50                	ja     80106cea <inituvm+0x6a>
80106c9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106c9d:	e8 be b9 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80106ca2:	83 ec 04             	sub    $0x4,%esp
80106ca5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106caa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cac:	6a 00                	push   $0x0
80106cae:	50                   	push   %eax
80106caf:	e8 0c da ff ff       	call   801046c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106cb4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cba:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106cc1:	50                   	push   %eax
80106cc2:	68 00 10 00 00       	push   $0x1000
80106cc7:	6a 00                	push   $0x0
80106cc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ccc:	52                   	push   %edx
80106ccd:	e8 9e fd ff ff       	call   80106a70 <mappages>
  memmove(mem, init, sz);
80106cd2:	83 c4 20             	add    $0x20,%esp
80106cd5:	89 75 10             	mov    %esi,0x10(%ebp)
80106cd8:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106cdb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce1:	5b                   	pop    %ebx
80106ce2:	5e                   	pop    %esi
80106ce3:	5f                   	pop    %edi
80106ce4:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ce5:	e9 66 da ff ff       	jmp    80104750 <memmove>
    panic("inituvm: more than a page");
80106cea:	83 ec 0c             	sub    $0xc,%esp
80106ced:	68 69 77 10 80       	push   $0x80107769
80106cf2:	e8 89 96 ff ff       	call   80100380 <panic>
80106cf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106cfe:	00 
80106cff:	90                   	nop

80106d00 <loaduvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106d09:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106d0c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106d0f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106d15:	0f 85 a2 00 00 00    	jne    80106dbd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106d1b:	85 ff                	test   %edi,%edi
80106d1d:	74 7d                	je     80106d9c <loaduvm+0x9c>
80106d1f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106d23:	8b 55 08             	mov    0x8(%ebp),%edx
80106d26:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106d28:	89 c1                	mov    %eax,%ecx
80106d2a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106d2d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106d30:	f6 c1 01             	test   $0x1,%cl
80106d33:	75 13                	jne    80106d48 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106d35:	83 ec 0c             	sub    $0xc,%esp
80106d38:	68 83 77 10 80       	push   $0x80107783
80106d3d:	e8 3e 96 ff ff       	call   80100380 <panic>
80106d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d48:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d4b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d51:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d56:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d5d:	85 c9                	test   %ecx,%ecx
80106d5f:	74 d4                	je     80106d35 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106d61:	89 fb                	mov    %edi,%ebx
80106d63:	b8 00 10 00 00       	mov    $0x1000,%eax
80106d68:	29 f3                	sub    %esi,%ebx
80106d6a:	39 c3                	cmp    %eax,%ebx
80106d6c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d6f:	53                   	push   %ebx
80106d70:	8b 45 14             	mov    0x14(%ebp),%eax
80106d73:	01 f0                	add    %esi,%eax
80106d75:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106d76:	8b 01                	mov    (%ecx),%eax
80106d78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d7d:	05 00 00 00 80       	add    $0x80000000,%eax
80106d82:	50                   	push   %eax
80106d83:	ff 75 10             	push   0x10(%ebp)
80106d86:	e8 25 ad ff ff       	call   80101ab0 <readi>
80106d8b:	83 c4 10             	add    $0x10,%esp
80106d8e:	39 d8                	cmp    %ebx,%eax
80106d90:	75 1e                	jne    80106db0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106d92:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d98:	39 fe                	cmp    %edi,%esi
80106d9a:	72 84                	jb     80106d20 <loaduvm+0x20>
}
80106d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d9f:	31 c0                	xor    %eax,%eax
}
80106da1:	5b                   	pop    %ebx
80106da2:	5e                   	pop    %esi
80106da3:	5f                   	pop    %edi
80106da4:	5d                   	pop    %ebp
80106da5:	c3                   	ret
80106da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dad:	00 
80106dae:	66 90                	xchg   %ax,%ax
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106db3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106db8:	5b                   	pop    %ebx
80106db9:	5e                   	pop    %esi
80106dba:	5f                   	pop    %edi
80106dbb:	5d                   	pop    %ebp
80106dbc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106dbd:	83 ec 0c             	sub    $0xc,%esp
80106dc0:	68 a4 79 10 80       	push   $0x801079a4
80106dc5:	e8 b6 95 ff ff       	call   80100380 <panic>
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dd0 <allocuvm>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106ddc:	85 f6                	test   %esi,%esi
80106dde:	0f 88 9a 00 00 00    	js     80106e7e <allocuvm+0xae>
80106de4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106de6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106de9:	0f 82 a1 00 00 00    	jb     80106e90 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106def:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df2:	05 ff 0f 00 00       	add    $0xfff,%eax
80106df7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dfc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106dfe:	39 f0                	cmp    %esi,%eax
80106e00:	0f 83 8d 00 00 00    	jae    80106e93 <allocuvm+0xc3>
80106e06:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106e09:	eb 46                	jmp    80106e51 <allocuvm+0x81>
80106e0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106e10:	83 ec 04             	sub    $0x4,%esp
80106e13:	68 00 10 00 00       	push   $0x1000
80106e18:	6a 00                	push   $0x0
80106e1a:	50                   	push   %eax
80106e1b:	e8 a0 d8 ff ff       	call   801046c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e20:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e26:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106e2d:	50                   	push   %eax
80106e2e:	68 00 10 00 00       	push   $0x1000
80106e33:	57                   	push   %edi
80106e34:	ff 75 08             	push   0x8(%ebp)
80106e37:	e8 34 fc ff ff       	call   80106a70 <mappages>
80106e3c:	83 c4 20             	add    $0x20,%esp
80106e3f:	85 c0                	test   %eax,%eax
80106e41:	78 5d                	js     80106ea0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106e43:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e49:	39 f7                	cmp    %esi,%edi
80106e4b:	0f 83 87 00 00 00    	jae    80106ed8 <allocuvm+0x108>
    mem = kalloc();
80106e51:	e8 0a b8 ff ff       	call   80102660 <kalloc>
80106e56:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e58:	85 c0                	test   %eax,%eax
80106e5a:	75 b4                	jne    80106e10 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106e5c:	83 ec 0c             	sub    $0xc,%esp
80106e5f:	68 a1 77 10 80       	push   $0x801077a1
80106e64:	e8 47 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e69:	83 c4 10             	add    $0x10,%esp
80106e6c:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106e6f:	74 0d                	je     80106e7e <allocuvm+0xae>
80106e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e74:	8b 45 08             	mov    0x8(%ebp),%eax
80106e77:	89 f2                	mov    %esi,%edx
80106e79:	e8 a2 fa ff ff       	call   80106920 <deallocuvm.part.0>
    return 0;
80106e7e:	31 d2                	xor    %edx,%edx
}
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e83:	89 d0                	mov    %edx,%eax
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
80106e90:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e96:	89 d0                	mov    %edx,%eax
80106e98:	5b                   	pop    %ebx
80106e99:	5e                   	pop    %esi
80106e9a:	5f                   	pop    %edi
80106e9b:	5d                   	pop    %ebp
80106e9c:	c3                   	ret
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ea0:	83 ec 0c             	sub    $0xc,%esp
80106ea3:	68 b9 77 10 80       	push   $0x801077b9
80106ea8:	e8 03 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106ead:	83 c4 10             	add    $0x10,%esp
80106eb0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106eb3:	74 0d                	je     80106ec2 <allocuvm+0xf2>
80106eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80106ebb:	89 f2                	mov    %esi,%edx
80106ebd:	e8 5e fa ff ff       	call   80106920 <deallocuvm.part.0>
      kfree(mem);
80106ec2:	83 ec 0c             	sub    $0xc,%esp
80106ec5:	53                   	push   %ebx
80106ec6:	e8 d5 b5 ff ff       	call   801024a0 <kfree>
      return 0;
80106ecb:	83 c4 10             	add    $0x10,%esp
    return 0;
80106ece:	31 d2                	xor    %edx,%edx
80106ed0:	eb ae                	jmp    80106e80 <allocuvm+0xb0>
80106ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ede:	5b                   	pop    %ebx
80106edf:	5e                   	pop    %esi
80106ee0:	89 d0                	mov    %edx,%eax
80106ee2:	5f                   	pop    %edi
80106ee3:	5d                   	pop    %ebp
80106ee4:	c3                   	ret
80106ee5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106eec:	00 
80106eed:	8d 76 00             	lea    0x0(%esi),%esi

80106ef0 <deallocuvm>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ef6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106efc:	39 d1                	cmp    %edx,%ecx
80106efe:	73 10                	jae    80106f10 <deallocuvm+0x20>
}
80106f00:	5d                   	pop    %ebp
80106f01:	e9 1a fa ff ff       	jmp    80106920 <deallocuvm.part.0>
80106f06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f0d:	00 
80106f0e:	66 90                	xchg   %ax,%ax
80106f10:	89 d0                	mov    %edx,%eax
80106f12:	5d                   	pop    %ebp
80106f13:	c3                   	ret
80106f14:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f1b:	00 
80106f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 0c             	sub    $0xc,%esp
80106f29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f2c:	85 f6                	test   %esi,%esi
80106f2e:	74 59                	je     80106f89 <freevm+0x69>
  if(newsz >= oldsz)
80106f30:	31 c9                	xor    %ecx,%ecx
80106f32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f37:	89 f0                	mov    %esi,%eax
80106f39:	89 f3                	mov    %esi,%ebx
80106f3b:	e8 e0 f9 ff ff       	call   80106920 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f46:	eb 0f                	jmp    80106f57 <freevm+0x37>
80106f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f4f:	00 
80106f50:	83 c3 04             	add    $0x4,%ebx
80106f53:	39 fb                	cmp    %edi,%ebx
80106f55:	74 23                	je     80106f7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f57:	8b 03                	mov    (%ebx),%eax
80106f59:	a8 01                	test   $0x1,%al
80106f5b:	74 f3                	je     80106f50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f62:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f65:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f68:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f6d:	50                   	push   %eax
80106f6e:	e8 2d b5 ff ff       	call   801024a0 <kfree>
80106f73:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f76:	39 fb                	cmp    %edi,%ebx
80106f78:	75 dd                	jne    80106f57 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f80:	5b                   	pop    %ebx
80106f81:	5e                   	pop    %esi
80106f82:	5f                   	pop    %edi
80106f83:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f84:	e9 17 b5 ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80106f89:	83 ec 0c             	sub    $0xc,%esp
80106f8c:	68 d5 77 10 80       	push   $0x801077d5
80106f91:	e8 ea 93 ff ff       	call   80100380 <panic>
80106f96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f9d:	00 
80106f9e:	66 90                	xchg   %ax,%ax

80106fa0 <setupkvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	56                   	push   %esi
80106fa4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106fa5:	e8 b6 b6 ff ff       	call   80102660 <kalloc>
80106faa:	85 c0                	test   %eax,%eax
80106fac:	74 5e                	je     8010700c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106fae:	83 ec 04             	sub    $0x4,%esp
80106fb1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fb3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106fb8:	68 00 10 00 00       	push   $0x1000
80106fbd:	6a 00                	push   $0x0
80106fbf:	50                   	push   %eax
80106fc0:	e8 fb d6 ff ff       	call   801046c0 <memset>
80106fc5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106fc8:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106fcb:	83 ec 0c             	sub    $0xc,%esp
80106fce:	ff 73 0c             	push   0xc(%ebx)
80106fd1:	52                   	push   %edx
80106fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80106fd5:	29 d0                	sub    %edx,%eax
80106fd7:	50                   	push   %eax
80106fd8:	ff 33                	push   (%ebx)
80106fda:	56                   	push   %esi
80106fdb:	e8 90 fa ff ff       	call   80106a70 <mappages>
80106fe0:	83 c4 20             	add    $0x20,%esp
80106fe3:	85 c0                	test   %eax,%eax
80106fe5:	78 19                	js     80107000 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fe7:	83 c3 10             	add    $0x10,%ebx
80106fea:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ff0:	75 d6                	jne    80106fc8 <setupkvm+0x28>
}
80106ff2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ff5:	89 f0                	mov    %esi,%eax
80106ff7:	5b                   	pop    %ebx
80106ff8:	5e                   	pop    %esi
80106ff9:	5d                   	pop    %ebp
80106ffa:	c3                   	ret
80106ffb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107000:	83 ec 0c             	sub    $0xc,%esp
80107003:	56                   	push   %esi
80107004:	e8 17 ff ff ff       	call   80106f20 <freevm>
      return 0;
80107009:	83 c4 10             	add    $0x10,%esp
}
8010700c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010700f:	31 f6                	xor    %esi,%esi
}
80107011:	89 f0                	mov    %esi,%eax
80107013:	5b                   	pop    %ebx
80107014:	5e                   	pop    %esi
80107015:	5d                   	pop    %ebp
80107016:	c3                   	ret
80107017:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010701e:	00 
8010701f:	90                   	nop

80107020 <kvmalloc>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107026:	e8 75 ff ff ff       	call   80106fa0 <setupkvm>
8010702b:	a3 c4 45 11 80       	mov    %eax,0x801145c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107030:	05 00 00 00 80       	add    $0x80000000,%eax
80107035:	0f 22 d8             	mov    %eax,%cr3
}
80107038:	c9                   	leave
80107039:	c3                   	ret
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107040 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 08             	sub    $0x8,%esp
80107046:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107049:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010704c:	89 c1                	mov    %eax,%ecx
8010704e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107051:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107054:	f6 c2 01             	test   $0x1,%dl
80107057:	75 17                	jne    80107070 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	68 e6 77 10 80       	push   $0x801077e6
80107061:	e8 1a 93 ff ff       	call   80100380 <panic>
80107066:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010706d:	00 
8010706e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107070:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107073:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107079:	25 fc 0f 00 00       	and    $0xffc,%eax
8010707e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107085:	85 c0                	test   %eax,%eax
80107087:	74 d0                	je     80107059 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107089:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010708c:	c9                   	leave
8010708d:	c3                   	ret
8010708e:	66 90                	xchg   %ax,%ax

80107090 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
80107096:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107099:	e8 02 ff ff ff       	call   80106fa0 <setupkvm>
8010709e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070a1:	85 c0                	test   %eax,%eax
801070a3:	0f 84 e9 00 00 00    	je     80107192 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801070ac:	85 d2                	test   %edx,%edx
801070ae:	0f 84 b5 00 00 00    	je     80107169 <copyuvm+0xd9>
801070b4:	31 f6                	xor    %esi,%esi
801070b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070bd:	00 
801070be:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801070c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801070c3:	89 f0                	mov    %esi,%eax
801070c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070c8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801070cb:	a8 01                	test   $0x1,%al
801070cd:	75 11                	jne    801070e0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070cf:	83 ec 0c             	sub    $0xc,%esp
801070d2:	68 f0 77 10 80       	push   $0x801077f0
801070d7:	e8 a4 92 ff ff       	call   80100380 <panic>
801070dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801070e0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070e7:	c1 ea 0a             	shr    $0xa,%edx
801070ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070f7:	85 c0                	test   %eax,%eax
801070f9:	74 d4                	je     801070cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801070fb:	8b 38                	mov    (%eax),%edi
801070fd:	f7 c7 01 00 00 00    	test   $0x1,%edi
80107103:	0f 84 9b 00 00 00    	je     801071a4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107109:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
8010710b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80107111:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107114:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
8010711a:	e8 41 b5 ff ff       	call   80102660 <kalloc>
8010711f:	89 c7                	mov    %eax,%edi
80107121:	85 c0                	test   %eax,%eax
80107123:	74 5f                	je     80107184 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107125:	83 ec 04             	sub    $0x4,%esp
80107128:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010712e:	68 00 10 00 00       	push   $0x1000
80107133:	53                   	push   %ebx
80107134:	50                   	push   %eax
80107135:	e8 16 d6 ff ff       	call   80104750 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010713a:	58                   	pop    %eax
8010713b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107141:	ff 75 e4             	push   -0x1c(%ebp)
80107144:	50                   	push   %eax
80107145:	68 00 10 00 00       	push   $0x1000
8010714a:	56                   	push   %esi
8010714b:	ff 75 e0             	push   -0x20(%ebp)
8010714e:	e8 1d f9 ff ff       	call   80106a70 <mappages>
80107153:	83 c4 20             	add    $0x20,%esp
80107156:	85 c0                	test   %eax,%eax
80107158:	78 1e                	js     80107178 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010715a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107160:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107163:	0f 82 57 ff ff ff    	jb     801070c0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107169:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010716c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010716f:	5b                   	pop    %ebx
80107170:	5e                   	pop    %esi
80107171:	5f                   	pop    %edi
80107172:	5d                   	pop    %ebp
80107173:	c3                   	ret
80107174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107178:	83 ec 0c             	sub    $0xc,%esp
8010717b:	57                   	push   %edi
8010717c:	e8 1f b3 ff ff       	call   801024a0 <kfree>
      goto bad;
80107181:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107184:	83 ec 0c             	sub    $0xc,%esp
80107187:	ff 75 e0             	push   -0x20(%ebp)
8010718a:	e8 91 fd ff ff       	call   80106f20 <freevm>
  return 0;
8010718f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107192:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107199:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010719c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010719f:	5b                   	pop    %ebx
801071a0:	5e                   	pop    %esi
801071a1:	5f                   	pop    %edi
801071a2:	5d                   	pop    %ebp
801071a3:	c3                   	ret
      panic("copyuvm: page not present");
801071a4:	83 ec 0c             	sub    $0xc,%esp
801071a7:	68 0a 78 10 80       	push   $0x8010780a
801071ac:	e8 cf 91 ff ff       	call   80100380 <panic>
801071b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071b8:	00 
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071c6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071c9:	89 c1                	mov    %eax,%ecx
801071cb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071ce:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071d1:	f6 c2 01             	test   $0x1,%dl
801071d4:	0f 84 f8 00 00 00    	je     801072d2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801071da:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071e3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801071e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801071e9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071f0:	89 d0                	mov    %edx,%eax
801071f2:	f7 d2                	not    %edx
801071f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071f9:	05 00 00 00 80       	add    $0x80000000,%eax
801071fe:	83 e2 05             	and    $0x5,%edx
80107201:	ba 00 00 00 00       	mov    $0x0,%edx
80107206:	0f 45 c2             	cmovne %edx,%eax
}
80107209:	c3                   	ret
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107210 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 0c             	sub    $0xc,%esp
80107219:	8b 75 14             	mov    0x14(%ebp),%esi
8010721c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010721f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107222:	85 f6                	test   %esi,%esi
80107224:	75 51                	jne    80107277 <copyout+0x67>
80107226:	e9 9d 00 00 00       	jmp    801072c8 <copyout+0xb8>
8010722b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107230:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107236:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010723c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107242:	74 74                	je     801072b8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107244:	89 fb                	mov    %edi,%ebx
80107246:	29 c3                	sub    %eax,%ebx
80107248:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010724e:	39 f3                	cmp    %esi,%ebx
80107250:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107253:	29 f8                	sub    %edi,%eax
80107255:	83 ec 04             	sub    $0x4,%esp
80107258:	01 c1                	add    %eax,%ecx
8010725a:	53                   	push   %ebx
8010725b:	52                   	push   %edx
8010725c:	89 55 10             	mov    %edx,0x10(%ebp)
8010725f:	51                   	push   %ecx
80107260:	e8 eb d4 ff ff       	call   80104750 <memmove>
    len -= n;
    buf += n;
80107265:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107268:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010726e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107271:	01 da                	add    %ebx,%edx
  while(len > 0){
80107273:	29 de                	sub    %ebx,%esi
80107275:	74 51                	je     801072c8 <copyout+0xb8>
  if(*pde & PTE_P){
80107277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010727a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010727c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010727e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107281:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107287:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010728a:	f6 c1 01             	test   $0x1,%cl
8010728d:	0f 84 46 00 00 00    	je     801072d9 <copyout.cold>
  return &pgtab[PTX(va)];
80107293:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107295:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010729b:	c1 eb 0c             	shr    $0xc,%ebx
8010729e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801072a4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801072ab:	89 d9                	mov    %ebx,%ecx
801072ad:	f7 d1                	not    %ecx
801072af:	83 e1 05             	and    $0x5,%ecx
801072b2:	0f 84 78 ff ff ff    	je     80107230 <copyout+0x20>
  }
  return 0;
}
801072b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072c0:	5b                   	pop    %ebx
801072c1:	5e                   	pop    %esi
801072c2:	5f                   	pop    %edi
801072c3:	5d                   	pop    %ebp
801072c4:	c3                   	ret
801072c5:	8d 76 00             	lea    0x0(%esi),%esi
801072c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072cb:	31 c0                	xor    %eax,%eax
}
801072cd:	5b                   	pop    %ebx
801072ce:	5e                   	pop    %esi
801072cf:	5f                   	pop    %edi
801072d0:	5d                   	pop    %ebp
801072d1:	c3                   	ret

801072d2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801072d2:	a1 00 00 00 00       	mov    0x0,%eax
801072d7:	0f 0b                	ud2

801072d9 <copyout.cold>:
801072d9:	a1 00 00 00 00       	mov    0x0,%eax
801072de:	0f 0b                	ud2
