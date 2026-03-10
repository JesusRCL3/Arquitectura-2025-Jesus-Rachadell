#Este es el ejercicio 1 de la practica 4
.data
	buffer: .space 100
	pos: .word 0
	save: .word 0
	msgReady: .asciiz "\nBuffer Actual: "
	
.text
.globl main
main:
	# Habilita la entrada de teclado
	li $t0, 0xFFFF0000
	lw $t1, 0($t0)
	ori $t1, $t1, 0x02
	sw $t1, 0($t0)
	# Configuracion del coproc0
	mfc0 $a0, $12
	ori $a0, $a0, 0x801
	mtc0 $a0, $12

bucle_principal:
	li $v0, 30
	syscall
	move $s0, $a0

espera:
	li $v0, 30
	syscall
	subu $t2, $a0, $s0
	blt $t2, 20000, espera
	
	la $a0, msgReady
	li $v0, 4
	syscall
	
	jal printAndVoid
	j bucle_principal

#Imprima los 100 caracteres y limpia el buffer
printAndVoid:	
	li $t1, 0 #i
	li $t2, 100 #n
bucle_print:
	beq $t1, $t2, fin_print
	la $t0, buffer
	addu $t0, $t0, $t1
	lb $a0, 0($t0)
	li $v0, 11
	syscall
	sb $zero, 0($t0)
	addiu $t1, $t1, 1
	j bucle_print
fin_print:
	la $t3, pos
	sw $zero, 0($t3) #reinicia pos
	jr $ra
	
.ktext 0x80000180
	.set noat
	sw $at, save
	.set at
	
	mfc0 $k0, $13 #lee que interrupcion fue
	andi $k0, $k0, 0x3C
	bne $k0, $zero, fin_handler
	
	lw $k1, 0xFFFF0004
	blt $k1, 65, fin_handler
	bgt $k1, 90, fin_handler
	
	la $k0, pos
	lw $k0, 0($k0)
	
	la $k1, buffer
	add $k1, $k1, $k0 #buffer[pos]
	
	lw $k0, 0xFFFF0004
	sb $k0, 0($k1) #guardamos el caracter
	
	la $k0, pos
	lw $k1, 0($k0)
	addiu $k1, $k1, 1
	
	li $k0, 100
	bne $k1, $k0, save_pos
	li $k1, 0
save_pos:
	la $k0, pos
	sw $k1, 0($k0)

fin_handler:
	mfc0 $k0, $14
	.set noat
	lw $at, save
	eret
	.set at

	
	
