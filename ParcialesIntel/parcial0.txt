global	main
extern	printf
extern  gets
extern  sscanf
section		.data
    mensaje		db			"Ingrese un numero de fila (Entre 1 y 15):",0
    msjNroIng   db          "El numero ingresado es: %hi",10,0
    msjSumatoria   db       "El valor de la sumatoria es: %hi",10,0
    matriz          dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                    dw 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ;15 x 15
    
    formatInpuI  db      '%hi',0
section		.bss
    inputI      resb    50
    esValid     resb    1
    nroIng      resw    1
    colActual   resw    1
    sumatoria   resw    1

section		.text
main:
    call obtenerNumeroValido

    mov		rcx,msjNroIng
    mov     rdx,[nroIng]		
	sub     rsp, 32        
	call	printf				
	add     rsp, 32 

    mov word[sumatoria],0
    call primeradiagonal

    mov		rcx,msjSumatoria
    mov     rdx,[sumatoria]		
	sub     rsp, 32        
	call	printf				
	add     rsp, 32 
ret
;-----------------------------------------------------------------------------------------
;Rutinas Internas
;-----------------------------------------------------------------------------------------
obtenerNumeroValido:
    mov		rcx,mensaje		
	sub     rsp, 32        
	call	printf					
	add     rsp, 32 

    mov     rcx,inputI
    sub     rsp,32
    call    gets
    add     rsp,32

    mov rcx,inputI
    mov rdx,formatInpuI
    mov r8,nroIng
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl obtenerNumeroValido

    cmp word[nroIng],1
    jl obtenerNumeroValido
    cmp word[nroIng],15
    jg obtenerNumeroValido

ret
;-------------------------------------------------------------------------
primeradiagonal:
    mov rax,0
    mov rbx,0
    mov rdx,0
    mov word[colActual],1

    ;En numIng tengo el numero de fila en la que empiezo
primeraParte:

    cmp word[nroIng],15
    jg finPrimeraParte
    
    sub word[nroIng],1
    sub word[colActual],1

    mov ax,word[nroIng]

    mov bx,30 ;30 = cant. columnas(15) * longitud elementos(2)
    imul bx

    ;en Rax tengo el dezplazamiento necesario para iniciar
    mov rdx,rax
    
    
    mov ax,word[colActual]

    mov bx,2 ;longitud elemento
    imul bx

    add rax,rdx

    mov rbx,0
    mov bx,word[matriz+rax]
    add word[sumatoria],bx

    add word[nroIng],2
    add word[colActual],2
    jmp primeraParte

finPrimeraParte:
    sub word[nroIng],2 ;lo vuelvo al estado anterior a salir de la matriz
segundaParte: 
    cmp word[colActual],15
    jg finSegundaParte

    sub word[nroIng],1  ;resto uno mas para el siguiente movimiento
    mov ax,word[nroIng]

    mov bx,30 ;30 = cant. columnas(15) * longitud elementos(2)
    imul bx
    mov rdx,rax
    
    sub word[colActual],1
    mov ax,word[colActual]

    mov rbx,0
    mov bx,2 ;longitud elemento
    imul bx

    add rax,rdx
    mov bx,word[matriz+rax]
    add word[sumatoria],bx

    add word[colActual],2
    jmp segundaParte

finSegundaParte:
ret
;----------------------------------------------------------------------------------------