	AREA 	RESET, DATA, READONLY
	EXPORT __Vectors
__Vectors
    DCD 0x10001000 
    DCD Reset_Handler 
	ALIGN
	AREA 	mycode, CODE, READONLY
ENTRY
	EXPORT Reset_Handler
Reset_Handler
	LDR R0,=SRC
	LDR R1,[R0]
STOP
	B STOP
SRC DCD 0X12345678

	END
	
	