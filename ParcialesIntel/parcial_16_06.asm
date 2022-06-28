;Se dispone de una matriz de 12x12 que representa un edificio nuevo a estrenar, donde
;tiene 12 pisos con 12 departamentos en cada uno. Cada elemento de la matriz es un
;binario de 4 bytes, donde guarda el precio de venta en U$S de cada departamento. Se
;dispone de un archivo (PRECIOS.DAT) que contiene los precios de los departamentos,
;donde cada registro del archivo contiene los siguientes campos: 
; Piso: Carácter de 2 bytes 
; Departamento:  Binario de 1 byte  
; Precio venta: Binario de 4 bytes
;Se pide realizar un programa en assembler Intel 80x86 que realice la carga de la matriz
;a través del archivo. Como la información del archivo puede ser incorrecta se deberá
;validar haciendo uso de una rutina interna (VALREG) que descartará los registros
;inválidos (la rutina deberá validar todos los campos del registro).
;Una vez finalizada la carga, se solicitará ingresar por teclado numero (x) y un precio de
;venta (no se requieren validar) y se deberá mostrar todos los departamentos/pisos cuyo
;precio de venta sea menor al ingresado.
;Para alumnos con padrón par, x será un numero de piso y se deberá mostrar por
;pantalla todos los nros de departamento cuyo precio sea inferior al ingresado en el piso
;ingresado.
;Para alumnos con padrón impar,x será un numero de departamento y se deberá
;mostrar por pantalla todos los nros de piso donde el departamento ingresado tenga
;precio inferior al ingresado.
;------------PISOS---------------------
;|  0  1  2  3  4  5  6  7  8  9  10  11 
;|  1
;|  2
;D  3
;E  4
;P  5 
;T  6
;O  7
;S  8
;|  9
;|  10
;|  11

global 	main
extern 	printf
extern  gets
extern  sscanf
extern  puts

section  		.data

    ; Definiciones del archivo binario
	fileName	db	"PRECIOS.dat",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

	; Registro del archivo
	registro	times 0 	db ""
	piso		times 2		db " "
	depto					db 0
	precioVenta		        dd 0
   ;precioVenta times 4     db 0
    
    matriz      times 144 dd 0
    
    vecPisos    db    "010203040506070809101112",0
    
    msgDpto     db "Ingrese un numero de dpto (1 al 12)",0

section  		.bss

    fileHandle	resq	1
    esValid		resb	1
	contador    resq    1
	piso		resq	1
    pisoNro     resb    1
	nroIng		resd	1
	
	buffer      resb	10

section 		.text
main:
    call	abrirArchivo

	cmp		qword[fileHandle],0				;Error en apertura?
	jle		errorOpen

    call    leerArchivo
    call    mostrar
ret

abrirArchivo:
    ;	Abro archivo para lectura
	mov		rcx,fileName			;Parametro 1: dir nombre del archivo
	mov		rdx,mode				;Parametro 2: dir string modo de apertura
	sub		rsp,32
	call	fopen					;ABRE el archivo y deja el handle en RAX
	add		rsp,32

	mov		qword[fileHandle],rax
ret

leerArchivo:
leerRegistro:
	mov		rcx,registro				;Parametro 1: dir area de memoria donde se copia
	mov		rdx,7						;Parametro 2: longitud del registro
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

eof:
	;	Cierro archivo cuando llega a fin del archivo
	mov		rcx,qword[fileHandle]	;Parametro 1: handle del archivo
	sub		rsp,32
	call	fclose
	add		rsp,32
ret

VALREG:
validarPiso:
    mov     byte[esValid],'S'
    mov     rbx,0        ;Utilizo rbx como indice del vector de pisos validos
	mov     rax,0        ;dia convertido en número
evaluarPiso:
    cmp     rax,12
    je      esInvalido

    inc     rax

    lea		rsi,[piso]
    lea     rdi,[vecPisos + rbx]
    rep     cmpsb
    je      finValidarPiso
   
    add     rbx,2 ; aumento 2 bytes al rbx, asi leo el proximo piso del vector en el proximo loop
    jmp     evaluarPiso
finValidarPiso:
    ; guardo el valor de la fila
    mov		byte[pisoNro],rax ; paso el piso en bianrio a una variable
validarDpto:
    cmp     byte[dpto],1
    jl      esInvalido
    cmp     byte[dpto],12
    jg      esInvalido
