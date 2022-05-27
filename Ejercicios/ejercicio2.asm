;******************************************************
; ejercicio2.asm
; Realizar un programa en assembler Intel x86 que imprima por pantalla la siguiente
; frase: “El alumno [Nombre] [Apellido] de Padrón N° [Padrón] tiene [Edad] años para
; esto se debe solicitar previamente el ingreso por teclado de:
;  Nombre y Apellido
;  N° de Padrón
;  Fecha de nacimiento
; - aprender los comandos de ensamblado y linkedicion
;		nasm -fwin64 pgm.asm 
;       gcc pgm.obj -o pgm
;       pgm
;******************************************************
global	main
extern	gets
extern  printf


section		    .data
    msjNom	    db	'Ingrese nombre o * para finalizar: ',0
    msjApe	    db	'Ingrese apellido o * para finalizar: ',0
    msjPad	    db	'Ingrese padron o * para finalizar: ',0
    msjEdad	    db	'Ingrese edad o * para finalizar: ',0
	msjElAl	    db	'El alumno %s',0
    msjEsp	    db	' %s',0
    msjDePa	    db	' de Padron N %s',0
    msjEda	    db	' tiene %s',0

section         .bss
    textoNom	resb	6
	textoApe	resb	10
    textoPad	resb	10
    textoEdad	resb	10
   
section		.text

main:
    sub rsp,28h
ingTextoNom:
; Ingrese nombre
	mov		rcx,msjNom
	call	printf

	mov		rcx,textoNom	;Parametro 1: direccion del campo donde se copia lo ingresado por teclado
	call	gets		;Lee de teclado hasta el fin de linea (enter) y guarda en formato caracteres 
						;agrega 0 binario como fin de string	
	cmp	byte[textoNom],'*'
	je	fin



; Ingrese apellido

    mov     rcx,msjApe
    call    printf

    mov     rcx, textoApe
    call    gets

    cmp     byte[textoApe],'*'
    je fin


; Ingrese Padron

    mov     rcx,msjPad
    call    printf

    mov     rcx, textoPad
    call    gets

    cmp     byte[textoPad],'*'
    je fin

; Ingrese Edad
    
    mov     rcx,msjEdad
    call    printf

    mov     rcx, textoEdad
    call    gets

    cmp     byte[textoEdad],'*'
    je fin

; Ud ingresó
    mov		rcx,msjElAl
    mov		rdx,textoNom
    call	printf

    mov		rcx,msjEsp
    mov		rdx,textoApe
    call	printf

    mov		rcx,msjDePa
    mov		rdx,textoPad
    call	printf

    mov		rcx,msjEda
    mov		rdx,textoEdad
    call	printf

fin:
    add     rsp,28h
    ret