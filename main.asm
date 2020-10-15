    DEVICE ZXSPECTRUMNEXT
    include "drivers/font.asm"
    include "drivers/next.asm"
SLOT0_PAGE = 100

    MMU 0 e, SLOT0_PAGE
    ORG #38
    push af, bc, de, hl, ix
    call Keyboard.update
    pop ix, hl, de, bc, af
    ei
    ret
    include "drivers/keyboard.asm"
    include "drivers/tile-driver.asm"
    include "engine/engine.asm"
    include "utils/limitedstring.asm"
    DISPLAY "Zero page pointer: ", $
    ORG #8000
Start:
    DISPLAY "Loader ", $
    nextreg 7, 3
    nextreg Slot_0_Reg, SLOT0_PAGE
    call TextMode.init
    
    call Fetcher.loadFile

    call Render.prepareScreen
    call Render.renderGopherScreen
    ld de, 0 : call TextMode.gotoXY
    jp Render.workLoop
    include "engine/resident-parts.asm"

hostName
    db "file"
    ds 48 - ($ - hostName), 32
    db 0

    ds 255
stack = $ - 1

    include "drivers/esxdos.asm"
    include "render/index.asm"
    include "utils/comparebuff.asm"

buffer:
    DISPLAY "Page buffer ", $
    ds 32, 0

    SAVENEX OPEN "test.nex", Start, stack, 0 , 2
    SAVENEX CORE 3,0,0 : SAVENEX CFG 0
    SAVENEX AUTO : SAVENEX CLOSE
    CSPECTMAP "cspect/test.map"