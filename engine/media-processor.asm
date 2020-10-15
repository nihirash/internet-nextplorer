    MODULE MediaProcessor

media_type db 2 ; Same as icon

processResource:
    xor a : ld (Render.page_offset), a, (Render.cursor_position), a
    ld a, (media_type)
    cp 2 : jr z, processPage
; Fallback to plain text
processText:
    call Render.renderPlainTextScreen
    jp   Render.plainTextLoop

processPage:
    call Render.renderGopherScreen
    jp   Render.workLoop

    ENDMODULE