    MODULE DialogBox
; HL - message
msgBox:
    push hl
    call drawBox
    call Input.waitForButtonUp
    pop hl
    call TextMode.printZ
    ld b, 150
.loop
    halt
    djnz .loop
    ret

inputBox:
    xor a : ld (inputBuffer), a
.noclear
    call drawBox
.loop
    ld de, #0D05 : call TextMode.gotoXY
    ld hl, inputBuffer : call TextMode.printZ
    ld a, Font.INPUT : call TextMode.putC : ld a, ' ' : call TextMode.putC
    call Keyboard.getSinglePress
    and a : jr z, .loop
    cp 12 : jr z, .removeChar
    cp 13 : ret z
    cp 32 : jr c, .loop
    jr .putC
.putC
    ld e, a
    xor a : ld hl, inputBuffer, bc, #ff : cpir
    ld (hl), a : dec hl : ld (hl), e 
    jr .loop
.removeChar
    xor a
    ld hl, inputBuffer, bc, #ff : cpir
    dec hl : dec hl : ld (hl), a 
    jr .loop

inputBuffer ds #ff

msgNoWait:
    push hl
    call drawBox
    pop hl
    jp TextMode.printZ

drawBox:
    ld h, #0C, a, Font.BORDER_BOTTOM : call TextMode.fillLine
    ld h, #0D, a, ' '                : call TextMode.fillLine
    ld h, #0E, a, Font.BORDER_TOP    : call TextMode.fillLine
    ld de, #0D05 : call TextMode.gotoXY
    ret
    ENDMODULE