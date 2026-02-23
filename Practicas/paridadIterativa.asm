.data
	msg1: .asciiz "Es par\n"
	msg2: .asciiz "Es impar\n"
.text
main:
	#get n
	li $v0, 5
	syscall
	move $a0, $v0
	
	li $t0, 0 #i
	li $a1, 1 #if 1:par if -1:impar
	#llamada a la funcion iterativa
	jal par
	
	#carga el return de par
	move $a0, $v0
	
	#if 1:par -1:impar
	beq $a0, 1, ifpar
	
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
	#condicion de salida i=n
	beq $t0, $a0, exitpar
	
	#Cambia de signo 1:par -1:impar
	mul $a1, $a1, -1
	
	#i++
	addi $t0, $t0, 1
	j par
exitpar:
	#return 1:par or -1:impar
	move $v0, $a1
	jr $ra