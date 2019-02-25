# Annie Shen
# ashen7@ucsc.edu
# CMPE 12/L - Lab5
# Section 1D - TA: Maxwell Lichtenstein
# Introduction to Uno32 and MIPS - Part 1
    
#include<WProgram.h>
#include<xc.h>

.global main
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
    
    # TrisD: reset all to input
    LI $t1, 0xFFFF  # set t1 = 0xFFFF
    SW $t1, TRISD   # store t1(0xFFFF) into TrisD 
    
    # TrisE: reset all to output
    LI $t1, 0	    # set t1 = 0
    SW $t1, TRISE   # store t1 into TrisF
    
    # TrisF: for 1st button
    LI $t1, 0b10    # set t1 = 0b10
    SW $t1, TRISF   # store t1 into TrisF

Loop:
    # Switches: 8-11 bits
    LW $t1, PORTD   # load value of PortD into t1. The inputted value
    ANDI $t1,$t1, 0b111100000000 # perform mask
    SRL $t1,$t1,8   # shift 8 to the right
    
    # Buttons(2,3,4): 5-7 bits
    LW $t2, PORTD   # load PortD value into t2
    ANDI $t2,$t2, 0b11100000 # perform mask
		    # no need for shifting

    # for button 1 at PortF
    LW $t3, PORTF   # load PortF value into t3
    ANDI $t4,$t3, 0b10 # perform mask
    SLL $t4,$t4,3   # shift 3 to the left
    
    # combine switches and buttons
    OR $t1,$t1,$t2
    OR $t1,$t1,$t4
    SW $t1, PORTE   # store t1 into PortE
    JAL Loop	    # Loop forever
    NOP
    
hmm:    J hmm
    NOP
endProgram:
    J endProgram
    NOP
    
.end main
    

.data
HelloWorld: .asciiz "Assembly Hello World \n"

