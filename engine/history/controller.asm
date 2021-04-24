    MODULE History

back:
    ld a, (depth) : cp 1 : ret z
    ld hl, historyBlock + HistoryRecord, de, historyBlock, bc, (total - 1) * HistoryRecord : ldir ; Move history up
    ld hl, depth : dec (hl)
; Loads current resource
load:
    ld hl, .msg : call DialogBox.msgNoWait
    xor a : ld hl, buffer, de, buffer + 1, bc, #ffff - buffer - 1, (hl), a : ldir
    
    ld a, (historyBlock.isFile) : and a : jp nz, Fetcher.fetchFromFS
    jp Fetcher.fetchFromNet

.msg db "Loading resource! Please wait! It will be here soon!", 0

home:
    ld hl, homePage
; HL - gopher row
navigate:
    ld de, hl
    call UrlEncoder.isValidGopherRow
    jr nc, load ; Not valid - reload last
    ld hl, de
    push hl

    push hl
    ld hl, HistoryEnd - HistoryRecord, de, HistoryEnd, bc,  HistoryRecord * total : lddr
    xor a : ld hl, historyBlock, de, historyBlock + 1, bc, historyBlockSize - 1, (hl), a : ldir
    pop hl

    ; Fill record
    ld de, hl
    call UrlEncoder.isFile
    ex hl, de
    ld de, historyBlock
    ld (de), a : inc de
    ld a, (hl) : push hl, de : call Render.getIcon : pop de, hl
    ld (de), a : inc de
    ld a, 9, bc, #ff : cpir
.locatorCopy
    ld a, (hl) : cp 9 : jr z, 1f
    ld (de), a : inc hl, de
    jr .locatorCopy
1
    inc hl : xor a : ld (de), a
    ld de, historyBlock.host
.hostCopy
    ld a, (hl) : cp 9 : jr z, 1f
    ld (de), a : inc hl, de
    jr .hostCopy
1
    inc hl : xor a : ld (de), a
    ld de, historyBlock.port
.portCopy
    ld a, (hl) 
    cp 9 : jr z, 1f
    cp 13 : jr z, 1f
    cp 10 : jr z, 1f
    cp 0  : jr z, 1f
    ld (de), a : inc hl, de
    jr .portCopy
1   xor a : ld (de), a
    ld hl, DialogBox.inputBuffer, de, historyBlock.search, bc, #ff : ldir
    ld de, (Render.position), (historyBlock.position + HistoryRecord), de
    ld de, 0, (historyBlock.position), de
    pop hl
    ld a, (depth) : cp total : jr nc, 1f
    inc a : ld (depth), a
1
    ld a,(historyBlock.mediaType) : cp Font.DOWNLOAD : jp z, Downloader.go
    jp load

    ENDMODULE
