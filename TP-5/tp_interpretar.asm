global 	main
extern 	printf
extern	gets
extern puts
extern sscanf

section .data
    msgBienvenida     db  "~~Bienvenido al interprete de Binario de Punto Flotante IEEE 754 de precision simple~~", 0
    msgContinuacion     db  "~~A continuacion ingrese el numero que corresponde a la accion desea realizar~~", 0
    msgOpcion1     db  "(1) Obtener notacion cientifica normalizada en base 2 de un numero almacenado en BPFlotante IEEE 754", 0
    msgOpcion2    db  "(2) Obtener configuracion binaria o hexadecimal de un numero almacenado en BPFlotante IEEE 754", 0
    msgSubOpcion1   db  "~~Ingresar configuracion a interpretar~~",0
    msgSubOpcion11   db  "(1) Binaria",0
    msgSubOpcion12   db  "(2) Hexadecimal",0
    msgSubOpcion2   db  "~~Ingresar notacion cientifica a interpretar~~",0
    msgSubOpcion20  db "~~Ingresar configuracion a visualizar~~",0
    mensajeErrorCantidad	    db  				'Numero no valido.',10,0
    numeroFormato   db					'%hi',0

section .bss
    opcionIngresada resb 1
    opcion          resb 1
    datoValido					resb	1
    buffer  		resb 	1

section .text

main:

menu:
    mov  	rcx,msgBienvenida
	call 	puts

    mov  	rcx,msgContinuacion
	call 	puts

    mov  	rcx,msgOpcion1
	call 	puts

    mov  	rcx,msgOpcion2
	call 	puts

    mov rcx,opcionIngresada
    call gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp		rax,1
	jl		errorIngresoCantidad

	call 	validarCantidad
	;cmp		byte[datoValido],'N'
	;je		errorIngresoCantidad

	jmp 	finIngresoCantidad

errorIngresoCantidad:
	mov 	rcx,mensajeErrorCantidad
	sub 	rsp,32
	call 	printf
	add 	rsp,32
	jmp 	menu
finIngresoCantidad:
ret

;------------------------------------------------------
;   Valida si la cantidad ingresada por el usuario es válida
;------------------------------------------------------
validarCantidad:
	mov		byte[datoValido],'N'

	cmp		word[opcion],1
	jl		errorIngresoCantidad;finValidarCantidad

	cmp		word[opcion],2
	jg		errorIngresoCantidad;finValidarCantidad

	mov		byte[datoValido],'S'

finValidarCantidad:
ret
