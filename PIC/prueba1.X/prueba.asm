;colocar el valor 0x20 en la direccion de memoria RAM 0x222
;colocar el valor 0x20 en la direccion de memoria RAM 0x323    
;Hacer la suma de ambos valores y colocar el resultado en 0x000    
    code 0x00
    
    movlb 0x02		;muevo 2 a BSR
    movlw 0x20		;muevo 0x20 al registro w
    movwf 0x22,1	;muevo 0x20 a la direccion 0x222 porque le pega el BSR
    movlb 0x03		;muevo3 a BSR
    movlw 0x30		;muevo 0x30 al registro w
    movwf 0x23,1	;;muevo 0x23 a la direccion 0x323 porque le pega el BSR
    movlb 0x02		;muevo 2 a BSR
    addwf 0x22, 0 ,1	;Sumo lo que hay en W con 0x222 y resultado en w
    movwf 0x00,0	;muevo w a la direccion 0x000, no usa BSR asi que le pega 0
    nop
    
    
    END