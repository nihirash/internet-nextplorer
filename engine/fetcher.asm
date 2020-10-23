    MODULE Fetcher
; HL - pointer to gopher page line
; C flag - is error happens
fetch:
    call History.save
.skipHistory
    push hl
    ld hl, .msg : call DialogBox.msgNoWait
    pop hl
    push hl
    ld a, (hl) : call Render.getIcon
    ld (MediaProcessor.media_type), a
    pop hl : push hl
    call UrlEncoder.isFile
    pop hl
    jp c, fetchFromFS
    push hl
    call UrlEncoder.isValidGopherRow
    pop hl
    jr c, fetchFromNet
    scf
    ret
.msg db "Loading resource! Please wait! It will be here soon!", 0

; HL - pointer to gopher page line
fetchFromNet:
    ld a, 9, bc, #ff : cpir
    ld de, requestBuffer
.copyRequest
    ld a, (hl) 
    cp 9 
    jr z, .urlCopied
    ld (de), a
    inc hl, de
    ; TODO add search request support
    jp .copyRequest
.urlCopied
    xor a : ld (de), a
.getDomainAndHost
    ld a, 9, bc, #ff : cpir 
    push hl ; domain
    ld a, 9, bc, #ff : cpir
    ; hl - host
    pop de ; de - port
    ex hl, de
    call Wifi.openTCP
    jr c, .error
    ld hl, buffer, de, buffer + 1, bc, #ffff - buffer - 1, (hl), a
    ldir
    ld a, (Render.isInputRequest) : and a : jr z, .performRequest

    ld a, 0, bc, #ff, hl, requestBuffer : cpir  : dec hl
    ld a, 9, (hl), a : inc hl
    ld de, DialogBox.inputBuffer
.loadSearchRequest
    ld a, (de) : ld (hl), a : and a : jr z, .performRequest
    inc hl, de
    jr .loadSearchRequest
.performRequest
    ld hl, requestBuffer
    call Wifi.tcpSendZ
    ld hl, buffer, (Wifi.buffer_pointer), hl
.loadPackets
    call Wifi.getPacket
    ld a, (Wifi.closed) : and a : jr nz, .closedCallback
    jr .loadPackets
.error 
    scf 
    ret
.closedCallback
    
    or a
    ret

; HL - pointer to gopher page line
fetchFromFS:
    call UrlEncoder.extractPath
loadFile
    xor a : ld (de), a
    
    ld hl, buffer, de, buffer + 1, bc, #ffff - buffer - 1, (hl), a
    ldir
    ld hl, nameBuffer : call Dos.loadBuffer
    or a
    ret

requestBuffer ds #ff
    ENDMODULE