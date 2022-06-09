#Part 3 - Loops

.data
Z: .word 2
i: .word 0

.text
main:	lw a0, Z
  	lw a1, i      
  	
for:    slti a2, a1, 21       	
    	addi a1, a1, 2 		
    	beq a2, zero, do   	
    	addi a0, a0, 1        	
    	j for

do:	addi a0, a0, 1       	
   	slti a2, a0, 100    	
   	beq a2, zero, while    	
   	j do
   
while:	addi a3, zero, 0    
    	slt a2, a3, t1      
    	beq a2, zero, end   
    	addi a0, a0, -1    
    	addi a1, a1, -1  
    	j while

end: 	sw a0, Z, a5        
    	sw a1, i, a6      
    	