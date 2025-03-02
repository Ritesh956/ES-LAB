
#include<LPC17xx.h>

unsigned char tohex[10]={0X3F, 0X06, 0X5B, 0X4F, 0X66, 0X6D, 0X7D, 0X07, 0X7F, 0X6F};

int arr[2]={0,0}; // arr[0] will select U8, arr[1] will select U9

unsigned int i, j;

int main()
{
    LPC_GPIO0->FIODIR|=0XFF0; // to disply 0-9
	LPC_GPIO1->FIODIR|=0X3<<23; // to select where to disply
while(1)
     {
	for(arr[1]=0; arr[1]<10 arr[1]++)
		for(arr[0]=0; arr[0]<10; arr[0]++)
			 {
					for(i=0; i<2; i++)
					{
						LPC_GPIO1->FIOPIN=i<<23; //  selecting a perticular seven segment
						LPC_GPIO0->FIOPIN=tohex[arr[i]]<<4;   //  selecting what to display
						for(j=0; j<1000; j++);
					}
					for(j=0; j<1000; j++);
					LPC_GPIO0->FIOCLR|=0X00000FF0; // Needed ???
			}
		 
      }
}
