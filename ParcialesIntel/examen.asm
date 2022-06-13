global main
extern printf
extern gets
extern sscanf
extern fopen
extern fclose
extern fread


section     .data

filename   db   "CALEN.dat",0
modo       db   "rb",0
mens_error  db "Error al abrir el archivo",0
registo     times 0     db "" ;es una etiqueta, 
dia         times 2     db " "
semana     db   0   ;semana es un byte
descrip     times 20    db  " "
matriz      times 42    dw  0 ;matriz de 6*7 donde caada hueco tiene 2 bytes
dias        db  "DOLUMAMIJUVISA" ;tabla para validar dias
mensaje_pedir_semana    db  "ingrese la semana, entre 1 y 6",10,13,0
num_format   db     "%i" ;32 bits
mens_listado    db  "dia        - cant actividades",10,13,0
dias_Imprimir   db  "domingo    ",0
                db  "lunes      ",0
                db  "martes     ",0
                db  "miercoles  ",0
                db  "jueves     ",0
                db  "viernes    ",0
                db  "sabado     ",0

mens_cant_act   db  "%lli",10,13,0


section     .bss

puntero_file     resq    1 ;PUNTERO FILE
registro_valido resb    1 ;verificar que el registro que leo es valido
contador    resq    1

diabin      resb    1
num_convertido  resd    1
buffer      resb    100


section     .text
main:
    call    abrir_archivo
    cmp     qword[puntero_file], 0 ;compara el handle con el 0
    jle     error_open ;si el handle es menor o igual a 0, no se pudo abrir el archivo
    call    leer_archivo
    call    listar_actividades

fin_programa:
    ret       

abrir_archivo:

    mov     rcx,filename ;rcx tiene el nombre del archivo
    mov     rdx,modo ;rcx tiene el modo del archivo
    sub     rsp,32 ;para usar fopen
    call    fopen ;abre el archivo de rcx con el modo de rdx
    add     rsp,32 ;para usar fopen
    mov     qword[puntero_file], rax ;rax tiene el handle, lo movemos a nuestra variable
    ret

error_open:
    mov     rcx,mens_error ;el rcx tiene el mensaje de error
    sub     rsp,32 ;para usar printf
    call    printf ;imprime el error
    add     rsp,32 ;para usar printf
    jmp     fin_programa ;va si o si para cortar todo el programa

leer_archivo:

leer_registro:
    mov     rcx,registo ;lo guardamos en registro
    mov     rdx,23 ;el registro es de 23 bytes
    mov     r8,1 ;SOLO una secuencia de 23 bytes
    mov     r9,qword[puntero_file] ;handle
    sub     rsp,32 ;por usar fread
    call    fread ;leyo 23 bytes y los guardo en registro. rax tiene la cantidad de bytes leidos
    add     rsp,32 ;por usar fread
    cmp     rax,0 ;si no llego ni a leer un registro
    jle     eof ;rax <= 0. Fin del archivo
    call    VALCAL ;valida los datos, pedida por consigna. Deja su validez en registro_valido
    cmp     byte[registro_valido],'S' ;S es valido, N no valido
    jne     leer_registro ;si es diferente a S, es invalido, pasamos a la siguiente linea
    call    sumar_act
    jmp     leer_registro ;no es fin del archivo, volvemos a leer 


eof: ;ya se termino el archivo
    mov     rcx,qword[puntero_file] ;puntero file en rcx
    sub     rsp,32 ;para usar fclose
    call    fclose ;cierra lo de rcx
    add     rsp,32 ;para usar fclose
    ret

VALCAL:
    mov     rbx,0 ;inicializar desplazamiento en 0
    mov     rcx,7 ;7 dias de la semana, para el loop
    mov     rax,0 
validar_dia:
    inc     rax ;rax = rax +1. SI ES VALIDO, EN RAX TE QUEDA LA FILA
    mov     qword[contador],rcx ;lleva el 7 a contador
    mov     rcx,2 ;cantidad de bytes que voy a comparar. Son 2 letras, 2 bytes
    lea     rsi,[dia] ;origen de lo que voy a comparar. La direccion de dia
    lea     rdi,[dias + rbx] ;destino
    repe    cmpsb ;cmpsb compara memoria-memoria, usa repe. 
    mov     rcx,qword[contador] ;recupero el dia para el loop
    je      dia_valido ;si da 0, el dia es valido
    add     rbx,2 ;muevo 2 bytes, para buscar la siguiente letra
    loop    validar_dia ;contador/rcx - 1 y hace loop
    jmp     invalidar_registro ;ya termino el loop, es invalido


