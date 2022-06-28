;Se cuenta con un archivo en formato binario llamado ENCUESTA.DAT que contiene
;información de las respuestas de una encuesta. La encuesta consultaba a que
;candidato votaría (de una lista de 4 opciones) y se realizó en 10 ciudades.
;Cada registro del archivo representa una respuesta y contiene la siguiente
;información:
; Código de candidato: 2 bytes en formato ASCII (AF, MM, RL, SM)
; Código de ciudad: 1 bytes en formato binario punto fijo sin signo
;Se pide realizar un programa en assembler Intel x86 que lea el archivo y por cada
;registro llene una matriz (M) de 4x10 donde cada fila representa a un candidato y
;cada columna una ciudad. Cada elemento de la matriz M representa la sumatoria
;de respuestas para cada candidato en cada ciudad; para el llenado de M se hará
;uso de una rutina interna VALREG q validará los datos de cada registro descartando
;los incorrectos.
;Por último el programa debe pedir ingresar un código de candidato e informar por
;pantalla en que ciudad tiene menos intención de votos teniendo en cuenta que
;habrá un vector en memoria de longitud 10, cuyos elementos tienen 20 bytes de
;longitud con los nombres de las ciudades.
;|--------------------CIUDAD-------------------------
;C              0   1   2   3   4   5   6   7   8   9   
;A  (0 = AF)
;N  (1 = MM)
;D  (2 = RL)
;|  (3 = SM)

global 	main
extern 	printf
extern  gets
extern  sscanf
extern  puts

section  		.data

    ; Definiciones del archivo binario
	fileName	db	"ENCUESTA.dat",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

    ; Registro del archivo
	registro	times 0 	db ""
	candidato	times 2		db " "
	codCiuda				db 0

    matriz      times 40    dw 0
    vecCandi                db  "AFMMRLSM",0

    ciuImp		db	"Montevideo          ",0
				db	"Canelones           ",0
				db  "Atlantida           ",0
				db  "Maldonado           ",0
				db  "Salto               ",0
				db  "Piriapolis          ",0
				db  "JoseIgnacio         ",0
                db  "PuntaDelEste        ",0
                db  "FrayBentos          ",0
                db  "PuntaDiablo         ",0
    msgCant		db	'%lli',10,13,0
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
    call    listar

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
validarCandi:
    mov     byte[esValid],'S'
    mov     rbx,0
    mov     rax,0
evaluoCandi:
    cmp     rax,4
    je      esInvalido

    inc     rax

    lea		rsi,[candidato]
    lea     rdi,[vecCandi + rbx]
    rep     cmpsb
    je      finValidarCandi 
    
    add     rbx,2 ; aumento 2 bytes al rbx, asi leo el proximo codigo del vector 
    jmp     evaluoCandi
finValidarcandi:
    mov     byte[candiBin],rax ; paso el codigo en bianrio a una variable
validarCiudad:
    cmp     byte[codCiudad],1
    jl      esInvalido
    cmp     byte[codCiudad],10
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
    
    sub		byte[codCiudad],1				;Resto a [codCiudad] 1 para hacer el desplaz. columnas
    mov		al,byte[codCiudad]

    mov		bl,2
    mul     bl

    mov		rdx,rax

    sub		byte[candiBin],1
    mov		al,byte[candiBin]

    mov		bl,20
    mul     bl

    add		rax,rdx

    mov		bx,word[matriz + rax]	;obtengo la cantidad de votos del recurso en la matriz
	inc		bx						;sumar 1
	mov		word[matriz + rax],bx	;volver a actualizar la cantidad del dia en la matriz
ret
listar:
ingresoCandidato:
	mov		rcx,msgCandidato		;Parametro 1: direccion del mensaje a imprimir
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
	jl		ingresoCandidato

	;valido que el nro ingresado sea [1..10]
	cmp		dword[nroIng],1
	jl		ingresoCandidato
	cmp		dword[nroIng],4
	jg		ingresoCandidato

	;ya tengo el nro ingresado [1..4] en binario (double word 4 bytes)
    sub		dword[nroIng],1		;Restar 1 para hacer desplaz. filas (fila - 1) * L * Cant.Cols

	mov		rax,0
	mov     eax,dword[nroIng]

	mov		bl,20			;muevo el desplaz. filas a bl como multiplicador (fila - 1) * L * Cant.Cols
	mul		bl				;resultado de la multip. queda en el ax

	mov		rdi,rax			;Paso el desplaz. de la matriz al rdi

	mov		rcx,msgEnc			;Parametro 1: direccion de memoria del campo a imprimir
	sub		rsp,32
	call	printf				;Muestro encabezado del listado por pantalla
	add		rsp,32

	mov		rcx,10
	mov		rsi,0			;Utilizo rsi para desplazar dentro del vector diasImp
	mov		rbx,0
    mov     qword[filas],0
mostrar:
    cmp     qword[filas],9
    je      imprimoResultado

	lea     rcx,[ciuImp + rsi]
	sub		rsp,32
	call	printf
	add		rsp,32

	mov		bx,word[matriz + rdi]		; recupero la cantidad total de actividades en el dia de la matriz
    cmp     bx,qword[aux]
    jl      swapRecu

	mov		rcx,msgCant		;Parametro 1: direccion de memoria de la cadena texto a imprimir
	mov		rdx,rbx			;Parametro 2: campo que se encuentra en el formato indicado q se imprime por pantalla
	sub		rsp,32
	call	printf
	add		rsp,32
continuo:
	add		rdi,2			;Avanzo al próximo elemento de la fila (cada elem. es una WORD de 2 bytes)
	add		rsi,21		;Avanzo 14 + 1 bytes (1 byte de caract. especial 0 al final de cada dia)
    inc     qword[filas]
	jmp	    mostrar

ret
swapRecu:
    mov     qword[aux],bx
    mov     rcx, qword[filas]
    mov     qword[aux2],rcx
    jmp     continuo
imprimoResultado:
    mov		rcx,msgCant		;Parametro 1: direccion de memoria de la cadena texto a imprimir
	mov		rdx,msgResu		;Parametro 2: campo que se encuentra en el formato indicado q se imprime por pantalla
	sub		rsp,32
	call	printf
	add		rsp,32

    mov		rcx,msgCant		;Parametro 1: direccion de memoria de la cadena texto a imprimir
	mov		rdx,qword[aux2]			;Parametro 2: campo que se encuentra en el formato indicado q se imprime por pantalla
	sub		rsp,32
	call	printf
	add		rsp,32

endProg:
ret