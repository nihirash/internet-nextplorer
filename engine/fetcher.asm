    MODULE Fetcher
; HL - pointer to gopher page line
fetch:
    push hl
    call UrlEncoder.isFile
    pop hl
    jr c, fetchFromFS
    push hl
    call UrlEncoder.isValidGopherRow
    pop hl
    jr c, fetchFromNet
    ret

fetchFromNet:
    break
    ret

; HL - pointer to gopher page line
fetchFromFS:
    call UrlEncoder.extractPath
loadFile
    xor a : ld (de), a
    ld hl, nameBuffer : call Dos.loadBuffer
    ret

    ENDMODULE