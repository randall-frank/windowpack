         ORG   $3F00
         DSK   ../bin/LOADER#063f00
         TYP   $06  ; /BIN file

WRMAINRAM =    $C004
WRCARDRAM =    $C005

TOP      LDY   #$00
SRC      LDA   $4000,Y
         STA   WRCARDRAM      ; w:WRCARDRAM
DST      STA   $1000,Y
         STA   WRMAINRAM      ; w:WRMAINRAM
         INY
         BNE   SRC
         INC   SRC+2
         INC   DST+2
         LDA   DST+2
         CMP   #$17
         BNE   TOP
         LDY   #$80
DUP      LDA   $3F80,Y
         STA   $0300,Y
         STA   WRCARDRAM      ; w:WRCARDRAM
         STA   $0300,Y
         STA   WRMAINRAM      ; w:WRMAINRAM
         DEY
         BPL   DUP
         RTS
