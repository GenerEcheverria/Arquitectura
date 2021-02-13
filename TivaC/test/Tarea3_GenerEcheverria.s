;EJERCICIO
;Elabore un programa, en ensamblador, para la tarjeta TIVA C con el microcontrolador
;TM4C1294NCPDT; que lea el estado de un interruptor conectado en cualquier pin de cualquier puerto
;e incremente un contador de 16 bit cada vez que el interruptor cambie de uno a cero, además, muestre
;la cuenta del contador en 16 diodos leds conectados a los pines de puertos.
;*********************************************************************************************************
;AUTOR: Gener Alejandro Echeverria Chi 
;LIS
;Arquitectura de computadoras

;***************************************************************************************************
;
;Se usará el Switch 1 del Tiva como interruptor por lo que PJ0 ser usará como entrada
;Se usará los 8 pines del puerto K y los 8 del puerto M como salidas para representar los 16 bits del contador 
;siendo K los 8 bits bajos y M los 8 bits altos 
;****************************************************************************************************

;Seleccion de control de modo digital (Alternativo o generico)
GPIO_PORTJ_AFSEL_R EQU 0x40060420	
GPIO_PORTK_AFSEL_R EQU 0x40061420	
GPIO_PORTM_AFSEL_R EQU 0x40063420	
	
;Habilitacion digital
GPIO_PORTJ_DEN_R EQU 0x4006051C	
GPIO_PORTK_DEN_R EQU 0x4006151C
GPIO_PORTM_DEN_R EQU 0x4006351C
	
;Habilitacion analogica	
GPIO_PORTJ_AMSEL_R EQU 0x40060528	
GPIO_PORTK_AMSEL_R EQU 0x40061528
GPIO_PORTM_AMSEL_R EQU 0x40063528
	
;Resistencia pull up	
GPIO_PORTJ_PUR_R EQU 0x40060510
	
;entrada/salida
GPIO_PORTJ_DIR_R EQU 0x40060400	
GPIO_PORTK_DIR_R EQU 0x40061400	
GPIO_PORTM_DIR_R EQU 0x40063400	

;Máscara
GPIO_PORTJ_DATA_R EQU 0x40060004	;PJ0 
GPIO_PORTK_DATA_R EQU 0x400613FC	;PK7-PK0
GPIO_PORTM_DATA_R EQU 0x400633FC	;PM7-PM0

;Activacion de puertos
SYSCTL_RCGCGPIO EQU 0x400FE608
	
;lectura para saber si se puede se activó
STSCTL_PRGPIO EQU 0x400FEA08

;--------------------SEGMENTO DE DATOS 
			AREA DATOS, DATA, READWRITE, ALIGN=2
CONTA	SPACE 2		;Reservo 16 bits para el contador	DIRECCION 0X20000000				


;---------------------SEGMENTO DE CODIGO
			AREA |.text|, CODE, READONLY , ALIGN=2
			THUMB	
			EXPORT Start
Start	
;Activo el puerto J 
			LDR R0, =SYSCTL_RCGCGPIO	;R0 se le asigna la direccion 0x400FE608
			LDR R1, [R0]				;Cargo el valor de la direccion 0x400FE608 a R1
			ORR R1, #0x100				;1_xxxx_xxxx (Puerto J)
			STR R1, [R0]				;Enciendo el Puerto J (Bit 8 de RCGCGPIO)
			LDR R0, =STSCTL_PRGPIO		;R0 se le asigna la direccion 0x400FEA08
;Ciclo para comprobar la activacion del puerto J
no_listoJ			
			LDR R1, [R0]				;Cargo el valor de la direccion 0x400FEA08 a R1
			ANDS R1, #0x100				;AND con bandera para comprobar que se activó J
			BEQ no_listoJ
			
			
;Activo el puerto K
			LDR R0, =SYSCTL_RCGCGPIO	;R0 se le asigna la direccion 0x400FE608
			LDR R1, [R0]				;Cargo el valor de la direccion 0x400FE608 a R1
			ORR R1, #0x200				;1x_xxxx_xxxx (Puerto J)
			STR R1, [R0]				;Enciendo el Puerto K (Bit 9 de RCGCGPIO)
			LDR R0, =STSCTL_PRGPIO		;R0 se le asigna la direccion 0x400FEA08
;Ciclo para comprobar la activacion del puerto K			
no_listoK			
			LDR R1, [R0]				;Cargo el valor de la direccion 0x400FEA08 a R1
			ANDS R1, #0x200				;AND con bandera para comprobar que se activó K
			BEQ no_listoK
			
			
