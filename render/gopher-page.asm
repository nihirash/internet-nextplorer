cursor_position db 0
page_offset     db 0

renderGopherScreen:
    ld b, PER_PAGE
.loop
    push bc
    ld a, PER_PAGE : sub b
    
    ld b, a, e, a, a, (page_offset) : add b : ld b, a : call Render.findLine
    ld a, h : or l : jr z, .exit
    ld a, e : call Render.renderRow
.exit
    pop bc 
    djnz .loop
    ret