    MODULE MediaProcessor

media_type db 2 ; Same as icon

processResource:
    call UrlEncoder.extractHostName

    ld a, (media_type)
    cp Font.LINK  : jr z, processPage
    cp Font.INPUT : jr z, processPage
    cp Font.MUSIC : jr z, processPT
    cp Font.IMAGE : jr z, processImage
; Fallback to plain text
processText:
    call Render.renderPlainTextScreen
    jp   Render.plainTextLoop

processPT:
    call VortexProcessor.play
    jp History.refresh

processPage:
    call Render.renderGopherScreen
    jp   Render.workLoop

processImage:
    call ScreenViewer.display
    jp History.refresh

    ENDMODULE