;Activo puerto M
			LDR R0, =SYSCTL_RCGCGPIO	;R0 se le asigna la direccion 0x400FE608
			LDR R1, [R0]				;Cargo el valor de la direccion 0x400FE608 a R1
			ORR R1, #0x800				;1xxx_xxxx_xxxx Puerto M (Bit 11)
			STR R1, [R0]				;Enciendo el Puerto M (Bit 11 de RCGCGPIO)
			LDR R0, =STSCTL_PRGPIO		;R0 se le asigna la direccion 0x400FEA08
no_listoM			
			LDR R1, [R0]				;Cargo el valor de la direccion 0x400FEA08 a R1
			ANDS R1, #0x800				;AND con bandera para comprobar que se activó M
			BEQ no_listoM
			
			
;Configuración de Puerto J (PJ0) como entrada
			LDR R0, =GPIO_PORTJ_AFSEL_R		;Cargo la direccion 0x40060420 a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40060420 a R1
			BIC R1, #0x01					;Niega valor y hace AND para poner 0 en el bit 0 de R1. 0 = Utilizo el pin como GPIO
			STR R1, [R0]					;El valor de R1 lo envio a 0x40060420.  
			
			LDR R0, =GPIO_PORTJ_DEN_R		;Cargo la direccion 0x4006051C a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x4006051C a R1
			ORR R1, #0x01					;OR inclusiva. Pongo 1 en el bit 0 de R1. 1 = habilito funciones digitales.
			STR R1, [R0]					;El valor de R1 lo envio a 0x4006051C 
			
			LDR R0, =GPIO_PORTJ_AMSEL_R		;Cargo la direccion 0x40060528 a R0 
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40060528 a R1
			BIC R1, #0x01					;Niega valor y hace AND para poner 0 en el bit 0 de R1. 0 = Desactiva funciones analógicas
			STR R1, [R0]					;El valor de R1 lo envio a 0x40060528
			
			LDR R0, =GPIO_PORTJ_PUR_R		;Cargo la direccion 0x40060510 a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40060510 a R1
			ORR R1, #0x01					;OR inclusiva. Pongo 1 en el bit 0 de R1. 1 = activo resistencias pull up
			STR R1, [R0]					;El valor de R1 lo envio a 0x40060510
			
			LDR R0, =GPIO_PORTJ_DIR_R		;Cargo la direccion 0x40060400 a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40060400 a R1
			BIC R1, #0x01					;Niega valor y hace AND para poner 0 en el bit 0 de R1. 0 = Pin de entrada					
			STR R1, [R0]					;El valor de R1 lo envio a 0x40060400
			
			
;Configuracion de Puerto K (PK0-PK7) como salida
			LDR R0, =GPIO_PORTK_AFSEL_R		;Cargo la direccion 0x40061420 a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40061420 a R1
			BIC R1, #0xFF					;Niega valor y hace AND para poner 0 en el bit 0-7 de R1. 0 = Utilizo el pin como GPIO
			STR R1, [R0]					;El valor de R1 lo envio a 0x40061420
			
			LDR R0, =GPIO_PORTK_DEN_R		;Cargo la direccion 0x4006151C a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x4006151C a R1
			ORR R1, #0xFF					;OR. Pongo 1 en el bit 0-7 de R1. 1 = habilito funciones digitales.
			STR R1, [R0]					;El valor de R1 lo envio a 0x4006151C
			
			LDR R0, =GPIO_PORTK_AMSEL_R		;Cargo la direccion 0x40061528 a R0 
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40061528 a R1
			BIC R1, #0xFF					;Niega valor y hace AND para poner 0 en el bit 0-7 de R1. 0 = desactivo funciones analógicas
			STR R1, [R0]					;El valor de R1 lo envio a 0x40061528
			
			LDR R0, =GPIO_PORTK_DIR_R		;Cargo la direccion 0x40061400 a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40061400 a R1
			ORR R1, #0xFF					;OR. Pongo 1 en el bit 0-7 de R1. 1 = Pin de salida					
			STR R1, [R0]					;El valor de R1 lo envio a 0x40061400
			
			
