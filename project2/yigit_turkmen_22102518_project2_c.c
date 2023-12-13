#include <MKL25Z4.H>
#include <stdio.h>
#include <math.h>
//This is how you import a header file
#include "utils.h"
int initialize(void);
void SysTick_Handler(void);
void PORTD_IRQHandler(void);
void PORTA_IRQHandler(void);
int enable_clock(void);
int enable_button(void);
int enable_led(void);

#define RED_LED_POS 18
#define GREEN_LED_POS 19
#define BUTTON_1_POS 1
#define BUTTON_2_POS 2
#define BUTTON_3_POS 7
#define MASK(x) (1UL << (x))

#define LED_1_POS 20
#define LED_2_POS 21
#define LED_3_POS 22
#define LED_4_POS 23
void Delayy(uint32_t ticks);

static int green_led_counter = 11;
static int redled_on = 1;
static int greenled_on = 0;
static int blink_state = 1;
static int stop_blinking = 0;
static int bit_counter = 0;
static int delay_counter;

static int blink_state_counter = 0;
static int stop_counter = 0;

static const int systick_load = 130000;

int enable_clock(void) {
	SIM->SCGC5 |= 1UL << ((10));
	SIM->SCGC5 |= 1UL << ((9));
	SIM->SCGC5 |= 1UL << ((12));
	SIM->SCGC5 |= 1UL << ((13));
}
int enable_button(void) {
	PORTA->PCR[BUTTON_1_POS] = 0x100;    /* make PTB18 pin as GPIO */
	PORTA->PCR[BUTTON_2_POS] = 0x100;
	PORTD->PCR[BUTTON_3_POS] = 0x100;	/* make PTB19 pin as GPIO */
	PTA->PDDR &= ~MASK(BUTTON_1_POS);
	PTA->PDDR &= ~MASK(BUTTON_2_POS);
	PTD->PDDR &= ~MASK(BUTTON_3_POS);
	
	PORTA->PCR[BUTTON_1_POS] |= PORT_PCR_PS_MASK | PORT_PCR_PE_MASK| PORT_PCR_IRQC(0x0a);
	PORTA->PCR[BUTTON_2_POS] |= PORT_PCR_PS_MASK | PORT_PCR_PE_MASK| PORT_PCR_IRQC(0x0a);
	PORTD->PCR[BUTTON_3_POS] |= PORT_PCR_PS_MASK | PORT_PCR_PE_MASK| PORT_PCR_IRQC(0x0a);
}
int enable_led(void) {
	PORTB->PCR[RED_LED_POS] = 0x100;    /* make PTB18 pin as GPIO */
	PORTB->PCR[GREEN_LED_POS] = 0x100;      /* make PTB19 pin as GPIO */
	PTB->PDDR |= (3UL << RED_LED_POS);    /* make PTB as output pins */
	
	
	PORTE->PCR[LED_1_POS] = 0x100;    /* make PTB18 pin as GPIO */
	PORTE->PCR[LED_2_POS] = 0x100;
	PORTE->PCR[LED_3_POS] = 0x100;
	PORTE->PCR[LED_4_POS] = 0x100;	
	

	PTE->PDDR |= 1UL << (LED_1_POS);
	PTE->PDDR |= 1UL << ((LED_2_POS));
	PTE->PDDR |= 1UL << ((LED_3_POS));
	PTE->PDDR |= 1UL << ((LED_4_POS));	
}

int initialize(void){
	
	      /* enable clock to Port B */
	
	SysTick->CTRL = 0; // Disable SysTick
	SysTick->LOAD = systick_load ; // Set reload register to get 1.3s interrupts clk=11199999
	NVIC_SetPriority(SysTick_IRQn , 1);
	SysTick->VAL = 0; // Reset the SysTick counter value
	SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk | SysTick_CTRL_ENABLE_Msk;
	NVIC_ClearPendingIRQ(PORTD_IRQn);
	NVIC_ClearPendingIRQ(PORTA_IRQn);
	NVIC_SetPriority(PORTD_IRQn , 2);
	NVIC_SetPriority(PORTA_IRQn , 3);
	NVIC_EnableIRQ(PORTD_IRQn);
	NVIC_EnableIRQ(PORTA_IRQn);

	
	return 0;
}

void SysTick_Handler(void){
	// Control halt blinking
	delay_counter++;
	if (stop_blinking == 1) {
		stop_counter++;
		if (stop_counter >= 20) {
			stop_blinking = 0;
			stop_counter = 0;
			blink_state = 1;
			blink_state_counter = 0;
		}
	}


// Manage blink state transitions
if (++blink_state_counter >= 13) {
    blink_state_counter = 0;
    blink_state = !blink_state; // Toggle blink state

    if (green_led_counter < 10) {
        green_led_counter++;
    } else if (green_led_counter == 10) {
        redled_on = 1;
        greenled_on = 0;
    }
}

	

}

void PORTD_IRQHandler(void) {
    int ledState[4];
	if (delay_counter < 5) {
		return;
	} else {
	delay_counter = 0;
    //Delay(100000); // Delay to mitigate button bounce
    // Increment and wrap the counter
    bit_counter = (bit_counter + 1) % 16;

    // Update the LED states based on the current counter value
    for (int i = 0; i < 4; i++) {
        ledState[i] = (bit_counter & (1 << i)) ? 1 : 0;
    }
    // Control the LEDs based on the calculated states
    PTE->PCOR = 0xF << LED_1_POS; // Clear all LED bits first
    for (int i = 0; i < 4; i++) {
        if (ledState[i]) {
            PTE->PSOR = 1UL << (LED_1_POS + i); // Set LED bit if state is 1
        }
    }
    // Clear the interrupt status flag
    PORTD->ISFR = 0xFFFFFFFF;
}
}

void PORTA_IRQHandler(void){
	if (PORTA->ISFR & 1UL << ((BUTTON_1_POS))) {
		green_led_counter = 0;
		redled_on = 0;
		greenled_on = 1;
	} else if (PORTA -> ISFR & 1UL << ((BUTTON_2_POS))){
		stop_blinking = 1;
	}
	PORTA->ISFR = 0xffffffff;
}


int main(void){
	__disable_irq();
	initialize();
	enable_clock();
	enable_button();
	enable_led();
	__enable_irq();
	
	while (1) {
    // When not in halt blinking mode
    if (!stop_blinking) {
        if (blink_state) {
            // Swap RED and GREEN LED states
            PTB->PCOR = (redled_on ? 1UL << RED_LED_POS : 1UL << GREEN_LED_POS);
            PTB->PSOR = (redled_on ? 1UL << GREEN_LED_POS : 1UL << RED_LED_POS);
        } else {
            // Turn on the LEDs based on redled_on or greenled_on
            PTB->PSOR = (redled_on ? 1UL << RED_LED_POS : 0) | 
                        (greenled_on ? 1UL << GREEN_LED_POS : 0);
        }
    } 
    // stop blinking mode
    else {
        PTB->PSOR = (1UL << RED_LED_POS) | (1UL << GREEN_LED_POS);
    }
}

}

