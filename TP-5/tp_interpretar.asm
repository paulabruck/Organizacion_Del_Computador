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
    msgInfoEspacio              db  "(SI NO SE INGRESA UN DIGITO SE CONSIDERARA COMO UN 1 EN CASO DE SER EL PRIMER DIGITO O COMO EL ULTIMO DIGITO INGRESADO)",0  
    msgSubOpcion2               db  "~~Ingresar notacion cientifica a interpretar~~",0
    msgIngCoef                  db  "~~Ingresar Coeficiente:  ",0
    msgIngExpo                  db  "~~Ingresar exponente:  ",0
    msgConfSelec                db  "~~Ingresar configuracion a visualizar~~",0
    mensajeErrorOpcion  	    db  "@@ La opcion ingresada no es valida, por favor verifique de ingresar una valida @@",0
    msgLetrasMay                db  "(Ingresar las letras en Mayuscula)",0
    msgProxDigi                 db  "~~Proximo Digito: ",0
    msgnumBina                  db  "~~Numero binario ingresado valido -------> ",0
    msgnumHexa                  db  "~~Numero hexadecimal ingresado valido -------> ",0
    msgNotCien                  db  "~~La Notacion cientifica normalizada en base 2 ingresada es ------->",0
    msgRNCBin                   db  "~~Resultado configuracion binaria~~",0
    msgRNCHexa                  db  "~~Resultado configuracion Hexadecimal~~",0
    msgRBANC                    db  "~~Resultado Notacion cinetifica~~",0
    numeroFormato               db  '%lli',0
    stringFormato               db  '%s',0
    msgBase                     db  " X10 ^ ",0
    msgcoma                     db  " , ",0
    msgenter                    db  " ",0
    contador                    dq  0
    aux0                        dq  0
    aux                         dq  0
    aux2                        dq  0
    param                       dq  0
    param1                      dq  0
    vectorHexa                  times 32 dq 1
    vector                      times 32 dq 1
    vectorResultado             times 32 dq 1
    vectorAux                   times 32 dq 1
    vectorNuevo                 times 32 dq 1
 
section .bss
    opcionIngresada     resb 1
    opcion              resb 1
    inputNumeros        resb 50

section .text

main:
    jmp     menu 
accionARealizar:
    cmp	    qword[opcion],1
    je      accion1

    cmp		qword[opcion],2
    je      accion2    
ret
;----------------------------------------------------------------------;
; Brinda opciones al usuario para poder definir la accion a realizar   ;
;----------------------------------------------------------------------;
menu:
    mov  	rcx,msgenter
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgBienvenida
    sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgContinuacion
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgOpcion1
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgOpcion2
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov     rcx,opcionIngresada
    sub     rsp,32
    call    gets
    add     rsp,32

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
    sub     rsp,32
	call	sscanf
    add     rsp,32
	
	cmp		rax,1
	jl		errorIngresoOpcion
    
	call 	validarOpcion
    
    jmp     accionARealizar
ret
;-----------------------------------------------------------;
; Avisa al usuario el error y le pide que ingrese nuevamente;
;-----------------------------------------------------------;
errorIngresoOpcion:
	mov 	rcx,mensajeErrorOpcion
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov     rcx,msgenter
    sub     rsp,32
    call    puts
    add     rsp,32

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

    cmp word[inputNumeros],'8'
    je  agregarHexaAVector

    cmp word[inputNumeros],'9'
    je  agregarHexaAVector

    cmp word[inputNumeros],'0'
    je  agregarHexaAVector

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
accion1:
    mov  	rcx,msgenter
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgSubOpcion1
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgSubOpcion11
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgSubOpcion12
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov     rcx,opcionIngresada
    sub     rsp,32
    call    gets
    add     rsp,32

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	sub     rsp,32
	call	sscanf
    add     rsp,32

	cmp		rax,1
	jl		errorIngresoOpcion

	call 	validarOpcion
   
    mov  	rcx,msgenter
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgIngConf
	sub     rsp,32
	call 	puts
    add     rsp,32
    
    cmp     word[opcion],1
    je      esBinario

    cmp     word[opcion],2
    je      esHexadecimal
