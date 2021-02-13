;
; SP test.asm
;
; Created: 19/11/2020 09:32:19 a. m.
; Author : gener_000
;


; Replace with your application code
.CSEG
	ldi r16,5
	push r16	;cargo en la pila el contenido de r16 o sea 5. (SP=0x8FF pero meto en la pila, SP=0x8FE) Porque PUSH decrementa en 1
	ldi r16,3
	push r16	;cargo en la pila el contenido de r16 o sea 3. (SP=0x8FE pero meto en la pila, SP=0x8FD
	call suma	;llamo a la subrutina suma. (SP=0x8FD pero meto a la pila, SP=0x8FB) Porque call decrementa en 2
	pop r7
	sts 0x100, r7
	rjmp fin

suma: 
	;ejemplo 1
	pop r4		;saco parte de la direccion de retorno de la pila
	pop r5		;saco parte de la direecion de retorno de la pila
	pop r0		;saco operando 3
	pop r1		;saco operando 5 y lo guardo en r1
	
	add r0,r1	;sumo
	push r0		;meto resultado a la pila
	push r5		;regreso direccion de retorno
	push r4		;regreso direccion de retorno
	ret			;regreso de subrutina
	

fin: 
	nop
