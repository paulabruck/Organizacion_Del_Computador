;Ejercicio 11:
;Realizar una rutina interna que reciba como parámetro un campo DIA en formato de
;caracteres de 2 bytes y devuelva en un campo resultado RESULT en formato
;carácter de 1 byte, indicando una ‘S’ en caso que el día sea válido, y en caso
;contrario una ‘N’.
;Los valores válidos son LU, MA, MI, JU, VI, SA, DO.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        DIA      db         "DO"  
        dias     db         "DOLUMAMIJUVISA"
        msgValido   db      "El dia ingresado es valido.",10,0
        msgInvalido db      "El dia ingresado no es valido.",10,0
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
    mov rcx,7
    mov rsi,0
    mov rbx,0
ciclo:
    mov r10,rcx ;me lo guardo
    mov rcx,2
    lea rsi,[DIA]
    lea rdi,[dias+rbx]
    repe cmpsb
    mov rcx,r10 ;Lo Recupero

    je diaValido
    add rbx,2
    loop ciclo

    jmp final
diaValido:
    mov byte[RESULT],'S'
final:
ret