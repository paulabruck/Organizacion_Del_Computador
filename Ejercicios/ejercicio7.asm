;Ejercicio 7:
;Dada una matriz de 3x3 de números almacenados en BPF c/s de 16 bits, calcule la
;traza e imprimirla por pantalla.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	matriz      dw 4,1,1
                dw 1,4,1
                dw 1,1,4
    msgMax      db "La traza es de: %hi.",10,0          

section		.bss
    traza   resw    1

section		.text
main:  
    mov word[traza],0

    mov rax,0

    mov ax,[matriz]
    add [traza],ax

    mov ax,[matriz+8]
    add [traza],ax

    mov ax,[matriz+16]
    add [traza],ax    

    mov rcx,msgMax
    mov rdx,[traza]
    sub rsp,32
    call    printf
    add rsp,32
ret