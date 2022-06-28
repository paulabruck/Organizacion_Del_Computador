global  main

extern  puts
extern  printf
extern  gets    
extern  sscanf

section .data

    mensajeIngresoNumero        db      "Ingrese un numero en formato empaquetado conf. hexa...",0
    mensajeIngresoCoordenadas   db      "Ingrese valores i j...",0
    formatoCoordenadas          db      "%i %i",0

    matriz  times   225     dw  0 ; 12*12 elementos, de 2 bytes, inicialment todos en 0

    vectorLetrasValidas         db      "CAFEBD",0

    nroIngersadoString          db      "***",0
    nroIngresadoBPFcs           dw      0
    formatoNroIngresado         db      "%i",0

    mensajePromColumna          db      "Promedio de la columna ---> %i",0

section .bss

    ingresosValidos     resb    1   ;'S/N'
    datoValido          resb    1   ;'S/N' 

    ingresoNumero       resb    50
    longitudIngreso     resw    1
    letraIngreso        resb    1 ; guardo temporalmente la letra del empaquetado para evaluarla...

    ingresoCoordenadas  resb    50
    coordenadaI         resw    1
    coordenadaJ         resw    1

	desplaz			    resw	1
    fila                resw    1
    columna             resw    1
    sumatoria           resw    1


section .text
main:

    ; Mensaje  a usuario ingrese nro...
    mov     rcx,mensajeIngresoNumero
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,ingresoNumero
    sub     rsp,32
    call    gets
    add     rsp,32

    ; caso que el usuario quiera finalizar los ingresos...
	cmp	byte[ingresoNumero],'*'
	je	calcularPromedios

    ; Mensaje a usuario ingrese coordenadas...
    mov     rcx,mensajeIngresoCoordenadas
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,ingresoCoordenadas
    sub     rsp,32
    call    gets
    add     rsp,32

    ; tengo los ingresos del usuario, procedo a la validacion...
    call    VALING
    cmp     byte[ingresosValidos],'N'
    je      main ; en caso de que los ingresos no sean validos, pido que vuelva a ingresar...


    ; para este punto tengo todos los ingresos validados
    ; actualizo la matriz --->

actualizarMatriz:

    ; BUSCO DESPLAZAMIENTO DE LA MATRIZ! (posicion en la cual ubicar el nro ingresado...)
    ;  [(fila-1)*longFila]  + [(columna-1)*longElemento]
    ;  longFila = longElemento * cantidad columnas

	mov		bx,[coordenadaI] ; la coordenada i es el nro de la fila...
	sub		bx,1             ; le resto 1
	imul	bx,bx,30		 ;(multiplico por la longitud de la fila, seria 2bytes * 15 columnas) en bx tengo el desplazamiento a la fila

	mov		[desplaz],bx

	mov		bx,[coordenadaJ] ; la coordenada j es el nro de la columna...
	dec		bx
	imul	bx,bx,2			;(multiplico por la longirud de los elementos de M, 2 bytes)bx tengo el deplazamiento a la columna

	add		[desplaz],bx	; en desplaz tengo el desplazamiento final

    sub		ebx,ebx
    mov		bx,[desplaz] ; tenog en bx el desplazamiento...

    ; ahora que tengo la posicion, actualizo el valor...
    mov     rax,0 ; inicializo el rax en 0
    mov     ax,word[nroIngresadoBPFcs] ; paso al ax el valor a guardar
    mov     word[matriz + ebx],ax ; hago la transferencia

    ; se actualizo el valor correspondiente de la matriz, pido el siguiente ingreso...

finActualizarMatriz:
    jmp     main


calcularPromedios:

    ; PADRON: 106016 ---> calculo los promedios de las columnas
    ; hago la sumatoria de la columna y divido por 15
    ; tengo que sacar el promedio para las 15 columnas...

    ; me posiciono en la fila 1 columna 1

    ;arranco en fila 1 columna 1
    mov     word[fila],1
    mov     word[columna],1   

    mov     rcx,15 ;15 columnas

siguienteColumna:
    push    rcx  ; urtilizo instruccion push para no afectar la cntidad de columnas a promediar

    mov     rcx,15 ;15 elementos en la columna

sumarElemColumna:    

    call    calcularDesplaz
    sub		ebx,ebx
	mov		bx,[desplaz]

    mov		ax,word[matriz + ebx]
    add     word[sumatoria],ax ; primer valor de la columna sumado...

    ; paso a la siguiente fila
    add     word[fila],1
    loop    sumarElemColumna

    pop     rcx

    ;aca imprimo el promedio --->

    mov     ax,word[sumatoria]
    idiv    15

    push    rcx
    mov     rcx,mensajePromColumna
    mov     rdx,rax
    sub     rsp,32
    call    printf
    add     rsp,32
    pop     rcx

    add     word[columna],1 ; paso a la siguiente columna
    loop    siguienteColumna


