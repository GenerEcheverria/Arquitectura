;
; Potencia.asm
;
; Created: 22/11/2020 08:06:25 p. m.
; Author : gener_000
;


; Replace with your application code
.CSEG
	ldi r22,2		;base
	push r22
	ldi r22, 4		;exponente
	push r22
	call exp
	pop r7
	sts 0x100,r7
	rjmp finished

exp: 
	pop r0
	pop r1
	pop	r2
	pop r3
	ldi r23,1
	sub r2,r23
	ciclo:
		add r3,r3
		sub r2,r23
		breq fin
		rjmp ciclo
	fin:
		push r3
		push r1
		push r0
		ret

finished:
	nop