validarPrecio:
    cmp     qword[precioVenta],0
    jle     esInvalido
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

    sub		byte[pisoNro],1				;Resto a [diabin] 1 para hacer el desplaz. columnas
    mov		al,byte[pisoNro]

    mov		bl,4
    mul     bl

    mov		rdx,rax

    sub		byte[dpto],1
    mov		al,byte[dpto]

    mov		bl,48
    mul     bl

    add		rax,rdx

    mov     rcx,4 ; se copian 4 bytes
    lea     rsi,[precioVenta]
    lea     rdi,[matriz + rax] ; posicion ---> direccion inicio matriz + desplamiento calculado previamente.
    rep     movsb

ret
mostrar:
ingresoDpto:
    mov		rcx,msgDpto		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
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
	jl		ingresoDpto

    cmp		dword[nroIng],1
	jl		ingresoDpto
	cmp		dword[nroIng],12
	jg		ingresoDpto
ingresoPrecio:
    mov		rcx,msgPrecio		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

    mov		rcx,buffer			;Parametro 1: direccion de memoria del campo donde se guarda lo ingresado
	sub		rsp,32
	call	gets				;Lee de teclado y lo guarda como string hasta que se ingresa fin de linea . Agrega un 0 binario al final
	add		rsp,32

    mov		rcx,buffer		    ;Parametro 1: campo donde están los datos a leer
	mov		rdx,numFormat	    ;Parametro 2: dir del string q contiene los formatos
    mov		r8,precioIng		    ;Parametro 3: dir del campo que recibirá el dato formateado
	sub		rsp,32
	call	sscanf
	add		rsp,32

    cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		ingresoPrecio

    mov		rcx,msgVaDpto		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    mov		rcx,dword[nroIng]	;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    mov		rcx,msgCumplen		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    sub		dword[nroIng],1 ; fila osea dpto
    mov		al,dword[nroIng]

    mov		bl,48
    mul     bl

    mov		rdx,rax ;fila a usar
    mov     qword[contador],0
buscoMatriz:
    cmp     qword[contador],11
    je      fin
    mov     rcx,4 ; se comparan 4 bytes
    lea     rsi,[precioIng]
    lea     rdi,[matriz + rax] ; posicion ---> direccion inicio matriz +  desplamiento calculado prevaimente...
    rep     cmpsb
    jge     continuo

    inc     qword[contador]
    mov		rcx,qword[contador]		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32
    dec     qword[contador]

continuo:
    add     rax,4
    inc     qword[contador]
    jmp     buscoMatriz  
ret
fin:
ret

