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
    LDR R10, =UNPACKED_BCD
    LDR R0, [R10]
    LDR R11, =PACKED_BCD
    
    LSR R2, R0, #0x0F
    AND R2, R2, #0x0F
    
    LSR R3, R0, #8
    AND R3, R3, #0x0F
    
    LSR R4, R0, #16
    AND R4, R4, #0x0F
    
    LSR R5, R0, #24
    AND R5, R5, #0x0F

    ORR R6, R2, R3, LSL #4
    ORR R6, R6, R4, LSL #8
    ORR R6, R6, R5, LSL #12

    STR R6, [R11]
    
STOP
    B STOP

UNPACKED_BCD DCD 0x01020304
    AREA data, DATA, READWRITE
PACKED_BCD DCD 0
    END
