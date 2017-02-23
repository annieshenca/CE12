.ORIG X3000		;begin at address x3000

	LEA R0,WEL	;loads welcome message into R0
	PUTS		;print the string to console

TOP	AND R0,R0,0	;clear all registers
	AND R1,R1,0
	AND R2,R2,0
	AND R3,R3,0
	AND R4,R4,0
	AND R5,R5,0
	ST R1,X	
	ST R1,FLG
	ST R1,INT
	LEA R0,ASK	;loads asking for input message
	PUTS		;print the string to console

INPUT	GETC		;gets input and store into R0
	OUT		;prints out R0 to console
	
	;input == LF?
	LD R1,LFYN	;loads LF value into R1
	ADD R1,R0,R1	;R1 = R0 -10
	BRz CALC	;if the input is LF(enter key), then branch to label CALC

	;input == X?
	LD R1,XCHAR	;loads the value of X character into R1
	ADD R1,R0,R1	;R1 = R0 ADD R1
	BRz X_INPUT	;go to label QUIT if the input is indeed 'X'

	;input == -?
	LD R1,NEGSIGN	;loads the value of negative sign into R1
	ADD R1,R0,R1	;R1 = input - 45
	BRz FLAG	;if R1 equals to zero, then go to label FLAG

	ADD R1,R1,-3	;R1 = R1 - 3 to get the actual digit
	;ST R1,DIGIT	;store actual digit into DIGIT
	
	ADD R2,R2,10	;for INTLOOP - R2 = 9, counter for amount of times R3 add to itself
	LD R3,INT	;for INTLOOP - load INT into R3

INTLOOP	ADD R4,R4,R3	;R4 = R4 ADD R3(INT)
	ADD R2,R2,-1	;decrement R2 the counter by 1
	BRp INTLOOP	;while R2 is still positive, go back up to INTLOOp and repeat
	ADD R4,R4,R1	;R4 = R4 + R1(the input digit)
	ST R4,INT	;store value of R3 into INT
	AND R4,R4,0	;reset R4=0
	;LD R0,INT
	;OUT
	BRnzp INPUT
	
FLAG	LD R1,FLG	;load value in FLG into R1 (now 0)
	ADD R1,R1,1	;R1 = R1 + 1
	ST R1,FLG	;store the value of R1 into FLG(which is now 1)
	BRnzp INPUT	;branch back to INPUT

X_INPUT	LD R1,X		;load value of X into R1 (now 0)
	ADD R1,R1,1	;increment R1 (now 1)
	ST R1,X		;store value of R1 into X variable
	BRnzp INPUT	;return to label INPUT

TWOSC	LD R1,INT	;load value of INT into R1
	NOT R1,R1	;R1 = !R1
	ADD R1,R1,1	;R1 = R1 + 1
	ST R1,INT	;store R1 into INT
	BRnzp MASKS	;branch to  no matter the value

CALC	LD R1, X	;load value in X into R1
	;ADD R1,R1,-1	;R1 = R1 - 1
	BRp QUIT	;branch to QUIT if X=1(positive), meaning the user input was a "X"
	
	LEA R0,RESULT	;load RESULT message into R0
	PUTS		;prints R0 to console

	;FLG == 1?
	LD R1, FLG	;load value of FLG into R1
	ADD R1,R1,-1	;R1 = R1 - 1
	BRz TWOSC	;if FLG==1, then branch to label TWOSC

MASKS	LD R1,INT	;load value of INT into R1
	LD R2,MCOUNT	;-15
	LEA R3,MASK	;load address of 1st Mask into R3
	BRnzp CONT

MASKSS	ADD R3,R3,1	;move to the next mask address
	ADD R2,R2,1	;increment the MCOUNT by 1

CONT	ADD R2,R2,0	;just to have it here so BR can check value
	BRp DONE	;finished the calculation for this input. go to TOP to ask for another
	LDR R4,R3,0	;load value of R3(the mask) into R4
	AND R0,R1,R4	;R0 = R1 AND R4(mask)
	BRz ZEROP	;if R0=0, then print '0'
	BRnp ONEP	;if R0=1, then print '1'

ZEROP	LD R0,ZERO	;load value of ZERO into R0
	OUT		;prints '0' to console	
	BRnzp MASKSS
	
ONEP	LD R0,ONE
	OUT		;prints '1' to console
	BRnzp MASKSS

DONE	LEA R0,BLK
	PUTS
	BRnzp TOP

QUIT	LEA R0,BYE	;load the BYE message into R0
	PUTS		;print R0 to console

HALT			;end user's program

;variables
WEL	.STRINGZ "Welcome to Annie's Binary Conversion Program!\n"
ASK	.STRINGZ "Please enter a number between 0-9, or 'X' to quit:\n"
LFYN	.FILL #-10	;invert of ASCII "LF"
XCHAR	.FILL #-88	;invert of character "X" in ASCII
NEGSIGN	.FILL #-45	;invert of the sign "-" in ASCII
X	.FILL #0	;is input "X"?
INT	.FILL #0	;set INT to 0
FLG	.FILL #0	;set FLAG to 0
MCOUNT	.FILL #-15	;counter for MASK
ZERO	.FILL #48	;the number 0
ONE	.FILL #49	;the number 1
BLK	.STRINGZ "\n"
RESULT	.STRINGZ "Thanks, here's the binary:\n"
THANK	.STRINGZ "Thanks, here's the number in binary:\n"
BYE	.STRINGZ "Thank you for using the program. Bye!"
MASK	.FILL X8000	;16-bit mask
	.FILL X4000
	.FILL X2000
	.FILL X1000
	.FILL X0800
	.FILL X0400
	.FILL X0200
	.FILL X0100
	.FILL X0080
	.FILL X0040
	.FILL X0020
	.FILL X0010
	.FILL X0008
	.FILL X0004
	.FILL X0002
	.FILL X0001

.END			;End of the program