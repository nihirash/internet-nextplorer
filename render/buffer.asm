; B - line count
findLine:
    ld hl, buffer
    xor a : or b : jr z, .checkEmpty
.loop
    ld a, (hl) : and a : jr z, .nope 
    cp 13 : inc hl : jr z, .checkLF
    cp 10 : jr z, .nextCheck
    jr .loop
.nextCheck
    and a : jr z, .nope
    djnz .loop
    ret
.checkLF
    ld a, (hl)
    cp 10 : jr nz, .nextCheck
    inc hl
    jr  .nextCheck
.checkEmpty
    ld a, (hl) : and a : ret nz
.nope
    ld hl, 0 : ret