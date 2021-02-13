;********************************************
;Elaborar un programa para el PIC18F4550 que escriba desde la direccion 0x00
;hasta la direccion 0x100 de la RAM el valor 0xAA    
;********************************************   
#include <p18f4550.inc>    
CODE 0x00
    
    LFSR 0, 0x000
    movlw 0xAA
    ciclo: 
	MOVF INDF0, w, 0
	MOVWF INDF0,0
	ADDWF 0x001,0,0
	MOVF INDF0, w, 0	
	movlw 0xAA
	;btfss PORTD, 0, ACCESS
    bra ciclo
    
    ;Punteros
    ;FSR0 --> FSR0H:FSR0L
    ;FSR1 --> FSR1H:FSR1L
    ;FSR2 --> FSR2H:FSR2L