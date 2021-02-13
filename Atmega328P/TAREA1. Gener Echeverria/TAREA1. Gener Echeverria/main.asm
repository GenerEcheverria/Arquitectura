;
; TAREA1. Gener Echeverria.asm
;
; Created: 10/11/2020 09:28:07 a. m.
; Author : gener_000
;


; Replace with your application code
.EQU valor = 0x55
.EQU inicial = 0x100
.EQU final = 0x8ff

.CSEG 
	ldi r26, low(inicial)
	ldi r27, high(inicial)
	ldi r28, low(final)
	ldi r29, high(final)
	ldi r16, valor

	llenar:
	st X+, r16
	cp r28,r26
	cpc r29,r27
	brne llenar
	nop
