;
; PrenderLED.asm
;
; Created: 26/11/2020 10:58:33 a. m.
; Author : Gener Echeverria
;


; Replace with your application code
.CSEG
	cbi DDRD,0
	cbi PORTD,0 ;
	sbi DDRB,5
	
	in r0, PIND

	rol r0
	rol r0
	rol r0
	rol r0
	rol r0

	out PORTB, r0
	nop