;-------------------VERSION QUE COMPILA -----------------------------------------------;
/*
; Se dispone de una matriz de 12x12 que representa un edificio nuevo a estrenar, donde
; tiene 12 pisos con 12 departamentos en cada uno. Cada elemento de la matriz es un
; binario de 4 bytes, donde guarda el precio de venta en U$S de cada departamento. Se
; dispone de un archivo (PRECIOS.DAT) que contiene los precios de los departamentos,
; donde cada registro del archivo contiene los siguientes campos: 
; - Piso: Carácter de 2 bytes 
; - Departamento:  Binario de 1 byte  
; - Precio venta: Binario de 4 bytes
; Se pide realizar un programa en assembler Intel 80x86 que realice la carga de la matriz
; a través del archivo. Como la información del archivo puede ser incorrecta se deberá
; validar haciendo uso de una rutina interna (VALREG) que descartará los registros
; inválidos (la rutina deberá validar todos los campos del registro).
; Una vez finalizada la carga, se solicitará ingresar por teclado numero (x) y un precio de
; venta (no se requieren validar) y se deberá mostrar todos los departamentos/pisos cuyo
; precio de venta sea menor al ingresado.
; Para alumnos con padrón par, x será un numero de piso y se deberá mostrar por
; pantalla todos los nros de departamento cuyo precio sea inferior al ingresado en el piso
; ingresado.
; Para alumnos con padrón impar, x será un numero de departamento y se deberá
; mostrar por pantalla todos los nros de piso donde el departamento ingresado tenga
; precio inferior al ingresado.


global main
extern puts
extern printf
extern sscanf
extern gets
extern fopen
extern fclose
extern fread

section .data
    ; Datos archivo
    nombreArchivo   db  "PRECIOS.DAT", 0
    modo            db  "rb", 0
    msjErrorAbrir   db  "Error en la apertura del archivo Precios", 0  

    ; Datos registro
    registro        times 0     db ""
    piso            times 2     db " "
    departamento                db 0
    precio          times 4     db 0

    ; Datos matriz
    matriz          times 144   dd 0

    pisoStr         db  "**", 0
    pisoFormat      db  "%hi", 0
    deptoFormat     db  "%hi", 0
    precioFormat    db  "%li", 0
    pisoNum         db  0
    desplaz         db  0
    contadorFila    db  0
    contadorCol     db  0
    msjErrorPiso    db  "Es invalido", 10, 0
    msjBienPiso     db  "El piso es: %hi", 10, 0
    msjBienDepto    db  "El depto es: %hi", 10, 0
    msjBienPrecio   db  "El precio es: %i", 10, 0
    msjPedirDep     db  "Ingrese un numero de departamento: ", 10, 0
    msjPedirPrecio  db  "Ingrese un precio de venta: ", 10, 0
    msjPisos        db  "El piso %hi tiene un precio inferior al ingresado en el departamento ingresado", 10, 0

    msjPrecioEs     db  "El precio ingresado es: %i", 10, 0
    msjDeptoEs      db  "El depto ingresado es: %hi", 10, 0
    pisoBien        db  "Fila: %hi", 10, 0
    deptoBien       db  "Columna: %hi", 10, 0
    filaBien        db  "La fila ahora es %hi", 10, 0

    msjOk           db  "Todo bien", 10, 0
    msjCheckeando   db  "Ingrese %hi en la matriz en el lugar %hi", 10, 0
    msjAver         db  "Aca tengo %hi", 10, 0
    deplazFila      db  "Desplazamiento fila: %hi", 10, 0
    desplazCol      db  "Desplazamiento columna: %hi", 10, 0

section .bss
    handleArchivo       resq    1
    esValido            resb    1
    deptoIngresado      resw    1
    precioIngresado     resb    4
    bufferDep           resb    100
    bufferPrecio        resb    100

section .text
main:
    call    abrirArchivo

    cmp     qword[handleArchivo],0				;Error en apertura?
	jle		errorAbrirArchivo

    call    leerArchivo
    call    solicitar

    mov		rcx,msjOk		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32


finalPrograma:
    ret

errorAbrirArchivo:
    mov     rcx, msjErrorAbrir
    sub     rsp, 32
    call    puts
    add		rsp, 32

    jmp     finalPrograma

abrirArchivo:
    mov     rcx, nombreArchivo                  ; Parametro 1: direccion del archivo
    mov     rdx, modo                           ; Parametro 2: modo de apertura
    sub		rsp, 32
	call	fopen                               ; Abro el archivo y dejo el handle en el rax
	add		rsp, 32

    cmp     rax, 0
    jle     errorAbrirArchivo
    mov     qword[handleArchivo], rax

    ret

leerArchivo:

leerRegistro:
    mov     rcx, registro
    mov     rdx, 7
    mov     r8, 1
    mov     r9, [handleArchivo]
    sub     rsp, 32
    call    fread
    add		rsp, 32

    cmp     rax, 0
    jle     finalDelArchivo

    call    VALREG
    cmp     byte[esValido], "S"
    jne     leerRegistro                        ; Si el registro no es valido, pasa al siguiente

    call    avanzarEnMatriz
    jmp     leerRegistro

finalDelArchivo:
    mov     rcx, [handleArchivo]
    sub     rsp, 32
    call    fclose
    add		rsp, 32

    ret

avanzarEnMatriz:
    ; Desplazamiento 
    ; [(fila-1)*longFila]  + [(columna-1)*longElemento]
    ; longFila = longElemento * cantidad columnas -> longFila = 48

    mov		rax, 0
	mov		rbx, 0

    mov     rcx, pisoBien		;Parametro 1: direccion del mensaje a imprimir
    mov     rdx, [pisoNum]
	sub		rsp,32
	call	printf
	add		rsp,32

    sub     byte[pisoNum], 1
    mov     bx, [pisoNum]
    imul    bx, bx, 48

    mov		[desplaz],bx                            ;copio a [desplaz] el desplaz.fila

    mov     rcx, deplazFila		;Parametro 1: direccion del mensaje a imprimir
    mov     rdx, [desplaz]
	sub		rsp,32
	call	printf
	add		rsp,32

    mov     rcx, deptoBien		;Parametro 1: direccion del mensaje a imprimir
    mov     rdx, [departamento]
	sub		rsp,32
	call	printf
	add		rsp,32

    sub     byte[departamento], 1
    mov     bx, [departamento]
    imul    bx, bx, 4

    mov     rcx, desplazCol		;Parametro 1: direccion del mensaje a imprimir
    mov     rdx, rbx
	sub		rsp,32
	call	printf
	add		rsp,32

    add     [desplaz], bx
    mov     ax, [desplaz]

    mov     bx, [precio]
    mov     [matriz + rax], bx             ;actualizo la matriz en la coordenada (i, j) dada con el numero dado

    mov     rcx, msjCheckeando
    mov		rdx,[matriz + rax]		;Parametro 1: direccion del mensaje a imprimir
    mov     r8, [desplaz]
	sub		rsp,32
	call	printf
	add		rsp,32

    ret

solicitar:
    mov		rcx,msjPedirDep		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

	mov		rcx,bufferDep			;Parametro 1: direccion de memoria del campo donde se guarda lo ingresado
	sub		rsp,32
	call	gets				;Lee de teclado y lo guarda como string hasta que se ingresa fin de linea . Agrega un 0 binario al final
	add		rsp,32

	mov		rcx,bufferDep		        ;Parametro 1: campo donde están los datos a leer
	mov		rdx,deptoFormat	            ;Parametro 2: dir del string q contiene los formatos
    mov		r8,deptoIngresado		    ;Parametro 3: dir del campo que recibirá el dato formateado
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		solicitar

    mov		rcx,msjPedirPrecio		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

	mov		rcx,bufferPrecio			;Parametro 1: direccion de memoria del campo donde se guarda lo ingresado
	sub		rsp,32
	call	gets				;Lee de teclado y lo guarda como string hasta que se ingresa fin de linea . Agrega un 0 binario al final
	add		rsp,32

	mov		rcx,bufferPrecio		        ;Parametro 1: campo donde están los datos a leer
	mov		rdx,precioFormat	            ;Parametro 2: dir del string q contiene los formatos
    mov		r8,precioIngresado		    ;Parametro 3: dir del campo que recibirá el dato formateado
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		solicitar

comparar:
    mov     rbx, 0

    mov     rcx, msjDeptoEs
    mov		rdx,[deptoIngresado]		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

    mov     rcx, msjPrecioEs
    mov		rdx,[precioIngresado]		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	printf
	add		rsp,32

    mov     bx, [deptoIngresado]
    dec     bx
    imul    bx, bx, 4

recorroFilas:
    cmp     byte[contadorFila], 12
    jg      finalPrograma

    mov     eax, [matriz + rbx]

    cmp     eax, [precioIngresado]
    jl      mostrarFila

    add     rbx, 48
    inc     byte[contadorFila]
    jmp     recorroFilas

mostrarFila:
    mov		rcx,msjPisos		;Parametro 1: direccion del mensaje a imprimir
    mov     rdx,[contadorFila]
	sub		rsp,32
	call	printf
	add		rsp,32

    add     rbx, 48
    inc     byte[contadorFila]
    jmp     recorroFilas

; ------------------------------------------------
;                 RUTINAS INTERNAS               |
; ------------------------------------------------

VALREG:

validarPiso:
    mov		rcx,2
	mov		rsi,piso
	mov		rdi,pisoStr
	rep	    movsb

	mov		rcx,pisoStr    
	mov		rdx,pisoFormat   
	mov		r8,pisoNum      
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp     rax,1
	jl	    invalido

    cmp		byte[pisoNum],1
	jl		invalido
	cmp		byte[pisoNum],12
	jg		invalido 

    mov     rcx, msjBienPiso
    mov     rdx, [pisoNum]
    sub		rsp,32
	call	printf
	add		rsp,32

deptoValido:
    cmp		byte[departamento],1
	jl		invalido
	cmp		byte[departamento],12
	jg		invalido

    mov     al, byte[departamento]
    cbw
    mov     [departamento], ax

    mov     rcx, msjBienDepto
    mov     rdx, [departamento]
    sub		rsp,32
	call	printf
	add		rsp,32

    mov     rcx, msjBienPrecio
    mov     rdx, [precio]
    sub		rsp,32
	call	printf
	add		rsp,32

regValido:
    mov		byte[esValido],'S'

finValidar:
	ret

invalido:
    mov		byte[esValido],'N'

    mov     rcx, msjErrorPiso
    sub		rsp,32
	call	puts
	add		rsp,32

	jmp		finValidar


 */