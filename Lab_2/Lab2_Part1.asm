#Part 1 - Arithmetic

.data   
A: .word 15
B: .word 10
C: .word 5
D: .word 2
E: .word 18
F: .word -3
Z: .word 0
 
.text
main:	lw a0, A
	lw a1, B
	lw a2, C
	lw a3, D
	lw a4, E
	lw a5, F
	lw a6, Z

	sub t1, a0, a1  #(A-B) 
	mul t2, a2, a3  #(C*D)
	sub t3, a4, a5  #(E-F)
	div t4, a0, a2  #(A/C)

	add t5, t1, t2  # (A-B) + (C*D)
	add t6, t5, t3  # (A-B) + (C*D) + (E-F)
	sub a6, t6, t4  # (A-B) + (C*D) + (E-F) - (A/C)

	sw a6, Z, t0


