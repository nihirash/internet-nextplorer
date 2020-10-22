    MODULE TextMode
SCREEN EQU #4000
TILE_REG_MODE   EQU %11100011

init:
    nextreg ULA_Control_Reg, %10000000 ; Disable ULA screen 

    nextreg #4c, #00 ; Transperency color
    ;0x6B (107) => Tilemap Control
    ; bit 7 = 1 Enable the tilemap (soft reset = 0)
    ;   bit 6 = 0 for 40x32, 1 for 80x32 (soft reset = 0)
    ;   bit 5 = Eliminate the attribute entry in the tilemap (soft reset = 0)
    ;   bit 4 = Palette select (soft reset = 0)
    ;   bit 3 = Select textmode (soft reset = 0)
    ;   bit 2 = Reserved, must be 0
    ;   bit 1 = Activate 512 tile mode (soft reset = 0)
    ;   bit 0 = Force tilemap on top of ULA (soft reset = 0)
    nextreg TileMap_Control_Reg, TILE_REG_MODE ; Tilemap enabled
   
;  0x6C (108) => Default Tilemap Attribute
; (R/W)
;   Active if nextreg 0x6B bit 5 is set
;   bits 7:4 = Palette offset (soft reset = 0)
;   bit 3 = X mirror (soft reset = 0)
;   bit 2 = Y mirror (soft reset = 0)
;   bit 1 = Rotate (soft reset = 0)
;   bit 0 = ULA over tilemap (soft reset = 0)
;           (or bit 8 of the tile number if 512 tile mode is enabled)
    nextreg #6c, %0000000
    ; Tilemap Base Address
    nextreg #6e, 0
    ; Tile Definitions Base Address
    nextreg #6f, #0F

    ; Tile transp. color
    nextreg #4c, 0
    ;
    nextreg Palette_Mode_Reg, %00110001
    ; Color index
    nextreg #40,0 
    ld hl, pal, b, pal_end - pal ; 16 colours for tiles
.loop
    ld a, (hl) : inc hl
    nextreg #44, a
    djnz .loop
    ret

cls:
    call savePages
    ld (.spSave), sp
    ld sp, SCREEN + 80 * 32
    ld hl, 0, b, 80
.loop
    dup 16
    push hl
    edup
    djnz .loop
    ld sp, (.spSave)
    ei
    ld hl, 0, (coords), hl
    jp restorePages
.spSave dw 0

; DE - XY
gotoXY:
    ld (coords), de
    ret

; Draws 16x16 tile    
; A - tile number
; HL - XY
putTileXY:
    push af
    call calcXY
    call savePages
    pop af
    ld (hl), a : inc hl : inc a : ld (hl), a : inc a
    ld de, 79 : add hl, de : ld (hl), a : inc a, hl : ld (hl), a
    jp restorePages

; HL - text pointer
printZ:
    ld a, (hl) : and a : ret z
    push hl
    call putC
    pop hl
    inc hl
    jr printZ

; A - char
putC:
    push af
    call savePages
    pop af
    cp 13 : jr z, newLine
    ld b, a
    ld a, (y) : cp 28 : call nc, scroll
    ld hl, (coords) : call calcXY
    ld a, b, (hl), a
    ld a, (x) : inc a : cp 79 : jr nc, newLine
    ld (x), a
    jp restorePages
    

; H - line number
; A - char
fillLine:
    push af
    call savePages
    ld l, 0 : call calcXY
    pop af
    ld b, 80
.loop
    ld (hl), a
    inc hl
    djnz .loop
    jp restorePages
    


calcXY:
    ld a, h, e, a, d, 80 : mul d, e
    ld a, l, hl, SCREEN : add hl, a : add hl, de
    ret

newLine:
    ld hl, y
    inc (hl)
    xor a : ld (x), a
    jp restorePages

scroll:
    push bc
    ld de, SCREEN, hl, SCREEN + #50, bc, 80 * 29: ldir
    ld a, 27, (y), a : xor a : ld (x), a
    pop bc
    ret

savePages:
    di
    NextRegRead Slot_2_Reg
    ld (currentPages), a
    NextRegRead Slot_3_Reg
    ld (currentPages + 1), a
    nextreg Slot_2_Reg, 10
    nextreg Slot_3_Reg, 11 
    ret

restorePages:
    ld a, (currentPages)
    nextreg Slot_2_Reg, a
    ld a, (currentPages + 1)
    nextreg Slot_3_Reg, a
    ei
    ret

currentPages:
    dw 0

coords:
x db 0
y db 0

pal:
    incbin "font.nxp",0,32
pal_end:
    ENDMODULE