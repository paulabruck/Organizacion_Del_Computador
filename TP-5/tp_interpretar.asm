global 	main
extern 	printf
extern	gets
extern  puts
extern  sscanf

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
    msgNegativo                 db  "-",0
    msgIngSignoExpo             db  "~~Ingrese signo del exponente(+ ---> Positivo | - ---> Negativo) : ",0
    msgIngCantDigit             db  "~~Ingrese cantidad de digitos que posee el exponente : ",0
    contador                    dq  0
    aux0                        dq  0
    aux                         dq  0
    aux2                        dq  0
    param                       dq  0
    param1                      dq  0
    msg                         dq  0
    flagNeg                     dq  0
    diferenciaBH                dq  0
    vectorHexa                  times 32 dq 1
    vector                      times 32 dq 1
    vectorResultado             times 32 dq 1
    vectorAux                   times 32 dq 1
    vectorNuevo                 times 32 dq 1
    vectorExponente             times 8  dq 1
 
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
    mov  	qword[msg],msgenter
    call    putss

    mov  	qword[msg],msgBienvenida
    call    putss

    mov  	qword[msg],msgContinuacion
    call    putss

    mov  	qword[msg],msgOpcion1
	call    putss

    mov  	qword[msg],msgOpcion2
	call    putss

    mov     qword[msg],opcionIngresada
    call    getss

    mov 	qword[msg],opcionIngresada
	call    scanfNumero
	
	call 	validarOpcion
    jmp     accionARealizar
ret
;-----------------------------------------------------------;
; Avisa al usuario el error y le pide que ingrese nuevamente;
;-----------------------------------------------------------;
errorIngresoOpcion:
	mov 	qword[msg],mensajeErrorOpcion
	call 	putss

    mov     qword[msg],msgenter
    call    putss

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
    cmp     word[inputNumeros],'A'
    je      agregarHexaAVector

    cmp     word[inputNumeros],'B'
    je      agregarHexaAVector

    cmp     word[inputNumeros],'C'
    je      agregarHexaAVector

    cmp     word[inputNumeros],'D'
    je      agregarHexaAVector

    cmp     word[inputNumeros],'E'
    je      agregarHexaAVector

    cmp     word[inputNumeros],'F'
    je      agregarHexaAVector

    sub     word[inputNumeros],48

    cmp     word[inputNumeros],0
    jge     menorA9
menorA9:
    cmp     word[inputNumeros],9
    jle     nuevamenteACaracter
nuevamenteACaracter:
    add     word[inputNumeros],48
    jmp     agregarHexaAVector

    jmp     errorIngresoOpcion
ret
;-----------------------------------------------------------;
; visualizar configuracion en notacion cientifica           ;
;-----------------------------------------------------------; 
accion1:
    mov  	qword[msg],msgenter
	call 	putss

    mov  	qword[msg],msgSubOpcion1
	call 	putss

    mov  	qword[msg],msgSubOpcion11
	call 	putss

    mov  	qword[msg],msgSubOpcion12
	call 	putss

    mov     qword[msg],opcionIngresada  
    call    getss

    mov 	qword[msg],opcionIngresada
    call    scanfNumero

	call 	validarOpcion
   
    mov  	qword[msg],msgenter
	call 	putss

    mov  	qword[msg],msgIngConf
	call 	putss
    
    cmp     word[opcion],1
    je      esBinario
    cmp     word[opcion],2
    je      esHexadecimal
exponentesNegativo2:
    call    exponentesNegativo
    jmp     pasarExponenteABinario  
exponentesCero2:
    call    exponentesCero
    jmp     pasarExponenteABinario
exponentesPostivo2:
    call    exponentesPostivo
    jmp     pasarExponenteABinario
negativo:
    mov     qword[msg],msgNegativo
    call    printfString
    jmp     elExponente
ret
;-----------------------------------------------------------;
; configuracion binaria a notacion cientifica               ;
;-----------------------------------------------------------;
esBinario:
    mov  	qword[msg],msgInfoEspacio
	call 	putss
    mov     qword[diferenciaBH],8
    mov     rsi,0
ingresoBinario:
    cmp     rsi,256
    jge     binarioValido

	mov		qword[msg],msgProxDigi	
	call	printfString	

    mov     qword[msg],inputNumeros
    call    getss
    
    mov     qword[msg],inputNumeros
    call    scanfNumero
    call    validarBinario
agregarAVector:
    mov     rdi,[opcion]
    mov     [vectorResultado+rsi],rdi
    mov     [vector+rsi],rdi
    add     rsi,8

    jmp     ingresoBinario
