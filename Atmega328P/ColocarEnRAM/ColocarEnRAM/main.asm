;
; ColocarEnRAM.asm
;
; Created: 10/11/2020 09:14:56 a. m.
; Author : gener_000
;

.CSEG 
	ldi r26, low(0x100)
	ldi r27, high(0x100)
	ldi r24, low(0x800)
	ldi r25, high(0x800)
	ldi r16, 0x55

	ciclo:
	st X+, r16
	sbiw r25:r24,1		;aztiva la bandera z
	breq fin			;z=0 no se ejecuta		z=1 se ejecuta
	rjmp ciclo
	fin:

