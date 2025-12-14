         ORG   $1000
         DSK   ../bin/BEGINNING#061000
         TYP   $06  ; /BIN file

         STA   $C08B
         STA   $C08B
         STA   $C009
         LDY   #0
III      LDA   $1100,Y
         STA   $D000,Y
         LDA   $1200,Y
         STA   $D100,Y
         LDA   $1300,Y
         STA   $D200,Y
         LDA   $1800,Y
         STA   $D800,Y
         LDA   $1900,Y
         STA   $D900,Y
         LDA   $1A00,Y
         STA   $DA00,Y
         LDA   $1B00,Y
         STA   $DB00,Y
         INY
         BNE   III
         STA   $C008
         STA   $C081
         STA   $C081
         LDY   #20
IIII     LDA   END,Y
         STA   $310,Y
         DEY
         BPL   IIII
         RTS
END
         ORG   $310
XIN      =     $300
YIN      =     $301
SHN      =     $302
CMD      =     $303
XBYTE    =     0
XBIT     =     1
YLINE    =     2
PTR1     =     3
PTR2     =     5
TEMP1    =     7
TEMP2    =     8
TEMP3    =     9
PAGE     =     10
SCRN     =     11
MFLAG    =     13
DX       =     14
DY       =     15
TEMP0    =     16
XBYTES   =     $D800
XBITS    =     $D900
HIGHS    =     $DA00
LOWS     =     $DB00
RAMRD    =     $C002
RAMWRT   =     $C004
STORE80  =     $C000
         STA   $C08B
         STA   $C08B
         STA   $C009
         JSR   $D000
         STA   $C008
         STA   $C081
         STA   $C081
         RTS
         DS    $100-$63
         ORG   $D000
         LDA   CMD
         STA   STORE80
         AND   #%00010000
         BNE   FFFFF
         LDA   #0
         STA   PAGE
         BEQ   FFFFF1
FFFFF    LDA   #$20
         STA   PAGE
FFFFF1   LDA   CMD
         AND   #$0F
         CMP   #4
         BLT   FFFF
         JMP   MANAGE
MANAGE   RTS
CALC     LDA   HIGHS,X
         CLC
         ADC   PAGE
         STA   SCRN+1
         LDA   LOWS,X
         STA   SCRN
         RTS
FFFF     ASL
         TAY
         LDA   TBL,Y
         STA   VECT+1
         LDA   TBL+1,Y
         STA   VECT+2
         LDY   XIN
         LDA   XBYTES,Y
         STA   XBYTE
         LDA   XBITS,Y
         STA   XBIT
         LDA   YIN
         STA   YLINE
         LDA   #$60
         STA   PTR1+1
         STZ   PTR1
         LDX   SHN
         STA   RAMRD+1
INCHECK  DEX
         BMI   INWEGO
         LDY   #1
         LDA   (PTR1)
         AND   (PTR1),Y
         CMP   #$FF
         BNE   KK
         JMP   QUIT
KK       LDA   (PTR1)
         CLC
         ADC   PTR1
         PHA
         LDA   (PTR1),Y
         ADC   PTR1+1
         STA   PTR1+1
         PLA
         STA   PTR1
         JMP   INCHECK
INWEGO   LDY   #2
         LDA   (PTR1),Y
         BEQ   BS
         DEC
         BEQ   BSM
         DEC
         BEQ   BIT
         LDA   #1
         STA   MFLAG
INSIDE   LDA   PTR1
         CLC
         ADC   #3
         STA   PTR1
         LDA   PTR1+1
         ADC   #0
         STA   PTR1+1
         LDA   XBIT
         CLC
         ADC   #7
         ASL
         TAY
         LDA   (PTR1),Y
         CLC
         ADC   PTR1
         STA   PTR2
         INY
         LDA   (PTR1),Y
         ADC   PTR1+1
         STA   PTR2+1
         LDA   XBIT
         ASL
         TAY
         LDA   (PTR1),Y
         CLC
         ADC   PTR1
         PHA
         INY
         LDA   (PTR1),Y
         ADC   PTR1+1
         STA   PTR1+1
         PLA
         STA   PTR1
         JMP   DOIT
