;Se cuenta con un archivo en formato binario llamado ENCUESTA.DAT que contiene
;información de las respuestas de una encuesta que consultaba a empleados de 10
;compañías cuál es el recurso más importante que el empleador debía pagar para
;facilitar el trabajo remoto y daba para elegir 4 opciones (Internet, Computadora, Silla,
;Luz). Cada registro del archivo representa la respuesta de un empleado y contiene la
;siguiente información:
; Código de recurso: 2 bytes en formato ASCII (IN, CO, SI, LU)
; Código de compañía: 1 byte en formato binario punto fijo sin signo (1 a 10)
;Se pide realizar un programa en assembler Intel que:
;1. Lea el archivo y por cada registro llene una matriz (M) de 4x10 donde cada fila
;representa a un recurso y cada columna una compañía.  Cada elemento de M es
;un binario de punto fijo sin signo de 2 bytes y representa la sumatoria de
;respuestas para cada recurso en cada compañía; 
;2. Validar los datos del registro mediante una rutina interna (VALREG) para que
;puedan ser descartados los inválidos.
;3. Padrón PAR: ingresar por teclado un código de recurso e informar por pantalla la
;compañía que más lo eligió y que % representa del total.  Padrón IMPAR:
;ingresar por teclado un código de compañía e informar por pantalla el recurso
;con mayor cantidad de votos y que % representa del total.
;-----------------COMPANIA-------------------
;|      0   1   2   3   4   5   6   7   8   9
;|  IN  -
;R  CO
;E  SI
;C  LU
;U
;R
;S
;O

global 	main
extern 	printf
extern  gets
extern  sscanf
extern  puts

section  		.data

    ; Definiciones del archivo binario
	fileName	db	"ENCUESTAS.dat",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

    ; Registro del archivo
	registro	times 0 	db ""
	recurso		times 2		db " "
	codComp					db 0

    matriz      times 40    dw 0
    vecRecu     db  "INCOSILU",0
    msgIngrese  db "Ingrese el codigo de la compania (numero entre 1 y 10):",0
    msgMayorVotos db "El recurso con mayor votos es: (1= IN , 2=CO ,3=SI ,4=LU )",0
    msgCantVotos db "Cantidad de votos:",0
    msgPorcentaje db "Porcentaje que representa sobre el total:",0
    numFormat	db	'%i'	;%i 32 bits / %lli 64 bits

section  		.bss

    fileHandle	resq	1
    recuBin     resb    1
    codIng		resq	1
    buffer      resb	10
section 		.text
main:
    call    abrirArchivo
    
    cmp		qword[fileHandle],0				;Error en apertura?
	jle		errorOpen

    call    leerArchivo
    call    mostrar

ret

abrirArchivo:                       ;Abro archivo para lectura
    
	mov		rcx,fileName			;Parametro 1: dir nombre del archivo
	mov		rdx,mode				;Parametro 2: dir string modo de apertura
	sub		rsp,32
	call	fopen					;ABRE el archivo y deja el handle en RAX
	add		rsp,32

	mov		qword[fileHandle],rax
ret

errorOpen:
    mov		rcx, msgErrOpen
	sub		rsp,32
	call	printf
	add		rsp,32

    jmp		endProg

leerArchivo:
leerRegistro:
	mov		rcx,registro				;Parametro 1: dir area de memoria donde se copia
	mov		rdx,3						;Parametro 2: longitud del registro
	mov		r8,1						;Parametro 3: cantidad de registros
	mov		r9,qword[fileHandle]		;Parametro 4: handle del archivo
	sub		rsp,32
	call	fread						;LEO registro. Devuelve en rax la cantidad de bytes leidos
	add		rsp,32

	cmp		rax,0				        ;Fin de archivo?
	jle		eof

    call    VALREG
    
    cmp     byte[esValid],'S'
    jne     leerRegistro

    call    actualizarMatriz

    jmp     leerRegistro

eof:                                ;Cierro archivo cuando llega a fin del archivo
	
	mov		rcx,qword[fileHandle]	;Parametro 1: handle del archivo
	sub		rsp,32
	call	fclose
	add		rsp,32
ret

VALREG:
validarRecu:
    mov     byte[esValid],'S'
    mov     rbx,0
    mov     rax,0
