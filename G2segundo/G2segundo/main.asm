;
; G2segundo.asm
;
; Created: 30/10/2020 09:34:34 a. m.
; Author : gener_000
;*************************************************************************************************
;Programa que pone en memoria RAM 0x100 y 0x200, suma dos valores y coloca el resultado en memoria 
;*************************************************************************************************

	.EQU valor1 = 0x00241750		;define a la etiqueta valor1 0x100
	.EQU valor2 = 0x74239765	

	.DSEG
	OPER1: .BYTE 4	;X	Reserva memoria tamaño 16bit/2byte en la RAM
	OPER2: .BYTE 4	;Y
	RESUL: .BYTE 4	;Z

	;int x=2, y=3, z;	No tengo sistema operativo 

	.CSEG
	;ldi solo se usa a partir de r26

	ldi r26, low(OPER1)		;OPER1 contiene la direccion de la memoria RAM de hasta 12bit y r26 es de 8bit
	ldi r27, high(OPER1)	;OPER1 contiene la direccion de la memoria RAM de hasta 12bit y r27 es de 8bit

	ldi r28, low(OPER2)		;OPER2 contiene la direccion de la memoria RAM de hasta 12bit y r28 es de 8bit
	ldi r29, high(OPER2)	;OPER2 contiene la direccion de la memoria RAM de hasta 12bit y r29 es de 8bit

	ldi r30, low(RESUL)		;RESUL contiene la direccion de la memoria RAM de hasta 12bit y r30 es de 8bit
	ldi r31, high(RESUL)	;RESUL contiene la direccion de la memoria RAM de hasta 12bit y r31 es de 8bit

	ldi r16, low(valor1)	;Copio los 8bit bajos de 0x100 al registro r16 
	mov r0, r16
	ldi r17, high(valor1)	;Copio los 8bit altos de 0x100 al registro r17 
	mov r1, r17
	ldi r18, BYTE3(valor1)
	mov r2, r18
	ldi r19, BYTE4(valor1)
	mov r3, r19

	ldi r20, low(valor2)	;Copio los 8bit bajos de 0x200 al registro r18
	mov r4,r20
	ldi r21, high(valor2)	;Copio los 8bit altos de 0x200 al registro r19
	mov r5,r21

	ldi r22, BYTE3(valor2)	;Copio los 8bit bajos de 0x200 al registro r18
	mov r6,r22
	ldi r23, BYTE4(valor2)	;Copio los 8bit altos de 0x200 al registro r19
	mov r7,r23

	st X+, r16				;Copia a la memoria RAM apuntada por X el valor 0x00 e incrementa el puntero  
	st X+, r17				;Copia a la memoria RAM apuntada por X el valor 0x01   
	st X+, r18				;Copia a la memoria RAM apuntada por Y el valor 0x00 e incrementa el puntero  
	st X+, r19				;Copia a la memoria RAM apuntada por Y el valor 0x02
	st Y+,r20
	st Y+,r21
	st Y+,r22
	st Y,r23
	
	add r0, r4				;sumo partes bajas y dejo en r0
	adc r1,r5				;sumo partes altas y dejo en r1
	adc r2,r6
	adc r3,r7

	st Z+, r0				;Muevo a memoria parte baja e incremento puntero
	st Z+, r1				;Muevo a memoria parte alta
	st Z+, r2
	st Z, r3