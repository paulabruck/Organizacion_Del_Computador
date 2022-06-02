global 	main
extern 	printf
extern	gets
extern puts
extern sscanf

section .data
    msgBienvenida               db  "~~Bienvenido al interprete de Binario de Punto Flotante IEEE 754 de precision simple~~", 0
    msgContinuacion             db  "~~A continuacion ingrese el numero que corresponde a la accion desea realizar~~", 0
    msgOpcion1                  db  "(1) Obtener notacion cientifica normalizada en base 2 de un numero almacenado en BPFlotante IEEE 754", 0
    msgOpcion2                  db  "(2) Obtener configuracion binaria o hexadecimal de un numero almacenado en BPFlotante IEEE 754", 0
    msgSubOpcion1               db  "~~Ingresar configuracion a interpretar~~",0
    msgSubOpcion11              db  "(1) Binaria",0
    msgSubOpcion12              db  "(2) Hexadecimal",0
    msgIngConf                  db  "~~Ingrese digito a digito por linea segun configuracion elegida~~",0     
    msgSubOpcion2               db  "~~Ingresar notacion cientifica a interpretar~~",0
    msgIngCoef                  db  "~~Ingresar Coeficiente:  ",0
    msgIngExpo                  db  "~~Ingresar exponente:  ",0
    msgConfSelec                db  "~~Ingresar configuracion a visualizar~~",0
    mensajeErrorOpcion  	    db  "@@ La opcion ingresada no es valida, por favor verifique de ingresar una valida @@",0
    msgenter                    db  " ",0
    posicion                    dq  1
    vectorHexa                  db  "0123456789ABCDEF"
    vector                      times 32 dq 1
    vectorResultado             times 32 dq 1
    msgLetrasMay                db  "(Ingresar las letras en Mayuscula)",0
    msgProxNum                  db  "~~Proximo Digito: ",0
    msgnumBina                  db  "~~Numero binario ingresado valido -------> ",0
    msgnumHexa                  db  "~~Numero hexadecimal ingresado valido -------> ",0
    msgNotCien                  db  "~~La Notacion cientifica normalizada en base 2 ingresada es ------->",0
    msgRNCBin                   db  "~~Resultado configuracion binaria~~",0
    numeroFormato               db  '%lli',0
    stringFormato               db  '%s',0
    msgBase                     db  " X10 ^ ",0
    msgcoma                     db  " , ",0
    contador                    dq 0
    Y2                          dq 0
    aux                         dq 0
    aux2                         dq 0

section .bss
    opcionIngresada     resb 1
    opcion              resb 1
    datoValido		    resb 1
    contador_ingreso    resb 0
    contador_print      resb 0
    inputNumeros        resb 50
   
    buffer  		    resb 1

section .text

main:
  

;----------------------------------------------------------------------;
; Brinda opciones al usuario para poder definir la accion a realizar   ;
;----------------------------------------------------------------------;
menu:
    mov  	rcx,msgBienvenida
	call 	puts

    mov  	rcx,msgContinuacion
	call 	puts

    mov  	rcx,msgOpcion1
	call 	puts

    mov  	rcx,msgOpcion2
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf
	
	cmp		rax,1
	jl		errorIngresoOpcion
    
	call 	validarOpcion

    cmp		word[opcion],1
    je      caso1

    cmp		word[opcion],2
    je      caso2

;-----------------------------------------------------------;
; Avisa al usuario el error y le pide que ingrese nuevamente;
;-----------------------------------------------------------;
errorIngresoOpcion:
	mov 	rcx,mensajeErrorOpcion
	call 	puts

    mov     rcx,msgenter
    call    puts

    jmp     menu
ret
;-----------------------------------------------------------;
; Valida si la opcion ingresada por el usuario es válida    ;
;-----------------------------------------------------------;
validarOpcion:
	cmp		word[opcion],1
	jl		errorIngresoOpcion
    
	cmp		word[opcion],2
	jg		errorIngresoOpcion
ret
;-----------------------------------------------------------;
; Valida si el numero ingresado es binario                  ;
;-----------------------------------------------------------;    
validarBinario:
    cmp word[opcion],1
    jne  sera0
ret
sera0:
    cmp word[opcion],0
    jne  errorIngresoOpcion
ret 
;-----------------------------------------------------------;
; Valida si el numero ingresado es hexadecimal              ;
;-----------------------------------------------------------; 
validarHexadecimal:
    cmp word[inputNumeros],'1'
    je  agregarHexaAVector

    cmp word[inputNumeros],'2'
    je  agregarHexaAVector

    cmp word[inputNumeros],'3'
    je  agregarHexaAVector

    cmp word[inputNumeros],'4'
    je  agregarHexaAVector

    cmp word[inputNumeros],'5'
    je  agregarHexaAVector

    cmp word[inputNumeros],'6'
    je  agregarHexaAVector

    cmp word[inputNumeros],'7'
    je  agregarHexaAVector
    jg  corroborarLetras
      
