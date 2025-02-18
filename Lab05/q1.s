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
	LDR R0,=PACKED  ; Load base address of array
	MOV R1,#0       ; I = 0 (Outer loop counter)

OUTER_LOOP
	CMP R1,#4       ; Check if I < N-1 (N=5, so last valid index is 4)
	BEQ STOP        ; If I == N-1, exit loop
	MOV R2,R1       ; Set smallest index R2 = I
	MOV R3,R1       ; Set J pointer
	ADD R3,R1,#1    ; J = I + 1
	
INNER_LOOP
	CMP R3,#5       ; If J == N, exit inner loop
	BEQ CHECK_SWAP  ; Jump to swap check
	LDR R4,[R0,R2, LSL #2]  ; Load element at smallest index
	LDR R5,[R0,R3, LSL #2]  ; Load element at J index
	CMP R5,R4       ; Compare R5 (arr[J]) with R4 (arr[smallest])
	BGE CONT        ; If arr[J] >= arr[smallest], continue
	MOV R2,R3       ; Update smallest index to J

CONT
	ADD R3,R3,#1    ; J++
	B INNER_LOOP

CHECK_SWAP
	CMP R1,R2       ; If I == smallest index, no swap needed
	BEQ SKIP_SWAP
	LDR R4,[R0,R1, LSL #2]  ; Load arr[I]
	LDR R5,[R0,R2, LSL #2]  ; Load arr[smallest]
	STR R5,[R0,R1, LSL #2]  ; Swap arr[I] = arr[smallest]
	STR R4,[R0,R2, LSL #2]  ; Swap arr[smallest] = arr[I]

SKIP_SWAP
	ADD R1,R1,#1    ; I++
	B OUTER_LOOP

STOP
    B STOP
	
	AREA mydata,DATA,READWRITE
	
PACKED DCD 0x5,0x3,0x8,0x1,0x2  ; Array to be sorted

    END