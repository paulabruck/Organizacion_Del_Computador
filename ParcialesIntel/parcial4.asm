;Realizar una rutina interna que reciba como parámetro un campo PACK en formato
;de Decimal Empaquetado de 2 bytes y devuelva en un campo RESULT en formato
;carácter de 1 byte, indicando una ‘S’ en caso que sea un empaquetado válido, y en
;caso contrario una ‘N’.
global main
extern puts
extern gets
extern printf
extern sscanf

section .data


    matriz times 225 dw 0
    msjIngFilCol db "Ingrese fila (1 a 15) y columna (1 a 15) separados por un espacio. * para terminar: ",0
    msjIngreso db "Ingrese Empaquetado sin 0 al principio (123A, no 0123A): ",0,10
    RESULT db "N",0

    mensajePromFila         db      "Promedio de la Fila ---> %hi",10,0
    
    formato db "%hi%s",10,0
    numeroFormato db "%hi",10,0

    formatInputFilCol	db	"%hi %hi",0,10
    hola db "hola",10,0
    longTexto dq 0
    longCaracter dq 0
    contador dq 1
    letras db "ABCDEF",0
    numero0 db "0",0
    otroNumero dw 15
    numeroFinal dw 0

    filaSumatoria dw 1
    columnaSumatoria dw 1

    sumatoriaFil dw 0

    
    


section .bss
    

    desplaz			    resw	1
    promedioFil resw 1

    fila_actual resw 1
    columna_actual resw 1

    inputFilCol resb 50

    fila resw 1
    columna resw 1


    empaquetado resb 500
    empaquetadoSinCeros resb 500
    numero resw 1
    caracter resb 0
    numeroPrint resw 1

section .text
main:
    call ingresoFilColYEmpaquetado

    cmp byte[empaquetado], "*"
    je calcularSumatoriaPorFila
    
    cmp byte[RESULT], "N"
    je main

    call meterNumeroMatriz
    jmp main


calcularSumatoriaPorFila:
    
    mov word[sumatoriaFil],0
    call MoverseEnLaFila
    sub rdx,rdx
    mov ax,word[sumatoriaFil]
    mov bx,word[otroNumero]
    idiv bx
    mov word[numeroFinal],ax

    mov rcx,mensajePromFila
    mov dx,[numeroFinal]
    sub rsp,32
    call printf
    add rsp,32

    add word[filaSumatoria],1
    mov word[columnaSumatoria],1
    add qword[contador],1
    cmp qword[contador],16
    jl calcularSumatoriaPorFila
    jmp fin

MoverseEnLaFila:
    mov rcx,15
calcDesplazSumatoria:
    mov bx,[filaSumatoria]
    sub bx,1
    imul bx,bx,30

    mov [desplaz],bx
    mov bx,[columnaSumatoria]
    dec		bx
	imul	bx,bx,2
    add [desplaz],bx
    sub ebx,ebx
    mov bx,[desplaz]

    mov ax, word[matriz + ebx]
    add word[sumatoriaFil],ax
    add word[columnaSumatoria],1
    loop calcDesplazSumatoria





fin:
    


ret

meterNumeroMatriz:
    mov rax,qword[fila]
    mov qword[fila_actual],rax
    mov rax,qword[columna]
    mov qword[columna_actual],rax
    call calcDesplaz
    mov ax, word[numero]
    mov word[matriz + ebx],ax
ret


ingresoFilColYEmpaquetado:

    mov rcx,msjIngFilCol
    sub rsp,32
    call puts
    add rsp,32

    mov rcx,inputFilCol
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,msjIngreso
    sub rsp,32
    call puts
    add rsp,32

    mov rcx, empaquetado
    sub rsp,32
    call gets
    add rsp,32

    

    



    
veriSiTiene0AlPrincio:
    mov al, byte[numero0]
    cmp byte[empaquetado + 0],al
    je invalido

validar:
    mov		rcx,inputFilCol
	mov		rdx,formatInputFilCol
	mov		r8,fila
	mov		r9,columna
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp		rax,2
	jl		invalido

    cmp		word[fila],1
	jl		invalido
	cmp		word[fila],15
	jg		invalido

	cmp		word[columna],1
	jl		invalido
	cmp		word[columna],15
	jg		invalido


    mov rcx, empaquetado
    mov rdx, formato
    mov r8, numero
    mov r9, caracter
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,2
    jl invalido
    
largoSigno:
    mov qword[longCaracter],0
    mov rsi,0
compCaracter:
    cmp byte[caracter+rsi],0
    je verificarLongitud
    inc qword[longCaracter]
sigCaracter:
    inc rsi
    jmp compCaracter

verificarLongitud:
    cmp qword[longCaracter],1
    jg invalido

CambiarSigno:
    cmp byte[caracter],"C"
	je volver
	cmp byte[caracter],"A"
	je volver
	cmp byte[caracter],"F"
	je volver
	cmp byte[caracter],"E"
	je volver

	;BD negativos 
	cmp byte[caracter],"B"
	je empNeg
	cmp byte[caracter],"D"
	je empNeg

    
    jmp volver
    


invalido:
    
ret

empPositivo:
    jmp volver

empNeg:
    mov ax, word[numero]
    imul ax,-1
    mov word[numero],ax
volver:
    mov byte[RESULT],"S"
ret

calcDesplaz:
    mov		ax,[fila_actual]
	dec		ax
	imul	ax,ax,30		;bx tengo el desplazamiento a la fila

	mov		bx,ax

	mov		ax,[columna_actual]
	dec		ax
	imul	ax,2
    add bx,ax

ret