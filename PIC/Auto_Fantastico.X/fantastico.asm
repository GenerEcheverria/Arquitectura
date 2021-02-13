;*******************************
;Programa que prende en forma secuencial 8 diodos led conectados al puerdo D 
;del PIC18F4550. Primero prende el led conectado en D0, los demas leds apagados, 
;luego prende el led conectado a D1, los demás leds apagados, así hasta el led D8
; y regresa
;**********************************    
;1. Configuras puerto como salida y digital
;2. Sacar por el puerto 0000 0000
;3. Sacar por el puerto 0000 0001 (Rotacion <-)
;4. Sacar por el puerto 0000 0010
;5. Sacar por el puerto 0000 0100
;6. ...
;7. Sacar por el puerto 1000 0000 (Verificar el estado de un bit en un byte)
;8. Sacar por el puerto 0100 0000 (Rotacion ->)
;9. Sacar por el puerto 0010 0000
;10. ...
;11. Sacar por el puerto 0000 0001 (Igual a paso 3 y repite) (Verificar el estado de un bit en un byte)
include <p18f4550.inc>
    CODE 0x00
    ;1. Configuras puerto como salida y digital
    clrf TRISD,ACCESS
    ;2. Sacar por el puerto 0000 0000
    ;3. Sacar por el puerto 0000 0001 (Rotacion <-)
    movlw b'00000001'
    movwf LATD,ACCESS
    L1: 
	rlncf LATD, F, ACCESS
	btfss PORTD, 7, ACCESS
    bra L1
    L2:
	rrncf LATD, F, ACCESS
	btfss PORTD, 0, ACCESS
    bra L2
    bra L1
END    
    
   
    
    