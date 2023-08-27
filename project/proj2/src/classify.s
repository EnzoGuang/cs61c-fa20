.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # =====================================
    # check command line args
    # =====================================
    li t0, 5
    bne a0, t0, exit_incorrect_args

    # prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0


	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    addi a0, x0, 8
    jal malloc
    beq a0, x0, exit_malloc_fail    # if malloc fail a0 will set to 0
    add s3, a0, x0          # s3 store the row and column of m0
    
    lw a0, 4(s1)
    add a1, s3, x0
    addi a2, s3, 4
    jal read_matrix
    add s4, a0, x0          # s4 store the address of m0 in memory

    # Load pretrained m1
    addi a0, x0, 8
    jal malloc
    beq a0, x0, exit_malloc_fail
    add s5, a0, x0          # s5 store the row and column of m1

    lw a0, 8(s1)
    add a1, s5, x0
    addi a2, s5, 4
    jal read_matrix
    add s6, a0, x0          # s6 store the address of m1 in memory

    # Load input matrix
    addi a0, x0, 8
    jal malloc
    beq a0, x0, exit_malloc_fail
    add s7, a0, x0          # s7 store the row and column of input_matrix

    lw a0, 12(s1)
    add a1, s7, x0
    addi a2, s7, 4
    jal read_matrix
    add s8, a0, x0          # s8 sotre the address of input_matrix in memory

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(s3)
    lw t1, 4(s7)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    li t0, 0
    beq t0, a0, exit_malloc_fail
    add s9, a0, x0          # s9 store the result matrix of m0*input

    # 1. LINEAR LAYER:  m0 * input
    add a0, s4, x0
    lw a1, 0(s3)
    lw a2, 4(s3)
    add a3, s8, x0
    lw a4, 0(s7)
    lw a5, 4(s7)
    add a6, s9, x0
    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    add a0, s9, x0
    lw t0, 0(s3)
    lw t1, 4(s7)
    mul a1, t0, t1
    jal relu

    # 3. LINEAR LAYER: m1 * ReLU(m0 * input)
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul a0 t0, t1
    slli a0, a0, 2
    jal malloc
    li t0, 0
    beq t0, a0, exit_malloc_fail
    add s10, a0, x0         # s10 store the result of m1 *ReLU(m0*input)

    add a0, s6, x0
    lw a1, 0(s5)
    lw a2, 4(s5)
    add a3, s9, x0
    lw a4, 0(s3)
    lw a5, 4(s7)
    add a6, s10, x0
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    add a1, s10, x0
    lw a2, 0(s5)
    lw a3, 4(s7)
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    add a0, s10, x0
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul a1, t0, t1
    jal argmax
    add s11, a0, x0         # store the index of largest element   


    # Print classification
    bne x0, s2, finish

    add a1, s11, x0
    jal print_int

    # Print newline afterwards for clarity
    addi a1, x0, 10
    jal print_char

    # free the dynamic allocate space
    add a0, s3, x0
    jal free
    add a0, s4, x0
    jal free
    add a0, s5, x0
    jal free 
    add a0, s6, x0
    jal free 
    add a0, s7, x0
    jal free
    add a0, s8, x0
    jal free
    add a0, s9, x0
    jal free
    add a0, s10, x0
    jal free

    add a0, s11, x0

finish:
    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    ret

exit_incorrect_args:
    li a1, 89
    jal exit2

exit_malloc_fail:
    li a1, 88
    jal exit2