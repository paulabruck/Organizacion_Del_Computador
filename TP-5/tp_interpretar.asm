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
    vector                      times 32 dq 1
    vectorResultado             times 32 dq 1
    vectorAux                   times 32 dq 1
    vectorNuevo                 times 32 dq 1
    vectorExponente             times 32 dq 1
 
section .bss
    opcionIngresada     resb 1
    opcion              resb 1
    inputNumeros        resb 50

section .text

;------------------------------main------------------------------------;
main:
    jmp     menu 
accionARealizar:
    cmp	    qword[opcion],1
    je      accion1

    cmp		qword[opcion],2
    je      accion2    
ret
;---------------------------rutinas internas---------------------------;

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
; opcion 1: visualizar configuracion en notacion cientifica ;
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
; Subopcion 1:configuracion binaria a notacion cientifica   ;
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

    call    pasarBinaADecVecResul
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

    call    pasarDecABina
    
    mov     qword[msg], msgenter
    call    putss
;-----------------------------------------------------------;
; Subopcion 1:Imprimo resultado                             ;
;-----------------------------------------------------------;
imprimoResultadoCaso11:
AntesDeLaComa:
    mov     qword[msg],msgenter
    call    putss

    mov     qword[msg], msgRBANC
    call    putss

    mov     rsi,qword[diferenciaBH]
    mov     rdx,[vectorResultado+rsi]

    cmp     rdx,0
    je      signoPositivoBinario
    cmp     rdx,1
    je      signoNegativoBinario
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
signoNegativoBinario:
    mov     qword[msg],-1
    call    printfNumero

    jmp     laComa
signoPositivoBinario:
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
;Subopcion2:configuracion hexadeciaml a notacion cientifica ;
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
    jmp     traducirHexa
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
; Pasar hexadecimal  a  decimal                             ;
;-----------------------------------------------------------;
pasarHexaADec:
    cmp     rsi,0    
    jl      hexaABinario

    mov     rdx,[vectorNuevo+rsi]
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     rdx,0
    je      avanzoHexa
    cmp     rdx,1
    jge     continuoHexaADec
continuoHexaADec:
    cmp     qword[aux2],0
    je      elevadoA0Hexa
    cmp     qword[aux2],1
    je      elevadoA1Hexa

    mov     r8,16
    mov     r9,16
    jmp     potenciaHexa
elevadoA0Hexa:
    add     qword[aux],rdx
    jmp     avanzoHexa
elevadoA1Hexa:
    mov     r8,16
    mov     r9,[vectorNuevo+rsi]
    imul    r8,r9
    add     qword[aux],r8
    jmp     avanzoHexa  
potenciaHexa:
    imul    r8,r9
    dec     qword[aux2]
    cmp     qword[aux2],1
    jne     potenciaHexa
    
    mov     r9,[vectorNuevo+rsi]
    imul    r8,r9
    add     qword[aux],r8
avanzoHexa:   
    mov     rcx, qword[aux0]
    mov     qword[aux2],rcx
    add     qword[aux2],1   
    sub     rsi,8
    jmp     calcularResultado
ret  
hexaABinario:
    mov     rsi,0
limpioVectores:
    cmp     rsi,256
    je      vectoreslimpios

    mov     qword[vector+rsi],0
    mov     qword[vectorResultado+rsi],0
    mov     qword[vectorExponente+rsi],0
    add     rsi,8

    jmp     limpioVectores
vectoreslimpios:
    mov     qword[param],0
    mov     qword[param1],8
    mov     rsi,0
    call    pasarDecABina

    mov     rsi,248
    mov     rbx,0
swapVecExpoAVecResul:
    cmp     rsi, 0
    jl      imprimomsgRNCBin
    call    swap
    jmp     swapVecExpoAVecResul
ret
imprimomsgRNCBin:
    mov     rsi,0
    mov     rcx, msgRNCBin
    call    puts
imprimoVecResul:
    call    imprimoVectorResultado
    jmp     binarioObtenido
binarioObtenido:
    mov     qword[diferenciaBH],0
    jmp     calcularExponente
traducirHexa:
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
; Opcion2:Pasar Notacion cientifica a configuracion         ;
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
elegirConf:
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
    mov     qword[msg], msgNotCien
    call    printfString 

    mov     rsi,0
printAntesComa:
    cmp     rsi,8
    jge     printComa

    call    printVec

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

    call    printVec
    
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
    jge     elegirConf

    call    printVec

    jmp     printExpo
;-----------------------------------------------------------;
; Subopcion 1: Notacion Cientifica a configuracion binaria  ;
;-----------------------------------------------------------;
aConfBinaria:
    sub     qword[aux0],8
    mov     rsi,qword[aux0]
    mov     qword[aux2],0
calcularExpoExceso:
    call    pasarBinaADecVec
    jmp     expoExceso
decimalNegativo:
    not     qword[aux]
    inc     qword[aux]
    jmp     opero
ret
reconvierto:
    not     qword[aux]
    inc     qword[aux]
    jmp     pasarDecimalABinario
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
reinicioVectorExpo:
    cmp     rsi,256
    jge     pasarDecimalABinario
    mov     qword[vectorExponente+rsi],0
    add     rsi,8
    jmp     reinicioVectorExpo
pasarDecimalABinario:
    mov     qword[param],0
    mov     qword[param1],8
    mov     rsi,0
    call    pasarDecABina
    mov     rsi,56
    mov     rbx,8
swapVecExpoAVecResultado:
    cmp     rsi, 0
    jl      imprimomsgRNCbin1
    call    swap
    jmp     swapVecExpoAVecResultado
imprimomsgRNCbin1:
    mov     rsi,0
    mov     qword[msg], msgRNCBin
    call    putss
imprimoVecResul1:
   call     imprimoVectorResultado
   jmp      final
