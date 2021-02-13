;PRUEBA DE FUNCIONAMIENTO DE BOTON
;GENER ECHEVERRIA

;PN1,PN0



;Seleccion de control de modo digital (Alternativo o generico)
GPIO_PORTJ_AFSEL_R EQU 0x40060420	;Le pongo la direccion al puertoGPIO_PORTF_AFSEL_R EQU 0x4005D420
GPIO_PORTN_AFSEL_R EQU 0x40064420
;Habilitacion digital
GPIO_PORTJ_DEN_R EQU 0x4006051C	;Le pongo la direccion al puertoGPIO_PORTF_DEN_R EQU 0x4005D51C
GPIO_PORTN_DEN_R EQU 0x4006451C
;habilitacion anallogica	
GPIO_PORTJ_AMSEL_R EQU 0x40060528	
GPIO_PORTN_AMSEL_R EQU 0x40064528	
;pull up	
GPIO_PORTJ_PUR_R EQU 0x40060510
;entrada/salida
GPIO_PORTJ_DIR_R EQU 0x40060400	
GPIO_PORTN_DIR_R EQU 0x40064400
;mascara
GPIO_PORTJ_DATA_R EQU 0x40060004	
GPIO_PORTN_DATA_R EQU 0x4006400C

SYSCTL_RCGCGPIO EQU 0X400FE608
;lectura para saber si se puede acceder	
STSCTL_PRGPIO EQU 0X400FEA08
;							representa 0x004

			AREA DATOS, DATA, READWRITE, ALIGN=2
CONTA	SPACE 2		

;---------------------SEGMENTO DE CODIGO
			AREA |.text|, CODE, READONLY , ALIGN=2
			THUMB	;Ciertas instrucciones las ensambla en 16 bits pero las ejecuta en 32
			EXPORT Start
Start	
			
;**********************************		LDR R0, =SYSCTL_RCGCGPIO
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
			ORR R1, #0x1000				;ACTIVAR RELOJ
			STR R1, [R0]
			
			LDR R0, =STSCTL_PRGPIO
no_listo2			
			LDR R1, [R0]
			ANDS R1, #0x1000
			BEQ no_listo2
			
			LDR R0, =GPIO_PORTJ_AFSEL_R		;cargo la direccion a R0
			LDR R1, [R0]					;leo el registro GPIO_PORTJ_AFSEL_R y lo cargo en R1
			BIC R1, #0x01					;Niega valor y hace AND. 0= proposito general AFSEL
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTN_AFSEL_R		;cargo la direccion a R0
			LDR R1, [R0]
			BIC R1, #0x03					; 1= habilito entrada/salida digital
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_DEN_R
			LDR R1, [R0]
			ORR R1, #0x01					;1= habilito funciones digitales. OR 
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTN_DEN_R
			LDR R1, [R0]
			ORR R1, #0x03					
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_AMSEL_R
			LDR R1, [R0]
			BIC R1, #0x01					;0= deshabilitar funciones analógicas
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTN_AMSEL_R
			LDR R1, [R0]
			BIC R1, #0x03					
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_PUR_R
			LDR R1, [R0]
			ORR R1, #0x01					;1=activo pull up
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_DIR_R
			LDR R1, [R0]
			BIC R1, #0x01					;0=ENTRADA					
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTN_DIR_R
			LDR R1, [R0]
			ORR R1, #0x03					;1=salida
			STR R1, [R0]
				
			LDR R5, =GPIO_PORTJ_DATA_R
			LDR R3, =GPIO_PORTN_DATA_R
			
			MOV R1,#0x0000					;0x0000 Inicializa contador
			LDR R0, =CONTA
			STR R1,[R0]
			
			;*************************
			LDR R2, =GPIO_PORTJ_DATA_R	
			MOV R1, #0x0001
			STRH R1, [R2]
			;*************************

L1			
			LDR R1,[R0]	
			
			STR R1,[R3]

			LDR R2, =GPIO_PORTJ_DATA_R
			LDR R6,[R2]
			CBZ R6,contador
			B L1
			
contador
			LDR R0, =CONTA
			LDR R1, [R0]
			ADD R1,#0x0001
			STR R1,[R0]
			;*******************
			LDR R1,[R0]	
			
			STR R1,[R3]
			;******************
			
			
			
			B soltar
			
			
soltar		
			LDR R2, =GPIO_PORTJ_DATA_R
			LDR R6,[R2]
			CMP R6, #0x01	
			BEQ L1
			
			B soltar 
			
			ALIGN
			END