;-----------------------------------------------------------;
; configuracion binaria a notacion cientifica               ;
;-----------------------------------------------------------;
esBinario:
    mov  	rcx,msgInfoEspacio
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov     rsi,0
ingresoBinario:
    cmp     rsi,256
    jge     binarioValido

	mov		rcx,msgProxDigi	
    sub     rsp,32
	call	printf	
    add     rsp,32				

    mov     rcx,inputNumeros
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,inputNumeros
    mov     rdx,numeroFormato
    mov     r8,opcion
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,1
    jl      errorIngresoOpcion

    call    validarBinario

    jmp     agregarAVector
ret
agregarAVector:
    mov     rdi,[opcion]
    mov     [vector+rsi],rdi
    mov     [vectorAux+rsi],rdi
    add     rsi,8

    jmp     ingresoBinario
ret
binarioValido:
    mov     rsi,0

    mov		rcx,msgnumBina
    add     rsp,32
	call	printf	
    sub     rsp,32
printearNumeros:
    cmp     rsi,256

    jge     calcularExponente

    call    printGeneral

    jmp     printearNumeros
calcularExponente:
    mov     rcx, msgenter
    add     rsp,32
    call    puts
    sub     rsp,32

pasarExponenteEnExcesoADecimal:
    mov     rsi,64
    mov     qword[param1],8

    call    pasarBinaADec2
exponentes0:
    mov qword[aux],0
    jmp pasarDecABina2
ret
calculoResta127:
    cmp     qword[aux],0
    jle     exponentes0   
    sub     qword[aux],127
pasarExponenteABinario:
    mov rsi,0
    mov rbx,0
    mov qword[param],56
    mov qword[param1],8

    call pasarDecABina2
imprimoResultadoCaso11:
AntesDeLaComa:
    mov     rcx,msgenter
    add     rsp,32
    call    puts
    sub     rsp,32

    mov     rcx, msgRBANC
    add     rsp,32
    call    puts
    sub     rsp,32

    mov     rsi,0
    mov     rdx,[vectorAux+rsi]

    cmp     rdx,0
    je      signoPositivoC
    cmp     rdx,1
    je      signoNegativoC
laComa:
   mov      rcx, stringFormato
   mov      rdx, msgcoma
   add      rsp,32
   call     printf
   sub      rsp,32

   mov      rsi,72
mantisa:
    cmp     rsi,256
    jge     base

    mov     rcx,numeroFormato
    mov     rdx,[vectorAux+rsi]
    add     rsp,32
    call    printf
    sub     rsp,32

    add     rsi,8
    jmp     mantisa
ret
base:
    mov     rcx, stringFormato
    mov     rdx, msgBase
    add     rsp,32
    call    printf
    sub     rsp,32

    mov     rsi,8

    jmp     elExponente
ret
elExponente:
    cmp     rsi,72
    jge     final

    mov     rcx,numeroFormato
    mov     rdx,[vectorResultado+rsi]
    add     rsp,32
    call    printf
    sub     rsp, 32

    add     rsi,8
    jmp     elExponente
ret
signoNegativoC:
    mov     rcx,numeroFormato
    mov     rdx,-1

    add     rsp,32
    call    printf
    sub     rsp,32

    jmp     laComa
signoPositivoC:
    mov     rcx,numeroFormato
    mov     rdx,1

    add     rsp,32
    call    printf
    sub     rsp,32

    jmp     laComa
;-----------------------------------------------------------;
;  configuracion hexadeciaml a notacion cientifica          ;
;-----------------------------------------------------------;
esHexadecimal:
    mov     rsi,0
    mov     rbx,0

    mov     rcx, msgLetrasMay
    add     rsp,32
    call    puts
    sub     rsp,32
ingresoHexadecimal:
    cmp     rsi,32
    jge     hexadecimalValido

	mov		rcx,msgProxDigi	
    add     rsp,32
	call	printf
    sub     rsp,32					

    mov     rcx,inputNumeros
    add     rsp,32
    call    gets
    sub     rsp,32

    call    validarHexadecimal
