    MODULE VortexProcessor
play:
    xor a : in a, (#fe) : cpl : and 31 : jp nz, play
    
    ld de, #0314   : call TextMode.gotoXY
    ld hl, message : call TextMode.printZ

    ld hl, buffer  : call VTPL.INIT
.loop
    halt : di : call VTPL.PLAY : ei
    xor a : in a, (#fe) : cpl : and 31 : jp nz, .stop
    ld a, (VTPL.SETUP) : rla : jr nc, .loop 
.stop
    call VTPL.MUTE
    ret

message db "Press key to stop...", 0
    ENDMODULE