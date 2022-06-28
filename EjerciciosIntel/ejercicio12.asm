;Ejercicio 12:
;Realizar una rutina interna que reciba como parámetro un campo MES en formato
;BPF c/s de 8 bits y devuelva en un campo resultado RESULT en formato carácter de
;1 byte, indicando una ‘S’ en caso que el valor del mes sea válido, y en caso
;contrario una ‘N’.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        msgValido   db      "El mes ingresado es valido.",10,0
        msgInvalido db      "El mes ingresado no es valido.",10,0
        mes         db      1
section		.bss
        RESULT  resb    1

section		.text
main:  
    call validar

    cmp byte[RESULT],'S'
    je mensajeValido

    mov rcx,msgInvalido
    sub rsp,32
    call    printf
    add rsp,32
    jmp fin

mensajeValido:
    mov rcx,msgValido
    sub rsp,32
    call    printf
    add rsp,32
fin:
ret

validar:
    mov byte[RESULT],'N'
    
    cmp byte[mes],1
    jl  fin
    cmp byte[mes],12
    jg  fin
diaValido:
    mov byte[RESULT],'S'
final:
ret