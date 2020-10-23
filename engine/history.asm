    MODULE History
back:
    ld hl, prev
    ld a, (History.input), (Render.isInputRequest), a
    call Fetcher.fetch.skipHistory
    ld hl, prev, de, row, bc, #ff : ldir
    ld hl, (History.position), (Render.position), hl
    jp MediaProcessor.processResource

home:
    ld hl, homePage : call Fetcher.fetch
    jp MediaProcessor.processResource

refresh:
    ld a, (History.input), (Render.isInputRequest), a
    ld hl, row : call Fetcher.fetch.skipHistory
    jp MediaProcessor.processResource

save:
    push bc
    push hl
    push de

    push hl
    ld hl, (Render.position), (History.position), hl, hl, 0, (Render.position), hl
    ld a, (Render.isInputRequest), (History.input), a
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
