#include <LPC17xx.h>
#include <stdio.h>

#define Ref_Vtg 3.300
#define Full_Scale 0xFFF // 12-bit ADC

void delay_lcd(int r1)
{
    int r;
    for (r = 0; r < r1; r++);
}

void clear_ports(void) {
    LPC_GPIO0->FIOCLR = 0x0F << 23; // Clearing data lines
    LPC_GPIO0->FIOCLR = 1 << 27; // Clearing RS line
    LPC_GPIO0->FIOCLR = 1 << 28; // Clearing Enable line
}

void write(int temp2, int type) {
    clear_ports();
    LPC_GPIO0->FIOPIN = temp2; // Assign value to data lines
    if (type == 0)
        LPC_GPIO0->FIOCLR = 1 << 27; // Clear RS for command
    else
        LPC_GPIO0->FIOSET = 1 << 27; // Set RS for data
    LPC_GPIO0->FIOSET = 1 << 28; // EN = 1
    delay_lcd(25);
    LPC_GPIO0->FIOCLR = 1 << 28; // EN = 0
}

void lcd_comdata(int temp1, int type) {
    int temp2 = (temp1 & 0xF0) << 19; // Upper nibble
    write(temp2, type);
    temp2 = (temp1 & 0x0F) << 23; // Lower nibble
    write(temp2, type);
    delay_lcd(1000);
}

void lcd_puts(char* buf1) {
    unsigned int i = 0;
    while (buf1[i] != '\0') {
        lcd_comdata(buf1[i], 1);
        i++;
        if (i == 16) {
            lcd_comdata(0xC0, 0);
        }
    }
}

void lcd_init() {
    LPC_PINCON->PINSEL1 &= 0xFC003FFF; // P0.23 to P0.28
    LPC_GPIO0->FIODIR |= 0x0F << 23 | 1 << 27 | 1 << 28;
    clear_ports();
    delay_lcd(3200);
    lcd_comdata(0x33, 0); delay_lcd(30000);
    lcd_comdata(0x32, 0); delay_lcd(30000);
    lcd_comdata(0x28, 0); delay_lcd(30000);
    lcd_comdata(0x0C, 0); delay_lcd(800);
    lcd_comdata(0x06, 0); delay_lcd(800);
    lcd_comdata(0x01, 0); delay_lcd(10000);
}

int main(void) {
    unsigned long adc_temp1, adc_temp2;
    float in_vtg1, in_vtg2, vtg_diff;
    char vtg1[7], vtg2[7], vtg_diff_str[7];
    char Msg3[] = "C4:";
    char Msg4[] = "C5:";
    char Msg5[] = "Difference:";

    SystemInit();
    SystemCoreClockUpdate();
    LPC_SC->PCONP |= (1 << 15);
    lcd_init();

    LPC_PINCON->PINSEL3 |= 0x30000000; // P1.30 as AD0.4
    LPC_PINCON->PINSEL3 |= 0xC0000000; // P1.31 as AD0.5
    LPC_SC->PCONP |= (1 << 12); // Enable ADC peripheral

    lcd_comdata(0x80, 0);
    delay_lcd(800);
    lcd_puts(Msg3);
    lcd_comdata(0x88, 0);
    delay_lcd(800);
    lcd_puts(Msg4);

    // *Step 1: Perform one conversion using Software Mode*
    LPC_ADC->ADCR = (1 << 4) | (1 << 5) | (1 << 21); // Enable ADC, select channels (no BURST)
    LPC_ADC->ADCR |= (1 << 24); // Start conversion in software mode
    while (!(LPC_ADC->ADDR4 & 0x80000000)); // Wait for completion

    adc_temp1 = (LPC_ADC->ADDR4 >> 4) & 0xFFF;
    adc_temp2 = (LPC_ADC->ADDR5 >> 4) & 0xFFF;
    in_vtg1 = ((float)adc_temp1 * Ref_Vtg) / Full_Scale;
    in_vtg2 = ((float)adc_temp2 * Ref_Vtg) / Full_Scale;
    vtg_diff = in_vtg1 - in_vtg2; // *Calculate difference in software mode*

    sprintf(vtg1, "%3.2fV", in_vtg1);
    sprintf(vtg2, "%3.2fV", in_vtg2);
    sprintf(vtg_diff_str, "%3.2fV", vtg_diff); // *Store difference*

    lcd_comdata(0x83, 0);
    delay_lcd(800);
    lcd_puts(vtg1);
    lcd_comdata(0x8B, 0);
    delay_lcd(800);
    lcd_puts(vtg2);

    lcd_comdata(0xC0, 0);
    delay_lcd(800);
    lcd_puts(Msg5);
    lcd_comdata(0xCA, 0);
    delay_lcd(800);
    lcd_puts(vtg_diff_str); // *Display difference in software mode*

    // *Step 2: Transition to BURST Mode*
    LPC_ADC->ADCR &= ~(7 << 24); // *Clear START bits [26:24]*
    LPC_ADC->ADCR |= (1 << 16); // *Enable BURST mode*

    while (1) {
        while (!(LPC_ADC->ADDR4 & 0x80000000)); // Wait for conversion completion

        adc_temp1 = (LPC_ADC->ADDR4 >> 4) & 0xFFF;
        adc_temp2 = (LPC_ADC->ADDR5 >> 4) & 0xFFF;
        in_vtg1 = ((float)adc_temp1 * Ref_Vtg) / Full_Scale;
        in_vtg2 = ((float)adc_temp2 * Ref_Vtg) / Full_Scale;
        vtg_diff = in_vtg1 - in_vtg2; // *Compute voltage difference in burst mode*

        sprintf(vtg1, "%3.2fV", in_vtg1);
        sprintf(vtg2, "%3.2fV", in_vtg2);
        sprintf(vtg_diff_str, "%3.2fV", vtg_diff);

        lcd_comdata(0x83, 0);
        delay_lcd(800);
        lcd_puts(vtg1);
        lcd_comdata(0x8B, 0);
        delay_lcd(800);
        lcd_puts(vtg2);

        lcd_comdata(0xC0, 0);
        delay_lcd(800);
        lcd_puts(Msg5);
        lcd_comdata(0xCA, 0);
        delay_lcd(800);
        lcd_puts(vtg_diff_str);
    }
}

