#include <p18f4550.inc>
    CODE 0x00
    ;1. Configurar el puerto A como digital y como entrada los pines A2,A1,A0
    movlb 0x0F		;bsr ultimo banco (porque ahi esta puertos) si quisiera usar la memoria ampliada como en la linea 6
    movlw 0x0F		;W<--0x0F
    iorwf ADCON1,1,BANKED 	;W-->ADCON1	ADCON! solo activa A,B,E
    
    ;1)
    ;movlw 0x07		;W<--0x07  00000111
    ;movwf TRISA,0	;W-->TRISA
	;w=00000111
	;TRISA=00000111
    
    ;2)
    movlw 0x07		;W<--0x07  b´00000111´
    iorwf TRISA,1,0
	;w	   =00000 111
	;or
	;TRISA =xxxxx xxx
	;EX	   =xxx10 x01
	;	       10 111
    
;2. Configurar el puerto B como digital y como salida B3,B2, B1, B0
    movlw 0xF0
    andwf TRISB,1,0
;3. Leer el puerto A (PA->W)
oty:    
    movf PORTA, 0,0
;4. Sumar 2 unidades a W (W<-W+2)
    andlw 0x07
    addlw 2
;5. Mover lo que hay en W al puerto B(W->PB3,PB2,PB1,PB0)
    movwf LATB, 0 
;6. Repite desde el paso 3  
    bra oty
    END


