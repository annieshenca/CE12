.ORIG x3000

TOP
	AND R0,R0,0			;clear all registers
	AND R1,R1,0
	AND R2,R2,0
	AND R3,R3,0
	AND R4,R4,0
	AND R5,R5,0
	ST R1, FLAG
	ST R1,CIPHER
	LEA R0, WEL 		;load welcome message into R0
	PUTS				;print out welcome message

INPUT
	GETC				;get the inputted character and store into R0
	OUT
	LD R1,LF			;load value of LF into R1
	ADD R1,R0,R1
	BRz FLAG_CALC		;if R0 is LF, then branch to calculate FLAG's value
	
	LD R1,X 			;R1 = -88
	ADD R1,R0,R1		;R1 = R0-88
	BRz FLAG_X			;if input is "X", then branch to FLAG_X
	LD R1,E 			;load value of E(-69) into R1
	ADD R1,R0,R1		;R1 = R0-69
	BRz FLAG_E			;FLAG = 1
	LD R1,D
	ADD R1,R0,R1
	BRz FLAG_D

	BRnp TOP			;branch to TOP to restart if the user entered in something not expected

FLAG_X
	ST 0,FLAG 			;store 0 into FLAG
	BRnzp INPUT 		;branch back to INPUT to sense LF

FLAG_E
	ST -1,FLAG 			;store -1 into FLAG
	BRnzp INPUT

FLAG_D
	ST 1,FLAG 			;store 1 into FLAG
	BRnzp INPUT

FLAG_CALC
	LD R1, FLAG 		;load value of FLAG into R1
	BRz EXIT			;if FLAG==0, meaning user entered "X" to exit 

	LEA R1,PROMPT		;load PROMPT into R1
	PUTS				;print out asking for cipher
	BRnzp DONE 	;TESTING

DONE
	LEA R1,EMPT
	PUTS
	BRnzp TOP			;Head to label TOP and ask for E/D/X again

EXIT
	LEA R1,BYE
	PUTS

HALT

WEL		.STRINGZ "Welcome to Annie's Caesar Cipher program"
PROMPT	.STRINGZ "Do you want to (E)ncrypt, (D)ecrypt, or (E)xit?\n"
LF		.FILL #-10
E 		.FILL #-69
D 		.FILL #-68
X 		.FILL #-88
FLAG	.FILL #0
ASKCI	.STRINGZ "What is the cipher(1-25)?\n"
CIPHER	.FILL #0
ASKSTR	.FILL "What is the string(200 characters max)?\n"
NEGA	.FILL #-65
NEGZ	.FILL #-90
NEGa 	.FILL #-97
NEGz 	.FILL #-122
RESD	.STRINGZ "Here is your string and the decrypted result:\n"
RESE	.STRINGZ "Here is your string and the encrypted result:\n"
ENC 	.STRINGZ "<Encrypted> "
DEC 	.STRINGZ "\n<Decrypted> "
EMPT	.STRINGZ "\n"
BYE 	.STRINGZ "Goodbye!"

.END