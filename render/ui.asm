prepareScreen:
    call TextMode.cls
    ld h,2, a, Font.BORDER_TOP : call TextMode.fillLine
    ld h, 4, a, Font.SCROLL_UP : call TextMode.fillLine
    ld h, 27, a, Font.SCROLL_DOWN : call TextMode.fillLine
    
    ld h,3, a, Font.BORDER_BOTTOM : call TextMode.fillLine
    ld hl, #020C, a, Font.TILE_BACK : call TextMode.putTileXY
    ld hl, #0210, a, Font.TILE_HOME : call TextMode.putTileXY
    ld hl, #0246, a, Font.TILE_REFRESH : call TextMode.putTileXY
    
    ld de, #0314 : call TextMode.gotoXY : ld b, 48 
.loop
    push bc
    ld a, ' ' : call TextMode.putC
    pop bc
    djnz .loop

    ld de, #0314 : call TextMode.gotoXY : ld hl, hostName : call TextMode.printZ
    ret

inputHost:
.loop
    ld de, #0314 : call TextMode.gotoXY : ld hl, hostName : call TextMode.printZ
    ld a, Font.INPUT : call TextMode.putC
    ld a, ' ' : call TextMode.putC
    halt
    call Keyboard.getSinglePress
    and a : jr z, .loop
    cp 12 : jr z, .removeChar
    cp 13 : jp z, inputNavigate
    cp 32 : jr c, .loop
    jr .putC
    ret
.putC
    ld e, a
    xor a : ld hl, hostName, bc, 48 : cpir
    ld (hl), a : dec hl : ld (hl), e 
    jr .loop
.removeChar
    xor a
    ld hl, hostName, bc, 48 : cpir
    dec hl : dec hl : ld (hl), a 
    jr .loop

inputNavigate:
    ld hl, hostName, de, domain
.loop
    ld a, (hl) : and a : jr z, .complete
    ld (de), a : inc hl, de
    jr .loop
.complete
    ld a, 9 : ld (de), a : inc de
    ld a, '7' : ld (de), a : inc de
    ld a, '0' : ld (de), a : inc de
    ld a, 13 : ld (de), a : inc de
    ld a, 10 : ld (de), a : inc de
    ld hl, navRow : call Fetcher.fetch
    jp nc, MediaProcessor.processResource
    ld hl, loadingErrorMsg : call DialogBox.msgBox
    jp History.back

navRow db "1 ", 9, "/", 9
domain ds 64
