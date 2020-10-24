    MODULE Render
PER_PAGE = 22
WAIT_FRAMES = 3
    include "row.asm"
    include "buffer.asm"
    include "ui.asm"
    include "gopher-page.asm"
    include "plaintext.asm"

position EQU historyBlock.position
cursor_position EQU position + 1
page_offset     EQU position
    ENDMODULE

    include "dialogbox.asm"