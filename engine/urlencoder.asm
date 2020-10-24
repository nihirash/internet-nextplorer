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
    ld a, 1
    ret
.notFile
    xor a
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

extractPath:
    ld hl, historyBlock.locator, de, nameBuffer, bc, #ff : ldir
    ret

extractHostName:
    ld hl, historyBlock.host, de, hostName, bc, 64 : ldir
    ret 
    
    ENDMODULE