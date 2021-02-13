;*******************************************************
;Programa que configura el puerto J Pin 0 como entrada 
;y configura el puerto F pin 0 como salida. Leemos el puerto J pin 0
;y sacamos su estado por el puerto F pin 0
;****************************************************

;Seleccion de control de modo digital (Alternativo o generico)
GPIO_PORTJ_AFSEL_R EQU 0x40060420	;Le pongo la direccion al puerto
GPIO_PORTF_AFSEL_R EQU 0x4005D420
;Habilitacion digital
GPIO_PORTJ_DEN_R EQU 0x4006051C	;Le pongo la direccion al puerto
GPIO_PORTF_DEN_R EQU 0x4005D51C
;habilitacion anallogica	
GPIO_PORTJ_AMSEL_R EQU 0x40060528	
GPIO_PORTF_AMSEL_R EQU 0x4005D528	
;pull up	
GPIO_PORTJ_PUR_R EQU 0x40060510
;entrada/salida
GPIO_PORTJ_DIR_R EQU 0x40060400	
GPIO_PORTF_DIR_R EQU 0x4005D400
;mascara
GPIO_PORTJ_DATA_R EQU 0x40060004	
GPIO_PORTF_DATA_R EQU 0x4005D004
;Upset 0x000-0x3FF	-->		0x000=00 00_0000_00 00
;Upset 0x000-0x3FF	-->		0x000=00 00_0000_01 00 	ultimos dos se desechan, y se pone 1 a los que quiera leer y escribir

SYSCTL_RCGCGPIO EQU 0X400FE608
;lectura para saber si se puede acceder	
STSCTL_PRGPIO EQU 0X400FEA08
;							representa 0x004

;---------------------SEGMENTO DE CODIGO
			AREA |.text|, CODE, READONLY , ALIGN=2
			THUMB	;Ciertas instrucciones las ensambla en 16 bits pero las ejecuta en 32
			EXPORT Start
			EXPORT servi_inter	
			IMPORT EnableInterrupts	
Start	
			BL EnableInterrupts			;Bit global de interrupciones



			LDR R0, =SYSCTL_RCGCGPIO
			LDR R1, [R0]
			ORR R1, #0x100				;ACTIVAR RELOJ
			STR R1, [R0]
			
			LDR R0, =STSCTL_PRGPIO
no_listo1			
			LDR R1, [R0]
			ANDS R1, #0x100
			BEQ no_listo1
			
			
			LDR R0, =SYSCTL_RCGCGPIO
			LDR R1, [R0]
			ORR R1, #0x20				;ACTIVAR RELOJ
			STR R1, [R0]
			
			LDR R0, =STSCTL_PRGPIO
no_listo2			
			LDR R1, [R0]
			ANDS R1, #0x20
			;BEQ no_listo2
			
			LDR R0, =GPIO_PORTJ_AFSEL_R		;cargo la direccion a R0
			LDR R1, [R0]					;leo el registro GPIO_PORTJ_AFSEL_R y lo cargo en R1
			;AND R1, #0xFE					;Coloco en cero el bit cero del puerto J. R1=1111_1111 and 1111_1110 = 1111_1110
			BIC R1, #0x01					;Niega valor y hace AND. 0= proposito general AFSEL
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTF_AFSEL_R		;cargo la direccion a R0
			LDR R1, [R0]
			BIC R1, #0x01					; 1= habilito entrada/salida digital
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_DEN_R
			LDR R1, [R0]
			ORR R1, #0x01					;1= habilito funciones digitales. OR inclusiva
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTF_DEN_R
			LDR R1, [R0]
			ORR R1, #0x01					
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_AMSEL_R
			LDR R1, [R0]
			BIC R1, #0x01					;0= deshabilitar funciones analógicas
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTF_AMSEL_R
			LDR R1, [R0]
			BIC R1, #0x01					
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_PUR_R
			LDR R1, [R0]
			ORR R1, #0x01					;1=activo pull up
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_DIR_R
			LDR R1, [R0]
			BIC R1, #0x01					;0=ENTRADA					
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTF_DIR_R
			LDR R1, [R0]
			ORR R1, #0x01					;1=salida
			STR R1, [R0]
		
			LDR R5, =GPIO_PORTJ_DATA_R
			LDR R4, =GPIO_PORTF_DATA_R
oty			
			LDR R6,[R5]
			;EOR R6, #0x01					;niego el valor para invertirlo. Ahora se mantiene apagado y cuando presiono se prende el led
			STR R6,[R4]
			B	oty
;

servi_inter
			nop
			nop
			nop
			BX LR							;registro linker
			
			ALIGN
			END