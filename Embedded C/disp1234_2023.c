#include <LPC17xx.h>
 unsigned int i=0x00;
 unsigned char array_dec[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
 unsigned int dig_value[4]={4,3,2,1};
 unsigned int disp_select[4]={0, 1, 2, 3};
 void delay(void);
 void display(void);

 int main(void)
 {    
	LPC_GPIO0->FIODIR |= 0xFF<<4;	//P0.4 to P0.11 output         
	LPC_GPIO1->FIODIR |= 0XF<<23;	//P1.23 to P1.26 output             

	while(1)
	{
   	delay();
		
		for(i=0;i<4;i++) 
		{
			display();
		}
	} //end of while(1)
 }//end of main
void display(void)      //To Display on 7-segments
{
      
		LPC_GPIO1->FIOPIN = disp_select[i]<<23;               
		LPC_GPIO0->FIOPIN = array_dec[dig_value[i]]<<4;       
}

	 
void delay(void)
{ unsigned int i;
	for(i=0;i<10;i++);	
}
