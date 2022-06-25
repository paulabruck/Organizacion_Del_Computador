;       0   1   2   3   4   5   6   7   8   9
;   0
;   1
;   2
;   3
;   4
;   5
;   6                                           
;   7   
;   8
;   9
;   10
;   11
;   12
;   13
;   14
;   15
;   16
;   17
;   18
;   19
;   20
;   21
;   22
;   23
;   24
;   25
;   26
;   27
;   28
;   29
;Se dispone de una matriz de 30x10 que representa un tablero de Tetris (30 de alto y 10
;de largo).Cada elemento de la matriz indica si ese punto del tablero está ocupado o no
;siendo  * (asterisco) ocupado y ' ' (espacio en blanco) en caso contrario.
;Para cargar el tablero se hará uso de un archivo (FICHAS.DAT) que contiene el
;posicionamiento inicial de las fichas. Solo hay fichas de tipo '|' (dimensión 4x1) y cada
;registro del archivo tiene los siguientes campos:
;●  Fila: CL2 (Indica la fila de la posición inicial de la ficha - 1..30)
;●  Columna: BL1 (Indica la columna de la posición inicial de la ficha - 1..10)
;●  Sentido: CL1 (Indica el sentido hacia donde continúan el resto de las posiciones que
;ocupa la ficha en el tablero   A - Arriba; B - Abajo; D - Derecha; I - Izquierda)
;Se pide realizar un programa en assembler Intel 8086 que realice la carga del tablero
;(se asume que las fichas no solapan). Como la información del archivo puede ser
;incorrecta se deberá validar haciendo uso de una rutina interna (VALFICHA) para
;descartar los inválidos. La rutina deberá validar todos los campos del registro (tipo de
;datos, valores y que la ficha quepa en el tablero)  
;Se pide
;1. Carga del tablero
;2. Codificación de rutina interna VALFICHA
;3. Para aquellos alumnos con padrón PAR se deben imprimir los nros de filas
;donde todos los elementos tienen * mientras que los alumnos con padrón IMPAR
;los nros de columnas donde todos tiene *.

global 	main
extern 	printf
extern  gets
extern  sscanf
extern  puts

section  		.data

    ; Definiciones del archivo binario
	fileName	db	"FICHAS.dat",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

    ; Registro del archivo
	registro	times 0 	db ""
	fila		times 2		db " "
	columna					db 0
    sentido                 db " "

    matriz      times 300   db " "
    vecFila                 db "010203040506070809101112131415161718192021222324252627282930",0
    vecSentido              db "ABDI",0
    msgInvalido             db "Error en un dato",0

section  		.bss

    fileHandle	resq	1
    esValid		resb	1
    filaBin     resb    1
    sentidoBin  resb    1
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
	mov		rdx,4   					;Parametro 2: longitud del registro
	mov		r8,1						;Parametro 3: cantidad de registros
	mov		r9,qword[fileHandle]		;Parametro 4: handle del archivo
	sub		rsp,32
	call	fread						;LEO registro. Devuelve en rax la cantidad de bytes leidos
	add		rsp,32

	cmp		rax,0				        ;Fin de archivo?
	jle		eof

    call    VALFICHA
    
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

VALFICHA:
validarSentido:
    mov     rbx,0
    mov     rax,0
evaluoSentido:
    cmp     rax,4
    je      esInvalido

    inc     rax

    lea		rsi,[sentido]
    lea     rdi,[vecSentido + rbx]
    rep     cmpsb
    je      finValidarSentido
    
    add     rbx,1 ; aumento 2 bytes al rbx, asi leo el proximo codigo del vector 
    jmp     evaluoSentido
finValidarSentido:
    mov     byte[sentidoBin],rax ; paso el codigo en bianrio a una variable
validarFila:
    mov     byte[esValid],'S'
    mov     rbx,0
    mov     rax,0
evaluoFila:
    cmp     rax,30
    je      esInvalido

    inc     rax

    lea		rsi,[fila]
    lea     rdi,[vecFila + rbx]
    rep     cmpsb
    je      finValidarFila
    
    add     rbx,2 ; aumento 2 bytes al rbx, asi leo el proximo codigo del vector 
    jmp     evaluoFila
finValidarFila:
    mov     byte[filaBin],rax ; paso el codigo en bianrio a una variable
