prepareScreen:
    call TextMode.cls
    ld h,2, a, Font.BORDER_TOP : call TextMode.fillLine
    ld h, 4, a, Font.SCROLL_UP : call TextMode.fillLine
    ld h, 27, a, Font.SCROLL_DOWN : call TextMode.fillLine
    
    ld h,3, a, Font.BORDER_BOTTOM : call TextMode.fillLine
    ld hl, #020C, a, Font.TILE_BACK : call TextMode.putTileXY
    ld hl, #0210, a, Font.TILE_HOME : call TextMode.putTileXY
    ld hl, #0246, a, Font.TILE_REFRESH : call TextMode.putTileXY
    ld de, #0314 : call TextMode.gotoXY : ld hl, hostName : call TextMode.printZ
    ret
