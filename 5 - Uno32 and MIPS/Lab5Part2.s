# Annie Shen
# ashen7@ucsc.edu
# CMPE 12/L - Lab5
# Section 1D - TA: Maxwell Lichtenstein
# Introduction to Uno32 and MIPS - Part 2
    
#include<WProgram.h>
#include<xc.h>

#.global main
.text
.set noreorder

.ent main
main:
    /* this code blocks sets up the ability to print, do not alter it */
    ADDIU $v0,$zero,1
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)
    
    /* your code goes underneath this */
    LA $a0,HelloWorld
    JAL puts
    NOP
    
    # ---------------------------------------------------------------- #
    
    LI $t1, 0b111100000000 # set 1 as the switches bits(8-11) as we only care about those 
    SW $t1, TRISD	   # store t1 into TrisD. Set as input
    LI $t1, 0
    SW $t1, TRISE	   # set as output
    LI $t2, 0b1
    
    # have LED go from left to right (LD1 to LD7), branch to myDelay
    # in between LEDs to waste time, and then branch to Right
    Left:
	SW $t2, PORTE	   # t2 = switch input
	SLL $t2, $t2, 1	   # shift 1 to the left
	LW $a0, PORTD	   # a0 = switch output. ($a0 = for function calls)
	JAL myDelay	   # branch to myDelay to waste time before moving on 
	NOP

	LI $t3, 0b10000000 # set t3 as the last LED light
	BEQ $t2, $t3, Right# branch to Right once t2 got to last LED
	NOP
	B Left		   # repeat Left itself to move on to the next LED
	NOP
	
    # LED go from right to left (LD7 to LD1), branch to myDelay in
    # between LEDs to waste time, and then branch to Left
    Right:
	SW $t2, PORTE	   # t2 = swtich input
	SRL $t2, $t2, 1	   # shift 1 to the right
	LW $a0, PORTD	   # store t2 to output
	JAL myDelay	   # waste time
	NOP
	
	LI $t3, 0b1
	BEQ $t2, $t3, Left # branch to Left
	NOP
	B Right		   # repeat itself
	NOP
	
    # myDelay function: read the value of 4 switches. On or off to speed up or down
    myDelay:
	SRL $a0, $a0, 8	   # shift 8 to the right
        ANDI $a0, $a0, 0b1111  # AND with 0b1111 to clear out the random numbers in front of $a0
        ADDI $a0, $a0, 1   # Add 1 to a0, it's not multiplying 0 when all switches are off
	LI $t4, 11111	   # base delay counter
	LI $t5, 0
	MUL $t4, $t4, $a0  # multiply counter base on switches on/off
    
	Loop:
	    SUB $t4, $t4, 1# decrement counter by 1
	    BGTZ $t4, Loop # branch back to Loop if t4 > 0
	    NOP
	    JR $ra	   # reach here when t4==0. Jump back to where myDelay was called using $ra
	    NOP
	
hmm:    J hmm
    NOP
endProgram:
    J endProgram
    NOP
.end main


.data
HelloWorld: .asciiz "Assembly Hello World \n"