ret
agregarHexaAVector:
    mov     qword[aux],4
    call    rellenarVector
pasarHexaADeci:
    jmp     traducir
listo: 

    mov     rdx,[inputNumeros]
    mov     [vectorNuevo+rbx],rdx ;agrego a vector
    add     rbx,8
  
    jmp     ingresoHexadecimal
ret
hexadecimalValido:
    mov     rsi,0
   
    mov		rcx,msgnumHexa	
    add     rsp,32
	call	printf
    sub     rsp,32

    jmp     printearHexa
ret    
printearHexa:
    cmp     rsi,32
    jge     vectorHexaPrinteado

    mov     rcx,stringFormato
    lea     rdx,[vector+rsi]
    add     rsp,32
    call    printf
    sub     rsp,32

    add     rsi,4
    
    jmp     printearHexa
vectorHexaPrinteado:
    mov     rsi,0
hexaABina:
    mov     rsi,56
    mov     qword[aux2],0
    mov     qword[aux],0
calcularResuk:
;-----------------------------------------------------------;
; Pasar hexadec a  decimal                                  ;
;-----------------------------------------------------------;
pasarHexaADec:
    cmp     rsi,0    
    jl      hexaABina1
 
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     rdx,0
    je      avanzoH
    cmp     rdx,1
    jge     contH
contH:
    cmp     qword[aux2],0
    je      elevadoA0H
    cmp     qword[aux2],1
    je      elevadoA1H

    mov     r8,16
    mov     r9,16

    jmp     potenciaH
elevadoA0H:
    add     qword[aux],rdx
    jmp     avanzoH
ret
elevadoA1H:
    mov     r8,16
    mov     r9,[vectorNuevo+rsi]
    imul    r8,r9
    add     qword[aux],r8
    jmp     avanzoH
ret   
potenciaH:
    imul    r8,r9
    dec     qword[aux2]

    cmp     qword[aux2],1
    jne     potenciaH
    
    mov     r9,[vectorNuevo+rsi]
    imul    r8,r9
    add     qword[aux],r8
avanzoH:   
    mov     rcx, qword[aux0]
    mov     qword[aux2],rcx
    add     qword[aux2],1
sigH:    
    sub     rsi,8
    
    jmp     calcularResuk
ret    
hexaABina1:

pasarDecABinaH:
    mov     qword[aux2],2
    mov     rsi,0
    mov     rbx,8

dividoH:    
    cmp     qword[aux],2
    jl      termineH

    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 
    inc     qword[contador]

    mov     qword[aux],rax
    mov     rdi,rdx
    mov     [vector+rsi],rdi
    add     rsi,8

    jmp     dividoH
termineH:

    mov     rdi,qword[aux]
    mov     [vector+rsi],rdi
    add     rsi,8

    mov     rcx, msgenter
    add     rsp,32
    call    puts
    sub     rsp,32

    mov     rcx, numeroFormato
    mov     rdx, qword[contador]
   ; call printf
    mov     rsi,248
    mov     rbx,0
verH:
    cmp     rsi, 0
    jl      averH
    mov     rcx,numeroFormato
    mov     rdx,[vector+rsi]
    mov     [vectorResultado+rbx],rdx
    add     rbx,8
    ;call    printf
    sub     rsi,8
    jmp     ver
ret
averH:
    mov     rsi,0

    mov     rcx, msgRNCBin
    add     rsp,32
    call    puts
    sub     rsp,32
ver2H:
    cmp     rsi, 256
    jge     final

    mov     rcx,numeroFormato
    mov     rdx,[vectorResultado+rsi]
  ;  call    printf
    add     rsi,8

    jmp     ver2H
