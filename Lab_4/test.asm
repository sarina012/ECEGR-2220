#ALU Program 

#data section 
.data 
.text 

main:
#li a1, 3
#jal FibSequence
#add t1, zero, t0

#li a1, 10
#jal FibSequence
#add t2, zero, t0

	li a1, 20
	jal FibSequence
	add s0, zero, t0
j End 

# n is represented by register a1 
FibSequence:
	li t5, 1
	blez a1, If 
	beq a1, t5, ElseIf 

	# storing onto stack from the registers 
	addi sp, sp, -4
	sw ra, 0(sp)  # holds the return address of sp 
	addi sp, sp, -4 
	sw a1, 0(sp) # holds current value 

	addi a1, a1, -1 

	jal FibSequence
	
	add a2, zero, t0 

#restoring from stack to registers
	lw a1, 0(sp) 
	addi sp, sp, 4
	lw ra, 0(sp)
	addi sp, sp, 4

# storing information from the stack 
	addi sp, sp, -4
	sw ra, 0(sp)
	addi sp, sp, -4
	sw a1, 0(sp)
	addi sp, sp, -4
	sw a2, 0(sp)

	addi a1, a1, -2

	jal FibSequence

	add a3, zero, t0

	lw a2, 0(sp)
	addi sp, sp, 4
	lw a4 0(sp)
	addi sp, sp, 4
	lw ra, 0(sp)
	addi sp, sp, 4

	add t0, a2, a3
	ret

If:	addi t0, zero, 0
	ret 

ElseIf:	addi t0, zero, 1
	ret

End: 	li a7, 10
	ecall