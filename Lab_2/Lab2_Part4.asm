#Part 4 - Arrays

.data
A: .word 0, 0, 0, 0, 0  # int A[5] 
B: .word 1, 2, 4, 8, 16 # int B[5] 

.text
main:	add	t0, zero, zero	
	addi	t1, zero, 5	
	la	t5, A		
	la	t6, B		

for:	bge	t0, t1, while 	
	slli	t3, t0, 2	
	add	t2, t3, t6	
	lw	t2, (t2)	
	addi	t2, t2, -1	
	add	t4, t3, t5	
	sw	t2, (t4)	
	addi	t0, t0, 1	
	j	for		

while:	addi	t0, t0, -1
	blez	t0, exit
	slli	t3, t0, 2	
	add	t2, t3, t6	
	lw	t2, (t2)	
	add	t4, t3, t5	
	lw	t1, (t4)	
	add	t2, t2, t1	
	add	t2, t2, t2	
	
	sw 	t2, (t4)
	j	while
exit:
