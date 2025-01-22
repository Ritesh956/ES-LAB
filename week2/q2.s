    AREA RESET, DATA, READONLY
    EXPORT __Vectors
__Vectors
    DCD 0x00000000   
    DCD Reset_Handler
    ALIGN

    AREA mycode, CODE, READONLY
ENTRY
    EXPORT Reset_Handler
Reset_Handler
    LDR R0, =SRC
    LDR R1, [R0]
    LDR R2, =DST
    STR R1, [R2]
STOP    B STOP

    AREA mydata, DATA, READWRITE
SRC DCD 0x12345678
DST DCD 0
    END