dia_valido:
    mov     byte[diabin],al ;uso solo el al, porque necesito que solo sea de un byte.
    cmp     byte[semana],1 ;compara con 1
    jl      invalidar_registro ;si es menor es invalido
    cmp     byte[semana],6 ;compara con 6
    jg      invalidar_registro ;si es mayor es invalido

validar_registro:
    mov     byte[registro_valido],'S' ;pongo que el registro es valido
    jmp     fin_validar    
    

invalidar_registro:
    mov     byte[registro_valido],'N' ;pongo el registro como invalido

fin_validar:
    ret

sumar_act:
    mov     rax,0 ;porque voy a toquetearlo todo
    sub     byte[diabin],1 ;diabin-1 porque se maneja entre 0 y 6
    mov     al,byte[diabin]
    mov     bl,2
    mul     bl  ;hace bl * al y lo guarda en ax (2 bytes * num_columna)
    mov     rdx,rax ;desplazzamineto columna en rdx

    sub     byte[semana],1 ;semana-1 porque se maneja entre 0 y 5
    mov     al,byte[semana] 
    mov     bl,14 ;cant columnas 7 * largo 2 bytes = 14 
    mul     bl ;hace bl * al y lo guarda en ax (14 bytes * num_fila)
    add     rax,rdx ;lugar que debo alterar se guarda en rax

    inc     word[matriz+rax] ;ese cuadrado + 1

    ret

listar_actividades:
ingreso_semana:
    mov     rcx,mensaje_pedir_semana ;pedir semana en rcx
    sub     rsp,32 ;para usar printf
    call    printf ;imprime rcx
    add     rsp,32 ;para usar printf
    mov     rcx,buffer ;rcx tiene el buffer
    sub     rsp,32 ;para usar gets
    call    gets ;guarda la entrada en buffer
    add     rsp,32 ;para usar gets
    mov     rcx,buffer ;lo que quiero convertir
    mov     rdx,num_format ;el formato que quiero
    mov     r8,num_convertido ;donde lo guardo
    sub     rsp,32 ;para usar sscanf
    call    sscanf ;transforma rcx en formato rdx y guarda en r8
    add     rsp,32 ;para usar sscanf
    cmp     rax,1 ;rax - 1
    jl      ingreso_semana ;si no es un numero lo que ingreso
    cmp     dword[num_convertido],1 ;verifico que el numero
    jl      ingreso_semana ;que haya ingresado es entre
    cmp     dword[num_convertido],6 ;1 y 6. Sino vuelvo a pedir
    jg      ingreso_semana ;NUM CONVERTIDO = SEMANA = FILA

    sub     dword[num_convertido],1 ;para trabajar entre 0 y 5
    mov     rax,0 ;pa tocarlo
    mov     eax,dword[num_convertido] ;eax tiene fila
    mov     bl,14 ; 7 columnas * 2 bytes
    mul     bl ; fila matriz queda en ax

    mov     rdi,rax ;paso el desplazamiento a rdi porque printf afecta
    mov     rcx,mens_listado ;rcx tiene mensaje listado
    sub     rsp,32 ; para usar printf
    call    printf 
    add     rsp,32 ;para usar printf

    mov     rcx,7 ;por los 7 dias
    mov     rsi,0 ;rsi para manipular la impresion de dias
    mov     rbx,0 ;donde voy a guardar lo que debo poner

mostrar:  
    mov     qword[contador],rcx ;guardo lo del loop en contador
    lea     rcx,[dias_Imprimir + rsi]
    sub     rsp,32 ;para usar printf
    call    printf ;imprimo el dia
    add     rsp,32 ;para usar printf

    mov     bx,word[matriz+rdi]
    mov     rcx,mens_cant_act
    mov     rdx,rbx
    sub     rsp,32 ;para usar printf
    call    printf ;imprimo la cant de actividades
    add     rsp,32 ;para usar printf

    add     rdi,2 ;avanzo a la siguiente columna, (el siguiente dia en matriz)
    add     rsi,12 ;POR EL LARGO DE CADA DIA_IMPRIMIR
    mov     rcx,qword[contador] ;recupero el contador
    loop mostrar
    ret


 

