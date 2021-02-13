# 1 "Main.asm"
# 1 "<built-in>" 1
# 1 "Main.asm" 2

    ;movlb 0x01 ;Debo cargar en BSR el banco
    ;addwf 0x00,0,1 ;se le une el 0x01 al 0x00
       ;La direccion se divide en dos partes 4 y 8 bits,
   ;los 4 bits de mas peso se cargan en el registro BSR
   ;y los 8 bits restantes se le ponen a la instrucción
   ;0x1 00
   ;addwf 0x00,0,1 tendriamos 0x000 porque se ingora el BSR

;direccionar la memoria 0x320
    movlb 0x03 ;muevo 3 a BSR
    movlw 0x50 ;muevo 0x50 al registro w
    movwf 0x20,b ;muevo 50 a la direccion 0x320
    ;addwf 0x20,0,1
    END
