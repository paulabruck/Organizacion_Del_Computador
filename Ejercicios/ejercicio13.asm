;Ejercicio 13:
;Se tiene una fecha en formato carácter DD/MM/AAAA se pide realizar una rutina
;interna que realice la validación dejando en el campo RESULT de 1 byte una &#39;S&#39; si
;es válida o una &#39;N&#39; en caso contrario.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        fecha       db      "07/07/2010",0
        msgValido   db      "La fecha ingresada es valida.",10,0
        msgInvalido db      "La fecha ingresada no es valida.",10,0
        
        formatoDiayMes  db  '%hi',0
        formatoAnio     db  '%hi',0
        pruebaNum          db  '%hi',10,0
section		.bss
        RESULT  resb    1
        dia     resb    100
        mes     resb    100
        anio    resb    100
        diaNum  resw    1
        mesNum  resw    1
        anioNum resw    1
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

validar:
    mov byte[RESULT],'N'
extraccion:
    mov rcx,2
    lea rsi,[fecha]
    lea rdi,[dia]
    rep movsb

    mov rcx,2
    lea rsi,[fecha+3]
    lea rdi,[mes]
    rep movsb

    mov rcx,4
    lea rsi,[fecha+6]
    lea rdi,[anio]
    rep movsb
conversion:
    mov rcx,dia
    mov rdx,formatoDiayMes
    mov r8,diaNum
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin

    mov rcx,mes
    mov rdx,formatoDiayMes
    mov r8,mesNum
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin

    mov rcx,anio
    mov rdx,formatoAnio
    mov r8,anioNum
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl fin

validacion: ;(estos printf estan para verificar nomas lo que lei)
    mov rcx,pruebaNum
    mov rdx,[diaNum]
    sub rsp,32
    call printf
    add rsp,32

    mov rcx,pruebaNum
    mov rdx,[mesNum]
    sub rsp,32
    call printf
    add rsp,32

    mov rcx,pruebaNum
    mov rdx,[anioNum]
    sub rsp,32
    call printf
    add rsp,32

    cmp word[diaNum],1
    jl fin
    cmp word[diaNum],31
    jg fin

    cmp word[mesNum],1
    jl fin
    cmp word[mesNum],12
    jg fin

    cmp word[anioNum],1
    jl fin
    cmp word[anioNum],2020
    jg fin
valido:
    mov byte[RESULT],'S'
fin:
ret