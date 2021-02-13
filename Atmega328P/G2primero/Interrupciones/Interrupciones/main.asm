;
; Interrupciones.asm
;
; Created: 03/12/2020 10:06:50 a. m.
; Author : Gener Echeverria 
;


; Replace with your application code
	.DSEG

	.CSEG
		jmp inicio			;dir 0 y 1
		jmp serv_INT0		;dir 2 y 3			
		jmp serv_INT1		;dir 4 y 5
		;jmp EXT_INT0		;Funcionan igual		Etiquetas especificas para interrupciones INT/        DUDA
		;jmp EXT_INT1
inicio: 
		sbi DDRB,5			;Coloca en bit 5 del puerto B como salida (Uno)
		cbi DDRD,2			;Coloca en bit 2 del puerto D como entrada (Cero)
		sbi PORTD, 2		;activo resistencia pull-up
		cbi DDRD,3			;Coloca en bit 3 del puerto D como entrada (Cero)
		sbi PORTD,3			;activo resistencia pull-up
		ldi r16, 0x00		;muevo 0x00 al registro 16
		sts EICRA, r16		;muevo cero al registro EICRA causa de interrupcion nivel bajo
		sbi EIMSK,0			;activo INT0
		sbi EIMSK,1			;activo INT1
		cbi EIFR,0			;borro bandera de interrupcion 0
		cbi EIFR,1			;borro bandera de interrupcion 1
		sei					;activa interrupciones (SREG<--I=1

L1:		
		rjmp L1

serv_INT0:
		sbi PORTB, 5
		reti

serv_INT1:
		cbi PORTB, 5
		reti