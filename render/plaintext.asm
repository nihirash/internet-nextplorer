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
    call Input.read
    and a : jr z, plainTextLoop
    
    ; Down
    cp 'a' : jr z, textDown
    cp Keyboard.KEY_DOWN : jp z, textDown
    ; Up
    cp 'q' : jr z, textUp
    cp Keyboard.KEY_UP : jp z, textUp

    cp 'b' : jp z, History.back

    cp 'n' : jp z, inputHost

    cp 'h' : jp z, History.home
    jp plainTextLoop

textDown:
    ld a, (page_offset) : add PER_PAGE : ld (page_offset), a 
    call renderPlainTextScreen
    jp plainTextLoop

textUp:
    ld a, (page_offset) : and a : jr z, plainTextLoop
    sub PER_PAGE : ld (page_offset), a
    call renderPlainTextScreen
    jr plainTextLoop
