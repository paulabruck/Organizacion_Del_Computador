


; La matriz tendria una forma de, por ejemplo, siendo 1 los campos explosivos y 0 los que no:
;0 0 0 0 0 ... 0
;0 1 0 0 0 ... 0
;1 1 1 0 0 ... 1
;0 1 0 0 0 ... 0
;. . . . . ... 0
;. . . . . ... 0
;0 0 1 0 0 ... 0
global 	main
extern 	printf
extern	gets
extern 	sscanf
extern	fopen
extern	fread
extern	fclose

section .data
	fileName	db	"BOMBAS.DAT",0
    modoLectura		db	"rb",0
	msgErrorAbrir	db  "Error al abrir el archivo",0
	formatoScan     dq  "%hi",0

	registro  	times 0 dw ""
		fila   		dw ""
		columna 	dw ""
		potencia    dw 0

	matriz   	times 2500 db 0; En la matriz, 0 significa sin explosion, y 1 significa explosion
	pedirColumna	db "Ingrese un numero de columna: ",0
	columnaInvalida db "Columna ingrresada invalida",0
	filaSeguraMsj   db "La fila %hi es segura",0
	stringN   		db "N",0

section .bss
	validezRegistro	resq
	idArchivo 		resq
	filaNumero  	resw
	columnaNumero  	resw
	buffer     		resb	4
	potenciaActual	resw
	posicionActualMatriz 	resq
	columnaABuscar	resw
	

section .text
main:
	mov 	rdi,fileName
	mov  	rsi,modoLectura 
	call 	fopen

	mov  	[idArchivo],rax

	cmp  	rax,0
	jg  	leerRegistro

errorApertura:
	mov  	rdi,msgErrorAbrir
	sub  	rax,rax
	call 	printf
	jmp  	cierroArchivo

leerRegistro:
	mov  	rdi,registro
	mov   	rsi,6 ;Que lea 6 bytes, osea 3 words
	mov  	rdx,1
	mov 	rcx,[idArchivo]
	call  	freads
	cmp  	rax,0
	jle  	eof

	call    VALREG

	mov  	rdi,[validezRegistro]
	cmp  	rsi,[stringN]
	mov  	rcx,1
	repe 	cmpsb
	je   	leerRegistro ; si la string de validez es "N", el registro no es valido, por lo que lo descarto y vuelvo a leer otro
;formula para posciion de matriz = (columna - 1) * tamanioReg + (fila - 1) * tamanioReg * cantidadColumnas
	mov  	bx,[columnaNumero]
	sub 	bx,1
	mov 	ax,[filaNumero]
	sub 	ax,1
	mul  	ax,50 ;50 es la cantidad de columnas * 1 long byte

	add  	rax,rbx
	mov  	[posicionActualMatriz],rax
	mov   	byte[matriz + rax],1

ajustarPotencia:

	mov  	cx,[potencia]

	mov  	[potenciaActual],cx

	call  	potenciaArriba
	call  	potenciaAbajo
	call 	potenciaDerecha
	call  	potenciaIzquierda

	mov  	cx,[potenciaActual]

	loop  	ajustarPotencia

	jmp 	leerRegistro

potenciaArriba:
	mov  	rax,[posicionActualMatriz]
	mov  	bx,[potenciaActual]
	mul  	bx,50;1 bytes * cant columnas = 50
	sub  	rax,rbx
	cmp  	rax,0
	jl  	finHacerPotencia ; comparo con el 0 porque estoy haciendo por arriba, estoy seguro de que no se va a pasar de los 2500
	mov   	byte[matriz + rax],1
	ret
potenciaAbajo:
	mov  	rax,[posicionActualMatriz]
	mov  	bx,[potenciaActual]
	mul  	bx,50;1bytes * cant columnas = 50
	add  	rax,rbx
	cmp  	rax,2500
	jge  	finHacerPotencia ; comparo con el 2500 porque estoy haciendo por la abajo, estoy seguro de que no se va a ser menor que 0
	mov   	byte[matriz + rax],1
	ret
potenciaDerecha:
	mov  	rax,[posicionActualMatriz]
	mov  	bx,[potenciaActual]
	add  	rax,rbx
	cmp  	rax,2500
	jge  	finHacerPotencia ; comparo con el 2500 porque estoy haciendo por la derecha, porque va a subir la posicion de la matriz, no bajar
	mov   	byte[matriz + rax],1
	ret
potenciaIzquierda:
	mov  	rax,[posicionActualMatriz]
	mov  	bx,[potenciaActual]
	sub  	rax,rbx
	cmp  	rax,0
	jl  	finHacerPotencia ; comparo con el 0 porque estoy haciendo por la abajo, porque va a bajar la posicion de la matriz, no subir
	mov   	byte[matriz + rax],1
	ret

finHacerPotencia:
	ret

VALREG:
	mov  	di,fila
	mov     rsi,formatoScan
	mov    	dx,filaNumero
	call    sscanf
	cmp 	rax,1
	jl    	errorVALREG

	mov  	di,columna
	mov     rsi,formatoScan
	mov    	dx,columnaNumero
	call    sscanf
	cmp 	rax,1
	jl    	errorVALREG

	mov  	ax,[potencia]
	cmp  	ax,1
	jl   	errorVALREG
	cmp   	ax,50
	jg  	errorVALREG

	mov  	ax,[filaNumero]
	cmp  	ax,1
	jl   	errorVALREG
	cmp   	ax,50
	jg  	errorVALREG

	mov  	ax,[columnaNumero]
	cmp  	ax,1
	jl   	errorVALREG
	cmp   	ax,50
	jg  	errorVALREG ; me fijo que la potencia y el numero de filas y de columnas sean mayores a 1 y menores a 50

	mov 	qword[validezRegistro],"S"
	ret


errorVALREG:
	mov 	qword[validezRegistro],"N"
	ret

eof:
	mov  	rdi,pedirColumna
	mov  	rax,0
	call 	printf

	mov  	rdi,buffer
	call 	gets

	mov  	rdi,buffer
	mov  	rsi,formatoScan
	mov  	rdx,[columnaABuscar]
	call    sscanf
	cmp  	rax,0
	jle  	columnaInvalidada

	mov  	ax,[columnaABuscar]
	cmp  	ax,1
	jl   	columnaInvalidada
	cmp   	ax,50
	jg  	columnaInvalidada  ; me fijo que la columna ingresada sea mayor a 1 y menor a 50

	mov  	dx,ax  ; en el ax ahora voy a tener en que columna buscar
	mov  	cx,1   ; el cx va a ser un contador de filas

seguirRevisandoColumna:

	cmp   	dx,2500  ; me fijo si termine de recorrer toda la columna, fijandome que no me haya pasado del tamaño de la matriz
	jge  	cierroArchivo
	mov  	bl,[matriz + dx]
	cmp  	bl,0 ; si hay un cero significa que no hay explosiones
	je  	filaSegura

columnaAumentarIteracion:
	add  	dx,50 ; voy aumentando de fila en fila
	add  	cx,1  ; aumento el numero de fila
	jmp  	seguirRevisandoColumna

filaSegura:
	mov  	rdi,filaSeguraMsj
	mov  	si,cx
	sub  	rax,rax
	call  	printf
	jmp  	columnaAumentarIteracion

columnaInvalidada:
	mov  	rdi,columnaInvalida
	mov  	rax,0
	call  	printf
cierroArchivo:
	mov  	rdi,[idArchivo]
	call  	fclose
	ret