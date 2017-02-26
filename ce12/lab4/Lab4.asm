;Annie Shen
;CMPE 12 - Caesar Cipher
;ROW major

.ORIG x3000

TOP
	AND R0,R0,0		;clear all registers
	AND R1,R1,0
	AND R2,R2,0
	AND R3,R3,0
	AND R4,R4,0
	AND R5,R5,0
	AND R6,R6,0
	ST R1,FLAG
	ST R1,CIPHER

	LEA R0,WEL 		;load welcome message into R0
	PUTS
	LEA R0,PROMPT		;ask for E, D, or X
	PUTS

INPUT
<<<<<<< HEAD
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
=======
	GETC
	OUT
	
	;input == LF?
	LD R1,ENTER		;R1 = -10
	ADD R1,R0,R1		;R1 = R0-10
	BRz LF			;if R0 is LF
	
	;input == E?
	LD R1,E 	 	;load value of E(-69) into R1
	ADD R1,R0,R1		;R1 = R0-69
	BRz FLAG_E		;branch to FLAG_E to change FLAG to 1
	
	;input == D?
	LD R1,D 		;load value of D(-68) into R1
	ADD R1,R0,R1 		;R1 = R0-68
	BRz FLAG_D 		;branch to FLAG_D to change FLAG to -1
	
	;input == X?
	LD R1,X			;load value of X(-88) into R1
	ADD R1,R0,R1		;R1 = R0-88
	BRz INPUT		;if input is "X", let FLAG remain 0
	BRnp TOP		;branch to TOP to restart if input was invaild
>>>>>>> f3dd0ae0be2d07f3cc5a32fe1d8902bbaa81ee26

FLAG_E
	LD R1,FLAG		;laod value of FLAG(0) into R1
	ADD R1,R1,1 		;R1 = R1+1 = 1
	ST R1,FLAG		;store value of R1 into FLAG
	BRnzp INPUT

FLAG_D
<<<<<<< HEAD
	LD R1,FLAG			;laod value of FLAG(0) into R1
	ADD R1,R1,-1 		;R1 = R1-1 = -1
	ST R1,FLAG			;store value of R1 into FLAG
	BRnzp INPUT			;branch back to INPUT
=======
	LD R1,FLAG		;laod value of FLAG(0) into R1
	ADD R1,R1,1 		;R1 = R1+1 = 1
	NOT R1,R1		;R1 = !R1 -> = -1
	ST R1,FLAG		;store value of R1 into FLAG
	BRnzp INPUT
>>>>>>> f3dd0ae0be2d07f3cc5a32fe1d8902bbaa81ee26

LF
	LD R1, FLAG 		;load value of FLAG into R1
	BRz EXIT		;if FLAG==0, meaning user entered "X" to exit
	
	LEA R0,ASKCI		;load PROMPT into R1
	PUTS			;print out asking for cipher

CIPH
	GETC
	OUT
	LD R1,ENTER		;load value of LF into R1
	ADD R1,R0,R1		;R1 = R0-10
	BRz STRINGQ		;if R0 is LF
	
	LD R1, NEGZERO		;R1 = -48
	ADD R1,R0,R1		;R1 = R0-48 to get actual digit
	AND R2,R2,0		;clear R2
	ADD R2,R2,10		;for C_CALC -> R2 = 10 = counter
	LD R3,CIPHER		;for C_CALC -> load value of CIPHER into R3

C_CALC
	ADD R4,R4,R3		;R4 = R4 + R3(INT)
	ADD R2,R2,-1		;counter decrement by 1
	BRp C_CALC		;keep looping until counter goes to 0
	ADD R4,R4,R1		;CIPHER*10 + current digit
	ST R4,CIPHER
	AND R4,R4,0
	BRnzp CIPH

STRINGQ
	AND R1,R1,0		;clear registers
	AND R2,R2,0
	AND R3,R3,0
	LEA R2,ARRAY		;R2 = 1st address of ARRAY
	LEA R0,ASKSTR		;"What's the string?"
	PUTS

STRING
	GETC
	PUTC
	
	LD R1,ENTER
	ADD R1,R0,R1
	BRz DONE	;TESTING;if input is LF
	
	JSR STORE	;subroutine to STORE
	ADD R2,R2,1	;move to next ARRAY memory location
	ADD R3,R3,1	;character input counter
	BRnzp STRING

DONE
	LD R0,EMPT
	OUT
	BRnzp TOP		;Head to label TOP and ask for E/D/X again

EXIT
	LEA R0,BYE
	PUTS


HALT

;Variables
<<<<<<< HEAD
E 		.FILL #-69
D 		.FILL #-68
X 		.FILL #-88
FLAG	.FILL #0
CIPHER	.FILL #0
=======
ENTER	.FILL #-10		;ASCII value of LF
E 	.FILL #-69
D 	.FILL #-68
X 	.FILL #-88
FLAG	.FILL #0
ONE	.FILL #49
CIPHER	.FILL #0
INT	.FILL #0
NEGZERO	.FILL #-48
>>>>>>> f3dd0ae0be2d07f3cc5a32fe1d8902bbaa81ee26
NEGA	.FILL #-65
NEGZ	.FILL #-90
NEGa 	.FILL #-97
NEGz 	.FILL #-122
<<<<<<< HEAD
ARRAY	.BLKW 400
WEL		.STRINGZ "Welcome to Annie's Caesar Cipher program\n"
PROMPT	.STRINGZ "Do you want to (E)ncrypt, (D)ecrypt, or (E)xit?\n"
ASKCI	.STRINGZ "What is the cipher(1-25)?\n"
ASK		.STRINGZ "What is the string(200 characters max)?\n"
RESD	.STRINGZ "Here is your string and the decrypted result:\n"
RESE	.STRINGZ "Here is your string and the encrypted result:\n"
ENC 	.STRINGZ "<Encrypted> "
DEC 	.STRINGZ "\n<Decrypted> "
=======
R0SAVE	.FILL #0
R1SAVE	.FILL #0
R2SAVE	.FILL #0
R3SAVE	.FILL #0
R4SAVE	.FILL #0
R5SAVE	.FILL #0
R6SAVE	.FILL #0
R7SAVE	.FILL #0
WEL	.STRINGZ "Welcome to my Caesar Cipher program\n"
PROMPT	.STRINGZ "Do you want to (E)ncrypt, (D)ecrypt, or e(X)it?\n"
ASKCI	.STRINGZ "What's the cipher(1-25)?\n"
ASKSTR	.STRINGZ "What's the string(200 characters max)?\n"
;RESD 	.STRINGZ "Here is your string and the result:\n"
;ENC 	.STRINGZ "<Encrypted> "
;DEC 	.STRINGZ "\n<Decrypted> "
>>>>>>> f3dd0ae0be2d07f3cc5a32fe1d8902bbaa81ee26
EMPT	.STRINGZ "\n"
BYE 	.STRINGZ "Goodbye!"

;Subroutines
;---------------------------------------------------------------------

;take byte of data and store into array
STORE
	ST R0,ROSAVE
	RET

;loads a byte of data from array
LOAD


;takes a character and cipher as input and return the encrypted value
ENCRYPT
	ST R0,R0SAVE
	ST R1,R0SAVE
	ST R2,R0SAVE
	ST R3,R0SAVE
	ST R4,R0SAVE
	ST R5,R0SAVE
	ST R6,R0SAVE
	ST R7,R0SAVE
	


	RET

;takes a encrypted character and cipher as input and return the decrypted value
DECRYPT


;prints the array out
PRINT_ARRAY


;---------------------------------------------------------------------

ARRAY	.BLKW 400

.END
