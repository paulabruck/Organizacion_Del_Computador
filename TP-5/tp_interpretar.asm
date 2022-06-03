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
    vectorAux                   times 32 dq 1
    msgLetrasMay                db  "(Ingresar las letras en Mayuscula)",0
    msgProxNum                  db  "~~Proximo Digito: ",0
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
    contador                    dq 0
    Y2                          dq 0
    aux                         dq 0
    aux2                         dq 0
    aux3                        dq  0

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
    mov [vectorAux+rsi],rdi
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
    mov rcx, msgenter
    call puts
extraerExpoExce:
    mov rsi,64
calcularExpoExceso2:
pasarBinaADec2:
    cmp rsi,8   
    jl expoExceso2
    mov rcx, numeroFormato
    mov rdx,qword[vector+rsi]
  ;  call printf
    
    mov rcx, qword[aux2]
    mov qword[Y2],rcx
    cmp qword[vector+rsi],0
    je  avanzo2
    cmp qword[vector+rsi],1
    je  cont2
cont2:
  ;  mov rcx, qword[aux2]
   ; mov qword[Y2],rcx

    cmp qword[aux2],0
    je  elevadoA02
    cmp qword[aux2],1
    je  elevadoA12
    mov r8,2
    mov r9,2
    jmp potencia2
elevadoA02:
    inc qword[aux]
    jmp avanzo2
ret
elevadoA12:
    add qword[aux],2
    jmp avanzo2
ret   
potencia2:
    imul r8,r9
    dec qword[aux2]
    cmp qword[aux2],1
    jne  potencia2
    add qword[aux],r8
    
avanzo2:   
    mov rcx, qword[Y2]
    mov qword[aux2],rcx
    add qword[aux2],1
 
sig2:    
    sub rsi,8
    mov rcx, numeroFormato
    mov rdx, qword[aux]
   ; call printf
    
    jmp calcularExpoExceso2
ret    
expoExceso2:
    mov rcx, numeroFormato
    mov rdx,qword[aux]
  ;  call printf

    sub qword[aux],127
    mov rcx, numeroFormato
    mov rdx,qword[aux]
   ; call printf
lopasoABina:
pasarDecABina2:
    mov qword[aux2],2
    mov rsi,0
    mov rbx,8
 ;   mov rcx, numeroFormato
  ;  mov rdx,qword[aux2]
   ; call printf

   ; mov rcx, numeroFormato
    ;mov rdx,qword[aux]
    ;call printf

   
divido2:    
    cmp     qword[aux],2
    jl      termine2
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
    jmp divido2
termine2:
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
ver222:
    cmp rsi, 0
    jl aver2
    mov     rcx,numeroFormato
    mov     rdx,[vector+rsi]
    mov [vectorResultado+rbx],rdx
    add rbx,8
   ; call    printf
    sub rsi,8
    jmp ver222
ret
aver2:
   
    mov rcx, msgRNCBin
 ;   call puts
     mov rsi,8
ver221:
    cmp rsi, 72
    jge end2
    mov     rcx,numeroFormato
    mov     rdx,[vectorResultado+rsi]
   ; call    printf
    add rsi,8
    jmp ver221
ret
signoNegativoC:
    mov     rcx,numeroFormato
    mov     rdx,-1
    call    printf
    jmp comaa
signoPositivoC:
    mov     rcx,numeroFormato
    mov     rdx,1
    call    printf
    jmp comaa
end2:
    mov rcx,msgenter
    call puts
    mov rcx, msgRBANC
    call puts
    mov rsi,0
    mov     rcx,numeroFormato
    mov     rdx,[vectorAux+rsi]
    cmp rdx,0
    je signoPositivoC

    cmp rdx,1
    je signoNegativoC
comaa:
   mov rcx, stringFormato
   mov rdx, msgcoma
   call printf
   mov rsi,72
