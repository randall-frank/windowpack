         ORG   $9900
         DSK   ../bin/AMPER.PRODOS#069900
         TYP   $06  ; /BIN file

                        
GETBUFR  =     $BEF5      ; Allocate a basic.system buffer

ST       LDA   #1         ; 1 page
         JSR   GETBUFR
         BCC   III
         RTS
III      CMP   #$99       
         BNE   III-1
         LDY   #0
III2     LDA   $4000,Y
         STA   $9900,Y
         INY
         BNE   III2
         LDA   #$4C
         STA   $3F5
         LDA   #<START
         STA   $3F6
         LDA   #>START
         STA   $3F7
         LDA   $3F2
         STA   RETURN+1
         LDA   $3F3
         STA   RETURN+2
         LDA   #<RESET
         STA   $3F2
         LDA   #>RESET
         STA   $3F3
         EOR   #$A5
         STA   $3F4
         RTS
START    JSR   $B7        ; Parse the & command
         PHA
         JSR   $B1
         PLA
         LDY   #0
L1       CMP   TBL,Y
         BEQ   L2
         INY
         BNE   L1
         JMP   $DEBE      ; Comma check
L2       TYA
         TAX
         STX   TEMP2
         LDY   #0
         CPX   #0
         BEQ   L5
L4       LDA   TBL2,Y
         INY
         CMP   #$80
         BNE   L4
         DEX
         BNE   L4
L5       STY   TEMP
L3       LDY   TEMP
         LDA   TBL2,Y
         CMP   #$80
         BEQ   L6
         PHA
         JSR   $DEBE      ; Comma check
         JSR   $DD67      ; Get a value
         JSR   $E752      ; convert to 16bit integer $51,$52
         PLA
         TAX
         LDA   $50
         STA   0,X
         LDA   $51
         STA   1,X
         INC   TEMP
         JMP   L3
L6       LDA   TEMP2
         STA   5
         JMP   $300
TBL      ASC   'IOCPMLET'
TBL2     HEX   800001020304800480048000010480008080000180
TEMP     DFB   0
TEMP2    DFB   0
RESET    JSR   $C300      ; init video card
         LDA   #0
         STA   5
         JSR   $300       ; dispatch though RAW API interface
         LDA   #0
         STA   0
         STA   1
         LDA   #5
         STA   5
         JSR   $300
         LDA   #1
         STA   0
         STA   1
         STA   4
         STA   5
         LDA   #78
         STA   2
         LDA   #22
         STA   3
         JSR   $300
         LDA   #0
         STA   1403
RETURN   JMP   $FFFF
