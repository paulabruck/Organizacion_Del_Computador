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