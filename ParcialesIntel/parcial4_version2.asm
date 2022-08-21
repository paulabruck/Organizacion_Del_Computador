;Se pide realizar un programa en assembler Intel que realice un ciclo donde pida por teclado la configuración hexadecimal de un número empaquetado y
; los valores i j correspondientes a una coordenada de una matriz (M).  El fin del ingreso por teclado se produce cuando el usuario ingresa ‘*’ en lugar del número empaquetado
;
;La dimensión de M es 15x15 y sus elementos son números en formato binario de punto fijo con signo de 16 bits.  
;
;El programa deberá descartar ingresos inválidos.  Para ello hará  uso de una rutina interna llamada VALING que validará los valores de i y j, el formato del empaquetado 
; y que el número que representa entre en el formato destino.  Los elementos de M que no fueron ocupados por un número ingresado por el usuario deberán ser 0.
;
;Por último el programa deberá mostrar por pantalla la siguiente información:
;



global 	main
extern 	printf
extern  gets
extern  sscanf

section  		.data
	msjIngEmp				db	'Ingrese el empaquetado eg: 12A (Caracteres validos CAFE positivos BD negaivos solo en mayuscula) o * para terminar el programa: ',0
	msjIngI					db	'Ingrese coordenada i de 0 a 14: ',0
	msjIngJ					db	'Ingrese Cordenada j de 0 a 14 : ',0
	msjPromedio				db	'El promedio de la columna %lli es %lli',10,0
	msjError				db	'El input ingresado es invalido',10,0
	matriz     	times 225 	dw 0  ; word = 2 bytes = 16 bits y 15x15
	formatoCor   			db "%lli"
	formatoEmp   			db "%hi%c";No creo que sea valido pero o sino lo que haces es leer el input hasta que se un caracter valido y con un contador y movsb copias los bytes del numero y ahi usas sscanf con %hi
	sumatoriaCol			dq  0

section  		.bss
	i            			resq 0
	j            			resq 0
	numero		 			resw 0
	caracter     			resb 0
	inputEmp		resb	500
	inputI			resb	500
	inputJ			resb	500



section 		.text
main:

ingTexto:
	; Incializo las variables
	mov qword[i],15  ; para que este fuera de rango
	mov qword[j],15
	mov word[numero],0
	mov byte[caracter],0

	mov rcx,msjIngTex
	sub rsp,32
	call printf
	add rsp,32

	mov rcx,inputEmp
	sub rsp,32
	call gets
	add rsp,32

	cmp [input],"*" ; comparo si el primer byte input es * no se si se puede
	je 	iniciarPromedio	;si es igual termino el loop

	mov rcx,msjIngI
	sub rsp,32
	call printf
	add rsp,32

	mov rcx,inputI
	sub rsp,32
	call gets
	add rsp,32

	mov rcx,msjIngJ
	sub rsp,32
	call printf
	add rsp,32

	mov rcx,inputJ
	sub rsp,32
	call gets
	add rsp,32

	call VALING
	cmp rax,1  ; Si es 1 algo salio mal y vuelvo al arranque del loop
	je ingTexto

	; Lo meto a la matriz
	mov rax,qword[j] ; AMuevo la fila que es
	imul rax,rax,15  ; Multiplico por la cantidad de elementos en cada fila
	add  rax,,qword[i]

	mov bx,numero ;Guardo en bx el numero a ingresar en la matriz
	mov word[matriz + rax*2],bx ; Guardo el numero en la matriz, el *2 es el desplazamiento que se necesitan para las word (2 bytes)
	jmp ingTexto    			;Salto obligatorio para loop

; Alumnos con padrón par: el valor promedio (entero) por cada columna de M.
; Padron 106226
iniciarPromedio:
	mov [i],0
	mov [j],0
	mov [sumatoriaFila],0

sumarCol:
	mov rax,[j]
	imul rax,rax,15 ;Cantidad de numeros en fila
	add rax,[i]    ;sumo posicion en fila

	add sumatoriaFila,word[matriz + rax * 2]

	inc qword[j]
	cmp qword[j],14
	jle sumarCol

	; Divido

	mov rax,[sumatoriaCol]
	mov rbx,15 ;cantidad de filas
	idiv rbx   ;deja promedio en rax

	;Imprimo por pantalla

	mov rcx,msjPromedio
	mov rdx,[i]     ; numero de col
	mov r8,rax		; promedio
	sub rsp,32
	call printf
	add rsp,32

	inc qword[i]
	cmp qword[i],14
	jle sumarCol   ; SI es menor o igual a 14 sigue estando en rango

fin:
    ret

;;;;;;;;;;;;;;;;;;;;
; Rutinas Internas ;
;;;;;;;;;;;;;;;;;;;;;
VALING:
	call validarEmpaquetado
	cmp rax,1
	je ingresoInvalido
	call validarCorI
	cmp rax,1
	je ingresoInvalido
	call validarCorJ
	cmp rax,1
	je ingresoInvalido

	mov rax,0
	ret
ingresoInvalido:
	; Muestro un pantalla que lo ingresado no es correcto
	mov rcx,msjError   
	sub rsp,32
	call printf
	add rsp,32
	mov rax,1 ; Me aseguro que se 1 aunque ya deberia serlo
	ret

validarEmpaquetado:
	mov rcx,inputEmp
	mov rdx,formatoEmp
	mov r8, numero
	mov r9, caracter
	sub rsp,32
	call sscanf
	add rsp,32

	cmp		rax,2			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		empaquetadoInvalido

	;Chequeo que el caracter sea valido
	;CAFE Positivo 
	cmp [caracter],"C"
	je empPositivo
	cmp [caracter],"A"
	je empPositivo
	cmp [caracter],"F"
	je empPositivo
	cmp [caracter],"E"
	je empPositivo

	;BD negativos 
	cmp [caracter],"B"
	je empNeg
	cmp [caracter],"D"
	je empNeg

empaquetadoInvalido
	mov rax,1
	ret

empNeg:
	mov bx,word[numero]
	imul bx,bx,-1  ; hago el numero negativo
	mov word[numero],bx
empPositivo:
	mov rax,0  ; retorno 0 esta bien
	ret

validarCorI:
	mov rcx,inputI
	mov rdx,formatoCor
	mov r8, i
	sub rsp,32
	call sscanf
	add rsp,32

	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		cordInvalida

	cmp qword[i],0 ;Valor mas bajo
	jl  cordInvalida
	cmp qword[i],14 ;Valor mas alto
	jg  cordInvalida

	mov rax,0
	ret

validarCorJ:
	mov rcx,inputJ
	mov rdx,formatoCor
	mov r8, j
	sub rsp,32
	call sscanf
	add rsp,32

	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		cordInvalida

	cmp qword[j],0 ;Valor mas bajo
	jl  cordInvalida
	cmp qword[j],14 ;Valor mas alto
	jg  cordInvalida

	mov rax,0
	ret

cordInvalida: 
	mov rax,1
	ret