finPrograma:
    ret


;------------------------------------------------------
;------------------------------------------------------
;   RUTINAS INTERNAS
;------------------------------------------------------
VALING:

    mov     byte[ingresosValidos],'N'

    call    validarNumero
    cmp     byte[datoValido],'N'
    je      finValidarIngresos

    call    validarCoordenadas
    cmp     byte[datoValido],'N'
    je      finValidarCoordenadas

    ; para este puntod de la secuencia se que tengo ingresos validos!
    mov     byte[ingresosValidos],'S'

finValidarIngresos:
    ret

; VALIDACION NUMERO --->
validarNumero:

    mov     byte[datoValido],'N'

    ; veo la longitud del ingreso...
    mov     rsi,0 ; uso rsi como indice
evaluarCaracter:

    ;evaluo que no sea el fin de la cadena. Si no es el fin, aumento en uno la longitud del ingreso...
    cmp     byte[ingresoNumero + rsi],0 

    je      finIngreso ;  En caso de que no haga ese jump, incremento en uno la longitud del texto
    inc     word[longitudIngreso]

    ; guardo ultimo caracter leido para dsps compararlo...
    ; transferencia memoria-memoria, uso movsb
    mov     rcx,1 ; se copia 1 byte
    lea     rsi,[ingresoNumero + rsi]
    lea     rdi,[letraIngreso] ; 
    rep     movsb

    ; aumento el indice y vuelvo a evaluar
    inc     rsi
    jmp     evaluarCaracter

finIngreso:

    ; para este punto tengo la longitud del ingreso...
    ; necesitamos que sea menor  o igual a 16 bits para que entre en la matriz...
    cmp     word[longitudIngreso],4 
    jg      finValidarNumero

    ; si la longitud es menor o igual a 4 ocupa menos de 16 bits

    ; ahora me fijo que el ultimo caracter sea C,A,F,E,B o D, si es otra letra, no es valido!
verificarLetra:
    mov     byte[datoValido],'S'; en princpio defino que el dato es valido
    ; comparo contra el vector de LETRAS validas...
	mov     rbx,0                       ;Utilizo rbx como puntero al vector LETRAS
	mov		rcx,6						;6 letras posibles

compararLetra:

    push    rcx ; utilizo instruccion push para no afectar el contador del ciclo...

    mov     rcx,1 ;comparo 1 byte
    lea     rsi,[letraIngreso]
    lea     rdi,[vectorLetrasValidas + rbx]
    repe	cmpsb

    pop     rcx

	je		letraValida
	add		rbx,1 ; me muevo 1 byte...

	loop	compararLetra

    ; para este punto de la secuencia se que tengo un dato NO valido...(no matcheoo ninguna letra...)
    mov     byte[datoValido],'N'
    jmp     finValidarNumero

letraValida:
    ; se que ocupa 16 bits (en empaquetado), y que la letra es valida, ahora intento buscar el valor absouluto
    ; almaceno el valor absoluto en word[nroIngresadoBPFcs] (no llego por cuestiones de tiempo, paso directo a actualizacion de matriz y funcinalidades de usuario (promedios)...)
finValidarNumero:
    ret

; VALIDACION COORDENADAS --->
validarCoordenadas:

    mov     byte[datoValido],'N'

    ; uso sscanf
    mov     rcx,ingresoCoordenadas
    mov     rdx,formatoCoordenadas
    mov     r8,coordenadaI
    mov     r9,coordenadaJ
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp		rax,2 ; me fijo en el registro RAX el resultado tras usar sscanf
	jl		finValidarCoordenadas

    ; ahora me fijo que esten entre los valores validos...
	cmp		word[coordenadaI],1
	jl		finValidarCoordenadas
	cmp		word[coordenadaI],15 ; en caso e que la fila o columa sea menor a 1 o mayor a 5...
	jg		finValidarCoordenadas

	cmp		word[coordenadaJ],1
	jl		finValidarCoordenadas
	cmp		word[coordenadaJ],15
	jg		finValidarCoordenadas

    ; para este punto de la secuencia se que tengo un dato valido...
    mov     byte[datoValido],'S'

finValidarCoordenadas:
    ret

calcularDesplaz:
    ;  [(fila-1)*longFila]  + [(columna-1)*longElemento]
    ;  longFila = longElemento * cantidad columnas

	mov		bx,[fila]
	sub		bx,1
	imul	bx,bx,10		;bx tengo el desplazamiento a la fila

	mov		[desplaz],bx

	mov		bx,[columna]
	dec		bx
	imul	bx,bx,2			; bx tengo el deplazamiento a la columna

	add		[desplaz],bx	; en desplaz tengo el desplazamiento final
ret