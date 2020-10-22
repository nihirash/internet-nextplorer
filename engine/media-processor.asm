    MODULE MediaProcessor

media_type db 2 ; Same as icon

processResource:
    ld a, (media_type)
    cp Font.LINK : jr z, processPage
    cp Font.MUSIC : jr z, processPT
    cp Font.IMAGE : jr z, processImage
; Fallback to plain text
processText:
    call Render.renderPlainTextScreen
    jp   Render.plainTextLoop

processPT:
    call VortexProcessor.play
    ld hl, History.position : inc (hl)
    jp History.back

processPage:
    call Render.renderGopherScreen
    jp   Render.workLoop

processImage:
    call ScreenViewer.display
    ld hl, History.position : inc (hl)
    jp History.back

    ENDMODULE