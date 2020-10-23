
isInputRequest db 0

renderGopherScreen:
    xor a : ld (isInputRequest), a
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
    call checkBorder
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
    and a : jp z, workLoop

    cp 'a' : jp z, cursorDown
    cp Keyboard.KEY_DOWN : jp z, cursorDown

    cp 'q'             : jp z, cursorUp
    cp Keyboard.KEY_UP : jp z, cursorUp

    cp 'o'               : jp z, pageUp
    cp Keyboard.KEY_LEFT : jp z, pageUp

    cp 'p'                : jp z, pageDn
    cp Keyboard.KEY_RIGHT : jp z, pageDn

    cp 13 : jr z, navigate

    cp 'b' : jp z, History.back

    cp 'n' : jp z, inputHost

    cp 'h' : jp z, History.home

    jp workLoop

navigate:
    ld a, (page_offset), b, a, a, (cursor_position) : add b : ld b, a : call Render.findLine
    ld a, (hl)
    cp '1' : jp z, .page
    cp '0' : jp z, .page
    cp '9' : jp z, .fetch
    cp '7' : jp z, .input
    jp workLoop
.page
    call Fetcher.fetch
    jr .f2
.fetch
    ld de, (Render.position), (History.position), de
    call Fetcher.fetch.skipHistory
.f2
    jp nc, MediaProcessor.processResource
    ld hl, loadingErrorMsg : call DialogBox.msgBox
    jp History.back
.input
    push hl
    call DialogBox.inputBox
    ld a, 1 : ld (isInputRequest), a
    pop hl
    jr .page

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

loadingErrorMsg db "Document fetch error! Check your connection or hostname!", 0