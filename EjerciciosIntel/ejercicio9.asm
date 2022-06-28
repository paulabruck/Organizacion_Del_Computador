;Ejercicio 9:
;Dada una matriz de 5x5, determinar si dicha matriz es triangular superior y/o inferior
;e imprimir el resultado por pantalla.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
    msgTrianInf     db  "La matriz es triangular inferior.",10,0
    msgTrianSup     db  "La matriz es triangular superior.",10,0
    msgNada         db  "La matriz no es ni triangular inf ni sup.",10,0
	matriz          dw 1,1,1,1,1
                    dw 1,1,1,1,1
                    dw 1,1,1,1,1
                    dw 1,1,1,1,1
                    dw 1,1,1,1,1

    ;matrizSup       dw 1,1,1,1,1
    ;                dw 0,1,1,1,1
    ;                dw 0,0,1,1,1
    ;                dw 0,0,0,1,1
    ;                dw 0,0,0,0,1

    ;matrizInf       dw 1,0,0,0,0
    ;                dw 1,1,0,0,0
    ;                dw 1,1,1,0,0
    ;                dw 1,1,1,1,0
    ;                dw 1,1,1,1,1         

section		.bss

section		.text
main:  
;-------------------------------------------
verTriangularInf:
    mov rsi,2
primerEscalon:
    cmp rsi,10
    jge segundoEscalon

    cmp word[matriz+rsi],1
    jge verTriangularSup

    add rsi,2
    jmp primerEscalon
segundoEscalon:
    mov rsi,14
interacionesSegundo:
    cmp rsi,20
    jge tercerEscalon

    cmp word[matriz+rsi],1
    jge verTriangularSup

    add rsi,2
    jmp interacionesSegundo
tercerEscalon:
    mov rsi,26
interacionesTercero:
    cmp rsi,30
    jge cuartoEscalon

    cmp word[matriz+rsi],1
    jge verTriangularSup

    add rsi,2
    jmp interacionesTercero
cuartoEscalon:
    mov rsi,38
    cmp word[matriz+rsi],1
    jge verTriangularSup

    jmp esTrianInf
;---------------------------------------------------
verTriangularSup:
   mov rsi,10
primerPaso:
    cmp word[matriz+rsi],1
    jge noEsNada
    mov rsi,20
segundoPaso:
    cmp rsi,24
    jge tercerPaso

    cmp word[matriz+rsi],1
    jge noEsNada
    add rsi,2
    jmp segundoPaso
tercerPaso:
    mov rsi,30
interarTercer:
    cmp rsi,36
    jge cuartoPaso

    cmp word[matriz+rsi],1
    jge noEsNada
    add rsi,2
    jmp interarTercer
cuartoPaso:
    mov rsi,40
interarCuarto:
    cmp rsi,48
    jge esTrianSup

    cmp word[matriz+rsi],1
    jge noEsNada
    add rsi,2
    jmp interarCuarto
;--------------------------------------------------
esTrianInf:
    mov rcx,msgTrianInf
    sub rsp,32
    call    printf
    add rsp,32
    jmp fin

esTrianSup:
    mov rcx,msgTrianSup
    sub rsp,32
    call    printf
    add rsp,32
    jmp fin

noEsNada:
    mov rcx,msgNada
    sub rsp,32
    call    printf
    add rsp,32
fin:
ret