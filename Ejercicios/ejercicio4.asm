;Ejercicio 4:
;Escribir un programa que lea 15 números ingresados por teclado. Se pide imprimir
;dichos números en forma decreciente.


global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	vector		        times 15 dq 1
    msjIngreso          db      "Ingrese un numero:",0
    formatInput         db      "%lli",0
    formatoNumeros      db      "->%lli",0

section		.bss
    inputNumeros        resb 50
    numero              resq 1

section		.text
main:
    mov rsi,0

ingreso: 
    cmp rsi,40
    jge  ordenamiento

	mov		rcx,msjIngreso	
    sub     rsp, 32        
	call	printf					
	add     rsp, 32

    mov     rcx,inputNumeros
    sub     rsp,32
    call    gets
    add     rsp,32

    mov rcx,inputNumeros
    mov rdx,formatInput
    mov r8,numero
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl ingreso

    mov rdi,[numero]
    mov [vector+rsi],rdi

    add rsi,8

    jmp ingreso

ordenamiento:
    mov rsi,0
    mov rdi,0

primerfor:
    cmp rsi,32
    jge  fin

segundofor:
    cmp rdi,32 ;(cada numero = 8 bits * (cant(5) - 1))
    jge  reiniciarJ

    mov r9,[vector+rdi]
    mov r10,[vector+rdi+8]

    cmp r9,r10
    jl  swap ;jl de mayor a menor, jg de menor a mayor

    jmp incrementarIndice
swap:
    mov [vector+rdi],r10
    mov [vector+rdi+8],r9
incrementarIndice:
    add rdi,8
    jmp segundofor

reiniciarJ:
    mov rdi,0
    add rsi,8
    jmp primerfor

fin:
    mov rsi,0

printearNumeros:
    cmp rsi,40
    jge  vectorPrinteado

    mov rcx,formatoNumeros
    mov rdx,[vector+rsi]
    sub rsp,32
    call    printf
    add rsp,32

    add rsi,8
    jmp printearNumeros
vectorPrinteado:
ret