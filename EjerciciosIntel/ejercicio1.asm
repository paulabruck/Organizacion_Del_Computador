;******************************************************
; ejercicio1.asm
; 1. Escribir un programa que imprima por pantalla “Organización del Computador”.
; Objetivos
;	- hacer el primer programa en asm linux 64 bits
;	- aprender la estructura de un programa
;	- mostrar mensaje por pantalla usando puts de C
; - aprender los comandos de ensamblado y linkedicion
;		nasm -fwin64 pgm.asm 
;       gcc pgm.obj -o pgm
;       pgm
;******************************************************
global	main
extern	puts
section		.data
	mensaje		db			"Organizacion del Computador",0		;campo con el string a imprimir.  Debe finalizar con 0 binario

section		.text
main:
	sub     rsp, 28h             ; Reserva espacio para el Shadow Space

	mov		rcx,mensaje		;Parametro 1: direccion del mensaje a imprimir
	call	puts					;puts: imprime hasta el 0 binario y agrega fin de linea

	add     rsp, 28h             ; Libera el espacio reservado del Shadow Space
	ret
