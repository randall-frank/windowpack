         ORG   $1000
         DSK   ../bin/WINDOWS#061000
         TYP   $06  ; /BIN file

XIN      =     0
YIN      =     1
DX       =     2
DY       =     3
WID      =     4
OPT      =     5
PTR      =     6
BASE     =     8
WLEFT    =     32
WWIDTH   =     33
WTOP     =     34
WBOTTOM  =     35
****************************
* OPTS 0=INIT 1=OPEN 2=CLOSE 3=POP 4=MOVE 5=TOP 6=ESC 7=TAB
* VARS 0=X 1=Y 2=DX 3=DY 4=WIND 5=OPTS
***************************
         LDY   OPT
         BEQ   INIT
         DEY
         BEQ   OPEN
         DEY
         BEQ   CLOSE
         DEY
         BEQ   POP
         DEY
         BEQ   MOVE
         DEY
         BEQ   TOP
         DEY
         BEQ   ESC
         DEY
         BEQ   TABBING
         RTS
TABBING  LDA   XIN
         STA   $C054
         STA   $57B
         LDA   YIN
         CLC
         ADC   WTOP
         STA   $25
         JSR   $FC22
         RTS
ENDY2    DFB   0
ENDY     DFB   0
ENDX     DFB   0
LEVEL    DFB   0
INIT     JMP   INITS
OPEN     JMP   OPENS
CLOSE    JMP   CLOSES
TOP      JMP   TOPS
ESC      JMP   ESCS
POP      JMP   POPS
MOVE     JMP   MOVES
GET      LDA   (PTR)
         INC   PTR
         BNE   GET1
         INC   PTR+1
GET1     RTS
STORE    STA   (PTR)
         INC   PTR
         BNE   STORE1
         INC   PTR+1
STORE1   RTS
CALC     LDA   TBL1,X
         STA   BASE+1
         LDA   TBL2,X
         STA   BASE
         RTS
TBL1     HEX   040405050606070704040505060607070404050506060707
TBL2     HEX   008000800080008028A828A828A828A850D050D050D050D0
INITS    LDX   #1
L1       JSR   CALC
         LDY   #39
L2       STA   $C054
         LDA   #$56
         STA   (BASE),Y
         STA   $C055
         LDA   #$57
         STA   (BASE),Y
         DEY
         BPL   L2
         INX
         CPX   #24
         BNE   L1
         LDX   #0
         JSR   CALC
         LDA   #$20
         LDY   #39
L3       STA   (BASE),Y
         STA   $C054
         STA   (BASE),Y
         STA   $C055
         DEY
         BPL   L3
         STA   $C054
         LDA   #$40
         STA   PTR+1
         LDA   #0
         STA   PTR
L4       LDA   #0
         STA   (PTR)
         LDY   #1
         STA   (PTR),Y
         LDA   PTR+1
         CLC
         ADC   #8
         STA   PTR+1
         CMP   #$90
         BNE   L4
         LDA   #0
         STA   LEVEL
         RTS
OPENS    LDA   XIN
         CMP   #79
         BGE   OPENS-1
         LDA   YIN
         CMP   #22
         BGE   OPENS-1
         LDA   DX
         CMP   #2
         BLT   OPENS-1
         CLC
         ADC   XIN
         CMP   #81
         BGE   OPENS-1
         LDA   DY
         CMP   #2
         BLT   OPENS-1
         CLC
         ADC   YIN
         CMP   #25
         BGE   OPENS-1
         LDA   LEVEL
         CMP   #8
         BNE   OK
         RTS
OK       INC   LEVEL
         LDA   #0
         STA   PTR
         LDA   #$40
         STA   PTR+1
OK3      LDA   (PTR)
         BEQ   OK2
         LDA   PTR+1
         CLC
         ADC   #8
         STA   PTR+1
         CMP   #$80
         BEQ   OK-1
         BRA   OK3
OK2      LDA   LEVEL
         JSR   STORE
         LDA   WID
         JSR   STORE
         LDA   XIN
         JSR   STORE
         LDA   YIN
         JSR   STORE
         LDA   DX
         JSR   STORE
         LDA   DY
         JSR   STORE
         LDA   YIN
         CLC
         ADC   DY
         STA   ENDY
         DEC
         STA   ENDY2
         LDA   XIN
         CLC
         ADC   DX
         STA   ENDX
         LDX   YIN
L6       JSR   CALC
         LDY   XIN
L7       TYA
         PHY
         STA   $C055
         LSR
         BCC   L8
         STA   $C054
