    MODULE Uart
UART_RxD  equ #143B       ; Also used to set the baudrate
UART_TxD  equ #133B       ; Also reads status
UART_Sel  equ #153B       ; Selects between ESP and Pi, and sets upper 3 bits of baud
UART_SetBaud equ UART_RxD ; Sets baudrate
UART_GetStatus equ UART_TxD 

UART_TX_BUSY       equ %00000010
UART_RX_DATA_READY equ %00000001
UART_FIFO_FULL     equ %00000100

    ; Enable UART
; Cleaning all flags by reading UART regs
; Wastes AF and BC
init:
    ld hl, .table
    ld bc,9275	;Now adjust for the set Video timing.
    ld a,17
    out (c),a
    ld bc,9531
    in a,(c)	;get timing adjustment
    ld e,a
    rlc e		;*2 guaranteed as <127
    ld d,0
    add hl,de

    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    
    ld bc, UART_Sel, a, %00100000 : out (c), a ; select uart

    ld bc, UART_SetBaud
    ld a, l
    AND %01111111	; Res BIT 7 to req. write to lower 7 bits
    out (c), a
    ld a, h
    rl l		; Bit 7 in Carry
    rla		; Now in Bit 0
    or %10000000	; Set MSB to req. write to upper 7 bits
    out (c), a

    ret
.table
    dw 243,248,256,260,269,278,286,234

read:
    ld bc, UART_GetStatus
.wait
    in a, (c)
    rrca : jr nc, .wait
    ld bc, UART_RxD
    in a, (c)

    IFDEF WIFI_DEBUG
    push af, de, hl
    call TextMode.putC
    pop hl, de, af
    ENDIF
    ret

; Write single byte to UART
; A - byte to write
; BC will be wasted
write:    
    IFDEF WIFI_DEBUG
    push af, de, hl
    call TextMode.putC
    pop hl, de, af
    ENDIF

    ld d, a
    ld bc, UART_GetStatus
.wait   
    in a, (c) : and UART_TX_BUSY : jr nz, .wait
    out (c), d
    ret

    ENDMODULE