ret
traducir:
  ;  mov rcx,inputNumeros
   ; mov rdx,[inputNumeros]
   ; call puts
    cmp     qword[inputNumeros],'1'
    je      paso1
    cmp     qword[inputNumeros],'2'
    je      paso2
    cmp     qword[inputNumeros],'3'
    je      paso3
    cmp     qword[inputNumeros],'4'
    je      paso4
    cmp     qword[inputNumeros],'5'
    je      paso5
    cmp     qword[inputNumeros],'6'
    je      paso6
    cmp     qword[inputNumeros],'7'
    je      paso7
    cmp     qword[inputNumeros],'8'
    je      paso8
    cmp     qword[inputNumeros],'9'
    je      paso9
    cmp     qword[inputNumeros],'0'
    je      paso0
    cmp     qword[inputNumeros],'A'
    je      es10
    cmp     qword[inputNumeros],'B'
    je      esonce
    cmp     qword[inputNumeros],'C'
    je      es12
    cmp     qword[inputNumeros],'D'
    je      es13
    cmp     qword[inputNumeros],'E'
    je      es14
    cmp     qword[inputNumeros],'F'
    je      es15
ret
paso0:
    mov     qword[inputNumeros],0
    
    jmp     listo
paso1:
    mov     qword[inputNumeros],1

    jmp     listo
paso2:
    mov     qword[inputNumeros],2

    jmp     listo
paso3:
    mov     qword[inputNumeros],3

    jmp     listo
paso4:
    mov     qword[inputNumeros],4

    jmp     listo
paso5:
    mov     qword[inputNumeros],5

    jmp     listo
paso6:
    mov     qword[inputNumeros],6

    jmp     listo
paso7:
    mov     qword[inputNumeros],7

    jmp     listo
paso8:
    mov     qword[inputNumeros],8

    jmp     listo
paso9:
    mov     qword[inputNumeros],9

    jmp     listo
es10:
    mov     rcx,numeroFormato
    mov     qword[inputNumeros],10
    
   ; call printf
    jmp     listo
esonce:
    mov     qword[inputNumeros],11
 
    jmp     listo
es12:
    mov     qword[inputNumeros],12
 
    jmp     listo
es13:
    mov     qword[inputNumeros],13
 
    jmp     listo
es14:
    mov     qword[inputNumeros],14
 
    jmp     listo
es15:
    mov     qword[inputNumeros],15
 
    jmp     listo
;-----------------------------------------------------------;
; Pasar Notacion cientifica a configuracion                 ;
;-----------------------------------------------------------;
accion2:
    mov  	rcx,msgenter
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov     rsi,0

    mov  	rcx,msgSubOpcion2
	sub     rsp,32
	call 	puts
    add     rsp,32
ingresarCoeficiente:
    cmp     rsi,192
    jge     ingresarExponente

    mov  	rcx,msgIngCoef
    add     rsp,32
	call 	printf
    sub     rsp,32

    mov     rcx,opcionIngresada
    add     rsp,32
    call    gets
    sub     rsp,32

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	sub     rsp,32
	call	sscanf
    add     rsp,32

	cmp		rax,1
	jl		errorIngresoOpcion

    call    validarBinario

    call    agregarNCAVector

    jmp     ingresarCoeficiente

    mov     rsi,192
ingresarExponente:
    cmp     rsi,224
    jge     printNCienti

    mov  	rcx,msgIngExpo
    add     rsp,32
	call 	printf
    sub     rsp,32

    mov     rcx,opcionIngresada
    add     rsp,32
    call    gets
    sub     rsp,32

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	sub     rsp,32
	call	sscanf
    add     rsp,32

	cmp		rax,1
	jl		errorIngresoOpcion
    
    call    agregarNCAVector

    jmp     ingresarExponente     
visualizar:
    mov     rcx,msgenter
    add     rsp,32
    call    puts
    sub     rsp,32
    
    mov  	rcx,msgConfSelec
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgSubOpcion11
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov  	rcx,msgSubOpcion12
	sub     rsp,32
	call 	puts
    add     rsp,32

    mov     rcx,opcionIngresada
    add     rsp,32
    call    gets
    sub     rsp,32

    mov 	rcx,opcionIngresada
	mov		rdx,numeroFormato
	mov 	r8,opcion
	sub     rsp,32
	call	sscanf
    add     rsp,32

	cmp		rax,1
	jl		errorIngresoOpcion

    call    validarOpcion

    cmp     word[opcion],1
    je      hexaABina
    cmp     word[opcion],2
    je      aConfHexa