L8       TAY
         LDA   (BASE),Y
         JSR   STORE
         LDA   #$5C
         CPX   YIN
         BEQ   L99
         LDA   #$4C
         CPX   ENDY2
         BEQ   L99
         PLA
         PHA
         CMP   XIN
         BNE   L98
         LDA   #$5F
         BRA   L99
L98      INC
         CMP   ENDX
         BNE   L97
         LDA   #$5A
         BRA   L99
L97      LDA   #$A0
L99      STA   (BASE),Y
         PLY
         INY
         CPY   ENDX
         BNE   L7
         INX
         CPX   ENDY
         BNE   L6
SETW     LDA   XIN
         INC
         STA   WLEFT
         LDA   DX
         DEC
         DEC
         STA   WWIDTH
         LDA   YIN
         INC
         STA   WTOP
         LDA   ENDY
         DEC
         STA   WBOTTOM
         STA   $C054
         LDA   YIN
         INC
         STA   $25
         JSR   $FC22
         LDA   XIN
         INC
         INC
         STA   $57B
         RTS
CLOSES   LDA   #$40
         STA   PTR+1
         LDA   #0
         LDY   #1
         STA   PTR
C1       LDA   (PTR),Y
         CMP   WID
         BEQ   C2
         LDA   PTR+1
         CLC
         ADC   #8
         STA   PTR+1
         CMP   #$80
         BNE   C1
         RTS
C2       LDA   (PTR)
         CMP   LEVEL
         BEQ   C3
         LDA   PTR+1
         PHA
         JSR   POPS
         PLA
         STA   PTR+1
         LDA   #0
         STA   PTR
C3       DEC   LEVEL
         LDA   #0
         JSR   STORE
         JSR   STORE
         JSR   GET
         STA   XIN
         JSR   GET
         STA   YIN
         JSR   GET
         STA   DX
         JSR   GET
         STA   DY
         LDA   XIN
         CLC
         ADC   DX
         STA   ENDX
         LDA   YIN
         CLC
         ADC   DY
         STA   ENDY
         LDX   YIN
C4       JSR   CALC
         LDY   XIN
C5       TYA
         PHY
         STA   $C055
         LSR
         BCC   C6
         STA   $C054
C6       TAY
         JSR   GET
         STA   (BASE),Y
         PLY
         INY
         CPY   ENDX
         BNE   C5
         INX
         CPX   ENDY
         BNE   C4
         LDA   #$40
         STA   PTR+1
         LDA   #$0
         STA   PTR
         LDA   LEVEL
         BEQ   SETFULL
C7       LDA   (PTR)
         CMP   LEVEL
         BNE   C77
         JSR   GET
         JSR   GET
         JSR   GET
         STA   XIN
         JSR   GET
         STA   YIN
         JSR   GET
         STA   DX
         JSR   GET
         STA   DY
         LDA   YIN
         CLC
         ADC   DY
         STA   ENDY
         JMP   SETW
C77      LDA   PTR+1
         CLC
         ADC   #8
         STA   PTR+1
         CMP   #$80
         BNE   C7
         RTS
SETFULL  LDA   #0
         STA   WLEFT
         STA   WTOP
         LDA   #80
         STA   WWIDTH
         LDA   #24
         STA   WBOTTOM
         RTS
COPY     JSR   GET
         JSR   GET
         JSR   GET
         STA   XIN
         JSR   GET
         STA   YIN
         JSR   GET
         STA   DX
         JSR   GET
         STA   DY
         LDA   XIN
         CLC
         ADC   DX
         STA   ENDX
         LDA   YIN
         CLC
         ADC   DY
         STA   ENDY
         LDX   YIN
COP1     JSR   CALC
         LDY   XIN
COP2     TYA
         PHY
         STA   $C055
         LSR
         BCC   COP3
         STA   $C054
COP3     TAY
         LDA   (BASE),Y
         PHA
         LDA   (PTR)
         STA   (BASE),Y
         PLA
         JSR   STORE
         PLY
         INY
         CPY   ENDX
         BNE   COP2
         INX
         CPX   ENDY
         BNE   COP1
         RTS
FINDLEVEL LDA   #0
         STA   PTR
         LDA   #$40
         STA   PTR+1
FL1      LDA   (PTR)
         CMP   LEVELCOUNT
         BEQ   FINDLEVEL-1
         LDA   PTR+1
         CLC
         ADC   #8
         STA   PTR+1
         CMP   #$80
         BNE   FL1
         RTS
