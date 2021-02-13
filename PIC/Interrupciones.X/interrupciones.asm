;Por medio de un interrupctor
;conectado en el puerto B pin 1  se genere una interrupcion en cuyo servicio
;se incremente un contador de 8 bits
    
;NOTA Cada pin tiene una interrupcion especifica. Checar esquema
#include<p18f4550.inc>    
udata_acs
conta RES 2	    ;2 para el ejercicio
 
CODE 0x000
    bra inicio
    ORG 0x08
    bra ser_inter
    inicio:
	clrf conta,0
	;Configuracion del puerto
	movlw 0x0F
	movwf ADCON1,0
	movlw 0xFF
	movwf TRISB, 0
	;Configurar puertos
	
	
	;Configurar INT1
	bsf INTCON3, INT1IE,0
	bsf INTCON3, INT1IP,0
	bcf INTCON3, INT1IF,0
	;Activa interrupciones globales
	bsf INTCON,GIEH,0
	bsf INTCON,GIEL,0
	;Activa prioridad
	bsf RCON,IPEN,0
    oty:
	movf conta,W,0		;Muevo parte baja de conta a w
	movwf PORTX
	movf conta+1,W,0
	movwf PORTY
    bra oty
    ser_inter:
	incf conta,F,0
	bcf INTCON3, INT1IF,0
    retfie 1
END
 


