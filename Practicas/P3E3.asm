#Este es el tercer ejercicio de la practica 3
.data
	TensionControl: .word 0
	TensionEstado: .word 0
	TensionSistol: .word 0
	TensionDiastol: .word 0
	Space: .asciiz " "	
.text
main:
	jal controlador_tension
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	la $a0, Space
	li $v0, 4
	syscall
	
	move $a0, $v1
	li $v0, 1
	syscall
main_exit:
	li $v0, 10
	syscall

controlador_tension:
	la $t0, TensionControl
	li $t1, 1
	sw $t1, 0($t0)
	
	la $t0, TensionEstado
bucle_medicion:
	lw $t1, 0($t0)
	
	li $t2, 1
	beq $t1, $t2, Exito
	j bucle_medicion
Exito:
	la $t0, TensionSistol
	la $t1, TensionDiastol
	lw $v0, 0($t0)
	lw $v1, 0($t1)
	jr $ra

	
	