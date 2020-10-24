    MODULE Fetcher

; HL - pointer to gopher page line
fetchFromNet:
    ld hl, historyBlock.locator, de, requestBuffer
.copyRequest
    ld a, (hl) 
    and a : jr z, .urlCopied
    ld (de), a
    inc hl, de
    jp .copyRequest
.urlCopied
    xor a : ld (de), a
.getDomainAndHost
    ld hl, historyBlock.host, de, historyBlock.port
    call Wifi.openTCP
    jr c, .error
    ld a, (historyBlock.mediaType) : cp Font.INPUT : jr nz, .performRequest

    ld a, 0, bc, #ff, hl, requestBuffer : cpir  : dec hl
    ld a, 9, (hl), a : inc hl
    ld de, historyBlock.search
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
    ld hl, .err : call DialogBox.msgBox 
    jp History.back
    ret
.closedCallback
    jp MediaProcessor.processResource
.err db "Document fetch error! Check your connection or hostname!", 0

fetchFromFS:
    xor a : ld hl, buffer, de, buffer + 1, bc, #ffff - buffer - 1, (hl), a  : ldir
    
    call UrlEncoder.extractPath
loadFile
    ld hl, nameBuffer : call Dos.loadBuffer
    jp MediaProcessor.processResource

requestBuffer ds #ff
    ENDMODULE