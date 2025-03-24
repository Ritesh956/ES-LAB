	AREA RESET,DATA,READONLY
	EXPORT __Vectors

__Vectors
	
	DCD 0x10001000
	DCD Reset_Handler
	ALIGN
	AREA mycode,CODE,READONLY
	ENTRY
	EXPORT Reset_Handler	

Reset_Handler
	
	LDR r0, =SRC	;r0 is pointer to ith element
	LDR r1, =N1		
	LDR r2,[r1]		;r2 stores number of elements
	LDR r7, =DST
	MOV r8,#0
up	CMP r8,r2
	BEQ out
	ADD r8,#1
	LDR r9,[r0],#4
	STR r9,[r7],#4
	B up
out	LDR r0,=DST
	MOV r1, r0	
	MOV r3,r0	
	MOV r10,#0	
	MOV r11,#0	
lp1	CMP r11, r2	
	BEQ exit		
	ADD r3,r0,#4	
	MOV r1,r0		
	ADD r10,r11,#1	
lp2	CMP r10,r2		
	BEQ oif
	ADD r10,#1	
	LDR r4,[r3],#4
	LDR r5,[r1]
	CMP r5,r4
	BLT lp2
	MOV r1,r3
	SUB r1,#4
	B lp2
oif	ADD r11,#1
	LDR r4,[r0]
	LDR r5,[r1]
	STR r4,[r1]
	STR r5,[r0],#4
	B lp1
exit	
		
STOP 	
	B STOP

N1 DCD 0xA
SRC DCD 0x32,0x63,0x10,0x19,0x28,0x39,0x86,0x67,0x23,0x13
	
	AREA mydata,DATA,READWRITE

DST DCD 0,0,0,0,0,0,0,0,0,0
	END