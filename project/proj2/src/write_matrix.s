.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0

    # open file with name 
    add a1, s0, x0
    addi a2, x0, 1
    jal fopen
    li t0, -1
    beq a0, t0, exit_fopen
    add s4, a0, x0          # s4 store the file pointer 

    # malloc 8 bytes to store the value of row and column
    addi a0, x0, 8
    jal malloc
    add s5, a0, x0
    sw s2, 0(s5)
    sw s3, 4(s5)

    # write row and column into file
    add a1, s4, x0
    add a2, s5, x0
    addi a3, x0, 2
    addi a4, x0, 4
    jal fwrite
    li t0, 2
    bne a0, t0, exit_fwrite

    # write file
    add a1, s4, x0
    add a2, s1, x0
    mul a3, s2, s3
    addi a4, x0, 4
    jal fwrite
    mul t0, s2, s3
    bne a0, t0, exit_fwrite

    # close file pointer
    add a1, s4, x0
    jal fclose
    li t0, -1
    beq a0, t0, exit_fclose

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    ret

exit_fopen:
    li a1, 93
    jal exit2

exit_fwrite:
    li a1, 94
    jal exit2

exit_fclose:
    li a1, 95
    jal exit2
