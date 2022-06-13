;Ejercicio 5:
;Dado un vector de 20 números almacenados en el formato BPF c/s de 16 bits,
;escriba un programa que calcule el máximo, mínimo y el promedio de los números e
;imprimirlos por pantalla.



global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	vector      dw 1,1,1,1,1,1,1,1,1,1
                dw 1,1,1,1,1,1,1,1,1,100
    cantidad    dw  20
    msgMax      db "El maximo es: %hi.",10,0 
    msgMin      db "El minimo es: %hi.",10,0 
    msgProm     db "El promedio es: %hi y el resto es: %hi.",10,0

section		.bss
    promedio    resw    1
    resto       resw    1
    acumulador  resw    1
    maximo      resw    1
    minimo      resw    1

section		.text
main:
    mov rsi,2
    mov rbx,0
    mov word[acumulador],0
    mov word[promedio],0

    mov bx,[vector]
    mov word[maximo],bx
    mov word[minimo],bx
    add word[acumulador],bx
recorrerVector:
    cmp rsi,40 ;(20 elementos * 2 bytes de cada elemento)
    jge  fin

    mov bx,[vector+rsi]
revisarMaximo:
    cmp bx,[maximo]
    jg swapMaximo
revisarMinimo:
    cmp bx,[minimo]
    jl swapMinimo
sumarAcumulador:
    add word[acumulador],bx
    add rsi,2
    jmp recorrerVector

swapMaximo:
    mov [maximo],bx
    jmp revisarMinimo

swapMinimo:
    mov [minimo],bx
    jmp sumarAcumulador

fin:

    mov rcx,msgMax
    mov rdx,[maximo]
    sub rsp,32
    call    printf
    add rsp,32

    mov rcx,msgMin
    mov rdx,[minimo]
    sub rsp,32
    call    printf
    add rsp,32
    
    mov rax,0
    mov rbx,0
    mov rdx,0

    mov ax,word[acumulador]
    cwd  ;para cosas en 16 bits;
    mov bx,word[cantidad]
    idiv bx

    mov word[promedio],ax
    mov word[resto],dx

    mov rcx,msgProm
    mov rdx,[promedio]
    mov r8,[resto]
    sub rsp,32
    call    printf
    add rsp,32
ret