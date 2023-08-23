.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0

    # call fopen function, reading only
    add a1, s0, x0
    addi a2, x0, 0
    jal fopen
    add t0, a0, x0
    li t1, -1
    beq t0, t1, exit_fopen
    add s3, a0, x0          # store the file pointer returned by fopen

    # read row from file to row pointer
    add a1, s3, x0
    add a2, s1, x0
    addi a3, x0, 4
    jal fread
    li t0, 4
    bne a0, t0, exit_fread

    # read column from file to column pointer
    add a1, s3, x0
    add a2, s2, x0
    addi a3, x0, 4
    jal fread
    li t0, 4
    bne a0, t0, exit_fread

    # allocate row * column bytes by malloc
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t3, t1, t2
    slli t3, t3, 2
    add s5, t3, x0          # store the total bytes of file
    add a0, t3, x0
    jal malloc
    add s4, a0, x0          # store the address of array in s4

    # read the rest of file 
    add a1, s3, x0
    add a2, s4, x0
    add a3, s5, x0
    jal fread
    bne a0, s5, exit_fread

    add a1, s3, x0
    jal fclose
    li t0, -1
    beq a0, t0, exit_fclose

    add a0, s4, x0

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36
    ret

exit_fopen:
    li a1, 90
    jal exit2

exit_fread:
    li a1, 91
    jal exit2

exit_fclose:
    li a1, 92
    jal exit2