#Este es el primer ejercicio de la practica 3
.data
	LuzControl: .word 0
	LuzEstado: .word 0
	LuzDatos: .word 0
	ErrMsg: .asciiz "Hubo un error en la lectura"
.text
main:
	jal LeerLuminosidad
	
	move $a0, $v0
	move $a1, $v1
	
	bne $a1, $zero, main_error #si no es igual a 0 es un codigo de error
	
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

#Procedimiento InicializarSensorLuz
InicializarSensorLuz:
	la $t0, LuzControl
	li $t1, 0x1
	sw $t1, 0($t0)
	
	la $t0, LuzEstado
Esperar:
	lw $t1, 0($t0)
	beq $t1, $zero, Esperar
	jr $ra
#Fin del procedimiento

#Procedimiento de LeerLuminosidad 
LeerLuminosidad:
	#Se inicia el sensor y al regresar se restura $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal InicializarSensorLuz
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	#Comprueba en tiempo real el estado del sensor
	la $t0, LuzEstado
	lw $t1, 0($t0)
	
	li $t2, -1
	beq $t1, $t2, Error #LuzEstado es -1 si hubo un error
	
	#no hubo error
	la $t0, LuzDatos
	lw $v0, 0($t0)
	li $v1, 0
	jr $ra
Error:
	li $v0, -1
	li $v1, -1
	jr $ra
#Fin del procedimiento
	
	
	