; B - line count
findLine:
    ld hl, buffer
    xor a : or b : jr z, .checkEmpty
.loop
    ld a, (hl) : and a : jr z, .nope
    cp 10 : inc hl : jr nz, .loop
    ld a, (hl) : cp '.' : jr z, .nope
    and a : jr z, .nope
    djnz .loop
    ret
.checkEmpty
    ld a, (hl) : and a : ret nz
.nope
    ld hl, 0 : ret