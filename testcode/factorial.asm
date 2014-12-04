;; DESCRIPTION: This program computes the factorial of an integer in an
;; 		arbitrary memory location and stores the result both in
;;		register and memory. The default integer is 5.
;; INPUT:	memory content of INPUT label
;; OUTPUT:	memory content of RESULT label
;; REGISTERS:	R0 - stores 0 for value copy
;;		R1 - stores -1 for decrement
;;		R2 - stores computed sum, and final result
;;		R3 - stores current adder
;;		R4 - stores outer loop counter
;;		R5 - stores inner loop counter

ORIGIN	4x0000

SEGMENT	CodeSegment:
;;	All registors assumed to contain zero, due to microarchitecture
	LDR	R2, R0, INPUT	; R1 <- M[INPUT]
	LDR	R1, R0, NEG1
	ADD	R5, R1, R2	; initialize loop counters to be INPUT-2
	ADD	R5, R1, R5	;
	ADD	R4, R0, R5	;
	BRnzp	NEXT

INPUT:	DATA2	4x0005		; input can be altered
NEG1:	DATA2	4xFFFF
RESULT:	DATA2	4x0000

NEXT:
	BRnz	FINISH
OUTLOOP:
	ADD	R3, R0, R2	; update adder
INLOOP:
	ADD	R2, R2, R3
	ADD	R5, R1, R5	; decrement innerloop counter
	BRp	INLOOP
	ADD	R4, R1, R4	; update loop counters
	ADD	R5, R0, R4	;
	BRp	OUTLOOP
FINISH:	
	STR	R2, R0, RESULT
HALT:
	BRnzp	HALT		; end in infinite loop

