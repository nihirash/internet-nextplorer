    DEVICE ZXSPECTRUMNEXT
    include "drivers/font.asm"
    include "drivers/next.asm"
    
    ;DEFINE WIFI_DEBUG
    ;DEFINE EMU
SLOT0_PAGE = 16 
SLOT1_PAGE = 17
;;  0x0000 - 0x2000
    MMU 0 e, SLOT0_PAGE
    ORG #38
    push af, bc, de, hl, ix
    call Keyboard.update
    pop ix, hl, de, bc, af
    ei
    ret
    include "drivers/utils.asm"
    include "drivers/keyboard.asm"
    include "drivers/tile-driver.asm"
    include "engine/engine.asm"
    include "utils/limitedstring.asm"
    include "player/index.asm"
    include "screen-viewer/index.asm"
    include "drivers/uart.asm"
    include "drivers/wifi.asm"
    DISPLAY "Page 16 memory left: ", #2000 - $
    
    MMU 1 e, SLOT1_PAGE
    ORG #2000
; Currently unused

    ORG #8000
Start:
    nextreg 7, 3
    nextreg Slot_0_Reg, SLOT0_PAGE
    nextreg Slot_1_Reg, SLOT1_PAGE

    call TextMode.init
    call Wifi.init
    ld hl, homePage : call Fetcher.fetch : jp MediaProcessor.processResource

    include "engine/resident-parts.asm"


homePage db "1 ",9, "docs/index.gph", 9, "file", 9, " ",13,10,0

    ds 255
stack = $ - 1

    include "drivers/esxdos.asm"
    include "render/index.asm"
    include "utils/comparebuff.asm"

buffer:
    DISPLAY "Page buffer ", $
    ds 32, 0

    SAVENEX OPEN "browser.nex", Start, stack, 0 , 2
    SAVENEX CORE 3,0,0 : SAVENEX CFG 0
    SAVENEX AUTO : SAVENEX CLOSE
    CSPECTMAP "cspect/test.map"