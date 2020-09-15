; B - line count
findLine:
    ld hl, buffer
    xor a : or b : ret z
.loop
    ld a, (hl) : and a : jr z, .nope
    cp 10 : inc hl : jr nz, .loop
    ld a, (hl) : cp '.' : jr z, .nope
    and a : jr z, .nope
    djnz .loop
    ret
.nope
    ld hl, 0 : ret