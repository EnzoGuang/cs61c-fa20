.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    li t0, 1
    blt a1, t0, exit_m0
    blt a2, t0, exit_m0

    blt a4, t0, exit_m1
    blt a5, t0, exit_m1

    bne a2, a4, exit_not_match

    # Prologue
    addi sp, sp, -44
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

    li t0, 0            # represent current row
    li t1, 0            # represent current column
    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0
    add s4, a4, x0
    add s5, a5, x0
    add s6, a6, x0

outer_loop_start:
    bge t0, s1, outer_loop_end
    mul t3, t0, s2        # get the row address of m0
    slli t3, t3, 2
    add t3, t3, s0
    # add s9, t3, x0

inner_loop_start:
    bge t1, s5, inner_loop_end
    slli t2, t1, 2
    add t2, t2, s3        # get the column address of m1

    add a0, t3, x0        # call function "dot" return value in a0
    add a1, t2, x0
    add a2, s2, x0
    addi a3, x0, 1
    add a4, s5, x0
    add s7, t0, x0
    add s8, t1, x0
    add s9, t3, x0
    jal dot

    add t0, s7, x0
    add t1, s8, x0
    add t3, s9, x0
    mul t4, t0, s5      # calculate the address of [i][j]
    add t4, t4, t1
    slli t4, t4, 2
    add t4, t4, s6
    sw a0, 0(t4)
    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1
    add t1, x0, x0
    j outer_loop_start

outer_loop_end:
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
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44
    ret

exit_m0:
    li a1, 72
    jal exit2

exit_m1:
    li a1, 73
    jal exit2

exit_not_match:
    li a1, 74
    jal exit2