ret
corroborarLetras:
    cmp word[inputNumeros],'A'
    je  agregarHexaAVector

    cmp word[inputNumeros],'B'
    je  agregarHexaAVector

    cmp word[inputNumeros],'C'
    je  agregarHexaAVector

    cmp word[inputNumeros],'D'
    je  agregarHexaAVector

    cmp word[inputNumeros],'E'
    je  agregarHexaAVector

    cmp word[inputNumeros],'F'
    je  agregarHexaAVector

    jmp errorIngresoOpcion
ret
;-----------------------------------------------------------;
; visualizar configuracion en notacion cientifica           ;
;-----------------------------------------------------------; 
caso1:
    mov  	rcx,msgSubOpcion1
	call 	puts

    mov  	rcx,msgSubOpcion11
	call 	puts

    mov  	rcx,msgSubOpcion12
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf

	cmp		rax,1
	jl		errorIngresoOpcion

	call 	validarOpcion
   
    mov  	rcx,msgIngConf
	call 	puts
    
    cmp     word[opcion],1
    je      esBinario

    cmp     word[opcion],2
    je      esHexadecimal
;-----------------------------------------------------------;
; configuracion binaria a     notacion cientifica           ;
;-----------------------------------------------------------;
esBinario:
    mov rsi,0
ingresoBinario:
    cmp     rsi,256
    jge     binarioValido

	mov		rcx,msgProxNum	
	call	printf					

    mov     rcx,inputNumeros
    sub     rsp,32
    call    gets
    add     rsp,32

    mov rcx,inputNumeros
    mov rdx,numeroFormato
    mov r8,opcion
    call sscanf

    cmp rax,1
    jl errorIngresoOpcion
    call validarBinario
    jmp agregarAVector
ret
agregarAVector:
    mov rdi,[opcion]
    mov [vector+rsi],rdi

    add rsi,8

    jmp ingresoBinario
ret
binarioValido:
    mov     rsi,0
    mov		rcx,msgnumBina	
	call	printf	
printearNumeros:
    cmp  rsi,256
    jge  vectorPrinteado
    call  printGeneral
    jmp printearNumeros
vectorPrinteado:
ret
;-----------------------------------------------------------;
;  configuracion hexadeciaml a notacion cientifica          ;
;-----------------------------------------------------------;
esHexadecimal:
    mov rsi,0
    mov rcx, msgLetrasMay
    call puts
ingresoHexadecimal:
    cmp     rsi,32
    jge     hexadecimalValido

	mov		rcx,msgProxNum	
	call	printf					

    mov     rcx,inputNumeros
    call    gets

    mov     rcx, inputNumeros
    call    puts

    call validarHexadecimal

ret
agregarHexaAVector:
    mov qword[aux],4
    call rellenarVector
    jmp ingresoHexadecimal
ret
hexadecimalValido:
    mov     rsi,0
    mov		rcx,msgnumHexa	
	call	printf	
    jmp printearHexa
ret    
printearHexa:
    cmp rsi,32
    jge  vectorPrinteado

    mov rcx,stringFormato
    lea rdx,[vector+rsi]
    call    printf

    add rsi,4
    jmp printearHexa
vectorHexaPrinteado:
 ;   mov rsi,0
 ;   jmp convertirHexaABinario
ret
;aBinario:
;    cmp rdx,'1'
;    je  
;ret
;convertirHexaABinario:
;    cmp rsi,32
;    jge  vectorPrinteado

;    mov rcx,stringFormato
;    lea rdx,[vector+rsi]
;    call    aBinario
;    call    printf

;    add rsi,4
;    jmp convertirHexaABinario
;ret
;-----------------------------------------------------------;
; Pasar Notacion cientifica a configuracion                 ;
;-----------------------------------------------------------;
caso2:
    mov     rsi,0
    mov  	rcx,msgSubOpcion2
	call 	puts

ingresarCoeficiente:
    cmp     rsi,192
    jge     ingresarExponente
    mov  	rcx,msgIngCoef
	call 	printf

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf

	cmp		rax,1
	jl		errorIngresoOpcion
   ; call    validarBinario
    call    agregarNCAVector
    jmp     ingresarCoeficiente
    mov     rsi,192
    
ingresarExponente:

    cmp     rsi,224
    jge     printNCienti
    mov  	rcx,msgIngExpo
	call 	printf

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf

	cmp		rax,1
	jl		errorIngresoOpcion
    
    call    agregarNCAVector
    jmp     ingresarExponente
         
visualizar:
    mov     rcx,msgenter
    call    puts
    
    mov  	rcx,msgConfSelec
	call 	puts

    mov  	rcx,msgSubOpcion11
	call 	puts

    mov  	rcx,msgSubOpcion12
	call 	puts

    mov     rcx,opcionIngresada
    call    gets

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	call	sscanf

	cmp		rax,1
	jl		errorIngresoOpcion

    call    validarOpcion
    cmp     word[opcion],1
    je      aConfBinaria

    cmp     word[opcion],2
    je      aConfHexa
