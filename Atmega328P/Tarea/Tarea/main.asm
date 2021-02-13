;
; Tarea.asm
;
; Created: 16/01/2021 11:19:34 a. m.
; Author : Gener Echeverria LIS
;

;ATMEGA328P

;Iniciar contador de 16 bits en 0
;Interruptor en un pin (Entrada): PD2 (INT0)
;Puertos como salida para sacar el valor del contador	
	; PD		  PC		  PB
	;D7-D4		C5-C0		B5-B0
	;xxxx_		xxxx_xx		xx_xxxx
;Interrupcion aumenta contador

.DSEG
	contador: .BYTE 2			;Reservo 2 bytes		Está en 0x100
	
.CSEG
	jmp inicio
	jmp serv_INT0		
	
	inicio:
		ldi r16, 0x00			;0x00
		sts contador, r16		;Nos aseguramos de que contador  inicie en 0 (8 bits bajos)
		sts contador+1, r16		;(8 bits altos) 

		ldi r16,0x3F			;0011_1111
		out DDRB, r16			;Configuro el puerto B (B5-B0) como salida
		out DDRC, r16			;Configuro el puerto C (C5-C0) como salida
		ldi r16,0xF0			;1111_0000
		out DDRD,r16			;Configuro (D7-D4) como salida y el resto como entrada (INT0 en D2)
		sbi PORTD,2				;activo resistencia pull-up

		ldi r16, 0x00		;muevo 0x00 al registro 16
		sts EICRA, r16		;muevo cero al registro EICRA causa de interrupcion nivel bajo
		sbi EIMSK,0			;activo INT0
		cbi EIFR,0			;borro bandera de interrupcion 0
		sei					;activa interrupciones (SREG<--I=1)
		
	L1:	
		lds r16, contador		;Muevo 8 bits bajos almacenados en contador a r16
		out PORTB, r16			;Asigno en B los 6 bits bajos de la parte baja de contador
								;Giro a la derecha para dejar los 2 bits altos de de contador (representa el bit 8 y 7 de los 16 totales)
		lsr r16					;0XXx_xxxx
		lsr r16					;00XX_xxxx
		lsr r16					;000X_Xxxx
		lsr r16					;0000_XXxx
		lsr r16					;0000_0XXx
		lsr r16					;0000_00XX
		lds r17, contador+1		;Muevo 8 bits altos almacenados en contador+1 a r17
		out PORTD,r17			;Asigno a D los 4 bits mas altos de la parte alda del contador+1
								;Giro a la izquierda para dejar los 6 bits bajos de contador+1 (Representa el bit 9 al 14 de los 16 totales)
		lsl r17					;xxxX_XXX0
		lsl r17					;xxXX_XX00
		add r16,r17				;Sumo r16 y r17 para juntar del 7mo al 12vo bit del contador (16 bits)
		out PORTC,r16			;Asigno a c los 6 bits faltantes guardados en r16
		rjmp L1

	serv_INT0:
		lds r17,contador		;asigno los 8 bits bajos del contador a r17
		inc r17					;Incremento en 1 
		sts contador,r17		;Almaceno en contador(8 bits bajos) el valor de r17
		brbs 1, alta			;Si se activa la bandera Z, salto a alta para incrementar los 8 bits altos de contador
		reti
		alta:
		lds r17,contador+1		;asigno los 8 bits altos del contador a r17
		inc r17					;Incremento en 1 
		sts contador+1,r17		;Almaceno en contador+1(8 bits altos) el valor de r17
		reti



