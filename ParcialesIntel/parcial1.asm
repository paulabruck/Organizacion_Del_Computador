;Se dispone una matriz C que representa un calendario de actividades de una persona
;La matriz C está formada por 7 columnas (que corresponden a los dias de la semana)
;y por 6 filas (que corresponden a las semanas que puede tenes como maximo un mes)
;Cada elemento de la matriz es un bpf s/signo de 2 bytes (word)
;representa la cantidad de actividades que realizara dicho dia en la semana.
;Ademas se dispone de un archivo de entrada llamado CALEN.DAT donde cada registro tiene el siguiente formato:
;-Dia de la semana: caracter de 2 bytes (DO, LU, MA, MI, JU, VI, SA)
;-Semana: Binario de 1 byte (1 a 6)
;-Actividad: Caracteres de longitud 20 con la descripcion
;Como la informacion leida del archivo puede ser erronea,
;se dispone de una rutina interna llamada VALCAL para su validacion.
;Se pide realizarun programa assembler intel x86 que actualize lamatriz C con aquellos registros validos.
;Al finalizar la actualizacion se solicitara el ingreso por teclado 
;y se debe generar un listado indicando "Dia de la semana - Cantidad de Actividades"

global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
extern fopen
extern fread
extern fclose
section		.data
    fileName    db  "CALEN.dat",0
    mode        db  "rb",0;modo lectura de archivo binario
    msgErrorOpen db "Error al abrir el archivo.",0
    
    registro    times 0 db ""
    dia         times 2 db " "
    semana              db 0
    descrip     times 20 db " "

    dias        db  "DOLUMAMIJUVISA"

    diasImp     db  "Domingo       ",0
                db  "Lunes         ",0
                db  "Martes        ",0
                db  "Miercoles     ",0
                db  "Jueves        ",0
                db  "Viernes       ",0
                db  "Sabado        ",0

    matriz      dw 0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0

    msgSemana   db  'Ingrese la semana [1...6]:',10,13,0
    msgEnc      db  'Dia        -   Cant.Act',10,13,0
    numFormat   db  '%i' ;%i 32 bits /%lli 64 bits
    msgCant     db  '%d',10,13,0

section		.bss
    fileHandle  resq    1 
    esValid     resb    1
    diaBin      resb    1
    nroIng      resd    1
    contador    resq    1
    buffer      resb    10

section		.text
main:
    call abrirArch

    cmp qword[fileHandle],0 ;Error en apertura?
    jle errorOpen

    call leerArch
    call listar
endProg:
ret

errorOpen:
mov rcx,msgErrorOpen
sub rsp,32
call printf
add rsp,32

    jmp endProg

;-----------------------------------------------------------------------------------------
;Rutinas Internas
;-----------------------------------------------------------------------------------------
abrirArch:
    mov rcx,fileName
    mov rdx,mode
    sub rsp,32
    call fopen
    add rsp,32
    mov qword[fileHandle],rax

ret

leerArch:
    mov rcx,registro    ;direccion de memoria donde se copia
    mov rdx,23          ;longitud registro
    mov r8,1            ;cantidad de registros
    mov r9,qword[fileHandle];handle del archivo
    sub rsp,32
    call fread
    add rsp,32

    cmp rax,0           ;fin del archivo?
    jle eof

    call VALCAL

    cmp byte[esValid],'S'
    jne leerArch  ;si no es

    ;Actualizar la actividad leida del archivo matriz
    call sumarAct

    jmp leerArch

eof:
    ;cierro el archivo
    mov rcx,qword[fileHandle]
    sub rsp,32
    call fclose
    add rsp,32
ret

VALCAL:
    mov rbx,0
    mov rcx,7 ;Indica los ciclos del loop
    mov rax,0
compDia:
    inc rax
    mov qword[contador],rcx ;Me lo guardo

    mov rcx,2
    lea rsi,[dia]
    lea rdi,[dias+rbx]
    repe cmpsb
    mov rcx,qword[contador] ;Lo Recupero

    je diaValido
    add rbx,2
    loop compDia

    jmp invalido

diaValido:
    mov byte[diaBin],al
    cmp byte[semana],1
    jl  invalido
    cmp byte[semana],6
    jg  invalido

valido:
    mov byte[esValid],'S'

finValidar:
ret

invalido:
    mov byte[esValid],'N'
    jmp finValidar

sumarAct:
    ;desplazamiento de una matriz
    ;(col -1)*L + (fil - 1)* L * cant. columnas
    mov rax,0
    mov rbx,0
    
    sub byte[diaBin],1      ;diabin tiene el n* de columna
    mov al,byte[diaBin]     ;Le resto 1
                            ;En rax queda la columna de la matriz
    mov bl,2                 
    mul bl                  ;Multiplica rax(columnas) por bl (2) --> resultado en ax

    mov rdx,rax             ;Me lo guado en rdx mientras miro la segunda parte
    
    mov rax,0
    sub byte[semana],1      ;fil - 1
    mov al,byte[semana]

    mov bl,14               ;7 cols * 2 longitud = 14
    mul bl                  ; resultado a --> rax

    add rax,rdx             ;junto ambos desplazamientos

    mov bx,[matriz+rax] ;Pongo en bx la cant de actividades que tiene la matriz
    inc bx                  ;Le sumo 1
    mov word[matriz+rax],bx ;Actualizo valor en matriz

ret

listar:
ingresoSemana:
    mov rcx,msgSemana
    sub rsp,32
    call printf
    add rsp,32

    mov rcx,buffer
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,buffer
    mov rdx,numFormat
    mov r8,nroIng
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax,1
    jl ingresoSemana

    cmp dword[nroIng],1
    jl ingresoSemana
    cmp dword[nroIng],6
    jg ingresoSemana


    sub dword[nroIng],1     ;fila -1

    mov rax,0
    mov eax,dword[nroIng]

    mov bl,14
    mul bl

    mov rdi,rax             ;printf va a pisar rax, por eso lo guardo en rdi

    mov rcx,msgEnc
    sub rsp,32
    call printf
    add rsp,32

    mov rcx,7
    mov rsi,0
    mov rbx,0
mostrar:
    mov qword[contador],rcx ;Me lo guardo

    lea rcx,[diasImp+rsi]
    sub rsp,32
    call printf
    add rsp,32

    mov bx,word[matriz+rdi]

    mov rcx,msgCant
    mov rdx,rbx
    sub rsp,32
    call printf
    add rsp,32

    add rdi,2
    add rsi,15

    mov rcx,qword[contador];Lo recupero
    loop mostrar

ret