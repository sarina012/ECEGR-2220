#Part 5 - Function Call

.data
A: .word 0
B: .word 0
C: .word 0

.text
main:
	addi t0, zero, 5    #i=5
	addi t1, zero, 10   #j=10
	addi sp, sp, -8
	sw t0, 4(sp)
	sw t1, 0(sp)
	add a0, zero, t0
	jal AddItUp
	sw t1, A, s0
	lw t1, 0(sp)
	add a0, zero, t1
	jal AddItUp
	sw t1, B, s0
	addi sp, sp, 8
	lw t0, A
	lw t1, B
	add t2, t0, t1
	sw t2, C, s0
	li a7,10			
	ecall
	
AddItUp:
	add t0, zero, zero  
	add t1, zero, zero  	
   for:	slt t6, t0, a0
	beq t6, zero, exit
	addi t2, t0, 1
	add t1, t1, t2
	addi t0, t0, 1
	j for

exit:	jalr zero, ra, 0
	