
renderGopherScreen:
    call prepareScreen
    ld b, PER_PAGE
.loop
    push bc
    ld a, PER_PAGE : sub b
    
    ld b, a, e, a, a, (page_offset) : add b : ld b, a : call findLine
    ld a, h : or l : jr z, .exit
    ld a, e : call Render.renderRow
.exit
    pop bc 
    djnz .loop
    jp showCursor

showCursor:
    ld a, (cursor_position) : add 5 : ld d, a, e, 3  : call TextMode.gotoXY
    ld a, Font.CURSOR : call TextMode.putC
    ret

hideCursor:
    ld a, (cursor_position) : add 5 : ld d, a, e, 3 : call TextMode.gotoXY
    ld a, ' ' : call TextMode.putC
    ret

workLoop:
    dup WAIT_FRAMES
    halt 
    edup
    call Keyboard.inkey
    and a : jr z, workLoop

    cp 'a' : jr z, cursorDown
    cp Keyboard.KEY_DOWN : jp z, cursorDown

    cp 'q' : jr z, cursorUp
    cp Keyboard.KEY_UP : jp z, cursorUp

    cp 13 : jr z, navigate

    cp 'b' : jp z, History.back
    jp workLoop

navigate:
    ld a, (page_offset), b, a, a, (cursor_position) : add b : ld b, a : call Render.findLine
    ld a, (hl)
    cp '1' : jp z, .fetch
    cp '0' : jp z, .fetch
    cp '9' : jp z, .fetch
    jp workLoop
.fetch
    call Fetcher.fetch
    jp MediaProcessor.processResource

cursorDown:
    call hideCursor
    ld hl, cursor_position
    inc (hl)
    jr checkBorder

cursorUp:
    call hideCursor
    ld hl, cursor_position
    dec (hl)
    jr checkBorder

checkBorder:
    ld a, (cursor_position) : cp #ff : jr z, pageUp
    ld a, (cursor_position) : cp PER_PAGE : jr z, pageDn
    call showCursor
    jp workLoop

pageUp:
    ld a, (page_offset) : and a : jr z, .skip
    ld a, PER_PAGE - 1 : ld (cursor_position), a
    ld a, (page_offset) : sub PER_PAGE : ld (page_offset), a
.exit
    call renderGopherScreen
    jp workLoop
.skip
    xor a : ld (cursor_position), a : call showCursor : jp workLoop

pageDn:
    xor a : ld (cursor_position), a 
    ld a, (page_offset) : add PER_PAGE : ld (page_offset), a
    jr pageUp.exit

    