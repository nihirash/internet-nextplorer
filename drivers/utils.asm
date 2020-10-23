;;; Macroses!!!!
    MACRO EspSend Text
    ld hl, .txtB
    ld e, (.txtE - .txtB)
    call espSend
    jr .txtE
.txtB 
    db Text
.txtE 
    ENDM

    MACRO EspCmd Text
    ld hl, .txtB
    ld e, (.txtE - .txtB)
    call espSend
    jr .txtE
.txtB 
    db Text
    db 13, 10 
.txtE
    ENDM

    MACRO EspCmdOkErr text
    EspCmd text
    call checkOkErr
    ENDM
; IN DE - string pointer
; OUT HL - string len
strLen:
    ld hl, 0
.loop
    ld a, (de) : and a : ret z
    inc de, hl
    jr .loop