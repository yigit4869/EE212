ORG 0;

INIT:                      
    MOV R0, #15h;          ; Low part of dividend
    MOV R1, #0A0h;         ; High part of dividend
    MOV R2, #70h;          ; Divisor
                       
    MOV R5, #0FFh	   ; Reminder
    MOV R6, #0FFH	   ; Temporary R3
    MOV R7, #0FFH	   ; Temporary R4
    CLR C; 
    
DIVISION_HIGH: ;basically the general process is subtracting divisor from the dividend thenn counting this subtraction until inputs of the dividends become zero      
    MOV A, R6;
    ADD A, #01d;              
    MOV R6, A;
    JC R7_ADD
    JNC NO_R7_UPDATE;
    
    
R7_ADD: MOV A,R7
ADD A, #01d;    
MOV R7, A           

NO_R7_UPDATE:
    CLR C;
    MOV A, R0;
    SUBB A, R2;            
    MOV R0, A;
    
    JNC DIVISION_HIGH     
    DJNZ R1, DIVISION_HIGH
    JC DIVISION_LOW

DIVISION_LOW:              
    CLR C;
    MOV A, R6;
    ADD A, #01d;                   
    MOV R6, A
    
    JC ADD_R7
    JNC NO_R7_UPDATE_L;    
    
    
ADD_R7:    
    MOV A, R7
    ADD A, #01d;        
    MOV R7, A           

NO_R7_UPDATE_L:
    CLR C;
    MOV A, R0;
    SUBB A, R2;            
    MOV R0, A;

    JC Final
    JNC DIVISION_LOW;      
    

Final:
    ADD A, R2;
    MOV R5, A;
    
    MOV A, R6
    MOV R3, A
    MOV A, R7
    MOV R4, A


end;