ret
agregarNCAVector:

    mov rdi,[opcion]
    mov [vector+rsi],rdi

    add rsi,8
ret   
signoNegativo:
    mov rsi,0
    mov rdi,1
    mov [vectorResultado+rsi],rdi
  ;  add rsi,8
    jmp printComa
ret
signoPositivo:
    mov rsi,0
    mov rdi,0
    mov [vectorResultado+rsi],rdi
   ; add rsi,8
   jmp printComa
ret
printNCienti:
    mov rcx, msgNotCien
    call printf
    mov rsi,0
printAntesComa:
    cmp rsi,8
    jge printComa
    call printGeneral
    cmp qword[vector+rsi],-1
    je signoNegativo
    cmp qword[vector+rsi],1
    je signoPositivo

printComa:
    mov rcx, msgcoma
    call printf
    mov rsi,8
    mov rbx,72
printCoef:
    cmp rsi,192
    jge  printBase
    call printGeneral
    
    mov rdi,[vector+rsi]
    mov qword[vectorResultado+rbx],rdi

    add rbx,8
    jmp printCoef
printBase:
    mov rcx, msgBase
    call printf
    mov rsi,192
printExpo:
    cmp rsi,224
    jge  visualizar
    call printGeneral
    jmp printExpo
printFin:
ret
aConfBinaria:
    mov rsi,216
  ;  mov qword[contador],0
calcularExpoExceso:
;-----------------------------------------------------------;
; Pasar binario a  decimal                                  ;
;-----------------------------------------------------------;
pasarBinaADec:
    cmp rsi,184    
    jle expoExceso
    mov rcx, numeroFormato
    mov rdx,qword[vector+rsi]
   ; call printf
    cmp qword[vector+rsi],0
    je  avanzo
    cmp qword[vector+rsi],1
    je  cont
cont:
    mov rcx, qword[aux2]
    mov qword[Y2],rcx

    cmp qword[aux2],0
    je  elevadoA0
    cmp qword[aux2],1
    je  elevadoA1
    mov r8,2
    mov r9,2
    jmp potencia
elevadoA0:
    inc qword[aux]
    jmp avanzo
ret
elevadoA1:
    add qword[aux],2
    jmp avanzo
ret   
potencia:
    imul r8,r9
    dec qword[aux2]
    cmp qword[aux2],1
    jne  potencia
    add qword[aux],r8
    
avanzo:   
    mov rcx, qword[Y2]
    mov qword[aux2],rcx
    add qword[aux2],1
 
sig:    
    sub rsi,8
    jmp calcularExpoExceso
ret    
expoExceso:
    mov rcx, numeroFormato
    mov rdx,qword[aux]
   ; call printf

    add qword[aux],127
    mov rcx, numeroFormato
    mov rdx,qword[aux]
  ;  call printf
 
pasarDecABina:
    mov qword[aux2],2
    mov rsi,0
    mov rbx,8
 ;   mov rcx, numeroFormato
  ;  mov rdx,qword[aux2]
   ; call printf

   ; mov rcx, numeroFormato
    ;mov rdx,qword[aux]
    ;call printf

   
divido:    
    cmp     qword[aux],2
    jl      termine
    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 
  ;  mov     qword[Y2],rdx
    inc     qword[contador]

    mov qword[aux],rax
  ;  mov rcx, numeroFormato
   ; mov rdx,rdx;qword[Y2]
    ;call printf
    ;mov rcx, msgenter
    ;call puts
    mov rdi,rdx
    mov [vector+rsi],rdi
    
    add rsi,8
    jmp divido
termine:
 ;   mov rcx, numeroFormato
  ;  mov rdx, qword[aux]
   ; call printf
   mov rdi,qword[aux]
    mov [vector+rsi],rdi
    add rsi,8
     mov rcx, msgenter
    call puts
    mov rcx, numeroFormato
    mov rdx, qword[contador]
   ; call printf
    mov rsi,56
    mov rbx,8
ver:
    cmp rsi, 0
    jl aConfHexa
    mov     rcx,numeroFormato
    mov     rdx,[vector+rsi]
    mov [vectorResultado+rbx],rdx
    add rbx,8
   ; call    printf
    sub rsi,8
    jmp ver
ret
aConfHexa:
    mov rsi,0
    mov rcx, msgRNCBin
    call puts
ver2:
    cmp rsi, 256
    jge end
    mov     rcx,numeroFormato
    mov     rdx,[vectorResultado+rsi]
    call    printf
    add rsi,8
    jmp ver2
ret
end:
ret
printGeneral:
    mov     rcx,numeroFormato
    mov     rdx,[vector+rsi]
    call    printf

    add rsi,8
ret
rellenarVector:
    mov rdi,[inputNumeros]
    mov [vector+rsi],rdi

    add rsi,qword[aux]
ret
yo:
add qword[aux],2
    mov rcx, numeroFormato
    mov rdx,qword[aux]
    call printf