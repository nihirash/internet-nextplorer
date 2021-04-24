; This shit brokes adressing!!!!
;
;    STRUCT HistoryRecord
;isFile    BYTE
;mediaType BYTE
;locator   BLOCK #ff
;host      BLOCK 64 ; If you'll use longer host name - you're "сам себе злобный буратино"(you're your only enemy)
;port      BLOCK 6  ; can be up to 65535
;search    BLOCK #FF
;position  WORD #00
;    ENDS


total   equ 5
depth   db 0

historyBlock:  
.isFile    db  0
.mediaType db  0
.locator   ds  #1ff 
.host      ds  64
.port      ds  6
.search    ds  #ff
.position  dw  #00

historyBlockSize = $ - historyBlock

HistoryRecord EQU $ - historyBlock
    dup total 
    ds HistoryRecord
    edup
HistoryEnd equ $ - 1