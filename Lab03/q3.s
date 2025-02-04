	AREA 	RESET, DATA, READONLY
	EXPORT 	__Vectors
__Vectors
    DCD 0x10001000       
    DCD Reset_Handler   
	ALIGN

	AREA    mycode, CODE, READONLY
ENTRY
	EXPORT Reset_Handler

Reset_Handler
    LDR R6, =RESULT          
    MOV R2, #0              
    LDR R0, =VALUE1           
    LDR R1, [R0]              
    LDR R0, =VALUE2           
    LDR R3, [R0]              

UP
    CMP R1, R3               
    BCC STORE                 
    SUB R1, R1, R3            
    ADD R2, R2, #1            
    MOV R4, R1                
    B UP                    

STORE
    STR R2, [R6], #4          
    STR R1, [R6]              

STOP
    B       STOP                  

VALUE1  DCD 11            
VALUE2  DCD 3           
	AREA    data, DATA, READWRITE
RESULT  DCD 0                     
	END
