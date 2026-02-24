.data
	arr: .word 1, 4, 8, 9, 2, 12, 3, 32, 2, 5, 22, 6, 5, 7
	space: .asciiz " "
.text
	la $a0, arr #array
	li $a1, 14 #n
	li $a2, 0 #m
	addi $a1, $a1, -1 #n-1
	
	jal quicksort
	
	#preludio para printear
	la $a3, arr
	li $a1, 0 #i 
	li $a2, 14 #n
	jal print
	
	li $v0, 10
	syscall
	
quicksort:
	#Si ($a2 >= $a1) ignora if
	bge $a2, $a1, continue1
	#guarda los datos
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)	
if1:
	#get pi on $v0
	jal particion
	
	#pi-1 on $a1=alto
	move $t8, $v0
	lw $a0, 0($sp)
    	lw $a2, 8($sp)
    	addi $a1, $t8, -1
	sw $t8, 16($sp)
	
	
   	jal quicksort
	
	lw $a0, 0($sp)
    	lw $t8, 16($sp)    
    	addi $a2, $t8, 1
    	lw $a1, 4($sp)
    	jal quicksort
		
	lw $ra, 12($sp)
	addi $sp $sp, 20
continue1:	
	jr $ra
		
particion:
	#$t1 = arr[n]
	sll $t0, $a1, 2
	add $t0, $t0, $a0
	lw $t1, 0($t0)
	
	#t2 = m-1 = i
	addi $t2, $a2, -1
	
	#$t4 = m = j
	move $t4, $a2
for1:
	bge $t4, $a1, continue2
	
	#$t3 = arr[j]
	sll $t5, $t4, 2
	add $t5, $t5, $a0
	lw $t3, 0($t5)
	
	bgt $t3, $t1, ifnot1
	addi $t2, $t2, 1
	
	#$t7 = arr[i]
	sll $t6, $t2, 2
	add $t6, $t6, $a0
	lw $t7, 0($t6)
	
	#swap
	sw $t3, 0($t6)
	sw $t7, 0($t5)
ifnot1:
	addi $t4, $t4, 1
	j for1
continue2:
	addi $t2, $t2, 1
	
	#$s0 = arr[i+1]
	sll $t5, $t2, 2
	add $t5, $t5, $a0
	lw $t7, 0($t5)
	
	#swap
	sw $t1, 0($t5)
	sw $t7, 0($t0)
	
	move $v0, $t2
	jr $ra

print:
	bge $a1, $a2, endprint
	
	lw $a0, 0($a3)
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	addi $a1, $a1, 1
	addi $a3, $a3, 4
	j print
	 
endprint:
	jr $ra
