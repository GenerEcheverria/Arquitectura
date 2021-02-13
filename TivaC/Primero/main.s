;Carga almacenamiento: no puedo hacer operaciones en memoria

;--------------------SEGMENTO DE DATOS 
			AREA DATOS, DATA, READWRITE, ALIGN=2
OPER1	SPACE 4
OPER2	SPACE 4
RESUL	SPACE 4 ;bytes


;---------------------SEGMENTO DE CODIGO
			AREA |.text|, CODE, READONLY , ALIGN=2
			THUMB	;Ciertas instrucciones las ensambla en 16 bits pero las ejecuta en 32
			EXPORT Start
Start		
		LDR R0,=OPER1		;seudo operación que mueve al registro R0, la direccion de OPER1
		MOV32 R1,#0X10201020		;Mueve el valor inmediato 0x20 al registro R1. MOV32 para 32 bits, MOV para 16 y 8
		STR R1,[R0]		;Almacena a la memoria OPER1 el valor del registro R1 en byte
		
		LDR R2,=OPER2		;seudo operación que mueve al registro R2, la direccion de OPER2
		MOV32 R3,#0X40304030		;Mueve el valor inmediato 0x20 al registro R3
		STR R3,[R2]		;Almacena a la memoria OPER2 el valor del registro R3 en byte.STRB para 8  STRH para 16 y STR para 32
		
		ADD R4,R3,R1		;Solo adicionar 8 bits(UADD8), de los registros R1 y R3 y dejalo en R4
		
		LDR R5,=RESUL
		STR R4, [R5]
		NOP
		NOP
			ALIGN
			END