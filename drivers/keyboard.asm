    MODULE Keyboard
KEY_UP = 11
KEY_DOWN = 10
KEY_LEFT = 8
KEY_RIGHT = 9
KEY_BACKSPACE = 12

keyCode db 0 

waitForKeyUp:
    xor a : in a, (#fe) : cpl : and 31 : jr nz, waitForKeyUp
    ret

getSinglePress:
    call inkey
.loop
    push af
    call inkey
    pop bc
    cp b 
    jr z, .loop
.exit
    ret

update:
    call inkey
    ld (keyCode), a
    ret

inkey:
   ld de,0
   ld bc,$fefe
   in a,(c)
   or $e1
   cp $ff
   jr nz, .keyhitA

   ld e,5
   ld b,$fd
   in a,(c)
   or $e0
   cp $ff
   jr nz, .keyhitA

   ld e,10
   ld b,$fb
   in a,(c)
   or $e0
   cp $ff
   jr nz, .keyhitA

   ld e,15
   ld b,$f7
   in a,(c)
   or $e0
   cp $ff
   jr nz, .keyhitA

   ld e,20
   ld b,$ef
   in a,(c)
   or $e0
   cp $ff
   jr nz, .keyhitA

   ld e,25
   ld b,$df
   in a,(c)
   or $e0
   cp $ff
   jr nz, .keyhitA

   ld e,30
   ld b,$bf
   in a,(c)
   or $e0
   cp $ff
   jr nz, .keyhitA

   ld e,35
   ld b,$7f
   in a,(c)
   or $e2
   cp $ff
   ld c,a
   jr nz, .keyhitB

.nokey
   xor a
   ret

.keyhitA

   ld c,a

   ld a,b
   cpl
   or $81
   in a,($fe)
   or $e0
   cp $ff
   jr nz, .nokey

   ld a,$7f
   in a,($fe)
   or $e2
   cp $ff
   jr nz, .nokey

.keyhitB

   ld b,0
   ld hl,.rowtbl-$e0
   add hl,bc
   ld a,(hl)
   cp 5
   jr nc, .nokey
   add a,e
   ld e,a

   ld hl,.table
   add hl,de

   ld a,$fe
   in a,($fe)
   and $01
   jr nz, .nocaps
   ld e,40
   add hl,de

.nocaps

   ld a,$7f
   in a,($fe)
   and $02
   jr nz, .nosym
   ld e,80
   add hl,de

.nosym

   ld a,(hl)
   ret

.rowtbl
   defb 255,255,255,255,255,255,255
   defb 255,255,255,255,255,255,255,255
   defb 4,255,255,255,255,255,255
   defb 255,3,255,255,255,2,255,1
   defb 0,255

.table
   db 0,'z','x','c','v'      ; CAPS SHIFT, Z, X, C, V
   db 'a','s','d','f','g'      ; A, S, D, F, G
   db 'q','w','e','r','t'      ; Q, W, E, R, T
   db '1','2','3','4','5'      ; 1, 2, 3, 4, 5
   db '0','9','8','7','6'      ; 0, 9, 8, 7, 6
   db 'p','o','i','u','y'      ; P, O, I, U, Y
   db 13,'l','k','j','h'       ; ENTER, L, K, J, H
   db ' ',0,'m','n','b'      ; SPACE, SYM SHIFT, M, N, B

   ; the following are CAPS SHIFTed

   db 0,'Z','X','C','V'      ; CAPS SHIFT, Z, X, C, V
   db 'A','S','D','F','G'      ; A, S, D, F, G
   db 'Q','W','E','R','T'      ; Q, W, E, R, T
   db 7,6,128,129,8            ; 1, 2, 3, 4, 5
   db 12,0,9,11,10             ; 0, 9, 8, 7, 6
   db 'P','O','I','U','Y'      ; P, O, I, U, Y
   db 13,'L','K','J','H'       ; ENTER, L, K, J, H
   db ' ',0,'M','N','B'      ; SPACE, SYM SHIFT, M, N, B

   ; the following are SYM SHIFTed

   db 0,':',96,'?','/'       ; CAPS SHIFT, Z, X, C, V
   db '~','|',92,'{','}'       ; A, S, D, F, G
   db 131,132,133,'<','>'      ; Q, W, E, R, T
   db '!','@','#','$','%'      ; 1, 2, 3, 4, 5
   db '_',')','(',39,'&'       ; 0, 9, 8, 7, 6
   db 34,';',130,']','['       ; P, O, I, U, Y
   db 13,'=','+','-','^'       ; ENTER, L, K, J, H
   db ' ',0,'.',',','*'      ; SPACE, SYM SHIFT, M, N, B

   ; the following are CAPS SHIFTed and SYM SHIFTed ("CTRL" key)

   db 0,26,24,3,22           ; CAPS SHIFT, Z, X, C, V
   db 1,19,4,6,7               ; A, S, D, F, G
   db 17,23,5,18,20            ; Q, W, E, R, T
   db 27,28,29,30,31           ; 1, 2, 3, 4, 5
   db 127,0,134,'`',135      ; 0, 9, 8, 7, 6
   db 16,15,9,21,25            ; P, O, I, U, Y
   db 13,12,11,10,8            ; ENTER, L, K, J, H
   db ' ',0,13,14,2          ; SPACE, SYM SHIFT, M, N, B
    ENDMODULE