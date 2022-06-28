;******************************************************
; ejercicio3.asm
; Realizar un programa que resuelva X^Y teniendo en cuenta que tanto X e Y pueden
; ser positivos o negativos.
; - aprender los comandos de ensamblado y linkedicion
;		nasm -fwin64 pgm.asm 
;       gcc pgm.obj -o pgm
;       pgm
;******************************************************

global main
extern puts
extern printf
extern sscanf
extern gets

section .data
    mensaje1 db "Ingrese la base: ",0
    mensaje2 db "Ingrese el exponente: ",0
    mensaje3 db "El resultado es: %li",10,0
    mensaje4 db "Ingresaste la base: %li y exponente: %lli",10,0
    mensaje5 db "El resultado es: 1/ %li",10,0
    format  db "%lli",0 ;El formato %lli es de 64 bits = 8 bytes
  

section .bss
    base_text resb 10
    exponente_text resb 10
    base_num    resq 1 ;la reserva de base y exponente es de 8 bytes porque tiene que ser la misma que el formato
    exponente_num   resq 1

section .text
main:
    sub rsp,8

Ingreso_base:

    mov rcx,mensaje1
 
    call printf

    mov rcx,base_text
    call gets

    mov rcx,base_text
    mov rdx,format
    mov r8,base_num

    call sscanf

    cmp rax,1
    jl Ingreso_base

Ingreso_exponente:

    mov rcx,mensaje2
    sub rax,rax
    call printf

    mov rcx,exponente_text
    call gets

    mov rcx,exponente_text
    mov rdx,format
    mov r8,exponente_num
    
    call sscanf

    cmp rax,1
    jl Ingreso_exponente

;Calculo de resultado:

    mov rcx,mensaje4
    mov rdx,[base_num]
    mov r8,[exponente_num]
    call printf

    cmp qword[exponente_num],0
    je  exponente_0

    mov rbx,[base_num] ;cargo en el registro rbx la base

    jg  exponente_positivo
    jl  exponente_negativo

exponente_0:
    mov rbx,1

    mov rcx,mensaje3

    call fin

exponente_positivo:
    imul rbx,qword[base_num]
    dec qword[exponente_num]
    cmp qword[exponente_num],1
    jg  exponente_positivo

    mov rcx,mensaje3

    call fin

exponente_negativo:
    imul rbx,qword[base_num]
    inc qword[exponente_num]
    cmp qword[exponente_num],-1
    jl  exponente_negativo

    mov rcx,mensaje5

    call fin

fin:
    mov rcx,rcx
    mov rdx,rbx

    call printf

    add rsp,8

ret