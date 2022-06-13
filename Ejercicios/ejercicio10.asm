;Ejercicio 10:
;Realizar una rutina interna que reciba como parámetro un campo PACK en formato
;de Decimal Empaquetado de 2 bytes y devuelva en un campo RESULT en formato
;carácter de 1 byte, indicando una ‘S’ en caso que sea un empaquetado válido, y en
;caso contrario una ‘N’.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        pack        db      "132A"
        msgValido   db      "El empaquetado ingresado es valido.",10,0
        msgInvalido db      "El empaquetado ingresado no es valido.",10,0
        
        formatonumeros  db  '%hi'
        formatoLetra    db  '%c'
        pruebaNum          db  '%hi',10,0
section		.bss
        RESULT          resb    1
        num             resb    10
        letra           resb    10  
        numNum          resw    1
        letraString     resw    1

section		.text
main: 
    call validar
    cmp byte[RESULT],'S'
    je mensajeValido

    mov rcx,msgInvalido
    sub rsp,32
    call    printf
    add rsp,32
    jmp final

mensajeValido:
    mov rcx,msgValido
    sub rsp,32
    call    printf
    add rsp,32
final:
ret
;--------------------------------------------
validar:
    mov byte[RESULT],'N'
extraccion:
    mov rcx,3
    lea rsi,[pack]
    lea rdi,[num]
    rep movsb

    mov rcx,2
    lea rsi,[pack+3]
    lea rdi,[letra]
    rep movsb
conversion:
    mov rcx,num
    mov rdx,formatonumeros
    mov r8,numNum
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin

    mov rcx,letra
    mov rdx,formatoLetra
    mov r8,letraString
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin
validacion:
    cmp word[numNum],0
    jl fin
    cmp word[numNum],999
    jg fin

    cmp word[letraString],'A'
    jl fin
    cmp word[letraString],'F'
    jg fin
valido:
    mov byte[RESULT],'S'
fin:
ret