;
; G2primero.asm
;
; Created: 29/10/2020 09:44:32 a. m.
; Author : gener_000
;


; Replace with your application code
;1.- Instrucciones y su sintaxis 
;2.-Directivas
;3.-Macros: Sustitucion de codigo que invoca funciones

//main //directiva
//include //directiva
//int //directiva en C. Le indica que reserve memoria 

//while	//instruccion

//printf //Macro. Pega codigo 

;defino mis datos 
	.EQU valor1 = 0x10
	.EQU valor2 = 0x20

	.DSEG //DATOS
	OPER1: .BYTE 1
	OPER2: .BYTE 1
	RESUL: .BYTE 2

	.CSEG //CODIGO
	ldi r16, valor1
	ldi r17, valor2
	sts OPER1, r16
	sts OPER2, r17
	add r16, r17
	sts RESUL, r16

	