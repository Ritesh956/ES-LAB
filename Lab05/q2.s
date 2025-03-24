	AREA RESET, DATA, READONLY
	EXPORT __Vectors

__Vectors
	DCD 0x10001000
	DCD Reset_Handler
	ALIGN

	AREA MYCODE, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler

Reset_Handler
	LDR R0, =NUMBER
	LDR R0, [R0]
	BL FACTORIAL
	LDR R1, =RESULT
	STR R0, [R1]
	B STOP

FACTORIAL
	PUSH {R1, LR}
	CMP R0, #1
	BLE BASE_CASE
	MOV R1, R0
	SUB R0, R0, #1
	BL FACTORIAL
	MUL R0, R1, R0
	B RETURN

BASE_CASE
	MOV R0, #1

RETURN
	POP {R1, LR}
	BX LR

STOP
	B STOP

	AREA MYDATA, DATA, READWRITE
NUMBER DCD 5
RESULT DCD 0
	END