POPS     LDA   #$40
         STA   PTR+1
         LDA   #0
         STA   PTR
P1       LDY   #1
         LDA   (PTR),Y
         CMP   WID
         BEQ   P2
         LDA   PTR+1
         CLC
         ADC   #8
         STA   PTR+1
         CMP   #$80
         BNE   P1
         RTS
P2       LDA   (PTR)
         CMP   LEVEL
         BEQ   P2-1
         STA   LEVELSTART
         LDA   LEVEL
         STA   LEVELCOUNT
P3       JSR   FINDLEVEL
         JSR   COPY
         LDA   LEVELCOUNT
         CMP   LEVELSTART
         BEQ   P4
         DEC   LEVELCOUNT
         BRA   P3
P4       LDA   LEVELSTART
         STA   LEVELCOUNT
         JSR   FINDLEVEL
         LDA   LEVEL
         INC
         STA   (PTR)
         INC   LEVELCOUNT
P5       JSR   FINDLEVEL
         LDA   (PTR)
         DEC
         STA   (PTR)
         JSR   COPY
         LDA   LEVELCOUNT
         DEC
         CMP   LEVEL
         BEQ   P6
         INC   LEVELCOUNT
         BRA   P5
P6       JMP   SETW
LEVELCOUNT DFB   0
LEVELSTART DFB   0
XSTORE   DFB   0
YSTORE   DFB   0
         RTS
MOVES    LDA   XIN
         STA   XSTORE
         LDA   YIN
         STA   YSTORE
         LDA   #$40
         STA   PTR+1
         LDA   #0
         STA   PTR
M1       LDY   #1
         LDA   (PTR),Y
         CMP   WID
         BEQ   M2
         LDA   PTR+1
         CLC
         ADC   #8
         STA   PTR+1
         CMP   #$80
         BEQ   MOVES-1
         BRA   M1
M2       JSR   POPS
         LDA   LEVEL
         STA   LEVELCOUNT
         JSR   FINDLEVEL
         JSR   COPY
         JSR   FINDLEVEL
         LDY   #4
         LDA   XSTORE
         CLC
         ADC   (PTR),Y
         CMP   #81
         BGE   TOOBIG
         INY
         LDA   YSTORE
         CLC
         ADC   (PTR),Y
         CMP   #25
         BGE   TOOBIG
         LDA   XSTORE
         LDY   #2
         STA   (PTR),Y
         INY
         LDA   YSTORE
         STA   (PTR),Y
TOOBIG   JSR   COPY
         JMP   SETW
PRINT    PHY
         PHA
         STA   $C055
         TYA
         LSR
         BCC   PR1
         STA   $C054
PR1      TAY
         PLA
         STA   (BASE),Y
         PLY
         RTS
TOPS     LDX   #0
         JSR   CALC
         LDA   #$20
         LDY   #39
T1111    STA   (BASE),Y
         STA   $C054
         STA   (BASE),Y
         STA   $C055
         DEY
         BPL   T1111
         LDY   #0
         LDA   #8
         STA   PLACE1+2
T1       LDX   #0
PLACE1   LDA   $800,X
         BEQ   OVER
         AND   #$7F
         JSR   PRINT
OVER     INX
         INY
         CPX   #8
         BNE   PLACE1
         INY
         INC   PLACE1+2
         LDA   PLACE1+2
         CMP   #$10
         BNE   T1
         RTS
XSTART   DFB   0,9,18,27,36,45,54,63
XEND     DFB   17,26,35,44,53,62,71,80
RESTORE  TAX
         LDA   XSTART,X
         STA   XIN
         LDA   XEND,X
         STA   ENDX
         LDA   #$80
         STA   PTR+1
         LDA   #0
         STA   PTR
         LDX   #0
R1       JSR   CALC
         LDY   XIN
R2       JSR   GET
         JSR   PRINT
         INY
         CPY   ENDX
         BNE   R2
         INX
         CPX   #18
         BNE   R1
         RTS
SAVEOFF  TAX
         ORA   #8
         STA   GET2PLACE+2
         LDA   XSTART,X
         STA   XIN
         LDA   XEND,X
         STA   ENDX
         LDA   #$80
         STA   PTR+1
         LDA   #0
         STA   PTR
         LDX   #0
S1       JSR   CALC
         LDY   XIN
S2       TYA
         PHY
         STA   $C055
         LSR
         BCC   S3
         STA   $C054
