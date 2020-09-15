Slot_0_Reg               EQU #50
Slot_1_Reg               EQU #51
Slot_2_Reg               EQU #52
Slot_3_Reg               EQU #53
Slot_4_Reg               EQU #54
Slot_5_Reg               EQU #55
Slot_6_Reg               EQU #56
Slot_7_Reg               EQU #57

Sprite_Register_Port     EQU #243B

    MACRO NextRegRead nreg
    ld bc, Sprite_Register_Port, a, nreg
    out (c), a : inc b : in a, (c)
    ENDM