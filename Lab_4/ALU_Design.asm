
.data
.text
main:	li t0, 0x01234567
	li t1, 0x11223344

	#add
	add a0, t0, t1
	#sub
	sub a1,t0,t1 
	#and
	and a2,t0,t1 
	#or 
	or a3,t0,t1
	#Shift right by one 	
	li t1,1 
	srl a4, t0, t1
	#Shift Right by two 
	li t1,2
	srl a5, t0, t1
	#shift right by three
	li, t1, 3
	srl a6, t0, t1 
	#shift left by one 
	li t1, 1
	sll a7, t0,t1 
	#shift left by two
	li t1, 2
	sll s2, t0,t1 
	#shift left by three
	li, t1, 3
	sll s3,t0,t1 

	#Immediates
	#addi
	addi s4,t2,0x00000011
	#and
	andi s5, t2,0x00000011
	#ori 
	ori s6, t2,0x00000011
	#shift right by one i 
	srli s7, t2, 1
	#shift right by two 
	srli s8, t2,2
	#sift right by three
	srli s9, t2,3
	#shift left by one
	slli s10, t2, 1
	#shift left by two 
	slli s11, t2,2
	#shift left by three 
	slli t3,t2,3
	li t0,0x00458945
	li t1,0x00458945
	sub t4,t0,t1