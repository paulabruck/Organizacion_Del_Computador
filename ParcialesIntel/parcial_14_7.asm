;Se cuenta con un archivo en formato binario llamado ENCUESTA.DAT que contiene
;información de las respuestas de una encuesta que consultaba a empleados de 10
;compañías cuál es el recurso más importante que el empleador debía pagar para
;facilitar el trabajo remoto y daba para elegir 4 opciones (Internet, Computadora, Silla,
;Luz). Cada registro del archivo representa la respuesta de un empleado y contiene la
;siguiente información:
; Código de recurso: 2 bytes en formato ASCII (IN, CO, SI, LU)
; Código de compañía: 1 byte en formato binario punto fijo sin signo (1 a 10)
;Se pide realizar un programa en assembler Intel que:
;1. Lea el archivo y por cada registro llene una matriz (M) de 4x10 donde cada fila
;representa a un recurso y cada columna una compañía.  Cada elemento de M es
;un binario de punto fijo sin signo de 2 bytes y representa la sumatoria de
;respuestas para cada recurso en cada compañía; 
;2. Validar los datos del registro mediante una rutina interna (VALREG) para que
;puedan ser descartados los inválidos.
;3. Padrón PAR: ingresar por teclado un código de recurso e informar por pantalla la
;compañía que más lo eligió y que % representa del total.  Padrón IMPAR:
;ingresar por teclado un código de compañía e informar por pantalla el recurso
;con mayor cantidad de votos y que % representa del total.

global 	main
extern 	printf
extern  gets
extern  sscanf
extern  puts

section  		.data

    ; Definiciones del archivo binario
	fileName	db	"PRECIOS.dat",0
    mode		db	"rb",0		; modo lectura del archivo binario
	msgErrOpen	db  "Error en apertura de archivo",0

    matriz      times 40 dw 0
section  		.bss

section 		.text
main:

ret