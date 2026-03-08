#Este es el segundo ejercicio de la practica 3
.data
	PresionControl: .word 0
	PresionEstado: .word 0
	PresionDatos: .word 0
	ErrMsg: .asciiz "Hubo un error en la lectura"
.text
main:
	jal LeerPresion
	
	move $a0, $v0
	move $a1, $v1
	
	bne $a1, $zero, main_error
	
	li $v0, 1
	syscall
	j main_exit
main_error:
	la $a0, ErrMsg
	li $v0, 4
	syscall
	
main_exit:
	li $v0, 10
	syscall


InicializarSensorPresion:
	la $t0, PresionControl
	li $t1, 0x5
	sw $t1, 0($t0)
	jr $ra

LeerPresion:
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	jal InicializarSensorPresion
	li $t9, 0 #inicializamos el contador de reintentos
while:
	la $t0, PresionEstado
	lw $t1, 0($t0)
	
	#Si la lectura está disponible lo lee
	li $t2, 1
	beq $t1, $t2, Exito
	
	#Si es 0, vuelve a intentar
	li $t2, -1
	bne $t1, $t2, while
	
	#Si es -1, ve si ya ha habido un intento, si es así termina en Error
	bne $t9, $zero, Error
	
	#Si es la primera vez que falló suma uno y reinicia el sensor
	addi $t9, $t9, 1
	jal InicializarSensorPresion
	j while
	
Exito:
	la $t0, PresionDatos
	lw $v0, 0($t0)
	li $v1, 0
	j Exit
Error:
	li $v0, -1
	li $v1, -1
Exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	
	