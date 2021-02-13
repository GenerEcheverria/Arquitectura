#include<stdint.h>

#define OPER1 (*((volatile uint16_t*) 0x20000000))	//Defino como puntero. uint8, 16 o 32
#define OPER2 (*((volatile uint16_t*) 0x20000002))	//0x20000002 porque ocupa 2 cuadno son 16 bits
#define RESUL (*((volatile uint16_t*) 0x20000004))

int main() {
	OPER1=0x1020;
	OPER2=0x4030;
	RESUL=OPER1+OPER2;
	
	while(1){
		
	}
	
	
	
	
	
	
	
	
}	
