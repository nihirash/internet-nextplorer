; A - row number
; HL - pointer to row
renderRow:
    add 5
    ld d, a, e, 4 : call TextMode.gotoXY
    ld a, (hl)
    call getIcon : inc hl
    jp drawRow

; A - gopher id char
getIcon:
    cp 'i' : jr z, .info
    cp '9' : jr z, .down
    cp '1' : jr z, .page
    cp '0' : jr z, .text
    cp '7' : jr z, .input
    ld a, '?'
    ret 
.info
    ld a, 32 : ret
.down
    ld de, hl
    ld bc, #ff, a, 9 : cpir
    ld a, b : or c : jr z, .downExit
    push de
.nameLoop
    ld a, (hl) : and a : jr z, .check
    cp 9 : jr z, .check
    cp 13 : jr z, .check
    push hl
    call CompareBuff.push
    pop hl 
    inc hl
    jr .nameLoop
.check
    ld hl, scrExt1 : call CompareBuff.search : and a : jr nz, .image
    ld hl, scrExt2 : call CompareBuff.search : and a : jr nz, .image
    ld hl, pt3Ext1 : call CompareBuff.search : and a : jr nz, .music 
    ld hl, pt3Ext2 : call CompareBuff.search : and a : jr nz, .music 
    ld hl, pt2Ext1 : call CompareBuff.search : and a : jr nz, .music 
    ld hl, pt2Ext2 : call CompareBuff.search : and a : jr nz, .music 
.checkExit
    pop hl
.downExit 
    ld a, Font.DOWNLOAD : ret
.page
    ld a, Font.LINK : ret
.text
    ld a, Font.TEXT : ret
.input
    ld a, Font.INPUT : ret
.image
    pop hl : ld a, Font.IMAGE : ret
.music
    pop hl : ld a, Font.MUSIC : ret

scrExt1 db ".scr", 0
scrExt2 db ".SCR", 0
pt3Ext1 db ".pt3", 0
pt3Ext2 db ".PT3", 0
pt2Ext1 db ".pt2", 0
pt2Ext2 db ".PT2", 0


; HL - text pointer
; A - icon
drawRow:
    push hl
    call TextMode.putC
    ld a, 32 : call TextMode.putC : ld a, 32 : call TextMode.putC
    pop hl
.loop
    ld a, (hl) : cp 09 : ret z
    push hl
    call TextMode.putC
    pop hl
    inc hl
    jp .loop