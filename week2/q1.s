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
	
	LDR R0, =SRC
    LDR R1, [R0]
    LDR R2, [R0, #4]

    ADD R3, R1, R2
    SUB R4, R1, R2

    STR R3, [R0, #8]
    STR R4, [R0, #12]

STOP B STOP

	AREA mydata, DATA, READWRITE
SRC DCD 8, 0
DST DCD 0, 0
	END