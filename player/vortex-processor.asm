    MODULE VortexProcessor
play:
    xor a : in a, (#fe) : cpl : and 31 : jp nz, play ; Waiting when all keys will be unpressed
    
    ld de, #0314   : call TextMode.gotoXY
    ld hl, message : call TextMode.printZ

    ld hl, buffer  : call VTPL.INIT
.loop
    halt : di : call VTPL.PLAY : ei
    xor a : in a, (#fe) : cpl : and 31 : jp nz, .stop
    ld a, (VTPL.SETUP) : rla : jr nc, .loop 
.stop
    call VTPL.MUTE
.wait
    xor a : in a, (#fe) : cpl : and 31 : jr nz, .wait ; Same as before - to prevent cycling playing
    ret

message db "Press key to stop...", 0
    ENDMODULE