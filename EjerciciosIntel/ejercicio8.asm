;Ejercicio 8:
;Dada una matriz de 4x4 de números almacenados en BPF c/s de 16 bits, calcule la
;diagonal inversa e imprimirla por pantalla.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
	matriz      dw 1,1,1,4
                dw 1,1,4,1
                dw 1,4,1,1
                dw 4,1,1,1

    msgMax      db "La diagonal inversa es: %hi.",10,0          

section		.bss
    traza   resw    1

section		.text
main:  
    mov word[traza],0

    mov rax,0

    mov ax,[matriz+6]
    add [traza],ax

    mov ax,[matriz+12]
    add [traza],ax

    mov ax,[matriz+18]
    add [traza],ax  

    mov ax,[matriz+24]
    add [traza],ax  

    mov rcx,msgMax
    mov rdx,[traza]
    sub rsp,32
    call    printf
    add rsp,32
ret