BIT      STZ   MFLAG
         JMP   INSIDE
BSM      LDY   #3
         LDA   #1
         STA   MFLAG
         LDA   (PTR1),Y
         CLC
         ADC   PTR1
         STA   PTR2
         INY
         LDA   (PTR1),Y
         ADC   PTR1+1
         STA   PTR2+1
INSIDE2  LDA   PTR1
         CLC
         ADC   #3
         STA   PTR1
         LDA   PTR1+1
         ADC   #0
         STA   PTR1+1
         JMP   DOIT
BS       STZ   MFLAG
         JMP   INSIDE2
TBL
         DA    STORE,XOR,ANOR,ANDON
GET1     STA   RAMRD+1
         LDA   (PTR1)
         INC   PTR1
         BNE   GG1
         INC   PTR1+1
GG1      RTS
GET2     STA   RAMRD+1
         LDA   (PTR2)
         INC   PTR2
         BNE   GG2
         INC   PTR2+1
GG2      RTS
DOIT     JSR   GET1
         STA   DX
         JSR   GET1
         STA   DY
BIGLOOP  LDX   YLINE
         JSR   CALC
         LDA   XBYTE
         STA   TEMP1
         LDA   DX
         STA   TEMP2
VECT     JSR   $FFFF
         INC   YLINE
         DEC   DY
         BNE   BIGLOOP
QUIT     STA   RAMRD
         STA   RAMWRT
         RTS
STORE
         LDA   TEMP1
         LSR
         TAY
         BCC   S1
         LDA   #4
         BNE   S2
S1       LDA   #5
S2       STA   CHANGE+1
S3       JSR   GET1
CHANGE   STA   $C004
         STA   (SCRN),Y
         DEC   TEMP2
         BEQ   S4
         DEC   CHANGE+1
         LDA   CHANGE+1
         CMP   #3
         BNE   S3
         INY
         JMP   S1
S4       RTS
XOR
         LDA   TEMP1
         LSR
         TAY
         BCC   X1
         LDA   #4
         BNE   X2
X1       LDA   #5
X2       STA   XCHN+1
         EOR   #6
         STA   XCHN2+1
X3       JSR   GET1
XCHN     STA   $C005
XCHN2    STA   $C003
         EOR   (SCRN),Y
         STA   (SCRN),Y
         DEC   TEMP2
         BEQ   S4
         DEC   XCHN+1
         DEC   XCHN2+1
         LDA   XCHN+1
         CMP   #3
         BNE   X3
         INY
         JMP   X1
ANOR
         LDA   TEMP1
         LSR
         TAY
         BCC   A1
         LDA   #4
         BNE   A2
A1       LDA   #5
A2       STA   ACHN+1
         EOR   #6
         STA   ACHN2+1
A3       JSR   GET1
         STA   TEMP0
         LDA   MFLAG
         BNE   A4
         LDA   #$FF
         BNE   ACHN
A4       JSR   GET2
ACHN     STA   $C005
ACHN2    STA   $C003
         AND   (SCRN),Y
         ORA   TEMP0
         STA   (SCRN),Y
         DEC   TEMP2
         BEQ   Z4
         DEC   ACHN+1
         DEC   ACHN2+1
         LDA   ACHN+1
         CMP   #3
         BNE   A3
         INY
         JMP   A1
ANDON
         LDA   TEMP1
         LSR
         TAY
         BCC   Z1
         LDA   #4
         BNE   Z2
Z1       LDA   #5
Z2       STA   ZCHN+1
         EOR   #6
         STA   ZCHN2+1
Z3       JSR   GET1
ZCHN     STA   $C005
ZCHN2    STA   $C003
         AND   (SCRN),Y
         STA   (SCRN),Y
         DEC   TEMP2
         BEQ   Z4
         DEC   ZCHN+1
         DEC   ZCHN2+1
         LDA   ZCHN+1
         CMP   #3
         BNE   Z3
         INY
         JMP   Z1
Z4       RTS
