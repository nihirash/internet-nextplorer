    MODULE VortexProcessor
play:
    call Input.waitForButtonUp

    ld hl, message : call DialogBox.msgNoWait

    ld hl, buffer  : call VTPL.INIT
.loop
    halt : di : call VTPL.PLAY : ei
    call Input.read
    and a : jp nz, .stop
    ld a, (VTPL.SETUP) : rla : jr nc, .loop 
.stop
    call VTPL.MUTE
    call Input.waitForButtonUp
    ret

message db "Press key to stop...", 0
    ENDMODULE