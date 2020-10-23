    MODULE Render
PER_PAGE = 22
WAIT_FRAMES = 3
    include "row.asm"
    include "buffer.asm"
    include "ui.asm"
    include "gopher-page.asm"
    include "plaintext.asm"

position:
cursor_position db 0
page_offset     db 0
    ENDMODULE

    include "dialogbox.asm"