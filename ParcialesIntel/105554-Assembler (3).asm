; Francisco Orquera Lorda
; 105554

global	main
extern  puts
extern  printf
extern  fopen
extern  fclose
extern  fread 
extern  sscanf
extern  fwrite

select .data
    fileName db "BENEFICIOS.dat",0
    modo db "rb",0
    msgErrorApertura db "Errora al abrir el archivo",0

    ; Registro archivo
    registroBeneficios times 0 db ""
    codigoEmp times 1 db " "
    codBenef times 2 db " "

    ; Matriz
    matriz  db  0,0,0,0,0
            db  0,0,0,0,0
			db  0,0,0,0,0
			db  0,0,0,0,0
			db  0,0,0,0,0
            db  0,0,0,0,0
            db  0,0,0,0,0
			db  0,0,0,0,0
			db  0,0,0,0,0
			db  0,0,0,0,0
    
    codBenefValidos db "SDKTVETRHF",0

    ; Para la segunda parte del ejercicio
    msgCodEmprUser db "Ingrese un codigo de empresa (entre 1 y 10): ",10,13,0
    codEmprUserForm db "%i",0

    msgOfreceTodosBeneficios db "Ofrece todos los beneficios",0
    msgNoOfreceTodosBeneficios db "No ofrece todos los beneficios",0

select.bss
    fileId resq 1
    regValido resb 1
    datoValido resb 1
    codBenPosCol resb 1
    desplaz resb 1
    codEmpUser resb 100
    codEmpUserNum resb 1

select .text

main:
    ; Abro el archivo
    mov rcx, fileName
    mov rdx, modo
    sub		rsp,32
	call	fopen
	add		rsp,32
    cmp rax, 0
    jle errorOpenFile
    mov [fileId], rax

    ; Leo el archivo y copio c/registro
    proxRegistro:
    mov rcx, registroBeneficios
    mov rdx, 3
    mov r8, 1 ; copio de a un registro
    mov r9, [fileId]
    sub		rsp,32  
	call    fread
	add		rsp,32
    cmp rax, 0
    jle eof

    call VALREG
    cmp byte[regValido], "N"
    je proxRegistro

    ; Si llego hasta aca el registro contiene datos validos
    call actualizarMatriz
    call proxRegistro


    ; Modifico la matriz
    actualizarMatriz:
    ; Desplazamiento 
    ; [(fila-1)*longFila]  + [(columna-1)*longElemento]
    ; longFila = longElemento * cantidad columnas
    mov rbx, 0

    mov bx, [codigoEmp]
    dec bx
    imul bx, bx, 5 ; 1 byte * 5 cols
    mov [desplaz], bx

    mov bx, [codBenPosCol]
    dec bx
    imul bx, bx, 1 ; cada elemento ocupa 1 byte
    add [desplaz], bx

    mov byte[matriz + desplaz], 1 ; significa que la empresa de esa fila ofrece el beneficio de esa col
                                  ; por lo tanto actualizo la celda con un 1 (lo ofrece) (en caso de que no lo ofrezca quedara en 0)
    
    ret

    ; Le pido al user que ingrese cod de Empresa
    beneficiosOfrecidos:
    codEmprInv:
    mov rcx, msgCodEmprUser
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, codEmpUser
    sub rsp, 32
    call gets
    add rsp, 32

    ; Paso a formato int porque codEmpUser tiene un Ascii
    mov rcx, codEmpUser
    mov rdx, codEmprUserForm
    mov r8, codEmpUserNum
    sub rsp, 32
    call sscanf
    add rsp, 32

    cmp rax, 1
    jl codEmprInv

    ; Como el codigo de empresa no debe ser validado (lo dice el enunciado) veo si ofrece todos los beneficios
    ; Desplazamiento 
    ; [(fila-1)*longFila]  + [(columna-1)*longElemento]
    ; longFila = longElemento * cantidad columnas
    mov rax, 1 ; lo voy a usar para iterar la columna

    ; Me posiciono en la fila que ingreso el user
    mov bx, [codEmpUserNum]
    dec bx
    imul bx, bx, 5 ; 1 byte * 5 cols
    mov [desplaz], bx

    mov rcx, 5 ; para el loop
    proxBenef:
    mov bx, [ax] ; va a empezar en la columna 0 para ir chequeando si es 0 o 1
    dec bx
    imul bx, bx, 1 ; cada elemento ocupa 1 byte
    add [desplaz], bx

    cmp byte[matriz + desplaz], 1
    jl noOfreceTodosBenef
    inc rax ; paso a la siguiente columna
    loop proxBenef

    ; Si llego aca significa que ofrece todos los beneficios
    mov rcx, msgOfreceTodosBeneficios
    sub rsp, 32
    call puts
    add rsp, 32
    ret

    noOfreceTodosBenef:
    mov rcx, msgNoOfreceTodosBeneficios
    sub rsp, 32
    call puts
    add rsp, 32
    ret

    ; Rutina Interna
    VALREG:
    mov byte[regValido], "N"

    call validarCodigoEmpresa
    cmp byte[datoValido], "N"
    jle finValidacionRegistro

    call validarCodigoBeneficio
    cmp byte[datoValido], "N"
    jle finValidacionRegistro

    mov byte[regValido], "S"
    
    finValidacionRegistro:
    ret

    validarCodigoEmpresa:
    mov byte[datoValido], "N"
    cmp byte[codigoEmp], 1
    jl codEmpInv
    cmp byte[codigoEmp], 10
    jg codEmpInv
    mov byte[datoValido], "S"
    codEmpInv:
    ret

    validarCodigoBeneficio:
    mov byte[datoValido], "S"
    mov rcx, 5 ; 5 iter del loop en total (1 para c/ beneficio)
    mov rbx, 0
    mov rax, 0 ; c/ lo uso para luego tener el numero de columna que corresponde

    sigBen:
    inc rax
    push rcx
    mov rcx, 2 ; cant a comparar
    lea rsi, [codBenef]
    lea rdi, [codBenefValidos + rbx]
    repe cmpsb
    je codBenOk
    pop rcx
    add rbx, 2
    loop sigBen
    mov byte[datoValido], "N"

    codBenOk:
    mov byte[codBenPosCol], al ; Num de columna para la matriz
    ret

    errorOpenFile:
    mov rcx, msgErrorApertura
    sub rsp, 32
    call puts
    add rsp, 32
    jmp finProg

    eof:
    mov rcx, [fileId]
    sub rsp, 32
    call fclose
    add rsp, 32
    call beneficiosOfrecidos

    finProg:
    ret