        ; Assume unsorted 32-bit numbers are in R1 through R10

        STMFD   SP!, {R1-R10}         @ Push registers onto stack.
                                       @ Now the 10 numbers are stored consecutively in memory.
                                       @ (Stack grows downward, so the block is at [SP]..[SP+36].)

        MOV     R11, SP               @ R11 will serve as the base pointer to our array on the stack.
        MOV     R7, #10               @ R7 = count of numbers (10).

        ;-----------------------------
        ; Selection sort on array at [R11] with indices 0..9.
        ; The array is considered to have element i at address R11 + (i*4)
        ; Sorting in ascending order (lowest value first).
        ;-----------------------------

        MOV     R0, #0                @ Outer loop index i = 0.
outer_loop:
        CMP     R0, R7
        BEQ     sort_done             @ If i == 10, the sort is complete.
        MOV     R3, R0                @ R3 will hold the index of the current minimum element (min_index = i).
        MOV     R1, R0                
        ADD     R1, R1, #1            @ Inner loop: j = i+1.
inner_loop:
        CMP     R1, R7                @ while (j < count)
        BEQ     inner_loop_end
        LDR     R2, [R11, R1, LSL #2]  @ R2 = array[j]
        LDR     R4, [R11, R3, LSL #2]  @ R4 = array[min_index]
        CMP     R2, R4                @ Compare array[j] with array[min_index]
        BGE     inner_loop_continue   @ if array[j] >= array[min_index], do nothing.
        MOV     R3, R1                @ Else, update min_index = j.
inner_loop_continue:
        ADD     R1, R1, #1            @ j++
        B       inner_loop
inner_loop_end:
        CMP     R3, R0                @ If min_index equals current i...
        BEQ     no_swap               @ ...no swap needed.
        ; Swap array[i] and array[min_index]:
        LDR     R2, [R11, R0, LSL #2]  @ R2 = array[i] (temporary)
        LDR     R4, [R11, R3, LSL #2]  @ R4 = array[min_index]
        STR     R4, [R11, R0, LSL #2]  @ array[i] = array[min_index]
        STR     R2, [R11, R3, LSL #2]  @ array[min_index] = temp (old array[i])
no_swap:
        ADD     R0, R0, #1            @ i++
        B       outer_loop
sort_done:
        ;-----------------------------
        ; At this point the array in memory (from [R11] up) is sorted in ascending order.
        ; The smallest element is at address R11 (index 0) and the largest at R11+36.
        ;
        ; We now want to load the sorted array back into registers R1-R10.
        ; We must use LDMDB. To load in ascending order (R1 = smallest, R10 = largest)
        ; we set up a pointer (in R12) to the “end” of the array (i.e. SP+40)
        ; so that LDMDB decrements from that pointer.
        ;-----------------------------

        ADD     R12, SP, #40          @ R12 = SP + 40 (points just past the end of the stored array)
        LDMDB   R12!, {R10, R9, R8, R7, R6, R5, R4, R3, R2, R1}
                                       @ LDMDB decrements R12 before each load.
                                       @ The first load gets the word at (R12-4) into R10,
                                       @ then R12-8 into R9, …, and finally the word at (R12-40) into R1.
                                       @ Because our sorted array in memory has the smallest value
                                       @ at address SP (i.e. R12-40) and the largest at SP+36 (i.e. R12-4),
                                       @ this results in R1 = smallest, ..., R10 = largest.

        ; Now registers R1 through R10 contain the sorted numbers in ascending order.
