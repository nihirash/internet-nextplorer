    MODULE ScreenViewer
display:
.wait
    xor a : in a, (#fe) : cpl : and 31 : jr nz, .wait

    NextRegRead Slot_6_Reg : ld (SLOT6), a
    NextRegRead Slot_7_Reg : ld (SLOT7), a
    nextreg Slot_6_Reg, 14
    nextreg Slot_7_Reg, 15

    ld hl, buffer, de, #c000, bc, 6912 : ldir
    call forceZXMode
.wait2
    xor a : in a, (#fe) : cpl : and 31 : jr z, .wait2

    call backToTileMode
    ld a, (SLOT6) : nextreg Slot_6_Reg, a
    ld a, (SLOT7) : nextreg Slot_7_Reg, a
    ret

forceZXMode:
    nextreg Palette_Mode_Reg, 0
    nextreg ULA_Control_Reg, 0
    nextreg TileMap_Control_Reg, 0
    ; 0x69 (105) => Display Control 1
    ; bit 7 = Enable layer 2 (alias port 0x123B bit 1)
    ; bit 6 = Enable ULA shadow display (alias port 0x7FFD bit 3)
    nextreg Display_Control_Reg_1, %01000000
    ret

backToTileMode:
    nextreg ULA_Control_Reg, %10000000
    nextreg TileMap_Control_Reg, TextMode.TILE_REG_MODE
    nextreg Display_Control_Reg_1, 0
    nextreg Palette_Mode_Reg, %00110001
    ret

SLOT6 db 0
SLOT7 db 0
    ENDMODULE