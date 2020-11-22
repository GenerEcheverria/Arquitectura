;
; SP test.asm
;
; Created: 19/11/2020 09:32:19 a. m.
; Author : gener_000
;


; Replace with your application code
.CSEG
	ldi r16,5
	push r16			;cargo en la pila el contenido de r16 o sea 5. (SP=0x8FF pero meto en la pila, SP=0x8FE) Porque PUSH decrementa en 1
	ldi r16,3
	push r16			;cargo en la pila el contenido de r16 o sea 3. (SP=0x8FE pero meto en la pila, SP=0x8FD
	call suma			;llamo a la subrutina suma. (SP=0x8FD pero meto a la pila, SP=0x8FB) Porque call decrementa en 2
	in r24,SPL			;Regreso con pila SP=0x8FD, SPL=0xFD
	in r25, SPH			;Regreso con pila SP=0x8FD, SPL=0x08
	adiw r25:r24, 1
	out SPL,r24
	out SPL, r25		;Pila SP=0x8FE

	pop r7				;Pila SP=0x8FF
	sts 0x100, r7
	nop
	rjmp fin

suma: 
	;ejemplo 2
	in r24,SPL			;leo la parte baja de SP=0x8FB,SPL=0xFB
	in r25, SPH			;leo la parte alta de SP=0x8FB, SPH=0x08
	adiw r25:r24, 2		;Sumo dos unidades al SP=0x8FD
	out SPL,r24			;Lo regreso a la pila
	out SPL, r25		;Lo regreso a la pila  SP=0x8FD

	pop r0		;Saco el valor 3 de la pila, SP=0x8FE
	pop r1		;Saco el valor 5 de la pila, SP=0x8FF
	add r0,r1	;sumo
	push r0		;meto resultado a la pila, SP=0x8FE

	in r24,SPL			;leo la parte baja de SP=0x8FE, SPL=0xFE
	in r25, SPH			;leo la parte alta de SP=0x8FE, SPH=0x08
	sbiw r25:r24, 3		
	out SPL,r24
	out SPL, r25		;la pila es SP=0x08FB

	ret					;Retorno a main SP=0x08FD
fin: 
	nop
