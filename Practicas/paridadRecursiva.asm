.data
	msg1: .asciiz "Es par\n"
	msg2: .asciiz "Es impar\n"
.text
main:
	#get n
	li $v0, 5
	syscall
	move $a0, $v0
	
	#llamada a la funcion recursiva
	jal par
	
	#carga el return de par
	move $a0, $v0
	
	#if 0:par 1:impar
	beqz $a0, ifpar
	
	#if impar carga msg2
	la $a0, msg2
	j exit
ifpar:
	#if par carga msg1
	la $a0, msg1
exit:
	#imprime si es par o impar
	li $v0, 4
	syscall
	
	#sale
	li $v0, 10
	syscall	
par:
	#guarda valores originales
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#if n==0
	beqz $a0, if0
	
	#par(n-1)
	addi $a0, $a0, -1
	jal par
	
	#carga valores originales
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	#1-par(n-1)
	mul $v0, $v0, -1
	addi $v0, $v0, 1
	
	#return
	jr $ra
if0:
	#if n==0 -> return 0
	li $v0, 0
	addi $sp, $sp, 4
	jr $ra
	
