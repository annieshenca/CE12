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
	OUT 				;print R0 to console
	LD R1,LF			;load value of LF into R1
	ADD R1,R0,R1 		;R1 = R0-10
	BRz LF				;if R0 is LF, then branch to calculate FLAG's value
	LD R1,E 	 		;load value of E(-69) into R1
	ADD R1,R0,R1		;R1 = R0-69
	BRz FLAG_E			;branch to FLAG_E to change FLAG to 1
	LD R1,D 			;load value of D(-68) into R1
	ADD R1,R0,R1 		;R1 = R0-68
	BRz FLAG_D 			;branch to FLAG_D to change FLAG to -1
	LD R1,X				;load value of X(-88) into R1
	ADD R1,R0,R1		;R1 = R0-88
	BRz INPUT			;if input is "X", let FLAG remain 0
	BRnp TOP			;branch to TOP to restart if the user entered in something not expected

FLAG_E
	LD R1,FLAG			;laod value of FLAG(0) into R1
	ADD R1,R1,1 		;R1 = R1+1 = 1
	ST R1,FLAG			;store value of R1 into FLAG
	BRnzp INPUT			;branch back to INPUT

FLAG_D
	LD R1,FLAG			;laod value of FLAG(0) into R1
	ADD R1,R1,-1 		;R1 = R1-1 = -1
	ST R1,FLAG			;store value of R1 into FLAG
	BRnzp INPUT			;branch back to INPUT

LF
	LD R1, FLAG 		;load value of FLAG into R1
	BRz EXIT			;if FLAG==0, meaning user entered "X" to exit
	LEA R1,PROMPT		;load PROMPT into R1
	PUTS				;print out asking for cipher
	BRnzp DONE			;TESTING

DONE
	LEA R1,EMPT
	PUTS
	BRnzp TOP			;Head to label TOP and ask for E/D/X again

EXIT
	LEA R1,BYE
	PUTS


HALT

;Variables
E 		.FILL #-69
D 		.FILL #-68
X 		.FILL #-88
FLAG	.FILL #0
CIPHER	.FILL #0
NEGA	.FILL #-65
NEGZ	.FILL #-90
NEGa 	.FILL #-97
NEGz 	.FILL #-122
ARRAY	.BLKW 400
WEL		.STRINGZ "Welcome to Annie's Caesar Cipher program\n"
PROMPT	.STRINGZ "Do you want to (E)ncrypt, (D)ecrypt, or (E)xit?\n"
ASKCI	.STRINGZ "What is the cipher(1-25)?\n"
ASK		.STRINGZ "What is the string(200 characters max)?\n"
RESD	.STRINGZ "Here is your string and the decrypted result:\n"
RESE	.STRINGZ "Here is your string and the encrypted result:\n"
ENC 	.STRINGZ "<Encrypted> "
DEC 	.STRINGZ "\n<Decrypted> "
EMPT	.STRINGZ "\n"
BYE 	.STRINGZ "Goodbye!"

.END
