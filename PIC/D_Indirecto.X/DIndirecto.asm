;********************************************
;Elaborar un programa para el PIC18F4550 que escriba desde la direccion 0x00
;hasta la direccion 0x100 de la RAM el valor 0xAA    
;********************************************   
#include <p18f4550.inc>    
CODE 0x00
    LFSR 1, 0x000
    movlw 0xAA
    L1:
	movwf INDF1,0	;AA-->0x000
	incfsz FSR1L,F,0	;FSR1L 0x01--> FSR1H:FSR1L	0x001
    bra L1
    incf FSR1H,F,0
    movwf INDF1,0
    nop
    /*ciclo: 
	MOVF INDF1, w, 0
	MOVWF INDF1,0
	ADDWF 0x01,0,0
	MOVF INDF1, w, 0	
	movlw 0xAA
	;btfss PORTD, 0, ACCESS
    bra ciclo*/
END    
    ;Punteros
    ;FSR0 --> FSR0H:FSR0L
    ;FSR1 --> FSR1H:FSR1L
    ;FSR2 --> FSR2H:FSR2L
 
    
    