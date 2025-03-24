	AREA RESET,DATA,READONLY
	EXPORT __Vectors
__Vectors
	DCD 0X10001000
	DCD Reset_Handler
	ALIGN
	AREA mycode,CODE,READONLY
	ENTRY
	EXPORT Reset_Handler
Reset_Handler
	LDR R1,=VALUE
	LDR R2,[R1]
	MLA R3,R2,R2,R2
	MOV R4,R3,LSR #1
	LDR R5,=RESULT
	STR R4,[R5]
STOP B STOP
VALUE DCD 10
	AREA mydata,DATA,READWRITE
RESULT DCD 0
	END