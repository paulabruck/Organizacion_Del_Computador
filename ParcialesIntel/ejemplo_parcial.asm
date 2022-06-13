;Numero de padron 103320

global main
extern sscanf
extern fopen
extern fread
extern fclose
extern printf
extern gets

section .data
    ; Definicion del archivo binario
    filename        db  "vacunacion.dat",0
    mode            db  "rb",0  ; modo lectura del archivo binario
    msjError        db  "Error en la apertura del archivo",0

    ; Registro del archivo
    registro        times 0         db ""
    dni                             dd 0 
    codigoProvincia                 db 0
    edad                            db 0

    ; Matriz
    matriz          times 96        dd 0

    poblacionVacunada               dq 0

    msgIngresoCodProvincia          db "Ingrese un codigo de provincia [1 a 24]: ",10,0

    msgIngresoPoblacion             db "Ingrese la cantidad de poblacion de la provincia: ",10,0

    formatoNumero                   db  "%lli" 

    msgSeVacunoMasDeLaMitad         db  "Se vacuno mas del 50% de la poblacion",10,0

    msgSeVacunoMenosDeLaMitad       db  "Se vacuno menos del 50% de la poblacion",10,0


section .bss

    fileHandle      resq    1
    esValido        resb    1
    rangoEtario     resb    1
    buffer          resb    5
    codIngresado    resb    1
    poblacionProv   resq    1

section .text

main:
    call abrirArchivo

    cmp     qword[fileHandle],0
    jle     errorOpen

    call    leerArchivo
    call    listar

finpgm:
    ret

abrirArchivo:
    mov     rcx,filename
    mov     rdx,mode
    call    fopen

    mov     qword[fileHandle],rax

    ret

errorOpen:
    mov     rcx,msjError
    call    printf

    jmp     finpgm

leerArchivo:

leerRegistro:
    mov     rcx,registro
    mov     rdx,6
    mov     r8,1
    mov     r9,qword[fileHandle]
    call    fread

    cmp     rax,0
    jle     eof

    call    VALREG

    cmp     byte[esValido],'S'
    jne     leerRegistro

    call    cargarDatos

    jmp     leerRegistro

eof:
    mov     rcx,qword[fileHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32

    ret

VALREG:
    ; verifico que la edad no sea menor al rango minimo y verifico los rangos etarios
    mov     al,0
    cmp     byte[edad],35
    jl      invalido
    cmp     byte[edad],40
    jl      rangoEtario1
    cmp     byte[edad],50
    jl      rangoEtario2
    cmp     byte[edad],60
    jl      rangoEtario3
    cmp     byte[edad],60
    jg      rangoEtario4

rangoEtario4:
    inc     al

rangoEtario3:
    inc     al

rangoEtario2:
    inc     al

rangoEtario1:
    inc     al
    mov     byte[rangoEtario],al

    ; verifico el codigo de provincia
    cmp     byte[codigoProvincia],1
    jle     invalido
    cmp     byte[codigoProvincia],24
    jg      invalido

valido:
    mov     byte[esValido],'S'

finValidar:
    ret

invalido:
    mov     byte[esValido],'N'
    jmp     finValidar


cargarDatos:
    ;desplazamiento de una matriz
    ; (col - 1) * L + (fil - 1) * L * cantidad de columnas
    ; [ Desplaz. columnas] + [Desplaz. filas]
    mov     rax,0
    mov     rbx,0

    mov     al,byte[rangoEtario]    ;cargo el rango etario en el al
    dec     al                      ; decremento en uno el al (col -1)

    mov     bl,4
    mul     bl

    mov     rdx,rax

    mov     al,byte[codigoProvincia]        ; cargo el codigo de provincia en el al
    dec     al                              ; decremento en uno el al (col -1)

    mov     bl,16                           ; muevo al bl 16 (cantidad columnas (4) x long elemento (4))
    mul     bl

    add     rax,rdx

    mov     ebx,dword[matriz + eax]         ; obtengo la cantidad de personas de un rango etario vacunadas en una provincia
    inc     ebx                             ; sumo 1
    mov     dword[matriz + eax],ebx         ; vuelvo a actualizar la cantidad de personas de un rango etario vacunadas en una provincia

    ret

listar:
    ; Pido codigo de provincia
    mov     rcx,msgIngresoCodProvincia
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,buffer
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,buffer 
    mov     rdx,formatoNumero 
    mov     r8,codIngresado  
    sub     rsp,32
    call    sscanf
    add     rsp,32

    ; Pido cantidad de poblacion
    mov     rcx,msgIngresoPoblacion
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,buffer
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,buffer 
    mov     rdx,formatoNumero 
    mov     r8,poblacionProv  
    sub     rsp,32
    call    sscanf
    add     rsp,32

    ; Calculo si se vacuno mas del 50% de la poblacion en esa provincia

    ; Busco la provincia en la matriz

    ; Desplazamiento de una matriz
    ; (col - 1) * L + (fil - 1) * L * cantidad de columnas
    ; [ Desplaz. columnas] + [Desplaz. filas]

    mov     rax,0
    mov     rbx,0

    mov     al,byte[codIngresado]        ; cargo el codigo de provincia ingresado en el al
    dec     al 

    mov     bl,16                       ; muevo al bl 16 (cantidad columnas (4) x long elemento (4))
    mul     bl                          ; me queda el resultado guardado en el al

    ; ahora itero por la fila como si fuera un vector y hago la suma total de todos los rangos etarios

    mov     rcx,4       ;muevo al rcx 4 que es la cantidad de columnas de la matriz para poder hacer el loop
sumarFila:
    mov     ebx,dword[matriz + rax]
    add     qword[poblacionVacunada],rbx
    add     rax,4           ;sumo 4 al rax por que los elementos de la matriz son de 4 bytes
    loop    sumarFila

    ;saco el porcentaje de la poblacion vacunada en la provincia
    mov     rdx,0
    mov     rax,0
    imul     rax,qword[poblacionVacunada],100

    mov     rbx,qword[poblacionProv]

    div     rbx  ;tengo el resultado en el rax

    cmp     rax,50
    jg      seVacunoMasDel50
    ; si el valor de rax es menor imprimo directamente que se vacuno menos de la mitad de la poblacion
    mov     rcx,msgSeVacunoMenosDeLaMitad
    sub     rsp,32
    call    printf
    add     rsp,32
    ret

seVacunoMasDel50:
    mov     rcx,msgSeVacunoMasDeLaMitad
    sub     rsp,32
    call    printf
    add     rsp,32
    ret