binarioValido:
    mov     rsi,0

    mov		qword[msg],msgnumBina
	call	printfString	
printearNumeros:
    cmp     rsi,256
    jge     calcularExponente
    
    mov     rdx,[vectorResultado+rsi]
    mov     qword[msg],rdx
    call    printfNumero
    add     rsi,8
    jmp     printearNumeros
calcularExponente:
    mov     qword[msg],msgenter
    call    putss
pasarExponenteEnExcesoADecimal:
    mov     rsi,64
    mov     qword[param],8
    mov     qword[param1],8
    mov     qword[aux2],0
    mov     qword[aux],0

    call    pasarBinaADec2
calculoResta127:
    cmp     qword[aux],127
    jl      exponentesNegativo2   
    je      exponentesCero2
    jg      exponentesPostivo2
pasarExponenteABinario:
    mov     rsi,0
reinicioVector:
    cmp     rsi,72
    jge     sigoo
    mov     qword[vector+rsi],0
    mov     qword[vectorResultado+rsi],0
    mov     qword[vectorExponente+rsi],0
    add     rsi,8
    jmp     reinicioVector
sigoo:
    mov     rsi,0
    mov     rbx,0
    mov     qword[param],0
    mov     qword[param1],8
    mov     rsi,qword[param]
    mov     rbx,qword[param1]

    call    pasarDecABina2B
    
    mov     qword[msg], msgenter
    call    putss
imprimoResultadoCaso11:
AntesDeLaComa:
    mov     qword[msg],msgenter
    call    putss

    mov     qword[msg], msgRBANC
    call    putss

    mov     rsi,qword[diferenciaBH]
    mov     rdx,[vectorResultado+rsi]

    cmp     rdx,0
    je      signoPositivoC
    cmp     rdx,1
    je      signoNegativoC
laComa:
   mov      qword[msg], msgcoma
   call     printfString
mantisa:
    cmp     rsi,256
    jge     base

    mov     rdx,[vectorResultado+rsi]
    mov     qword[msg],rdx
    call    printfNumero

    add     rsi,8
    jmp     mantisa
ret
base:
    mov     qword[msg], msgBase
    call    printfString

    mov     rsi,8
    cmp     qword[flagNeg],1
    je      negativo
elExponente:
    mov     rsi,56
expo:
    cmp     rsi,0
    jl      final

    mov     rdx,[vectorExponente+rsi]
    mov     qword[msg],rdx
    call    printfNumero

    sub     rsi,8
    jmp     expo
ret
signoNegativoC:
    mov     qword[msg],-1
    call    printfNumero

    jmp     laComa
signoPositivoC:
    mov     qword[msg],1
    call    printfNumero
    add     rsi,64
normalizo:
    add     rsi,8
    cmp     qword[vectorResultado+rsi],0
    je      normalizo
    add     rsi,8
    jmp     laComa
;-----------------------------------------------------------;
;  configuracion hexadeciaml a notacion cientifica          ;
;-----------------------------------------------------------;
esHexadecimal:
    mov     rsi,0
    mov     rbx,0
    mov     qword[msg], msgLetrasMay
    call    putss
ingresoHexadecimal:
    cmp     rsi,32
    jge     hexadecimalValido

	mov		qword[msg],msgProxDigi	
	call	printfString				

    mov     qword[msg],inputNumeros
    call    getss

    call    validarHexadecimal
agregarHexaAVector: 
    mov     qword[aux],4
    call    rellenarVector
pasarHexaADeci:
    jmp     traducir
listo:
    mov     rdx,[inputNumeros]
    mov     [vectorNuevo+rbx],rdx
    add     rbx,8

    jmp     ingresoHexadecimal
ret
hexadecimalValido:
    mov     rsi,0
   
    mov		qword[msg],msgnumHexa	
	call	printfString	  
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
    mov     qword[msg],msgenter
    call    putss

    mov     rsi,56
    mov     qword[aux2],0
    mov     qword[aux],0
calcularResultado:
;-----------------------------------------------------------;
; Pasar hexadec a  decimal                                  ;
;-----------------------------------------------------------;
pasarHexaADec:
    cmp     rsi,0    
    jl      hexaABina1

    mov     qword[msg],msgenter
    call    putss

    mov     rdx,[vectorNuevo+rsi]
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
elevadoA1H:
    mov     r8,16
    mov     r9,[vectorNuevo+rsi]
    imul    r8,r9
    add     qword[aux],r8
    jmp     avanzoH  
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
    
    jmp     calcularResultado