S3       TAY
         LDA   (BASE),Y
         JSR   STORE
         PLY
         INY
         CPY   ENDX
         BNE   S2
         INX
         CPX   #18
         BNE   S1
         LDX   #0
         STX   YIN
         JSR   CALC
         LDY   XIN
S5       JSR   GET2PLACE
         CMP   #0
         BEQ   S4
         ORA   #$80
         JSR   PRINT
         INY
         INX
         JMP   S5
S4       LDX   #16
S6       PHX
         INC   YIN
         LDX   YIN
         JSR   CALC
         PLX
         LDY   XIN
         LDA   #$5F
         JSR   PRINT
         INY
S7       JSR   GET2PLACE
         INX
         JSR   PRINT
         INY
         TXA
         BEQ   S8
         AND   #$0F
         CMP   #0
         BNE   S7
         JSR   GET2PLACE
         CMP   #0
         BEQ   S8
         JMP   S6
S8       LDY   XIN
         INC   YIN
         LDX   YIN
         JSR   CALC
         LDX   #0
S9       LDA   #$4C
         JSR   PRINT
         INY
         INX
         CPX   #$11
         BNE   S9
         RTS
GET2PLACE LDA   $800,X
         RTS
INVERSE  STA   WID
         LDX   X1
         LDA   XSTART,X
         TAY
         INY
         LDA   X1
         ORA   #8
         STA   GET2PLACE+2
         LDX   Y1
         JSR   CALC
         TXA
         ASL
         ASL
         ASL
         ASL
         TAX
INV4     JSR   GET2PLACE
         CMP   #$5A
         BEQ   INV1
         ORA   #$80
         PHA
         LDA   WID
         BEQ   INV2
         PLA
         AND   #$7F
         BRA   INV3
INV2     PLA
INV3     JSR   PRINT
         INY
         INX
         BRA   INV4
INV1     RTS
X1       DFB   0
Y1       DFB   0
ESCS     LDA   #0
         STA   X1
         INC
         STA   Y1
HORIZ    LDA   X1
         JSR   SAVEOFF
         LDA   X1
         ORA   #8
         STA   GET2PLACE+2
         LDA   #1
         STA   Y1
VERT     LDA   #1
         JSR   INVERSE
E1       LDA   $C000
         BPL   E1
         STA   $C010
         CMP   #$9B
         BEQ   EBAD
         CMP   #$8D
         BEQ   EOUT
         CMP   #$88
         BNE   E2
         JMP   LEFT
E2       CMP   #21+128
         BNE   E3
         JMP   RIGHT
E3       CMP   #139
         BNE   E4
         JMP   UP
E4       CMP   #138
         BEQ   DOWN
         JMP   E1
EBAD     LDA   X1
         JSR   RESTORE
         LDA   #$FF
         STA   0
         STA   1
         RTS
EOUT     LDA   X1
         JSR   RESTORE
         LDA   X1
         STA   0
         LDA   Y1
         STA   1
         RTS
DOWN     LDA   #0
         JSR   INVERSE
DD1      INC   Y1
         LDA   Y1
         CMP   #$10
         BEQ   DD3
         ASL
         ASL
         ASL
         ASL
         TAX
         JSR   GET2PLACE
         CMP   #$53
         BEQ   DD1
         CMP   #0
         BNE   DD2
DD3      LDA   #0
         STA   Y1
         BRA   DD1
DD2      JMP   VERT
UP       LDA   #0
         JSR   INVERSE
UU1      DEC   Y1
         LDA   Y1
         CMP   #$0
         BEQ   UU3
         ASL
         ASL
         ASL
         ASL
         TAX
         JSR   GET2PLACE
         CMP   #$53
         BEQ   UU1
         CMP   #0
         BEQ   UU1
         JMP   VERT
UU3      LDA   #$10
         STA   Y1
         BRA   UU1
RIGHT    LDA   X1
         JSR   RESTORE
RR1      INC   X1
         LDA   X1
         CMP   #8
         BEQ   RR2
         LDX   #0
         ORA   #8
         STA   GET2PLACE+2
         JSR   GET2PLACE
         CMP   #0
         BEQ   RR1
         JMP   HORIZ
RR2      LDA   #$FF
         STA   X1
         JMP   RR1
LEFT     LDA   X1
         JSR   RESTORE
LL1      DEC   X1
         LDA   X1
         CMP   #$FF
         BEQ   LL2
         LDX   #0
         ORA   #8
         STA   GET2PLACE+2
         JSR   GET2PLACE
         CMP   #0
         BEQ   LL1
         JMP   HORIZ
LL2      LDA   #8
         STA   X1
         JMP   LL1
