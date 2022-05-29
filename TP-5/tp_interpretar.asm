global 	main
extern 	printf
extern	gets
extern puts
extern sscanf

section .data
    msgBienvenida               db  "~~Bienvenido al interprete de Binario de Punto Flotante IEEE 754 de precision simple~~", 0
    msgContinuacion             db  "~~A continuacion ingrese el numero que corresponde a la accion desea realizar~~", 0
    msgOpcion1                  db  "(1) Obtener notacion cientifica normalizada en base 2 de un numero almacenado en BPFlotante IEEE 754", 0
    msgOpcion2                  db  "(2) Obtener configuracion binaria o hexadecimal de un numero almacenado en BPFlotante IEEE 754", 0
    msgSubOpcion1               db  "~~Ingresar configuracion a interpretar~~",0
    msgSubOpcion11              db  "(1) Binaria",0
    msgSubOpcion12              db  "(2) Hexadecimal",0
    msgIngConf                  db  "~~Ingrese segun configuracion elegida~~",0     
    msgSubOpcion2               db  "~~Ingresar notacion cientifica a interpretar~~",0
    msgConfSelec                db  "~~Ingresar configuracion a visualizar~~",0
    mensajeErrorOpcion  	    db  "@@ La opcion ingresada no es valida, por favor verifique de ingresar una valida @@",0
    msgenter                    db  " ",0
    posicion                    dq  1
    vectorHexa                  db  "0123456789ABCDEF"
    vectorBina                  db  "10"
    numeroFormato               db  '%lli',0

section .bss
    opcionIngresada     resb 1
    opcion              resb 1
    datoValido		    resb 1
    vector              times 16 resb 1
   
    buffer  		    resb 1

section .text

main:

;----------------------------------------------------------------------;
; Brinda opciones al usuario para poder definir la accion a realizar   ;
;----------------------------------------------------------------------;
menu:
    mov  	rcx,msgBienvenida
	call 	puts

    mov  	rcx,msgContinuacion
	call 	puts

    mov  	rcx,msgOpcion1
	call 	puts

    mov  	rcx,msgOpcion2
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf
	
	cmp		rax,1
	jl		errorIngresoOpcion
    
	call 	validarOpcion

    cmp		word[opcion],1
    je      caso1

    cmp		word[opcion],2
    je      caso2

errorIngresoOpcion:
	mov 	rcx,mensajeErrorOpcion
	call 	puts

    mov     rcx,msgenter
    call    puts

    jmp     menu

finIngresoOpcion:
ret

;-----------------------------------------------------------;
; Valida si la opcion ingresada por el usuario es válida    ;
;-----------------------------------------------------------;
validarOpcion:

	cmp		word[opcion],1
	jl		errorIngresoOpcion
    

	cmp		word[opcion],2
	jg		errorIngresoOpcion

    ret
validarBinario:
    mov rcx, numeroFormato
    mov rdx, [opcion]
    call printf
   
    ;mov rdx,0
    ;mov rcx,[opcion]
    ;mov [vector+rdx],rcx
    ;mov r9,numeroFormato
    ;mov r8,[vector+rdx]
   
   

    ret
caso1:
    mov  	rcx,msgSubOpcion1
	call 	puts

    mov  	rcx,msgSubOpcion11
	call 	puts

    mov  	rcx,msgSubOpcion12
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf


	cmp		rax,1
	jl		errorIngresoOpcion

	call 	validarOpcion
   
    mov  	rcx,msgIngConf
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf

    cmp		rax,1
	jl		errorIngresoOpcion
    call    validarBinario
    jmp     finIngresoOpcion

caso2:
    mov  	rcx,msgSubOpcion2
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf


	cmp		rax,1
	jl		errorIngresoOpcion

    mov  	rcx,msgConfSelec
	call 	puts

    mov  	rcx,msgSubOpcion11
	call 	puts

    mov  	rcx,msgSubOpcion12
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf


	cmp		rax,1
	jl		errorIngresoOpcion

    call    validarOpcion
	