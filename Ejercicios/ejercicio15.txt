;Ejercicio 15:
;Se lee de un archivo una serie de números en formato carácter de 3 bytes. Se pide
;realizar un programa que realice la sumatoria de esos números e informe el
;resultado por pantalla, indicando además la cantidad de números válidos e inválidos
;leídos del archivo.

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
extern fclose
extern fopen
extern fgets
section		.data
        file            db  "archivoejercicio15.txt",0
        mode            db  "r",0
        handle          dq  0
        msjApertura     db  "Archivo abrio correctamente.",10,0
        msjLeyendo      db  "Elemento leido.",10,0
        msjValidado     db  "Elemento validado.",10,0
        numeroFormat    db  "%hi",0
        msgFinal        db  "La cantidad de numeros validos es:%hi y la sumatoria de todos es:%hi",10,0

        reg  times 0 db ''
         numero     times 3 db ' '
         EOL        times 2 db ' '
section		.bss
        sumatoria   resw    1
        cantidad    resw    1
        resgistroValido resb 1
        datoValido      resb 1
        numNum          resw 1
    
section		.text
main:
    mov word[cantidad],0
    mov word[sumatoria],0
    ;abrir archivo
    mov rcx,file
    mov rdx,mode
    sub     rsp, 32 
    call fopen
    add     rsp, 32
    ;verificar si abrio bien
    cmp rax,0
    jle fin
    mov [handle],rax
    ;---------------------
mov rcx,msjApertura
sub rsp,32
call    printf
add rsp,32

leer: ;uso fgets porque con fread no puedo saber cuanto va a medir cada numero
    mov rcx,reg
    mov rdx,20 
    mov r8,[handle]
    sub     rsp, 32        
    call fgets					
    add     rsp, 32

    cmp rax,0
    jle cerrarArchivo

mov rcx,msjLeyendo
sub     rsp, 32        
call printf					
add     rsp, 32

    call validarRegistro
    cmp byte[resgistroValido],'N'
    je leer

mov rcx,msjValidado
sub     rsp, 32        
call printf					
add     rsp, 32
    mov rax,0
    mov ax,[numNum]
    inc word[cantidad]
    add word[sumatoria],ax
    jmp leer

cerrarArchivo:
    mov rcx,[handle]
    sub     rsp, 32 
    call fclose
    add     rsp, 32 

mov rcx,msgFinal
mov rdx,[cantidad]
mov r8,[sumatoria]
sub     rsp, 32        
call printf					
add     rsp, 32
fin:
ret
;------------------------
validarRegistro:
    mov byte[resgistroValido],'N'

    call validarNumero
    cmp byte[datoValido],'N'
    je  finValidarRegistro

    mov byte[resgistroValido],'S'
finValidarRegistro:
ret


validarNumero:
    mov byte[datoValido],'N'

    mov rcx,numero
    mov rdx,numeroFormat
    mov r8,numNum
    sub     rsp, 32        
    call sscanf					
    add     rsp, 32

    cmp rax,1
    jl final

    cmp word[numNum],-999
    jl  final
    cmp word[numNum],999
    jg  final

    mov byte[datoValido],'S'
final:
ret