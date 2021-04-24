    IFDEF PROXY    
    MODULE Wifi
; Same singature as wifi.openTCP
; HL - host pointer in gopher row
; DE - port pointer in gopher row
openTCP:
    push de
    push hl

    xor a : ld hl, hostBuff, de, hostBuff + 1, bc, 102, (hl), a : ldir

    EspCmdOkErr "AT+CIPCLOSE"
    EspCmdOkErr 'AT+CIPSTART="TCP","138.68.76.243",6912' // Replace here for yourown proxy. If you wish
    jr c, .error
    pop hl : ld de, hostBuff
.copyHost
    ld a, (hl) : cp 9 : jr z, 1F : and a : jr z, 1F
    ld (de), a : inc hl, de
    jr .copyHost
1   xor a : ld (de), a
    pop hl : ld de, portBuff
.copyPort
    ld a, (hl) : cp 9 : jr z, 1F : and a : jr z, 1F
    ld (de), a : inc hl, de
    jr .copyPort
1   ld hl, hostBuff : call tcpSendZ
    ld hl, portBuff : call tcpSendZ
    xor a : ld (closed), a
    ret
.error
    pop hl : pop de 
    ret

continue:
    EspCmdOkErr "AT+CIPSEND=1"
    ret c
.wait
    call Uart.read : cp '>' : jr nz, .wait
    ld a, 'c' : call Uart.write
    jp checkOkErr

hostBuff ds 96
portBuff ds 7
    ENDMODULE
    ENDIF