ret
agregarNCAVector:
    mov     rdi,[opcion]
    mov     [vector+rsi],rdi

    add     rsi,8
ret   
signoNegativo:
    mov     rsi,0
    mov     rdi,1
    mov     [vectorResultado+rsi],rdi
 
    jmp     printComa
ret
signoPositivo:
    mov     rsi,0
    mov     rdi,0
    mov     [vectorResultado+rsi],rdi
 
    jmp     printComa
ret
printNCienti:
    mov     rcx, msgNotCien
    add     rsp,32
    call    printf
    sub     rsp,32

    mov     rsi,0
printAntesComa:
    cmp     rsi,8
    jge     printComa

    call    printGeneral

    cmp     qword[vector+rsi],-1
    je      signoNegativo
    cmp     qword[vector+rsi],1
    je      signoPositivo
printComa:
    mov     rcx, msgcoma
    add     rsp,32
    call    printf
    sub     rsp,32

    mov     rsi,8
    mov     rbx,72
printCoef:
    cmp     rsi,192
    jge     printBase

    call    printGeneral
    
    mov     rdi,[vector+rsi]
    mov     qword[vectorResultado+rbx],rdi
    add     rbx,8

    jmp     printCoef
printBase:
    mov     rcx, msgBase
    add     rsp,32
    call    printf
    sub     rsp,32
    
    mov     rsi,192
printExpo:
    cmp     rsi,224
    jge     visualizar

    call    printGeneral

    jmp     printExpo
aConfBinaria:
    mov     rsi,216
    mov     qword[aux2],0
calcularExpoExceso:
;-----------------------------------------------------------;
; Pasar binario a  decimal                                  ;
;-----------------------------------------------------------;
pasarBinaADec:
    cmp     rsi,184    
    jle     expoExceso
    mov     rcx, numeroFormato
    mov rdx,qword[vector+rsi]
    ;call printf
    
    mov rcx, qword[aux2]
    mov qword[aux0],rcx
    cmp qword[vector+rsi],0
    je  avanzo
    cmp qword[vector+rsi],1
    je  cont
cont:
  ;  mov rcx, qword[aux2]
   ; mov qword[aux0],rcx

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
    mov rcx, qword[aux0]
    mov qword[aux2],rcx
    add qword[aux2],1
 
sig:    
    sub rsi,8
    mov rcx, numeroFormato
    mov rdx, qword[aux]
  ;  call printf
    
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
divido:    
    cmp     qword[aux],2
    jl      termine
    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 
  ;  mov     qword[aux0],rdx
    inc     qword[contador]

    mov qword[aux],rax
    mov rdi,rdx
    mov [vector+rsi],rdi
    
    add rsi,8
    jmp divido
termine:
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
    jl aver
    mov     rcx,numeroFormato
    mov     rdx,[vector+rsi]
    mov [vectorResultado+rbx],rdx
    add rbx,8
   ; call    printf
    sub rsi,8
    jmp ver
ret
aver:
    mov rsi,0
    mov rcx, msgRNCBin
    call puts
ver2:
    cmp rsi, 256
    jge final
    mov     rcx,numeroFormato
    mov     rdx,[vectorResultado+rsi]
    call    printf
    add rsi,8
    jmp ver2
ret
aConfHexa:
    call    aConfBinaria

    mov     rcx, msgenter
    add     rsp,32
    call    puts
    sub     rsp,32

    mov     rsi,248
    mov     qword[aux],0
    mov     qword[aux2],0
    mov     qword[aux0],0
c:    
pasarBinaADec1:
    cmp     rsi,0    
    jl      impri

    mov     rcx, numeroFormato
    mov     rdx,qword[vectorResultado+rsi]
  ;  call printf
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     qword[vectorResultado+rsi],0
    je      avanzo1
    cmp     qword[vectorResultado+rsi],1
    je      cont1
