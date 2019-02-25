;Annie Shen
;CMPE 12 - Caesar Cipher
;ROW major
;Decrypt start at ARRAY memory location 1, ends at 200.
;Encrypt start at 201, ends at 400

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
	GETC
	OUT
	
	;input == LF?
	LD R1,ENTER		;R1 = -10
	ADD R1,R0,R1		;R1 = R0-10
	BRz LF			;if R0 is LF
	
	;input == D?
	LD R1,D 		;load value of D(-68) into R1
	ADD R1,R0,R1 		;R1 = R0-68
	BRz FLAG_D 		;branch to FLAG_D to change FLAG to 1

	;input == E?
	LD R1,E 	 	;load value of E(-69) into R1
	ADD R1,R0,R1		;R1 = R0-69
	BRz FLAG_E		;branch to FLAG_E to change FLAG to -1
	
	;input == X?
	LD R1,X			;load value of X(-88) into R1
	ADD R1,R0,R1		;R1 = R0-88
	BRz INPUT		;if input is "X", let FLAG remain 0
	BRnp TOP		;branch to TOP to restart if input was invaild

FLAG_D
	LD R1,FLAG		;laod value of FLAG(0) into R1
	ADD R1,R1,1 		;R1 = R1+1 = 1
	ST R1,FLAG		;store value of R1 into FLAG
	BRnzp INPUT


FLAG_E
	LD R1,FLAG		;laod value of FLAG(0) into R1
	ADD R1,R1,1 	;R1 = R1+1 = 1
	NOT R1,R1		;R1 = !R1 -> = -1
	ST R1,FLAG		;store value of R1 into FLAG
	BRnzp INPUT

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
	AND R1,R1,0			;clear registers
	AND R2,R2,0
	AND R3,R3,0
	AND R4,R4,0
	LEA R2,ARRAY		;R1 = 1st address of ARRAY
	LEA R0,ASKSTR		;"What's the string?"
	PUTS

STRING
	GETC			;getting user input string
	OUT
	
	LD R1,ENTER
	ADD R1,R0,R1
	BRz NULL		;if input == LF, branch to add NULL at end of string & print results
	
	LD R1,FLAG
	ADD R1,R1,1
	BRnp DE			;if R1+1 = positive -> Decryption
	BRz EN			;if R1+1 = zero -> Encryption

DE
	JSR DECRYPT
	ADD R2,R2,1		;move to next ARRAY memory location
	ADD R3,R3,1		;character input counter
	BRnzp STRING

EN
	JSR ENCRYPT
	ADD R2,R2,1		;move to next ARRAY memory location
	ADD R3,R3,1		;character input counter
	BRnzp STRING

NULL
	LEA R2

RESULT
	LD R0,RESD		;"Here is your string and the result: "
	PUTS
	JSR PRINT_ARRAY	;subroutine -> print out dec and enc messages

DONE
	LD R0,EMPT
	OUT
	JSR CLEAR_ARRAY	;Resets all memory in ARRAY
	BRnzp TOP		;Head to label TOP and ask for E/D/X again

EXIT
	LEA R0,BYE
	PUTS


HALT

;Variables
ENTER	.FILL #-10		;ASCII value of LF
E 		.FILL #-69
D 		.FILL #-68
X 		.FILL #-88
FLAG	.FILL #0
ONE		.FILL #49
CIPHER	.FILL #0
NEGZERO	.FILL #-48
UPPA	.FILL #-65
UPPZ	.FILL #-90
LOWA 	.FILL #-97
LOWZ 	.FILL #-122
EN_INDEX.FILL #200		;Encrypted part of the array starts at location 201
TOTAL	.FILL #400
R0SAVE	.FILL #0		;for subroutines
R1SAVE	.FILL #0
R2SAVE	.FILL #0
R3SAVE	.FILL #0
R4SAVE	.FILL #0
R5SAVE	.FILL #0
R6SAVE	.FILL #0
R7SAVE	.FILL #0
WEL		.STRINGZ "Welcome to my Caesar Cipher program\n"
PROMPT	.STRINGZ "Do you want to (E)ncrypt, (D)ecrypt, or e(X)it?\n"
ASKCI	.STRINGZ "What's the cipher(1-25)?\n"
ASKSTR	.STRINGZ "What's the string(200 characters max)?\n"
RESD 	.STRINGZ "Here is your string and the result:\n"
DEC 	.STRINGZ "<Decrypted> "
ENC 	.STRINGZ "<Encrypted> "
EMPT	.STRINGZ "\n"
BYE 	.STRINGZ "Goodbye!"

;Subroutines
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;take byte of data and store into array-----------------------------
STORE
	ST R0,ROSAVE
	ST R1,ROSAVE
	ST R2,ROSAVE	;ARRAY mem location
	ST R3,ROSAVE	;chara counter



	LD R0,ROSAVE
	LD R1,ROSAVE
	LD R2,ROSAVE
	LD R3,ROSAVE
	RET
;end STORE----------------------------------------------------------


;loads a byte of data from array------------------------------------
LOAD


	RET
;end LOAD-----------------------------------------------------------


;takes a chara and cipher as input & return the enc. value----------
ENCRYPT
	ST R0,R0SAVE
	ST R1,R0SAVE
	ST R2,R0SAVE	;ARRAy mem location
	ST R3,R0SAVE	;character input counter
	ST R4,R0SAVE
	ST R5,R0SAVE
	ST R6,R0SAVE













	LD R0,R0SAVE
	LD R1,R0SAVE
	LD R2,R0SAVE
	LD R3,R0SAVE
	LD R4,R0SAVE
	LD R5,R0SAVE
	LD R6,R0SAVE
	RET
;end ENCRYPT----------------------------------------------------------


;takes a enc. chara and cipher as input & return the dec.-------------
DECRYPT
	ST R0,R0SAVE
	ST R1,R0SAVE
	ST R2,R0SAVE
	ST R3,R0SAVE
	ST R4,R0SAVE
	ST R5,R0SAVE
	ST R6,R0SAVE
















	LD R0,R0SAVE
	LD R1,R0SAVE
	LD R2,R0SAVE
	LD R3,R0SAVE
	LD R4,R0SAVE
	LD R5,R0SAVE
	LD R6,R0SAVE
	RET

;end DECRYPT----------------------------------------------------------


;prints the array out-------------------------------------------------
PRINT_ARRAY
	LEA R0,DEC 			;"<Decrypted> "
	PUTS				
	LEA R0,ARRAY 		;load ARRAY pointer to front. which is the start of dec message
	PUTS				;PUTS will print until reaches NULL

	LEA R0,EMPT 		;"\n"
	PUTS

	LEA R0,ENC 			;"<Encrypted> "
	PUTS
	LEA R0,ARRAY 		;reload to point to beginning
	LD R2,EN_INDEX		;R2 = 200
	ADD R0,R0,R2 		;R0 = 1(1st mem location) + 200 = 201 <-start of enc message
	PUTS				;print from mem location 201 until reaches NULL

	RET
;end PRINT_ARRAY------------------------------------------------------


;reset array to empty state-------------------------------------------
CLEAR_ARRAY
	LD R1, TOTAL		;R1 = 400. Counter for label RESET
	AND R2,R2,0			;clear R2
RESET
	LEA R3,ARRAY 		;load ARRAY pointer to front
	STR R2,R3,0			;store R=0 into current mem location of R2
	ADD R3,R3,1			;move R3 point to next mem location
	ADD R1,R1,-1		;decrement counter
	BRp RESET

	RET
;end CLEAR_ARRAY------------------------------------------------------
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

ARRAY	.BLKW 400

.END
