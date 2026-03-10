#Este es el ejercicio 3 de la practica 4
.data 
	estado: .word 0 #0:Reposo 1:Verde 2:Amarillo 3:Rojo
	pulsador: .word 0 #0:Desactivo 1:Activo
	save: .word 0 #para que $at no se escoñete

	msgRep: .asciiz "\nREPOSO - ESPERANDO"
	msgVer: .asciiz "\nVERDE - AVANCE"
	msgAma: .asciiz "\nAMARILLO - DESACELERE"
	msgRoj: .asciiz "\nROJO - PARE"

.text
.globl main
main:
	#activa el teclado
	la $t0, 0xFFFF0000
	lw $t1, 0($t0)
	ori $t1, $t1, 0x02
	sw $t1, 0($t0)
	
	#Configura Coproc0 status
	mfc0 $a0, $12
	ori $a0, $a0, 0x801
	mtc0 $a0, $12

bucle_estado:
	lw $t0, estado
	
	li $t1, 0
	bne $t0, $t1, verde
	
	la $a0, msgRep
	li $v0, 4
	syscall
esperar:
	lw $t1, pulsador
	beq $t1, 0, esperar
	
	li $t1, 0
	sw $t1, pulsador
	li $t1, 1
	sw $t1, estado
	j bucle_estado
verde:
	bne $t0, 1, amarillo
	
	la $a0, msgVer
	li $v0, 4
	syscall
	
	li $a0, 20000
	jal timer
	li $t1, 2
	sw $t1, estado
	j bucle_estado
amarillo:
	bne $t0, 2, rojo
	
	la $a0, msgAma
	li $v0, 4
	syscall
	
	li $a0, 10000
	jal timer
	li $t1, 3
	sw $t1, estado
	j bucle_estado
rojo:
	la $a0, msgRoj
	li $v0, 4
	syscall
	
	li $a0, 30000
	jal timer
	sw $zero, estado
	j bucle_estado

#Funcion de timer, $a0=Tiempo objetivo
timer:
	move $t8, $a0 #guarda tiempo objetivo
	li $v0, 30
	syscall
	move $t9, $a0
timer_wait:
	li $v0, 30
	syscall
	subu $t7, $a0, $t9
	bltu $t7, $t8, timer_wait
	jr $ra

.ktext 0x80000180
	.set noat
	sw $at, save
	.set at
	
	#si no es una interrupcion del teclado se sale
	mfc0 $k0, $13
	andi $k0, $k0, 0x3c
	bne $k0, $zero, fin_handler
	
	lw $k1, 0xFFFF0004
	andi $k1, $k1, 0xFF
	
	#si el estado no es 0 omite leer 
	la $k0, estado
	lw $k0, 0($k0)
	bne $k0, $zero, fin_handler
	
	#Sí no es 's' se omite
	bne $k1, 115, fin_handler
	
	#marcamos el pulsador como activado
	la $k0, pulsador
	li $k1, 1
	sw $k1, 0($k0)

fin_handler:
	mfc0 $k0, $14 #restaura EPC
	.set noat
	lw $at, save
	eret
	.set at
	
	