cont1:
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     qword[aux2],0
    je      elevadoA01
    cmp qword[aux2],1
    je  elevadoA11
    mov r8,2
    mov r9,2
    jmp potencia1
elevadoA01:
    inc qword[aux]
    jmp avanzo1
ret
elevadoA11:
    add qword[aux],2
    jmp avanzo1
ret   
potencia1:
    imul r8,r9
    dec qword[aux2]
    cmp qword[aux2],1
    jne  potencia1
    add qword[aux],r8
    
avanzo1:   
    mov rcx, qword[aux0]
    mov qword[aux2],rcx
    add qword[aux2],1
    mov rcx, numeroFormato
    mov rdx,qword[aux2]
  ;  call printf
    mov rcx, msgenter
  ;  call puts
sig1:    
    sub rsi,8
    jmp c
ret
impri:    
    mov rcx, numeroFormato
    mov rdx,qword[aux]
  ;  call printf
pasarDeciAHexa:
    mov qword[aux2],16 
    mov rsi,0
    mov rbx,4

divido1:    
    cmp     qword[aux],16
    jl      termine1
    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 
  ;  mov     qword[aux0],rdx
    inc     qword[contador]

     mov qword[aux],rax
  ;  mov rcx, numeroFormato
    mov rdx,rdx;qword[aux0]
    mov rdi,rdx
    cmp rdi,9
    jg convertir
    jmp conversionN
    
agregoo:
    mov [vector+rsi],rdi
    
    add rsi,4
    jmp divido1
convertir:
;    mov rcx,numeroFormato
;    mov rdx,rdi
 
    cmp rdi,10
    je esA
    cmp rdi,11
    je esB
    cmp rdi,12
    je esC
    cmp rdi,13
    je esD
    cmp rdi,14
    je esE
    cmp rdi,15
    je esF
ret
esA:
    mov rdi,'A'
    jmp agregoo
ret
esB:
    mov rdi,'B'
    jmp agregoo
ret
esC:
    mov rdi,'C'
    jmp agregoo
ret
esD:
    mov rdi,'D'
jmp agregoo
ret
esE:
    mov rdi,'E'
jmp agregoo
ret
esF:
    mov rdi,'F'
    jmp agregoo

ret
conversionN:
    cmp rdi,1
    je  es1
    cmp rdi,2
    je  es2
    cmp rdi,3
    je  es3
    cmp rdi,4
    je  es4
    cmp rdi,5
    je  es5
    cmp rdi,6
    je  es6
    cmp rdi,7
    je  es7
    cmp rdi,8
    je  es8
    cmp rdi,9
    je  es9
    cmp rdi,0
    je es0
ret
es0:
mov rdi,'0'
jmp agregoo
es1:
    mov rdi,'1'
    jmp agregoo
es2:
mov rdi,'2'
jmp agregoo
es3:
mov rdi,'3'
jmp agregoo
es4:
mov rdi,'4'
jmp agregoo
es5:
mov rdi,'5'
jmp agregoo
es6:
mov rdi,'6'
jmp agregoo
es7:
mov rdi,'7'
jmp agregoo
es8:
mov rdi,'8'
jmp agregoo
es9:
mov rdi,'9'
jmp agregoo

convertir1:
    mov rcx,numeroFormato
    mov rdx,rdi
    ;call printf
     cmp rdi,1
    je  es11
    cmp rdi,2
    je  es21
    cmp rdi,3
    je  es31
    cmp rdi,4
    je  es41
    cmp rdi,5
    je  es51
    cmp rdi,6
    je  es61
    cmp rdi,7
    je  es71
    cmp rdi,8
    je  es81
    cmp rdi,9
    je  es91
    cmp rdi,0
    je es01
    cmp rdi,10
    je esA11
    cmp rdi,11
    je esB1
    cmp rdi,12
    je esC1
    cmp rdi,13
    je esD1
    cmp rdi,14
    je esE1
    cmp rdi,15
    je esF1
ret
esA11:
    mov rdi,'A'
    jmp sigo

esB1:
    mov rdi,'B'
    jmp sigo

