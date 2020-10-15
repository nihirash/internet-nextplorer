    MODULE History
back:
    ld hl, prev
    call Fetcher.fetch.skipHistory
    ld hl, prev, de, row, bc, #ff : ldir
    jp MediaProcessor.processResource

save:
    push bc
    push hl
    push de

    push hl
    ld hl, row, de, prev, bc, #ff : ldir
    pop hl
    ld de, row
.loop
    ld a, (hl) : ldi
    cp 13 : jr z, .exit
    cp 10 : jr z, .exit
    jr .loop
.exit
    pop de
    pop hl
    pop bc
    ret

    ENDMODULE
