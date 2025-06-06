.data
mensaje: .asciiz "Hola Mundo"

.text
main:
    li $v0, 4
    la $a0, mensaje
    syscall

    li $v0, 10
    syscall