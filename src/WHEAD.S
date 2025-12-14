         ORG   $300
         DSK   ../bin/WHEAD#060300
         TYP   $06  ; /BIN file

         LDA   5
         CMP   #5
         BEQ   TOP
IN       STA   $C003
         STA   $C005
         JSR   $1000
         STA   $C002
         STA   $C004
         STA   $C054
         RTS
TOP      LDA   0
         ORA   1
         BEQ   IN
         LDA   #8
         STA   PLACE+2
I1       LDY   #0
I2       LDA   (0),Y
         STA   $C005
PLACE    STA   $800,Y
         STA   $C004
         INY
         BNE   I2
         INC   1
         INC   PLACE+2
         LDA   PLACE+2
         CMP   #$10
         BNE   I1
         BEQ   IN
