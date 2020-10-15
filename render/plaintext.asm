renderPlainTextScreen:
    call prepareScreen
    ld b, PER_PAGE
.loop
    push bc
    ld a, PER_PAGE : sub b
    
    ld b, a, e, a, a, (page_offset) : add b : ld b, a : call Render.findLine
    ld a, h : or l : jr z, .exit
    ld a, e
    add 5 : ld d, a, e, 3 : call TextMode.gotoXY
    call print70Text
.exit
    pop bc 
    djnz .loop
    ret

plainTextLoop:
    dup WAIT_FRAMES
    halt 
    edup
    call Keyboard.inkey
    and a : jr z, plainTextLoop
    
    ; Down
    cp 'a' : jr z, textDown
    cp Keyboard.KEY_DOWN : jp z, textDown
    ; Up
    cp 'q' : jr z, textUp
    cp Keyboard.KEY_UP : jp z, textUp

    cp 'b' : jp z, History.back

    jr plainTextLoop

textDown:
    ld hl, page_offset : inc (hl)
    call renderPlainTextScreen
    jr plainTextLoop

textUp:
    ld a, (page_offset) : and a : jr z, plainTextLoop
    dec a : ld (page_offset), a
    call renderPlainTextScreen
    jr plainTextLoop
