; 1		2	 3	 4	 5	 6	 7	 8	 9	 10
; *
; *
; *
; *
;
;
;		*
;		*
;		*
;		*
;
;
;							
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;

global 	main
extern 	printf
extern	gets
extern 	sscanf
extern	fopen
extern	fread
extern	fclose

section .data
	fileName	db	"FICHAS.DAT",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

	registro  	times 0 db ""
		file  		db 0
		columna 	db 0
		sentido		db ""

	chequeoSTR db 	"ABDI"

	matriz  	times 300 db ""
	msgColPerfecta  	db "La columna %hi esta llena de fichas"

section .bss
	validezRegistro	resq
	idArchivo 		resq
	iteracion 		resq
	posicionActualMatriz 	resq

section .text
main:
	mov 	rdi,fileName
	mov  	rsi,mode 
	call 	fopen

	mov  	[idArchivo],rax

	cmp  	rax,0
	jg  	leerRegistro

errorApertura:
	mov  	rdi,msgErrOpen
	sub  	rax,rax
	call 	printf
	jmp  	cierroArchivo

leerRegistro:
	mov  	rdi,registro
	mov   	rsi,3
	mov  	rdx,1
	mov 	rcx,[idArchivo]
	call  	freads
	cmp  	rax,0
	jle  	eof

	call    VALCAL

	mov  	rbx,[validezRegistro]
	cmp  	rbx,"N"
	je   	leerRegistro ;chequeo invalido asi q voy a leer otro reg

	mov  	bl,[columna]
	sub 	bl,1
	mov 	al,[fila]
	sub 	al,1
	mul  	al,10 ;10 es la cantidad de columnas

	add  	rax,rbx

	mov  	rcx,4
posicionActualMatriz
escriboAsterisco:
	mov  	byte[matriz + rax],"*"

	cmp  	byte[sentido],"A"
	je  	dirArriba

	cmp  	byte[sentido],"B"
	je  	dirAbajo

	cmp  	byte[sentido],"D"
	je  	dirDerecha

	cmp  	byte[sentido],"I"
	je  	dirIzquierda

sigoEscribiendo:
	cmp  	rax,0
	jl  	leerRegistro

	cmp  	rax,300
	jg  	leerRegistro
	
	loop  	escriboAsterisco

	jmp  	leerRegistro  ;Finalizo la copia de este registro

dirArriba:
	add  	rax,10;se mueve una fil hacia abajo
	jmp  	sigoEscribiendo

dirAbajo:
	sub  	rax,10
	jmp  	sigoEscribiendo

dirDerecha:
	add  	rax,1
	jmp  	sigoEscribiendo

dirIzquierda:
	sub  	rax,1
	jmp  	sigoEscribiendo

VALCAL:

	mov  	al,[fila]
	cmp   	al,1
	jl   	errorValcal
	cmp  	al,30
	jg  	errorValcal

	mov  	al,[columna]
	cmp   	al,1
	jl   	errorValcal
	cmp  	al,10
	jg  	errorValcal

	mov  	rcx,4
	mov  	rax,0

checkstr:
	lea   	rsi,[chequeoSTR + rax]
	lea  	rdi,[sentido]
	mov  	[iteracion],rcx
	mov   	rcx,1
	repe 	cmpsb
	je 		strvalida

	mov   	rcx,[iteracion]
	inc  	rax
	loop 	checkstr

	jmp   	errorValcal
	ret

errorValcal:
	mov		byte[validezRegistro],"N"
	ret

strvalida:
	mov		byte[validezRegistro],"S"
	ret

eof:
	mov 	rcx,10


	mov  	[iteracion],rcx

	mov  	rbx,[iteracion]
chequeandoColumna:
	mov  	rcx,1
	lea  	rsi,[matriz + rbx]
	lea     rdx,"*"
	jne  	columnaNoPerfecta

	add  	rbx,10
	cmp  	rbx,300
	jg  	columnaPerfecta

	jmp  	chequeandoColumna


columnaPerfecta:
	mov  	rdi,msgColPerfecta
	mov   	rsi,[iteracion]
	sub  	rax,rax
	call  	printf
columnaNoPerfecta:
	mov  	rcx,[iteracion]
	loop 
	ret