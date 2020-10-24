    MODULE MediaProcessor
processResource:
    call UrlEncoder.extractHostName
    ld a, (historyBlock.mediaType)
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
    jp History.back

processPage:
    call Render.renderGopherScreen
    jp   Render.workLoop

processImage:
    call ScreenViewer.display
    jp History.back

    ENDMODULE