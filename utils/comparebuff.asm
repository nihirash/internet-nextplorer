    MODULE CompareBuff
    
; Pushes A to buffer
push
    push af
    ld b, 32 : ld hl, buffer + 1 : ld de, buffer 
.loop
    ld a, (hl) : ld (de), a : inc hl : inc de : djnz .loop
    pop af
    ld hl, buffer + 31 : ld (hl), a
    ret

; HL - Compare string(null terminated)
; A - 0 NOT Found 
;     1 Found
search:
    ld b, 0 : push hl
.loop: 
    ld a, (hl) : inc hl : inc b : and a : jp nz, .loop
    dec b : pop hl : push bc : push hl
    pop hl 
    ld de, buffer + 32
.sourceLoop   
    dec de : djnz .sourceLoop
    pop bc
.compare    
    push bc : push af
    ld a, (de) : ld b, a 
    pop af : ld a, (hl) : cp b : pop bc : ld a, 0 : ret nz  
    inc de : inc hl
    djnz .compare
    ld a, 1
    ret

clear:
    xor a : ld hl, buffer : ld de, buffer + 1 : ld bc, 32 : ld (hl), a : ldir
    ret

buffer ds 32

    ENDMODULE