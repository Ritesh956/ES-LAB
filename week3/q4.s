	AREA RESET, DATA, READONLY
	EXPORT __Vectors
__Vectors
	DCD 0x10001000
	DCD Reset_Handler
	ALIGN

	AREA mycode, CODE, READONLY
ENTRY
	EXPORT Reset_Handler
Reset_Handler
	LDR R1, =VALUE1     
	LDR R1, [R1]         
	MOV R2, #0          

Loop:
	CMP R1, #0          
	BEQ Done             
	ADD R2, R2, R1       
	SUB R1, R1, #1      
	B Loop            

Done:
	LDR R0, =RESULT 
	STR R2, [R0]     

STOP
	B STOP             

	AREA data, DATA, READWRITE
VALUE1 DCD 0x00000005   
RESULT DCD 0           

	END 