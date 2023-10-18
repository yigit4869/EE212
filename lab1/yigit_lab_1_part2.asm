ORG 0

ACALL CONFIGURE_LCD

MOV R0, #00h

MOV A, #'I'
ACALL SEND_DATA
MOV A, #'N'
ACALL SEND_DATA
MOV A, #'P'
ACALL SEND_DATA
MOV A, #'U'
ACALL SEND_DATA
MOV A, #'T'
ACALL SEND_DATA
MOV A, #'='
ACALL SEND_DATA ; INPUT= written to the led

ACALL KEYBOARD
ACALL SEND_DATA
ANL A, #0Fh
MOV B, #100d
MUL AB
MOV R0, A ; first digit of the input taken and written

ACALL KEYBOARD
ACALL SEND_DATA
ANL A, #0Fh
MOV B, #10d
MUL AB
ADD A, R0
MOV R0, A ; second digit of the input taken and written

ACALL KEYBOARD
ACALL SEND_DATA
ANL A, #0Fh
ADD A, R0
MOV R0, A ; third digit of the input taken and written

MOV A, #0C0H
ACALL SEND_COMMAND ; passed to the next line in the led

COME_HERE:
ACALL KEYBOARD
CJNE A, #'A', COME_HERE ; waiting for the pressing A to show the output

MOV A, #'P'
ACALL SEND_DATA
MOV A, #'='
ACALL SEND_DATA
MOV A, #'('
ACALL SEND_DATA ; P=( written



MOV DPTR, #PRIMES_TABLE ; to access the rom
MOV R1, #00h ; prime table counter


CHECK: MOV A, R1 ; here is the first part of the process, dividing the input to the prime numbers to check whether the it is dividible or not
MOVC A,@A+DPTR
MOV R2, A
MOV B, A
MOV A, R0
DIV AB
MOV R3, A
MOV A, B
JZ  LOOP1
JNZ LOOP2

LOOP1: CJNE R2,#10d, NOT_equal ; comparing the reminder to the 10
SJMP between_10_100

LOOP2: ; 
MOV A, R1
ADD A, #01d
MOV R1, A
SJMP CHECK

NOT_equal: JC less_than_10 ; checking carry bit
SJMP higher_than_10

less_than_10: ; if prime number is one digit number
MOV A, R2
ADD A, #30h
ACALL SEND_DATA
MOV A, #','
ACALL SEND_DATA
MOV A,R3
MOV R0, A
DEC A
JZ DONE
SJMP CHECK

higher_than_10: ; checking carry bit
CJNE R2, #100d, NOT_EQUAL2
SJMP higher_than_100

NOT_EQUAL2: ; checking carry bit 
JC between_10_100
SJMP higher_than_100

between_10_100: ; if the prime number is a two digit number
MOV A, R2
MOV B, #10d
DIV AB
ADD A, #30h
ACALL SEND_DATA
MOV A, B
ADD A, #30h
ACALL SEND_DATA
MOV A, #','
ACALL SEND_DATA
MOV A,R3
MOV R0, A
DEC A
JZ DONE
SJMP CHECK

higher_than_100: ; if the prime number is higher than the 100
MOV A, R2
MOV B, #100d
DIV AB
ADD A, #30h
ACALL SEND_DATA
MOV A, B
MOV B, #10d
DIV AB
ADD A, #30h
ACALL SEND_DATA
MOV A, B
ADD A, #30h
ACALL SEND_DATA
MOV A, #','
ACALL SEND_DATA
MOV A,R3
MOV R0, A
DEC A
JZ DONE
SJMP CHECK


DONE:
MOV A, #')'
ACALL SEND_DATA ; process is done

STAY_HERE: SJMP STAY_HERE ; to make the code stay here

PRIMES_TABLE:
    DB 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73
    DB 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179
    DB 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251

CONFIGURE_LCD:	;THIS SUBROUTINE SENDS THE INITIALIZATION COMMANDS TO THE LCD
	mov a,#38H	;TWO LINES, 5X7 MATRIX
	acall SEND_COMMAND
	mov a,#0FH	;DISPLAY ON, CURSOR BLINKING
	acall SEND_COMMAND
	mov a,#06H	;INCREMENT CURSOR (SHIFT CURSOR TO RIGHT)
	acall SEND_COMMAND
	mov a,#01H	;CLEAR DISPLAY SCREEN
	acall SEND_COMMAND
	mov a,#80H	;FORCE CURSOR TO BEGINNING OF THE FIRST LINE
	acall SEND_COMMAND
	ret



SEND_COMMAND:
	mov p1,a		;THE COMMAND IS STORED IN A, SEND IT TO LCD
	clr p3.5		;RS=0 BEFORE SENDING COMMAND
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	acall DELAY
	clr p3.7
	ret


SEND_DATA:
	mov p1,a		;SEND THE DATA STORED IN A TO LCD
	setb p3.5	;RS=1 BEFORE SENDING DATA
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	acall DELAY
	clr p3.7
	ret


DELAY:
	push 0
	push 1
	mov r0,#50
DELAY_OUTER_LOOP:
	mov r1,#255
	djnz r1,$
	djnz r0,DELAY_OUTER_LOOP
	pop 1
	pop 0
	ret


KEYBOARD: ;takes the key pressed from the keyboard and puts it to A
	mov	P0, #0ffh	;makes P0 input
K1:
	mov	P2, #0	;ground all rows
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, K1
K2:
	acall	DELAY
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, KB_OVER
	sjmp	K2
KB_OVER:
	acall DELAY
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, KB_OVER1
	sjmp	K2
KB_OVER1:
	mov	P2, #11111110B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_0
	mov	P2, #11111101B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_1
	mov	P2, #11111011B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_2
	mov	P2, #11110111B
	mov	A, P0
	anl	A, #00001111B
	cjne	A, #00001111B, ROW_3
	ljmp	K2
	
ROW_0:
	mov	DPTR, #KCODE0
	sjmp	KB_FIND
ROW_1:
	mov	DPTR, #KCODE1
	sjmp	KB_FIND
ROW_2:
	mov	DPTR, #KCODE2
	sjmp	KB_FIND
ROW_3:
	mov	DPTR, #KCODE3
KB_FIND:
	rrc	A
	jnc	KB_MATCH
	inc	DPTR
	sjmp	KB_FIND
KB_MATCH:
	clr	A
	movc	A, @A+DPTR; get ASCII code from the table 
	ret

;ASCII look-up table 
KCODE0:	DB	'1', '2', '3', 'A'
KCODE1:	DB	'4', '5', '6', 'B'
KCODE2:	DB	'7', '8', '9', 'C'
KCODE3:	DB	'*', '0', '#', 'D'
END