validarColumna:
    cmp     byte[columna],1
    jl      esInvalido
    cmp     byte[columna],10
    jg      esInvalido
validarQueQuepa:
    sub		byte[columna],1				;Resto a [columna] 1 para hacer el desplaz. columnas
    mov		al,byte[columna]

    mov		bl,1
    mul     bl

    mov		rdx,rax

    sub		byte[filaBin],1
    mov		al,byte[filaBin]

    mov		bl,10
    mul     bl

    add		rax,rdx           

    cmp     byte[sentidoBin],1
    je      verificarArriba

    cmp     byte[sentidoBin],2
    je      verificarAbajo   

    cmp     byte[sentidoBin],3
    je      verificarDerecha

    cmp     byte[sentidoBin],4
    je      verificarIzquierda

validado:

ret
verificarArriba:
    sub     rax,40
    cmp     rax,0
    jl      esInvalido
    cmp     rax,300
    jg      esInvalido
    jmp     validado
verificarAbajo:
    add     rax,40
    cmp     rax,0
    jl      esInvalido
    cmp     rax,300
    jg      esInvalido
    jmp     validado
verificarDerecha:
    add     rax,4
    cmp     rax,0
    jl      esInvalido
    cmp     rax,300
    jg      esInvalido
    jmp     validado
verificarIzquierda:
    sub     rax,4
    cmp     rax,0
    jl      esInvalido
    cmp     rax,300
    jg      esInvalido
    jmp     validado
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
    
    sub		byte[columna],1				;Resto a [columna] 1 para hacer el desplaz. columnas
    mov		al,byte[columna]

    mov		bl,1
    mul     bl

    mov		rdx,rax

    sub		byte[filaBin],1
    mov		al,byte[filaBin]

    mov		bl,10
    mul     bl

    add		rax,rdx                 ;obtengo la coordenada inicial

    cmp     byte[sentidoBin],1
    je      haciaArriba

    cmp     byte[sentidoBin],2
    je      haciaBajo

    cmp     byte[sentidoBin],3
    je      haciaDerecha

    cmp     byte[sentidoBin],4
    je      haciaIzquierda
actualizado:
ret
haciaArriba:    
    mov     qword[aux],rax
    sub     rax,40 ;posicion inicial para ir para abajo
    mov     qword[contador],0
    
arriba:
    cmp     qword[contador],4
    je      actualizado  
    mov     bx,'*'
    mov		byte[matriz + rax],bx

    add     rax,10
    inc     qword[contador]    
    jmp     arriba
haciaBajo:
    mov     qword[contador],0
abajo:
    cmp     qword[contador],4
    je      actualizado  
    mov     bx,'*'
    mov		byte[matriz + rax],bx

    add     rax,10
    inc     qword[contador]    
    jmp     abajo

haciaDerecha:
    mov     qword[contador],0
derecha:
    cmp     qword[contador],4
    je      actualizado  
    mov     bx,'*'
    mov		byte[matriz + rax],bx

    add     rax,1
    inc     qword[contador]    
    jmp     derecha
haciaIzquierda:
    mov     qword[contador],0
    mov     qword[aux],rax
    sub     rax,4 ;posicion inicial para ir para abajo
    
izquierda:
    cmp     qword[contador],4
    je      actualizado  
    mov     bx,'*'
    mov		byte[matriz + rax],bx

    add     rax,1
    inc     qword[contador]    
    jmp     izquierda
mostrar:
    mov     rax,0
    mov     qword[contadorC],0
    mov     qword[contadorF],0
recorroXColumnas:
    cmp     qword[contadorF],29
    je      columnaEs
    cmp     byte[matriz+rax],"*"
    jne     proximaColumna
    add     rax,10
    inc     qword[contadorF]
    jmp     recorroXColumnas
proximaColumna:
    cmp     qword[contadorC],9
    je      endProg
    mov     rax,qword[contadorC]
    inc     rax
    mov     qword[contadorF],0
    inc     qword[contadorC]
    jmp     recorroXColumnas
columnaEs:
    mov		rcx,msgColumna		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    inc     qword[contadorC]
    mov		rcx,qword[contadorC]		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32
    dec     qword[contadorC]

    jmp     proximaColumna

endProg:	
ret