ret  
hexaABina1:
    mov     rsi,0
    mov rcx, numeroFormato
    mov rdx,qword[aux]
    call printf
limpioVector:
    cmp     rsi,256
    je      limpio

    mov     qword[vector+rsi],0
    mov     qword[vectorResultado+rsi],0
    mov     qword[vectorExponente+rsi],0
    add     rsi,8

    jmp     limpioVector
limpio:
    mov     qword[param],0;8
    mov     qword[param1],8
    mov     rsi,qword[param]
    mov     rbx,qword[param1]
    call    pasarDecABina2

    mov     rsi,248
    mov     rbx,0
verH:
    cmp     rsi, 0
    jl      averH

    mov     rcx,numeroFormato
    mov     rdx,[vector+rsi]
    mov     [vectorResultado+rbx],rdx
    add     rbx,8
    sub     rsi,8
    jmp     verH
ret
averH:
    mov     rsi,0
    mov     rcx, msgRNCBin
    call    puts
ver2H:
    cmp     rsi, 256
    jge     endH
    
    mov     rdx,[vectorResultado+rsi]
    mov     qword[msg],rdx
    call    printfNumero
    add     rsi,8
    jmp     ver2H
ret
endH:
binarioValido1:
    mov qword[diferenciaBH],0
    jmp calcularExponente
traducir:
    cmp     qword[inputNumeros],'A'
    je      esDiez
    cmp     qword[inputNumeros],'B'
    je      esOnce
    cmp     qword[inputNumeros],'C'
    je      esDoce
    cmp     qword[inputNumeros],'D'
    je      esTrece
    cmp     qword[inputNumeros],'E'
    je      esCatorce
    cmp     qword[inputNumeros],'F'
    je      esQuince

    jmp     pasoNumeros
ret
pasoNumeros:
    sub     qword[inputNumeros],48
    jmp     listo
esDiez:
    mov     qword[inputNumeros],10    
    jmp     listo
esOnce:
    mov     qword[inputNumeros],11
    jmp     listo
esDoce:
    mov     qword[inputNumeros],12
    jmp     listo
esTrece:
    mov     qword[inputNumeros],13
    jmp     listo
esCatorce:
    mov     qword[inputNumeros],14
    jmp     listo
esQuince:
    mov     qword[inputNumeros],15
    jmp     listo
expoIngreNegativo:
    mov     qword[flagNeg],1
    jmp     ingresarCantDigitos
expoIngrePositivo:
    mov     qword[flagNeg],0
    jmp     ingresarCantDigitos
;-----------------------------------------------------------;
; Pasar Notacion cientifica a configuracion                 ;
;-----------------------------------------------------------;
accion2:
    mov  	qword[msg],msgenter
	call 	putss
    mov     rsi,0
    mov  	qword[msg],msgSubOpcion2
	call 	putss
ingresarCoeficiente:
    cmp     rsi,192
    jge     ingresarSignoExponente

    mov  	qword[msg],msgIngCoef
	call 	printfString

    mov     qword[msg],opcionIngresada
    call    getss

    mov 	qword[msg],opcionIngresada
	call    scanfNumero

    call    validarBinario
    call    agregarNCAVector
    jmp     ingresarCoeficiente
ingresarSignoExponente:
    mov  	qword[msg],msgIngSignoExpo
    call    printfString

    mov     qword[msg],opcionIngresada
    call    getss

    cmp     qword[opcionIngresada],'-'
    je      expoIngreNegativo

    cmp     qword[opcionIngresada],'+'
    je      expoIngrePositivo

    jmp     errorIngresoOpcion
ingresarCantDigitos:
    mov  	qword[msg],msgIngCantDigit
    call    printfString

    mov     qword[msg],opcionIngresada
    call    getss

    mov 	qword[msg],opcionIngresada
	call    scanfNumero

    mov     r8,qword[opcion]
    mov     r9,8
    imul    r8,r9
    mov     qword[aux0],r8
    add     qword[aux0],192
    mov     rsi,192
ingresarExponente:
    cmp     rsi,qword[aux0]
    jge     printNCienti

    mov  	qword[msg],msgIngExpo
	call 	printfString

    mov     qword[msg],opcionIngresada
    call    getss

    mov 	qword[msg],opcionIngresada
	call    scanfNumero
    
    call    agregarNCAVector
    jmp     ingresarExponente     
