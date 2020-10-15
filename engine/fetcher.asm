    MODULE Fetcher
; HL - pointer to gopher page line
fetch:
    call History.save
.skipHistory
    push hl
    ld a, (hl) : call Render.getIcon
    ld (MediaProcessor.media_type), a
    pop hl : push hl
    call UrlEncoder.isFile
    pop hl
    jr c, fetchFromFS
    push hl
    call UrlEncoder.isValidGopherRow
    pop hl
    jr c, fetchFromNet
    ret

fetchFromNet:
;; TODO - Network driver
    ret

; HL - pointer to gopher page line
fetchFromFS:
    call UrlEncoder.extractPath
loadFile
    xor a : ld (de), a
    ld hl, nameBuffer : call Dos.loadBuffer
    ret

    ENDMODULE