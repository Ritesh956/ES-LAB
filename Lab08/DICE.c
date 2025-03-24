#include <LPC17xx.h>
#include <stdlib.h>

unsigned char msg1[13] = "Dice Result"; 
unsigned char key;
unsigned long int temp1 = 0;

void lcd_init(void);
void write(int, int);
void delay_lcd(unsigned int);
void lcd_comdata(int, int);
void clear_ports(void);
void lcd_puts(unsigned char *);

void lcd_init() {
    
    LPC_PINCON->PINSEL1 &= 0xFC003FFF; // P0.23 to P0.28
    
    LPC_GPIO0->FIODIR |= 0x0F << 23 | 1 << 27 | 1 << 28;
    clear_ports();
    delay_lcd(3200);
    lcd_comdata(0x33, 0);
    delay_lcd(30000);
    lcd_comdata(0x32, 0);
    delay_lcd(30000);
    lcd_comdata(0x28, 0);
    delay_lcd(30000);
    lcd_comdata(0x0c, 0); 
    delay_lcd(800);
    lcd_comdata(0x06, 0); 
    delay_lcd(800);
    lcd_comdata(0x01, 0); 
    delay_lcd(10000);
}

void lcd_comdata(int temp1, int type) {
    int temp2 = temp1 & 0xf0; 
    temp2 = temp2 << 19;
    write(temp2, type);
    temp2 = temp1 & 0x0f;
    temp2 = temp2 << 23;
    write(temp2, type);
    delay_lcd(1000);
}

void write(int temp2, int type) { 
    clear_ports();
    LPC_GPIO0->FIOPIN = temp2; 
    if (type == 0)
        LPC_GPIO0->FIOCLR = 1 << 27; 
    else
        LPC_GPIO0->FIOSET = 1 << 27; 
    LPC_GPIO0->FIOSET = 1 << 28;
    delay_lcd(25);
    LPC_GPIO0->FIOCLR = 1 << 28;
}

void delay_lcd(unsigned int r1) {
    unsigned int r;
    for (r = 0; r < r1; r++);
}

void clear_ports(void) { 
    LPC_GPIO0->FIOCLR = 0x0F << 23; 
    LPC_GPIO0->FIOCLR = 1 << 27; 
    LPC_GPIO0->FIOCLR = 1 << 28; 
}

void lcd_puts(unsigned char *buf1) {
    unsigned int i = 0;
    unsigned int temp3;
    while (buf1[i] != '\0') {
        temp3 = buf1[i];
        lcd_comdata(temp3, 1);
        i++;
        if (i == 16)
            lcd_comdata(0xc0, 0); 
    }
}

int main() {
    unsigned char k;
    lcd_init(); 
    temp1 = 0x80;
    lcd_comdata(temp1, 0); 
    delay_lcd(800);
    lcd_puts(&msg1[0]); 
    
    while (1) {
        if (!(LPC_GPIO2->FIOPIN & 1 << 12)) { 
            k = (rand() % 6) + 1; 
            k = k + 0x30;
            temp1 = 0xc0; 
            lcd_comdata(temp1, 0); 
            delay_lcd(800);
            lcd_puts(&k); 
        }
    }
}
