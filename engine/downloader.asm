    MODULE Downloader
; HL - gopher row 
go:
    ld hl, .msg : call DialogBox.msgNoWait 
    ld de, historyBlock.locator
    ld hl, de
.findFileName
    ld a, (de) : inc de
    cp '/' : jr nz, .skip
    ld hl, de
.skip
    and a : jr nz, .findFileName
.copy
    ;; HL - filename pointer
    ld de, filename
.copyFileName
    ld a, (hl) : and a : jr z, 1F

    ld (de), a : inc hl, de
    jr .copyFileName

1   ld (de), a

    call Fetcher.sendGopherRequest

    ld hl, filename, B, Dos.FMODE_CREATE
    call Dos.fopen : ld (fp), a

    ; Downloading started
.loadPackets
    ld hl, buffer, (Wifi.buffer_pointer), hl
    call Wifi.getPacket
    ld a, (Wifi.closed) : and a : jr nz, .closedCallback
    
    ld bc, (Wifi.bytes_avail), a, (fp), hl, buffer
    call Dos.fwrite
    call Wifi.continue
    jr .loadPackets
.closedCallback
    ld a, (fp) : call Dos.fclose
    jp History.back

.msg db "Downloading file! Wait a bit - eveything will happens now!",0
fp       db 0
filename ds 64
    ENDMODULE