;Configuracion de Puerto M (PM0-PM7) como salida
			LDR R0, =GPIO_PORTM_AFSEL_R		;Cargo la direccion 0x40063420 a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40063420 a R1
			BIC R1, #0xFF					;Niega valor y hace AND para poner 0 en el bit 0-7 de R1. 0 = Utilizo el pin como GPIO
			STR R1, [R0]					;El valor de R1 lo envio a 0x40063420
			
			LDR R0, =GPIO_PORTM_DEN_R		;Cargo la direccion 0x4006351C a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x4006351C a R1
			ORR R1, #0xFF					;OR. Pongo 1 en el bit 0-7 de R1. 1 = habilito funciones digitales.
			STR R1, [R0]					;El valor de R1 lo envio a 0x4006351C
			
			LDR R0, =GPIO_PORTM_AMSEL_R		;Cargo la direccion 0x40063528 a R0 
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40063528 a R1
			BIC R1, #0xFF					;Niega valor y hace AND para poner 0 en el bit 0-7 de R1. 0 = desactivo funciones analógicas
			STR R1, [R0]					;El valor de R1 lo envio a 0x40063528
			
			LDR R0, =GPIO_PORTM_DIR_R		;Cargo la direccion 0x40063400 a R0
			LDR R1, [R0]					;Cargo el valor que hay en a direccion 0x40063400 a R1
			ORR R1, #0xFF					;OR. Pongo 1 en el bit 0-7 de R1. 1 = Pin de salida						
			STR R1, [R0]					;El valor de R1 lo envio a 0x40063400
			
			
			LDR R4, =GPIO_PORTK_DATA_R		;Cargo la direccion 0x400613FC a R4
			LDR R5, =GPIO_PORTM_DATA_R		;Cargo la direccion 0x400633FC a R5
			MOV R1,#0x0000					;Muevo  el valor 0x0000 a R1
			LDR R0, =CONTA					;Cargo la direccion de CONTA a R0 
			STRH R1,[R0]					;El valor de R1 (16 bits)lo envio a la direccion de CONTA. Inicializo el contador en 0x0000

;Ciclo de reposo. El interruptor no esta presionado y muestro el valor del contador (parte baja) por los 8 pines del puerto K
; y (parte alta) por los 8 pines del puerto M
ciclo			
			LDRH R6,[R0]					;Muevo a R6 el valor (de 16 bits) que contiene la direccion del contador 
			STRB R6,[R4]					;Muevo el valor de R6 (solo 8 bits bajos)a donde apunta R4 (0x400613FC) para sacar los 8 bits bajos del contador por el puerto K
			ASR R7,R6,#8					;Hago un shift a la derecha (8 veces) del valor de R6(Tiene el valor de CONTA)
											;y lo guardo en R7 (Para quedarme con los 8 bits altos del contador)
			STRB R7,[R5]					;Muevo el valor de R7 (solo 8 bits) a donde apunta R5 (0x400633FC) para sacar los 8 bits altos del contador por el puerto M

			LDR R2, =GPIO_PORTJ_DATA_R		;Cargo la direccion 0x40060004 (puerto J pin 0 interruptor) a R2
			LDR R3,[R2]						;Cargo a R3 el valor al que apunta R2 (direccion 0x40060004)
			CBZ R3,contador					;Si R3 tiene un valor de 0x0000 (El interruptor es presionado) salto a la etiqueda contador
			B ciclo

;Salto en donde aumento en uno el contador 
contador
			LDR R0, =CONTA					;Cargo la direccion del contador R0
			LDRH R1, [R0]					;Cargo en R1 lo que apunta R0 (Contador)(solo paso 16 bits)
			ADD R1,#0x01					;Aumento en uno el valor de R1
			STRH R1,[R0]					;Almaceno el valor de R1 (solo 16 bits)a la direccion que apunta R0 (contador)
			B soltar_btn					;Salto al ciclo con la etiqueta soltar_btn

;Ciclo para asegurarme que el boton es soltado y pueda regresar al ciclo para sacar el valor del contador por puertos
;Esto es para evitar que el contador aumente indefinidamente si se mantiene presionado el interruptor sin soltar
soltar_btn		
			LDR R2, =GPIO_PORTJ_DATA_R		;Cargo la direccion 0x40060004 del puerto J (Interruptor) a R2
			LDR R6,[R2]						;Cargo a R6 el valor al que apunta R2 (puerto J)
			CMP R6, #0x01					;Comparo que el valor de R6 sea igual a 0x01 (Que ocurre cuando el boton no está presionado)
			BEQ ciclo						;Si es igual a 0x01 (es decir, el bot se soltó), regreso al ciclo principal para sacar el valor del contador por puertos
			B soltar_btn 					;Si no se cumplió lo anterior, repito el ciclo soltar_btn

			ALIGN
			END