esC1:
    mov rdi,'C'
    jmp sigo
esD1:
    mov rdi,'D'

jmp sigo
esE1:
    mov rdi,'E'

jmp sigo
esF1:
    mov rdi,'F'
    jmp sigo

es01:
mov rdi,'0'
jmp sigo
es11:
    mov rdi,'1'
    jmp sigo
es21:
mov rdi,'2'
jmp sigo
es31:
mov rdi,'3'
jmp sigo
es41:
mov rdi,'4'
jmp sigo
es51:
mov rdi,'5'
jmp sigo
es61:
mov rdi,'6'
jmp sigo
es71:
mov rdi,'7'
jmp sigo
es81:
mov rdi,'8'
jmp sigo
es91:
mov rdi,'9'
jmp sigo

termine1:
    mov rdi,qword[aux]
    jmp convertir1
sigo:  
    mov [vector+rsi],rdi
    add rsi,4
    mov rsi,27
    mov rbx,4
ver1:
    cmp rsi, 0
    jl aver1
    mov     rcx,stringFormato
    lea rdx,[vector+rsi]
    mov [vectorResultado+rbx],rdx
    add rbx,4
    sub rsi,4
    jmp ver1
ret
aver1:
    mov rsi,36;0
    mov rcx, msgRNCHexa
     call puts
ver21:
    cmp rsi, 0;36
    jl final
    mov     rcx,stringFormato
    lea rdx,[vector+rsi]
    call    printf
    sub rsi,4
    jmp ver21
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
ret
pasarBinaADec2:
    cmp     rsi,qword[param1];8   
    jl      calculoResta127
    
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     qword[vector+rsi],0
    je      avanzo2
    cmp     qword[vector+rsi],1
    je      cont2
cont2:
    cmp     qword[aux2],0
    je      elevadoA02
    cmp     qword[aux2],1
    je      elevadoA12

    mov     r8,2
    mov     r9,2

    jmp     potencia2
elevadoA02:
    inc     qword[aux]

    jmp     avanzo2
ret
elevadoA12:
    add     qword[aux],2

    jmp     avanzo2
ret   
potencia2:
    imul    r8,r9
    dec     qword[aux2]

    cmp     qword[aux2],1
    jne     potencia2

    add     qword[aux],r8
avanzo2:   
    mov     rcx, qword[aux0]
    mov     qword[aux2],rcx
    
    add     qword[aux2],1
sig2:    
    sub     rsi,   qword[param1];8

;    mov rcx, numeroFormato
;    mov rdx, qword[aux]
;    call printf  
    jmp     pasarBinaADec2
ret    
pasarDecABina2:

    mov     qword[aux2],2
 ;   mov     rsi,0
 ;   mov     rbx,8
;   mov rcx, numeroFormato
;   mov rdx,qword[aux2]
;   call printf
;   mov rcx, numeroFormato
;   mov rdx,qword[aux]
;   call printf
divido2:    
    cmp     qword[aux],2
    jl      termine2

    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 

    inc     qword[contador]

    mov     qword[aux],rax
;   mov rcx, numeroFormato
;   mov rdx,rdx;qword[aux0]
;   call printf
    mov     rdi,rdx
    mov     [vector+rsi],rdi ; agregar a vector
    add     rsi,8

    jmp     divido2
termine2:
;   mov rcx, numeroFormato
;   mov rdx, qword[aux]
;   call printf
    mov     rdi,qword[aux]
    mov     [vector+rsi],rdi ; agrego ultimo pedazo a vector 
    add     rsi,8

    mov     rcx, msgenter
    add     rsp, 32
    call    puts
    sub     rsp, 32

    mov     rsi,qword[param];56
    mov     rbx,qword[param1];8
ver222:
    cmp     rsi,0
    jl      retornar;imprimoResultadoCaso11;aver2

;   mov     rcx,numeroFormato
    mov     rdx,[vector+rsi]
    mov     [vectorResultado+rbx],rdx
    add     rbx,8
;   call    printf
    sub     rsi,8

    jmp     ver222
retornar:
ret
final:
ret