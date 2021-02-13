;
; PuertosG2.asm
;
; Created: 27/11/2020 09:17:47 a. m.
; Author : Gener
;


; Replace with your application code

.CSEG
	cbi DDRD,0
	sbi DDRB,5
oty:
	in R0, PIND
	lsl r0
	lsl r0
	lsl r0
	lsl r0
	lsl r0
	out PORTB, r0
	rjmp oty