;-----------------------------------------------------------;
;Subopcion2:pasarnotacioncientificaaconfiguracionHexadecimal;
;-----------------------------------------------------------;
aConfHexa:
    call    aConfBinaria

    mov     qword[msg], msgenter
    call    putss

    mov     rsi,248
    mov     qword[param],0
    mov     qword[aux],0
    mov     qword[aux2],0
    mov     qword[aux0],0    
    call    pasarBinaADecVecResul
;-----------------------------------------------------------;
; Pasar decimal a  hexadecimal                              ;
;-----------------------------------------------------------;
pasarDeciAHexa:
    mov     qword[aux2],16 
    mov     rsi,0
    mov     rbx,4
dividoDeci:    
    cmp     qword[aux],16
    jl      conviertoCocienteFinal

    mov     rax,qword[aux] 
    sub     rdx,rdx
    idiv    qword[aux2] 
    inc     qword[contador]

    mov     qword[aux],rax
    mov     rdx,rdx
    mov     rdi,rdx
    call    convertir

    mov     [vector+rsi],rdi
    add     rsi,4
    jmp     dividoDeci
conviertoCocienteFinal:
    mov     rdi,qword[aux]
    call    convertir 
    mov     [vector+rsi],rdi
    add     rsi,4
    mov     rsi,27
    mov     rbx,4
imprimoMensajeRNCHexa:
    mov     rsi,36
    mov     qword[msg], msgRNCHexa
    call    putss
imprimoVectorEnHexa:
    cmp     rsi,0
    jl      final

    mov     rcx,stringFormato
    lea     rdx,[vector+rsi]
    add     rsp,32
    call    printf
    sub     rsp,32
    sub     rsi,4
    jmp     imprimoVectorEnHexa
ret
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
retorno:
ret
esA:
    mov     rdi,'A'
    jmp     retorno
esB:
    mov     rdi,'B'
    jmp     retorno
esC:
    mov     rdi,'C'
    jmp     retorno
esD:
    mov     rdi,'D'
    jmp     retorno
esE:
    mov     rdi,'E'
    jmp     retorno
esF:
    mov     rdi,'F'
    jmp     retorno
printVec:
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
;-----------------------------------------------------------;
; Pasar binario a  decimal (vec resul)                      ;
;-----------------------------------------------------------;
pasarBinaADecVecResul:
    cmp     rsi,qword[param]
    jl      final
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     qword[vectorResultado+rsi],0
    je      avanzoVecResul
    cmp     qword[vectorResultado+rsi],1
    je      continuoVecResul
continuoVecResul:
    cmp     qword[aux2],0
    je      elevadoA0VecResul
    cmp     qword[aux2],1
    je      elevadoA1VecResul

    mov     r8,2
    mov     r9,2
    call    potencia
    jmp     avanzoVecResul
elevadoA0VecResul:
    inc     qword[aux]
    jmp     avanzoVecResul
elevadoA1VecResul:
    add     qword[aux],2
    jmp     avanzoVecResul
avanzoVecResul:   
    mov     rcx, qword[aux0]
    mov     qword[aux2],rcx
    
    add     qword[aux2],1
    sub     rsi,  qword[param1]
    jmp     pasarBinaADecVecResul
ret   
potencia:
    imul    r8,r9
    dec     qword[aux2]

    cmp     qword[aux2],1
    jne     potencia

    add     qword[aux],r8
ret
;-----------------------------------------------------------;
; Pasar binario a  decimal  (vector)                        ;
;-----------------------------------------------------------;
pasarBinaADecVec:
    cmp     rsi,184    
    jle     final
    
    mov     rcx, qword[aux2]
    mov     qword[aux0],rcx

    cmp     qword[vector+rsi],0
    je      avanzoVec
    cmp     qword[vector+rsi],1
    je      continuoVec
continuoVec:
    cmp     qword[aux2],0
    je      elevadoA0Vec
    cmp     qword[aux2],1
    je      elevadoA1Vec

    mov     r8,2
    mov     r9,2
    call    potencia
    jmp     avanzoVec
elevadoA0Vec:
    inc     qword[aux]
    jmp     avanzoVec
elevadoA1Vec:
    add     qword[aux],2
    jmp     avanzoVec   
avanzoVec:   
    mov     rcx, qword[aux0]
    mov     qword[aux2],rcx
    add     qword[aux2],1
    sub     rsi,8    
    jmp     pasarBinaADecVec
ret  
;-----------------------------------------------------------;
; Pasar decimal a  binario                                  ;
;-----------------------------------------------------------;
pasarDecABina:
    mov     qword[aux2],2
divido:    
    cmp     qword[aux],2
    jl      agregoCocienteFinal

    mov     rax,qword[aux] ;lo q voy a dividir 
    sub     rdx,rdx
    idiv    qword[aux2] ; divido por 2 

    inc     qword[contador]

    mov     qword[aux],rax
    mov     rdx,rdx
    mov     rdi,rdx
    mov     [vectorExponente+rsi],rdi ; agregar a vector
    add     rsi,8

    jmp     divido
agregoCocienteFinal:
    mov     rdi,qword[aux]
    mov     [vectorExponente+rsi],rdi ; agrego ultimo pedazo a vector 
    add     rsi,8
ret
;-------------------------------------------------------------------------------;
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
swap:
    mov     rdx,[vectorExponente+rsi]
    mov     [vectorResultado+rbx],rdx
    add     rbx,8
    sub     rsi,8
ret
imprimoVectorResultado:
    cmp     rsi, 256
    jge     final
    
    mov     rdx,[vectorResultado+rsi]
    mov     qword[msg],rdx
    call    printfNumero
    add     rsi,8
    jmp imprimoVectorResultado
ret
final:
ret