evaluoRecu:
    cmp     rax,4
    je      esInvalido

    inc     rax

    lea		rsi,[recurso]
    lea     rdi,[vecRecu + rbx]
    rep     cmpsb
    je      finValidarRecu 
    
    add     rbx,2 ; aumento 2 bytes al rbx, asi leo el proximo codigo del vector 
    jmp     evaluoRecu
finValidarRecu:
    mov     byte[recuBin],rax ; paso el codigo en bianrio a una variable
validarCompania:
    cmp     byte[codComp],1
    jl      esInvalido
    cmp     byte[codComp],10
    jg      esInvalido
ret

esInvalido:
    mov     rcx,msgInvalido
    add     rsp, 32
    call    puts
    sub     rsp,32

    mov     byte[esValid],'N'
ret

actualizarMatriz:
    ; deplazamiento de una matriz
	; (col - 1) * L + (fil - 1) * L * cant. cols
	; [Deplaz. Cols] + [Desplaz. Filas]
    
    sub		byte[codComp],1				;Resto a [codComp] 1 para hacer el desplaz. columnas
    mov		al,byte[codComp]

    mov		bl,2
    mul     bl

    mov		rdx,rax

    sub		byte[recuBin],1
    mov		al,byte[recuBin]

    mov		bl,20
    mul     bl

    add		rax,rdx

    mov		bx,word[matriz + rax]	;obtengo la cantidad de votos del recurso en la matriz
	inc		bx						;sumar 1
	mov		word[matriz + rax],bx	;volver a actualizar la cantidad del dia en la matriz
ret

mostrar:
ingresoCompania:
    mov		rcx,msgIngrese		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    mov		rcx,buffer			;Parametro 1: direccion de memoria del campo donde se guarda lo ingresado
	sub		rsp,32
	call	gets				;Lee de teclado y lo guarda como string hasta que se ingresa fin de linea . Agrega un 0 binario al final
	add		rsp,32

    mov		rcx,buffer		    ;Parametro 1: campo donde están los datos a leer
	mov		rdx,numFormat	    ;Parametro 2: dir del string q contiene los formatos
    mov		r8,codIng		;Parametro 3: dir del campo que recibirá el dato formateado
	sub		rsp,32
	call	sscanf
	add		rsp,32

    cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		ingresoCompania

    cmp		qword[codIng],1
	jl		ingresoCompania
	cmp		qword[codIng],10
	jg		ingresoCompania

    sub		qword[codIng],1 ; columna osea empresa
    mov		al,qword[codIng]

    mov		bl,2
    mul     bl

    mov		rdx,rax ;columna a usar
    mov     qword[contador],0
recorroColumna:
    cmp     qword[contador],3
    je      imprimo
   
    mov		bx,word[matriz + rdx]
    cmp     bx,qword[aux]
    jg      swapRecu

continuo:
    inc     qword[contador]
    add     rdx,20
    jmp     recorroColumna

imprimo:
    mov		rcx,msgMayorVotos		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    inc     qword[contador]
    mov		rcx,qword[contador]		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    mov		rcx,msgCantVotos		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    mov		rcx,qword[aux]	;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

porcentaje:
    mov     rax,0
totalVotos:
    cmp     rax,80
    je      imprimoPorcentaje

    mov     bx,[matriz + rax]
    mov     qword[total],bx

    add     rax, 2

    jmp     totalVotos
imprimoPorcentaje:
    mov     r8,100
    mov     r9,qword[aux]
    imul    r8,r9

    mov     rax,r8 
    sub     rdx,rdx
    idiv    qword[total] 

    mov		rcx,msgPorcentaje		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    mov		rcx,rax		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32
ret
swapRecu:
    mov     qword[aux],bx
    mov     rsi, qword[contador]
    mov     qword[aux2],rsi
    jmp     continuo

endProg:	
ret
;--------------------------------NUEVA VERSION QUE COMPILA---------------------------------------------;