otra:
    cmp rsi,256
    jge  fin
    mov     rcx,numeroFormato
    mov     rdx,[vectorAux+rsi]
    call    printf
    add rsi,8
    jmp otra
ret

fin:
    mov rcx, stringFormato
    mov rdx, msgBase
    call printf
    mov rsi,8
    jmp expooo
ret
expooo:
    cmp rsi,72
    jge u
     mov     rcx,numeroFormato
    mov     rdx,[vectorResultado+rsi]
    call    printf
    add rsi,8
    jmp expooo
ret
u:
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
 
ret

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
    mov qword[aux2],0
calcularExpoExceso:
;-----------------------------------------------------------;
; Pasar binario a  decimal                                  ;
;-----------------------------------------------------------;
pasarBinaADec:
    cmp rsi,184    
    jle expoExceso
    mov rcx, numeroFormato
    mov rdx,qword[vector+rsi]
    ;call printf
    
    mov rcx, qword[aux2]
    mov qword[Y2],rcx
    cmp qword[vector+rsi],0
    je  avanzo
    cmp qword[vector+rsi],1
    je  cont
cont:
  ;  mov rcx, qword[aux2]
   ; mov qword[Y2],rcx

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
    jge end
    mov     rcx,numeroFormato
    mov     rdx,[vectorResultado+rsi]
    call    printf
    add rsi,8
    jmp ver2
ret
end:
ret
aConfHexa:
    call aConfBinaria
    mov rcx, msgenter
    call puts
    mov rsi,248
    mov qword[aux],0
    mov qword[aux2],0
    mov qword[Y2],0

c:    
pasarBinaADec1:
    cmp rsi,0    
    jl impri
    mov rcx, numeroFormato
    mov rdx,qword[vectorResultado+rsi]
  ;  call printf
    mov rcx, qword[aux2]
    mov qword[Y2],rcx
    cmp qword[vectorResultado+rsi],0
    je  avanzo1
    cmp qword[vectorResultado+rsi],1
    je  cont1
cont1:
    mov rcx, qword[aux2]
    mov qword[Y2],rcx

    cmp qword[aux2],0
    je  elevadoA01
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
    mov rcx, qword[Y2]
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
  ;  mov     qword[Y2],rdx
    inc     qword[contador]

     mov qword[aux],rax
  ;  mov rcx, numeroFormato
    mov rdx,rdx;qword[Y2]
    ;call printf
    ;mov rcx, msgenter
    ;call puts
  ;  mov qword[aux3],rdx
   ; mov [vector+rsi],rdi
  
    ; mov rdx,qword[aux3]
  ;  lea rdx,[vector+rsi]
    mov rdi,rdx
    cmp rdi,9
    jg convertir
    jmp conversionN
    
agregoo:
    mov [vector+rsi],rdi
    
    add rsi,4
    jmp divido1
convertir:
    mov rcx,numeroFormato
    mov rdx,rdi
    ;call printf
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
    mov rcx, numeroFormato
    mov rdx, qword[aux]
   ; call printf
    mov rdi,qword[aux]
    jmp convertir1
sigo:  
    mov [vector+rsi],rdi
    add rsi,4
     mov rcx, msgenter
   ;call puts
    mov rcx, numeroFormato
    mov rdx, qword[contador]
   ; call printf
    mov rsi,27
    mov rbx,4
ver1:
    cmp rsi, 0
    jl aver1
    mov     rcx,stringFormato
   ; mov     rdx,[vector+rsi]
    lea rdx,[vector+rsi]
    mov [vectorResultado+rbx],rdx
    add rbx,4
    ;call    printf
    sub rsi,4
    jmp ver1
ret
aver1:
    mov rsi,36;0
    mov rcx, msgRNCHexa
     call puts
ver21:
    cmp rsi, 0;36
    jl end1
    mov     rcx,stringFormato
  ;  mov     rdx,[vectorResultado+rsi]
    lea rdx,[vector+rsi]
    call    printf
    sub rsi,4
    jmp ver21
ret
end1:
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