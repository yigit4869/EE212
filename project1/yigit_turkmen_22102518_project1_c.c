

#include <MKL25Z4.H>
#include <stdio.h>
#include <math.h>
#include "utils.h"
int foo(int a, int b);
int findM(int p, int q);
int findN(int p, int q);
int findGcd(int a, int b);
int findRelativelyPrime(int m);
int modInverse(int a, int m);
int encryption(int p, int q, int ms);
int findPower(int a, int b, int p);
int decryption(int p, int q, int c);

	
int findM(int p, int q){
	int a;
	int b;
	a = p - 1;
	b = q - 1;
	return a*b;
}
int findN(int a, int b){
	return a*b;
}

int foo(int a, int b){
	
	return a | b;
}

int findGcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}


int findRelativelyPrime(int m) {
    int e = 2;
    while (findGcd(m, e) != 1) {
        e++;
    }
    return e; }


int modInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
        if ((a * x) % m == 1) {
            return x;
        }
    }
    return -1; 
}

int findPower(int a, int b, int p) {

	int i;
	int temp = 1;
	for (i=1; i<=b; i++) {
	temp = temp * a;
	temp = temp % p;
	}
	return temp;
}



int encryption(int p, int q, int ms) {
	int m;
	int n;
	int e;
	int d;
	int final;
	
	m = findM(p, q);
	n = findN(p, q);
	e = findRelativelyPrime(m);
	d = modInverse(e, m);
	
	final = findPower(ms, e, n);
	return final;
}

int decryption(int p, int q, int c) {
	int m;
	int n;
	int e;
	int d;
	int final;
	
	m = findM(p, q);
	n = findN(p, q);
	e = findRelativelyPrime(m);
	d = modInverse(e, m);
	
	final = findPower(c, d, n);
	return final;
}


int main(void){
	char lookup[]= {'1','2','3','A','4','5','6','B','7','8','9','C','*','0','#','D'};
  char lookup_digit[]= {'0','1','2','3','4','5','6','7','8','9'};
	
	LCD_init();
	keypad_init();
	int block1;
	int block2;
	int message1;
	int message2;
	int out_digits1[4];
	int out_digits2[4];
	int p = 59;
	int q = 61;
	int c1;
	int c2;	
	int input;
	char charr;
	print_fnc("A for encryption");
	LCD_command(0xc0);
	print_fnc("D for decryption");
	start:
	input = 0;
	
	
	while (input == 0) {
		input = (int) keypad_getkey(); 
	}
	charr = lookup[input - 1];
	clear_lcd();
	Delay(500000);
	
	if (charr == 'A') {
		print_fnc("Enter message: ");
		LCD_command(0xc0);
		block1 = get_number_from_keypad();
		block2 = get_number_from_keypad();
		message1 = encryption(p, q, block1);
		message2 = encryption(p, q, block2);
		clear_lcd();
		print_fnc("Encrypted output: ");
		LCD_command(0xc0);
		
	} else if (charr == 'D') {
		print_fnc("Enter message: ");
		LCD_command(0xc0);
		block1 = get_number_from_keypad();
		block2 = get_number_from_keypad();
		c1 = encryption(p, q, block1);
		c2 = encryption(p, q, block2);
		message1 = decryption(p, q, c1);		
		message2 = decryption(p, q, c2);
		clear_lcd();
		print_fnc("Decrypted output: ");
		LCD_command(0xc0);
		
	} else {
		goto start;
	}
	out_digits1[0] = (message1 / 1000);
	out_digits1[1] = ((message1 % 1000)/ 100);
	out_digits1[2] = ((message1 % 100)/ 10);
	out_digits1[3] = (message1 % 10);
	
	out_digits2[0] = (message2 / 1000);
	out_digits2[1] = ((message2 % 1000)/ 100);
	out_digits2[2] = ((message2 % 100)/ 10);
	out_digits2[3] = (message2 % 10);
	
	LCD_data(lookup_digit[out_digits1[0]]);
	LCD_data(lookup_digit[out_digits1[1]]);
	LCD_data(lookup_digit[out_digits1[2]]);
	LCD_data(lookup_digit[out_digits1[3]]);
	
	LCD_data(lookup_digit[out_digits2[0]]);
	LCD_data(lookup_digit[out_digits2[1]]);
	LCD_data(lookup_digit[out_digits2[2]]);
	LCD_data(lookup_digit[out_digits2[3]]);


	//Initialize LCD and keypad
	
	

	
	//Blink LED
	blink();
}





