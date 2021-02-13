; Author : Gener Echeverria LIs

;PIC18F4550

;Iniciar contador de 16 bits en 0
;Interruptor en un pin (Entrada)
;3 puertos como salida -> Primer bit de E, 7 bits de A y 8 bits de D
				;x	    XXX_XXXX	    XXXX_XXXX
;Interrupcion aumenta contador
;valor del contador sacar por puertos. 

#include <p18f4550.inc>
udata_acs
contador RES 2			;Reservo 2 bytes para el contador
CODE 0x00  
    ORG 0x00
    bra inicio 
    ORG 0x08			;Direccion de la interrupcion
    bra ser_inter
    inicio: 
	clrf contador,0
	movlw 0x0F
	movwf ADCON1,0		;Activo puertos
	movlw 0xFF
	movwf TRISB, 0		;Configuro el puerto B como entrada
	
	movlw 0x00
	movwf TRISA,0		;Configuro el puerto A como salida
	movwf TRISD,0		;Configuro el puerto D como salida
	movwf TRISE,0		;Configuro el puerto E como salida
	
	;Configurar INT1
	bsf INTCON3, INT1IE,0		;bit de interrupcion
	bsf INTCON3, INT1IP,0		;bit de prioridad
	bcf INTCON3, INT1IF,0		;bit de bandera
	;Activa interrupciones globales
	bsf INTCON,GIEH,0
	bsf INTCON,GIEL,0
	;Activa prioridad
	bsf RCON,IPEN,0
    
    L1:
	movf contador,W,0		;Muevo parte baja de contador a W
	movwf LATD			;Muevo el valor de W al puerto D
	movf contador+1,W,0		;Muevo la parte alta de contador a W
	movwf LATA			;Muevo el valor de W al puerto A (7 bits)
	movlw 0x00			;Regreso W a 0
	btfsc contador+1,7,0		;Si el bit 7 de contador+1 es 0, salta la instruccion 
	movlw 0x01			;Cuando el bit 7 del contador+1 es 1, iguala W a 0x01
	movwf LATE			;Muevo el valor de w a LATE
    bra L1
	
    ser_inter:
	infsnz contador,F,0		;Incrementa contador, si no es 0 salta uno
	incf contador+1,F,0		;Si contador es 0, enonces aumenta en 1 contador+1
	bcf INTCON3, INT1IF,0		;Apago bandera
    retfie 1			   
END    


