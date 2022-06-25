;Se cuenta con una matriz (M) de 20x20 cuyos elementos son BPFC/S de 16 bits y
;un archivo (carbina.dat) cuyos registros están conformados por los siguientes
;campos:
;• Cadena de 16 bytes de caracteres ASCII que representa un BPFc/s de 16 bits
;• BPF s/s de 8 bits que indica el número de fila de M
;• BPF s/s de 8 bits que indica el número de columna de M
;Se pide codificar un programa que lea los registros del archivo y complete la matriz
;con dicha información. Como el contenido de los registros puede ser inválido
;deberá hacer uso de una rutina interna (VALREG) para validarlos (los registros
;inválidos serán descartados y se procederá a leer el siguiente). Luego realizar la
;sumatoria de la diagonal secundaria e imprimir el resultado por pantalla.
;Nota: Se deberá inicializar M con ceros por si no se lograra completar todos los
;elementos con la información provista en el archivo.
;   0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  
;0
;1  x
;2      x
;3          x
;4              x
;5                  x
;6                      x
;7                          x
;8                              x
;9                                  x   
;10                                     x
;11
;12
;13
;14
;15
;16
;17
;18                                                                       
;19                                                                             x
global 	main
extern 	printf
extern  gets
extern  sscanf
extern  puts

section  		.data

    ; Definiciones del archivo binario
	fileName	db	"carbina.dat",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

    ; Registro del archivo
	registro	times 0 	db ""
	cadena		times 16	db " "
	fila					db 0
    columna                 db 0

    matriz      times 400   dw 0
    msgInvalido             db "Error en un dato",0

section  		.bss
    fileHandle	resq	1
    esValid		resb	1

section 		.text
main:
    call    abrirArchivo

    cmp		qword[fileHandle],0				;Error en apertura?
	jle		errorOpen

    call    leerArchivo
    call    diagonalSecundaria
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
	mov		rdx,18   					;Parametro 2: longitud del registro
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
    mov     byte[esValid],'S'
validarCadena:
    mov     rbx,0
    mov     rax,0
evaluoCadena:
    cmp     rax,15
    je      finValidarCadena

    lea		rsi,[vecCero ]
    lea     rdi,[cadena + rbx]
    rep     cmpsb
    je      proximo
uno:    
    lea		rsi,[vecUno ]
    lea     rdi,[cadena + rbx]
    rep     cmpsb
    jne     esInvalido
proximo:   
    add     rbx,1 ; aumento 1 bytes al rbx, asi leo el proximo digito del vector
    inc     rax 
    jmp     evaluoCadena
finValidarCadena:
    mov		rcx,buffer		    ;Parametro 1: campo donde están los datos a leer
	mov		rdx,numFormat	    ;Parametro 2: dir del string q contiene los formatos
    mov		r8,cadbin		;Parametro 3: dir del campo que recibirá el dato formateado
	sub		rsp,32
	call	sscanf
	add		rsp,32
validarFila:

    cmp     byte[fila],1
    jl      esInvalido
    cmp     byte[fila],20
    jg      esInvalido
validarColumna:
    cmp     byte[columna],1
    jl      esInvalido
    cmp     byte[columna],20
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
    sub		byte[columna],1				;Resto a [columna] 1 para hacer el desplaz. columnas
    mov		al,byte[columna]

    mov		bl,2
    mul     bl

    mov		rdx,rax

    sub		byte[fila],1
    mov		al,byte[fila]

    mov		bl,40
    mul     bl

    add		rax,rdx   
    mov     bx, cadbin
    mov     word[matriz+rax], bx
ret
diagonalSecundaria:
    mov     rax,40
    mov     qword[contador],0
voy:
    cmp     rax,398
    jg      imprimoSuma
    mov     bx,word[matriz+rax]
    add     qword[suma],bx
    inc     qword[contador]
    mov     r8,qword[contador]
    mov     r9,2
    add     rax,r8
    add     rax,40
    jmp     voy
imprimoSuma:
    mov		rcx,msgSuma		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32

    mov		rcx,qword[suma]		;Parametro 1: direccion del mensaje a imprimir
	sub		rsp,32
	call	puts
	add		rsp,32
ret
endProg:
ret