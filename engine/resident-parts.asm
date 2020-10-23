nameBuffer db "index.gph", 0
     ds #7f - ($ - nameBuffer), 0   
     
         db 0
hostName ds 48

     MODULE History
row db "1Starting page", 09, "index.gph", 09, "file", 09, "70", 13, 10
    ds #ff - ($ - row)
prev db "1Starting page", 09, "index.gph", 09, "file", 09, "70", 13, 10
    ds #ff - ($ - prev)
position dw 0
input    db 0
     ENDMODULE