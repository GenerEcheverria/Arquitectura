;
; Ciclo.asm
;
; Created: 22/11/2020 07:20:19 p. m.
; Author : gener_000
;


; Replace with your application code
.CSEG
	ldi r26, low(0x100)
	ldi r27,high( 0x100)
	ldi r24, low (0x100)
	ldi r25, high (0x100)
	ldi r18, 1
	ldi r19,1

ciclo: 
	st X+, r18
	add r18,r19
	sbiw r25:r24, 1
	breq fin
	rjmp ciclo

fin:
	nop
