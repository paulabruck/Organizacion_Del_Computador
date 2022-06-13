;Ejercicio 6:
;Dado un vector de 30 números decimales (positivos/negativos) se pide escribir un
;programa que invierta el vector, es decir, el último elemento queda en el primer
;lugar, el anteúltimo en el segundo, etc.



global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	
    vecNum			dq	100,-200,32767,40,1979,2,7,50,24,-42,2,2,7,5,8,6,4,2,5,2,5,75,82,64,95,68,57,52,35,10			
    formatoNumeros      db      "->%lli",0

section		.bss
    

section		.text
main:
    mov rsi,0
    mov rdi,232

swap:
    cmp rsi,120
    jge  fin

    mov rdx,[vecNum+rsi]
    mov rcx,[vecNum+rdi]

    mov [vecNum+rdi],rdx
    mov [vecNum+rsi],rcx

    add rsi,8
    sub rdi,8

    jmp swap
fin:
    mov rsi,0

printearNumeros:
    cmp rsi,232 ;(bytes por elemento (8) * (cant elementos (20) - 1))
    jg  vectorPrinteado

    mov rcx,formatoNumeros
    mov rdx,[vecNum+rsi]
    sub rsp,32
    call    printf
    add rsp,32

    add rsi,8
    jmp printearNumeros

vectorPrinteado:
ret