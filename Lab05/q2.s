    AREA RESET, DATA, READONLY

    EXPORT __Vectors

__Vectors
    DCD 0X10001000
    DCD Reset_Handler

    ALIGN

    AREA mycode, CODE, READONLY

    ENTRY

    EXPORT Reset_Handler

Reset_Handler
    LDR R4, =UNPACKED    ; Load address of input array
    LDR R5, =PACKED      ; Load address of output array
    MOV R7, #3           ; Number of elements in the array (change as needed)

PROCESS_NEXT
    CMP R7, #0
    BEQ END_PROGRAM      ; Stop when all elements are processed

    LDR R0, [R4], #4     ; Load an element and move to the next one

    MOV R6, #1           ; Initialize factorial result to 1

FACTORIAL_LOOP
    CMP R0, #0
    BEQ STORE_RESULT
    MUL R6, R6, R0
    SUB R0, R0, #1       ; Corrected subtraction
    B FACTORIAL_LOOP     ; Continue factorial calculation

STORE_RESULT
    STR R6, [R5], #4     ; Store the factorial result

    SUB R7, R7, #1
    B PROCESS_NEXT       ; Process next number in the array

END_PROGRAM
STOP
    B STOP

UNPACKED DCD 0x4, 0x3, 0x2  ; Example input array

    AREA mydata, DATA, READWRITE

PACKED  DCD 0x00, 0x00, 0x00 ; Output array to store factorial values

    END
