.data
	arr: .word 1, 4, 8, 9, 2, 12, 3, 32, 2, 5, 22, 6, 5, 7
	space: .asciiz " "
.text
	la $a0, arr #Carga el array
	li $a1, 14 #n tamaño del array
	
	jal insertion
	
	move $a2, $a1
	la $a1, arr
	jal print
	
	li $v0, 10
	syscall
insertion:
	li $t0, 1 # i
for1:
	beq $t0, $a1, exitfor1 #if i==n get out
	
	move $t1, $t0 # j=i
	
	sll $t9, $t1, 2
	add $t9, $t9, $a0
	lw $t2, 0($t9) #aux = arr[j]
	
while1:
	ble $t1, 0, exitwhile1 #if j <= 0
	
	addi $t8, $t1, -1 #j-1
	sll $t9, $t8, 2
	add $t9, $t9, $a0
	lw $t3, 0($t9) #arr[j-1]
	
	bge $t2, $t3, exitwhile1
	
	sll $t9, $t1, 2
	add $t9, $t9, $a0
	sw $t3, 0($t9)
	
	addi $t1, $t1, -1
	j while1
exitwhile1:
	sll $t9, $t1, 2
	add $t9, $t9, $a0
	sw $t2, 0($t9)
	
	addi $t0, $t0, 1
	j for1
exitfor1:
	jr $ra
	
print:
	li $t0, 0
for2:
	beq $t0, $a2, exitfor2
	
	lw $a0, 0($a1)
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall

	addi $t0, $t0, 1
	addi $a1, $a1, 4
	j for2
exitfor2:	
	jr $ra
