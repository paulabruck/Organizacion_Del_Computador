global	main
extern	printf
extern	puts
extern  gets
extern  sscanf
extern fopen
extern fread
extern fclose

section		.data
    fileName            db  "ENCUESTA.dat",0
    mode                db  "rb",0;modo lectura de archivo binario
    msgErrorOpen        db  "Error al abrir el archivo.",0
    msgCandidatp        db  'Ingrese candidato (AF,MM,RL,SM) para saber ciudad con mayor intencion de voto:',0
    msgIntencion        db  'La ciudad con mayor intencion de voto para %s es: %s',10,0
    formatoLetra        db  '%s',0
    formatonumero       db  '%hi',10,0
    msjAperturaOk       db  "Apertura Ok.",0
    msjLeyendo          db  "Elemento leido.",0
    msjElemento         db  "Elemento Valido.",0

    registro            times 0 db ""
    candidato           times 2 db " "
    ciudad              db 0

    candidatos          db      "AF",0
                        db      "MM",0
                        db      "RL",0
                        db      "SM",0

    CiudadesImp     db  "Avellaneda         ",0
                    db  "Lanus              ",0
                    db  "Banfield           ",0
                    db  "Recoleta           ",0
                    db  "Palermo            ",0
                    db  "Belgrano           ",0
                    db  "Quilmes            ",0
                    db  "Saavedra           ",0
                    db  "Dock Sud           ",0
                    db  "Caballito          ",0

    matriz      dw 0,0,0,0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0,0,0,0
                dw 0,0,0,0,0,0,0,0,0,0
                ; 4 filas x 10 columnas
            
    section		.bss
    fileHandle          resq    1 
    esValid             resb    1
    contador            resq    1
    candidatoNum        resw    1
    candidatoString     resb    2
    ciudadAux           resw    1
    ciudadNum           resw    1
    NumCiudadMaxVotantes  resw    1
    buffer              resb    20
    nombreCiudad        resb    20

    section		.text
main:   
    call abrirArch

    cmp qword[fileHandle],0 ;Error en apertura?
    jle errorOpen

mov rcx,msjAperturaOk
sub     rsp, 32        
call puts					
add     rsp, 32

    call leerArch
    call mayorIntencion
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
;-----------------------------------------------------------------------------------
leerArch:
    mov rcx,registro    ;direccion de memoria donde se copia
    mov rdx,3          ;longitud registro
    mov r8,1            ;cantidad de registros
    mov r9,qword[fileHandle];handle del archivo
    sub rsp,32
    call fread
    add rsp,32

    cmp rax,0           ;fin del archivo?
    jle eof

mov rcx,msjLeyendo
sub     rsp, 32        
call puts					
add     rsp, 32

    call VALREG

    cmp byte[esValid],'S'
    jne leerArch  ;si no es

    mov rcx,msjElemento 
    sub     rsp, 32        
    call puts					
    add     rsp, 32

    call sumarVoto
    jmp leerArch

eof:
    ;cierro el archivo
    mov rcx,qword[fileHandle]
    sub rsp,32
    call fclose
    add rsp,32
ret
;---------------------------------------------------------------------------------
VALREG:
    mov rbx,0
    mov rcx,10 ;Indica los ciclos del loop
    mov rax,0
compCandidato:
    inc rax ;me guardo el numero de candidato (AF = 1, MM = 2, RL = 3, JM = 4)
    mov qword[contador],rcx ;Me lo guardo

    mov rcx,2
    lea rsi,[candidato]
    lea rdi,[candidatos+rbx]
    repe cmpsb
    mov rcx,qword[contador] ;Lo Recupero

    je candidatoValido
    add rbx,3
    loop compCandidato

    jmp invalido
candidatoValido:
    mov word[candidatoNum],ax
    cmp byte[ciudad],1
    jl  invalido
    cmp byte[ciudad],10
    jg  invalido

valido:
    mov byte[esValid],'S'

finValidar:
ret

invalido:
    mov byte[esValid],'N'
    jmp finValidar
;-------------------------------------------------------------------------------
sumarVoto:
    ;desplazamiento de una matriz
    ;(col -1)*L + (fil - 1)* L * cant. columnas
    mov rax,0
    mov rbx,0

    sub word[candidatoNum],1 ;(fila - 1)
    mov ax,word[candidatoNum]

    mov bx,20 ;(longitud = 2 * cant. columnas = 10)
    mul bx

    mov rdx,rax ;Me lo guardo porque lo voy a pisar

    mov rax,0
    sub byte[ciudad],1 ;(columna - 1)
    mov al,byte[ciudad]

    mov bl,2
    mul bl

    add rax,rdx ;junto ambos desplazamientos

    mov bx,word[matriz+rax] 
    inc bx
    mov word[matriz+rax],bx

ret
;------------------------------------------------------------------------------
mayorIntencion:
    mov	    rcx,msgCandidatp
    sub     rsp,32
    call    puts
    add     rsp,32

    mov	    rcx,buffer
	sub     rsp,32
    call    gets
    add     rsp,32

    mov		rcx,buffer		            ;Parametro 1: campo donde están los datos a leer
	mov		rdx,formatoLetra	        ;Parametro 2: dir del string q contiene los formatos
	mov		r8,candidatoString	        ;Parametro 3: dir del campo que recibirá el dato formateado
    sub     rsp,32	    
	call	sscanf
    add     rsp,32

    cmp rax,1
    jl mayorIntencion

    mov word[candidatoNum],0
    mov rax,0
    mov rcx,4
buscarNumeroCandidato:
    push rcx
    inc word[candidatoNum]
    mov rdx,0
    
    mov rcx,3
    lea rsi,[candidatoString]
    lea rdi,[candidatos+rax]
    repe cmpsb
    je candidatovalidado
    
    pop rcx
    add rax,3
    loop buscarNumeroCandidato

    jmp mayorIntencion
  
candidatovalidado:
    
    mov rcx,formatonumero
    mov rdx,[candidatoNum]
    sub     rsp, 32        
    call printf					
    add     rsp, 32
    
    mov rax,0
    mov rbx,0

    mov word[ciudadNum],1
    sub word[candidatoNum],1 ;(fila - 1)
    mov ax,word[candidatoNum]
    mov bx,20 ;(longitud = 2 * cant. columnas = 10)
    mul bx
    
    mov rbx,0
    mov bx,word[matriz+rax]
    mov word[ciudadAux],bx
    mov word[NumCiudadMaxVotantes],1

    add rax,2
    mov rcx,9
ciclo:
    inc word[ciudadNum]
    mov bx,word[matriz+rax]

    cmp bx,word[ciudadAux]
    jg swapMaximo
seguirCiclo:
    add rax,2
    loop ciclo

fin:
    mov rax,0
    mov rbx,0
    
    dec word[NumCiudadMaxVotantes]
    mov ax,word[NumCiudadMaxVotantes]
    mov bx,20 ;(longitud)
    mul bx

    mov rcx,20
    lea rsi,[CiudadesImp+rax]
    lea rdi,[nombreCiudad]
    rep movsb

    mov rcx,msgIntencion
    mov rdx,candidatoString
    mov r8,nombreCiudad
    sub rsp,32
    call    printf
    add rsp,32
ret

swapMaximo: 
    mov word[ciudadAux],bx 
    mov rbx,0
    mov bx,word[ciudadNum]
    mov word[NumCiudadMaxVotantes],bx
    jmp seguirCiclo

;--------------------------