SEGMENT  CodeSegment:

   LDR  R1, R0, ONE     ; R1 <= 1
   LDR  R2, R0, TWO     ; R2 <= 2
   LDR  R4, R0, NEGONE  ; R4 <= -1
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   BRnzp LOOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP


ONE:    DATA2 4x0001
TWO:    DATA2 4x0002
NEGONE: DATA2 4xFFFF
TEMP1:  DATA2 4x0001
GOOD:   DATA2 4x600D
BADD:   DATA2 4xBADD

LOOP:
   ADD R3, R1, R2       ; R3 <= R1 + R2
   AND R5, R2, R2       ; R5 <= R2 AND R2
   NOT R6, R1           ; R6 <= NOT R1
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   STR R6, R0, TEMP1    ; M[TEMP1] <= R6
   LDR R7, R0, TEMP1    ; R7 <= M[TEMP1]
   ADD R1, R1, R4       ; R1 <= R1-1
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   BRn DONE
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   BRnzp LOOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP

HALT:
   LDR  R1, R0, BADD
   BRnzp HALT
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP

DONE:
   LDR  R1, R0, GOOD
   BRnzp DONE
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
