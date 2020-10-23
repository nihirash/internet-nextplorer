    MODULE UrlEncoder
; HL - pointer to line in gopher page
; C - flag set when it's file
isFile:
.findServerLoop
    ld a, (hl) : and a : jr z, .notFile : inc hl
    cp 13 : jr z, .notFile
    cp 9  : jr z, .skipPath
    jr .findServerLoop
.skipPath
    ld a, (hl) : and a : jr z, .notFile : inc hl
    cp 13 : jr z, .notFile
    cp 9  : jr z, .compareServer
    jr .skipPath
.compareServer
    ld a, (hl) : cp "f" : jr nz, .notFile : inc hl
    ld a, (hl) : cp "i" : jr nz, .notFile : inc hl
    ld a, (hl) : cp "l" : jr nz, .notFile : inc hl
    ld a, (hl) : cp "e" : jr nz, .notFile : inc hl
    ld a, (hl) : cp 9   : jr nz, .notFile : inc hl
    scf
    ret
.notFile
    or a
    ret

; Is enough fields to encode
; HL - pointer to line in gopher page
; C - flag set when there is enough fields
isValidGopherRow:
    ld a, (hl) : and a : jr z, isFile.notFile : inc hl
    cp 13 : jr z, isFile.notFile
    cp 9  : jr z, .skipPath
    jr isValidGopherRow
.skipPath
    ld a, (hl) : and a : jr z, isFile.notFile : inc hl
    cp 13 : jr z, isFile.notFile
    cp 9  : jr z, .skipHost
    jr .skipPath
.skipHost
    ld a, (hl) : and a : jr z, isFile.notFile : inc hl
    cp 13 : jr z, isFile.notFile
    cp 9 :  jr z, .isValid
    jr .skipHost
.isValid:
    scf
    ret

; HL - pointer to gopher page line
extractPath:
    ld a, 9, bc, #ff : cpir 
    ld de, nameBuffer
.loop
    ld a, (hl) : cp 9 : ret z : and a : ret z
    ld (de), a : inc hl, de
    jr .loop

extractHostName:
    xor a
    ld hl, hostName, de, hostName + 1, bc, 47, (hl), a : ldir

    ld hl, History.row
    ld a, 9, bc, #ff : cpir 
    ld bc, #ff : cpir
    ld de, hostName
.loop
    ld a, (hl) : cp 9 : ret z : and a : ret z : cp 13 : ret z
    ld (de), a : inc hl, de
    jr .loop

    ENDMODULE