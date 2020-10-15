nameBuffer db "index.gph", 0
     ds #7f - ($ - nameBuffer), 0   

     MODULE History
row db "1Starting page", 09, "index.gph", 09, "file", 09, "70", 13, 10
    ds #ff - ($ - row)
prev ds #ff
     ENDMODULE