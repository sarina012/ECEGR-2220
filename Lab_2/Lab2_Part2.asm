#Part 2 - Branches

.data 
A: .word 10
B: .word 15 
C: .word 6
Z: .word 0 

.text
main: 
	lw a1, A
	lw a2, B
	lw a3, C
	lw a4, Z
	addi tp, zero, 5
	slt s0, a1, a2  	#A < B 
	slt s1, tp, a3 		#5 < C 
	and s2, s0, s1
	beq s2, zero, elseIf 	#if(A<B && C>5) 
	addi a4, zero, 1 	#Z = 1 
	j exit
	
elseIf: slt a0, a2, a1 		#B < A
	addi t0, a3, 1 		#C+1 
	addi t1, t0, 7 		#(C+1)=7 
	beq a3, zero, check
	bne a5, zero, check
	addi a4, zero, 3 
	j exit
	
check:	addi a4, zero, 2 
	j exit 

exit:	addi sp, zero, 1
	addi gp, zero, 2
	addi tp, zero, 3
	beq  a4, sp, case1
	beq  a4, gp, case2
	beq  a4,tp, case3
	addi a3, zero, 0 
	j leave
	
case1: addi a4, zero, -1
	j leave
case2: addi a4, zero, -2
	j leave
case3: addi a4, zero, -3
	j leave

leave: 	sw a4, Z, t6
