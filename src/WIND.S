         ORG   $1000
         DSK   ../bin/WINDS.BIN#061000
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
* OPTS 0=INIT 1=OPEN 2=CLOSE 3=TOP 4=ESC 5=POP
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
TOPS     RTS
ESCS     RTS
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
         CMP   #81
         BGE   OPENS-1
         LDA   DY
         CMP   #2
         BLT   OPENS-1
         CMP   #24
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
         LDA   XSTORE
         LDY   #2
         STA   (PTR),Y
         INY
         LDA   YSTORE
         STA   (PTR),Y
         JSR   COPY
         JMP   SETW