visualizar:
    mov     qword[msg],msgenter
    call    putss
    
    mov  	qword[msg],msgConfSelec
	call 	putss

    mov  	qword[msg],msgSubOpcion11
	call 	putss

    mov  	qword[msg],msgSubOpcion12
	call 	putss

    mov     qword[msg],opcionIngresada
    call    getss

    mov 	qword[msg],opcionIngresada
    call    scanfNumero

    call    validarOpcion

    cmp     word[opcion],1
    je      aConfBinaria
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
    call    printf ;falta
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
    mov     qword[msg], msgcoma
    call    printfString

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
    mov     qword[msg], msgBase
    call    printfString
    
    mov     rsi,192
printExpo:
    cmp     rsi,qword[aux0]
    jge     visualizar

    call    printGeneral

    jmp     printExpo
aConfBinaria:
    sub     qword[aux0],8
    mov     rsi,qword[aux0]
    mov     qword[aux2],0
calcularExpoExceso:
;-----------------------------------------------------------;
; Pasar binario a  decimal                                  ;
;-----------------------------------------------------------;
    mov     qword[param],192
    mov     qword[param1],8
    call    pasarBinaADec2B
decimalNegativo:
    not     qword[aux]
    inc     qword[aux]
    jmp     opero
ret
reconvierto:
    not     qword[aux]
    inc     qword[aux]
    jmp     pasarDecABina
ret
expoExceso:
    cmp     qword[flagNeg],1
    je      decimalNegativo
opero:
    add     qword[aux],127
   
    cmp     qword[aux],0
    jl      reconvierto
limpieza:
    mov     rsi,0
reinicioVector11:
    cmp     rsi,256
    jge     pasarDecABina
    mov     qword[vector+rsi],0
    add     rsi,8
    jmp     reinicioVector11
pasarDecABina:
    mov     qword[param],0
    mov     qword[param1],8
    mov     rsi,qword[param]
    mov     rbx,qword[param1]
    call    pasarDecABina2
    mov     rsi,56
    mov     rbx,8
ver:
    cmp     rsi, 0
    jl      aver
    mov     rdx,[vector+rsi]
    mov     [vectorResultado+rbx],rdx
    add     rbx,8
    sub     rsi,8
    jmp     ver
aver:
    mov     rsi,0
    mov     qword[msg], msgRNCBin
    call    putss
ver2:
    cmp     rsi, 256
    jge     final
    mov     rdx,[vectorResultado+rsi]
    mov     qword[msg],rdx
    call    printfNumero
    add     rsi,8
    jmp     ver2
aConfHexa:
    call    aConfBinaria

    mov     qword[msg], msgenter
    call    putss

    mov     rsi,248
    mov     qword[param],0;248
    mov     qword[aux],0
    mov     qword[aux2],0
    mov     qword[aux0],0
c:    
    call    pasarBinaADec2
pasarDeciAHexa:
    mov     qword[aux2],16 
    mov     rsi,0
    mov     rbx,4
divido1:    
    cmp     qword[aux],16
    jl      termine1

    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 
    inc     qword[contador]

    mov     qword[aux],rax
    mov     rdx,rdx;qword[aux0]
    mov     rdi,rdx

convertir:
    cmp     rdi,10
    je      esA
    cmp     rdi,11
    je      esB
    cmp     rdi,12
    je      esC
    cmp     rdi,13
    je      esD
    cmp     rdi,14
    je      esE
    cmp     rdi,15
    je      esF

    add     rdi,48
agregoo:
    mov     [vector+rsi],rdi
    add     rsi,4
    jmp     divido1
esA:
    mov     rdi,'A'
    jmp     agregoo
esB:
    mov     rdi,'B'
    jmp     agregoo
esC:
    mov     rdi,'C'
    jmp     agregoo
esD:
    mov     rdi,'D'
    jmp     agregoo
esE:
    mov     rdi,'E'
    jmp     agregoo
esF:
    mov     rdi,'F'
    jmp     agregoo
convertir1:
    cmp     rdi,10
    je      esA11
    cmp     rdi,11
    je      esB1
    cmp     rdi,12
    je      esC1
    cmp     rdi,13
    je      esD1
    cmp     rdi,14
    je      esE1
    cmp     rdi,15
    je      esF1

    add     rdi,48
    jmp     sigo
ret
esA11:
    mov     rdi,'A'
    jmp     sigo
esB1:
    mov     rdi,'B'
    jmp     sigo
esC1:
    mov     rdi,'C'
    jmp     sigo
esD1:
    mov     rdi,'D'
    jmp     sigo
esE1:
    mov     rdi,'E'
    jmp     sigo