/*
global 	main
extern 	printf
extern	gets
extern 	sscanf
extern	fopen
extern	fread
extern	fclose
extern  puts


section  .data
	; Definiciones del archivo binario
	fileName	db	"ENCUESTA.dat",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

	; Registro del archivo
	registro	times 0 	db ""
	recurso			times 2		db " "
	codigo					db 0

	; Matriz
	matriz		times 40	dw  0

	vecRecu		db	"INCOSILU"

	msgCodigo	db	'Ingrese codigo de empresa [1..10]: ',10,13,0 ;10: \n 13: \r (retorno de carro)

	numFormat	db	'%i',0	;%i 32 bits / %lli 64 bits
	stringF		db	'%s',0
	
	msgEnc		db	'Dia      - Cant.Act',10,13,0

	diasImp		db	"Internet      ",0
				db	"Computadora   ",0
				db  "Silla         ",0
				db  "Luz           ",0
			
	msgCant		db	'%lli',10,13,0
    aux         dq  0
    aux2        dq  0
	total		dq	0
	msgPorcentaje	db "Representa un :",0
    msgMayorVotos   db "Mayor Votos Recurso:",0
    msgCantVotos    db "Con:",0
section  .bss

	fileHandle	resq	1
	esValid		resb	1
	contador    resq    1
	diabin		resb	1
	nroIng		resd	1
	
	buffer      resb	10
	
section .text
main:
	call	abrirArch

	cmp		qword[fileHandle],0				;Error en apertura?
	jle		errorOpen

	call	leerArch
	call	listar
		
endProg:
	
	ret
	
errorOpen:
    mov		rcx, msgErrOpen
	sub		rsp,32
	call	printf
	add		rsp,32

    jmp		endProg

abrirArch:
	;	Abro archivo para lectura
	mov		rcx,fileName			;Parametro 1: dir nombre del archivo
	mov		rdx,mode				;Parametro 2: dir string modo de apertura
	sub		rsp,32
	call	fopen					;ABRE el archivo y deja el handle en RAX
	add		rsp,32

	mov		qword[fileHandle],rax

	ret

leerArch:

leerReg:
	mov		rcx,registro				;Parametro 1: dir area de memoria donde se copia
	mov		rdx,3						;Parametro 2: longitud del registro
	mov		r8,1						;Parametro 3: cantidad de registros
	mov		r9,qword[fileHandle]		;Parametro 4: handle del archivo
	sub		rsp,32
	call	fread						;LEO registro. Devuelve en rax la cantidad de bytes leidos
	add		rsp,32

	cmp		rax,0				        ;Fin de archivo?
	jle		eof

	call	VALCAL

	cmp		byte[esValid],'S'
	jne		leerReg

	; Actualizar la actividad leida del archivo en la matriz
	call	sumarAct

	jmp		leerReg

eof:
	;	Cierro archivo cuando llega a fin del archivo
	mov		rcx,qword[fileHandle]	;Parametro 1: handle del archivo
	sub		rsp,32
	call	fclose
	add		rsp,32

	ret

VALCAL:
	mov     rbx,0                       ;Utilizo rbx como puntero al vector vecRecu
	mov		rcx,4						;4 días por codigo
	mov     rax,0                       ;recurso convertido en número
compDia:
	inc     rax
	mov		qword[contador],rcx			;Resguardo el rcx en [contador] porque se va usar para cmpsb
	mov		rcx,2
	lea		rsi,[recurso]
	lea		rdi,[vecRecu + rbx]
	repe	cmpsb
	mov		rcx,qword[contador]			;Recupero el rcx para el loop

	je		diaValido
	add		rbx,2						;Avanzo en el vector vecRecu

	loop	compDia
	; Se ha finalizado el ciclo de iteraciones de todos los valores del vector vecRecu
	jmp     invalido

diaValido:
	mov		byte[diabin],al				;Paso el recurso en binario a una variable [diabin]
	cmp		byte[codigo],1
	jl		invalido
	cmp		byte[codigo],10
	jg		invalido

valido:
	mov		byte[esValid],'S'			;Devuelve S en la variable esValid si es un reg válido

finValidar:
	ret

invalido:
    mov		byte[esValid],'N'			;Devuelve N en la variable esValid si no es un reg válido
	jmp		finValidar

sumarAct:
	; deplazamiento de una matriz
	; (col - 1) * L + (fil - 1) * L * cant. cols
	; [Deplaz. Cols] + [Desplaz. Filas]

	mov		rax,0
	mov		rbx,0

	sub		byte[codigo],1				;Resto a [codigo] 1 para hacer el desplaz. columnas
    mov		al,byte[codigo]				;Copio el recurso en binario ([codigo]) al reg AL
										;en rax va tener la columna de la matriz de [0..6]
	
	mov		bl,2			            ;muevo al bl 2 como multiplicador
    mul		bl				            ;multiplico (col x 2) desplaz. cols. resultado en ax

	mov		rdx,rax			            ;copio a rdx el desplaz.cols

	sub		byte[diabin],1	            ;Resto a diabin 1 para hacer el desplaz. filas
	mov		al,byte[diabin]             ; recuBin seria 

    mov		bl,20			;muevo al bl 20 como multiplicando (cant.cols x long.elem = 20)
	mul		bl				;resultado de la multip. en ax

	add		rax,rdx			;sumo ambos desplaz.

	mov		bx,word[matriz + rax]	;obtengo la cantidad de actividades del recurso en la matriz
	inc		bx						;sumar 1
	mov		word[matriz + rax],bx	;volver a actualizar la cantidad del recurso en la matriz
    mov		bx,word[matriz + rax]		; recupero la cantidad total de votos en el recurso de la matriz

	ret

listar:

ingresoSemana:
	mov		rcx,msgCodigo		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

	mov		rcx,buffer			;Parametro 1: direccion de memoria del campo donde se guarda lo ingresado
	sub		rsp,32
	call	gets				;Lee de teclado y lo guarda como string hasta que se ingresa fin de linea . Agrega un 0 binario al final
	add		rsp,32

	mov		rcx,buffer		    ;Parametro 1: campo donde están los datos a leer
	mov		rdx,numFormat	    ;Parametro 2: dir del string q contiene los formatos
    mov		r8,nroIng		    ;Parametro 3: dir del campo que recibirá el dato formateado
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		ingresoSemana

	;valido que el nro ingresado sea [1..10]
	cmp		dword[nroIng],1
	jl		ingresoSemana
	cmp		dword[nroIng],10
	jg		ingresoSemana

	;ya tengo el nro ingresado [1..10] en binario ( word 2 bytes)
    sub		dword[nroIng],1		;Restar 1 para hacer desplaz. filas (fila - 1) * L * Cant.Cols
                                ; deberia ser word[nroIng] porque aca es 2 bytes
	mov		rax,0
	mov     eax,dword[nroIng]

	mov		bl,2			;muevo el desplaz. filas a bl como multiplicador (fila - 1) * L * Cant.Cols
	mul		bl				;resultado de la multip. queda en el ax

	mov		rdi,rax			;Paso el desplaz. de la matriz al rdi

    
    mov     qword[contador],0
recorroColumna:
    cmp     qword[contador],4
    je      imprimo
   
    mov		bx,word[matriz + rdi]
    cmp     rbx,qword[aux]
    jg      swapRecu

continuo:
    
    inc     qword[contador]
    add     rdi,20
    jmp     recorroColumna

imprimo:
    mov		rcx,msgMayorVotos		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

    inc     qword[aux2]
    
    mov		rcx,numFormat
    mov     rdx,qword[aux2]		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

    
    mov		rcx,msgCantVotos		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

    mov		rcx,msgCant
    mov     rdx, qword[aux]	;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

porcentaje:
	 mov		rcx,stringF
	mov 	rdx,msgPorcentaje		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32
    mov     rax,0
	
totalVotos:
    cmp     rax,80
    je      imprimoPorcentaje

    mov     bx,[matriz + rax]
    add     qword[total],rbx

	
	add		rsp,32
    add     rax, 2

    jmp     totalVotos
imprimoPorcentaje:
	
    mov     r8,qword[aux]
	mov     r9,100
    imul    r8,r9

	 

    mov     rax,r8 
	
    sub     rdx,rdx
    idiv    qword[total] 

	
	mov		rcx,msgCant
	mov 	rdx,rax	;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32
      
ret

swapRecu:
    mov     qword[aux],rbx
    mov     rsi, qword[contador]
    mov     qword[aux2],rsi
    jmp     continuo


 */