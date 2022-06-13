;Ejercicio 14:
;Realizar una rutina interna que reciba como parámetros las direcciones (DIR1 y
;DIR2) de dos campos hexadecimales de 2 bytes de longitud cada uno y realice la
;suma de ambos (en BPF s/signo de 16 bits) dejando el resultado en el campo
;resultado RESULT en formato BPF c/s 16 bits.


global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
section		.data
        DIR1                dw      0Bh
        DIR2                dw      0Bh
        formatonumero       db      '%hi'
        msgResultado        db      'El Resultado es:%hi',10,0
    
section		.bss
        RESULT  resw    1
    
section		.text
main:  
    mov word[RESULT],0
    call sumar

    mov rcx,msgResultado
    mov rdx,[RESULT]
    sub rsp,32
    call    printf
    add rsp,32
fin:
ret

sumar:
    mov rax,0
    mov rbx,0

    mov ax,[DIR1]
    mov bx,[DIR2]
    add ax,bx
    
    mov word[RESULT],ax
    
final:
ret