esF1:
    mov     rdi,'F'
    jmp     sigo
termine1:
    mov     rdi,qword[aux]
    jmp     convertir1
sigo:  
    mov     [vector+rsi],rdi
    add     rsi,4
    mov     rsi,27
    mov     rbx,4
aver1:
    mov     rsi,36
    mov     qword[msg], msgRNCHexa
    call    putss
ver21:
    cmp     rsi,0
    jl      final

    mov     rcx,stringFormato
    lea     rdx,[vector+rsi]
    add     rsp,32
    call    printf
    sub     rsp,32
    sub     rsi,4
    jmp     ver21
ret
printGeneral:
    mov     rdx,[vector+rsi]
    mov     qword[msg],rdx
    call    printfNumero
    add     rsi,8
ret
rellenarVector:
    mov     rdi,[inputNumeros]
    mov     [vector+rsi],rdi

    add     rsi,qword[aux]
ret
final:
ret
pasarBinaADec2:
    cmp     rsi,qword[param]
    jl      final
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     qword[vectorResultado+rsi],0
    je      avanzo2
    cmp     qword[vectorResultado+rsi],1
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
elevadoA12:
    add     qword[aux],2
    jmp     avanzo2
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
    sub     rsi,  qword[param1]
    jmp     pasarBinaADec2
ret   
pasarDecABina2:
    mov     qword[aux2],2
divido2:    
    cmp     qword[aux],2
    jl      termine2

    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 

    inc     qword[contador]

    mov     qword[aux],rax
    mov     rdi,rdx
    mov     [vector+rsi],rdi ; agregar a vector
    add     rsi,8

    jmp     divido2
termine2:
    mov     rdi,qword[aux]
    mov     [vector+rsi],rdi ; agrego ultimo pedazo a vector 
    add     rsi,8
ret
pasarBinaADec2B:
    cmp     rsi,qword[param]
    jl      final
    
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     qword[vector+rsi],0
    je      avanzo2B
    cmp     qword[vector+rsi],1
    je      cont2B
cont2B:
    cmp     qword[aux2],0
    je      elevadoA02B
    cmp     qword[aux2],1
    je      elevadoA12B

    mov     r8,2
    mov     r9,2
    jmp     potencia2B
elevadoA02B:
    inc     qword[aux]

    jmp     avanzo2B
elevadoA12B:
    add     qword[aux],2
    jmp     avanzo2B
potencia2B:
    imul    r8,r9
    dec     qword[aux2]

    cmp     qword[aux2],1
    jne     potencia2B

    add     qword[aux],r8
avanzo2B:   
    mov     rcx, qword[aux0]
    mov     qword[aux2],rcx
    
    add     qword[aux2],1
sig2B:    
    sub     rsi,qword[param]
   
    jmp     pasarBinaADec2B
ret   
pasarDecABina2B:
    mov     qword[aux2],2
divido2B:    
    cmp     qword[aux],2
    jl      termine2B

    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 

    inc     qword[contador]

    mov     qword[aux],rax
    mov     rdx,rdx
    mov     rdi,rdx
    mov     [vectorExponente+rsi],rdi ; agregar a vector
    add     rsi,8

    jmp     divido2B
termine2B:
    mov     rdi,qword[aux]
    mov     [vectorExponente+rsi],rdi ; agrego ultimo pedazo a vector 
    add     rsi,8
ret
putss:
    mov     rcx,qword[msg]
    sub     rsp,32
	call 	puts
    add     rsp,32
ret
getss:
    mov     rcx,qword[msg]
    sub     rsp,32
	call 	gets
    add     rsp,32
ret
printfString:
    mov     rcx, stringFormato
    mov     rdx, qword[msg]
    sub     rsp,32
	call 	printf
    add     rsp,32
ret
printfNumero:
    mov     rcx,numeroFormato
    mov     rdx, qword[msg]
    sub     rsp,32
	call 	printf
    add     rsp,32
ret
scanfNumero:
    mov     rcx,qword[msg]
    mov     rdx,numeroFormato
    mov     r8,opcion
    sub     rsp,32
    call    sscanf
    add     rsp,32
    cmp		rax,1
	jl		errorIngresoOpcion
ret
exponentesNegativo:
    sub     qword[aux],127
    not     qword[aux]
    inc     qword[aux]
    mov     qword[flagNeg],1
ret
exponentesCero:
    mov     qword[aux],0
ret
exponentesPostivo:
    sub     qword[aux],127
    mov     qword[flagNeg],0
ret
