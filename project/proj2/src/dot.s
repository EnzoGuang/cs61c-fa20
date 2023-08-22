.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    li t0, 1
    blt a2, t0, exit_length_lessthan_one
    blt a3, t0, exit_stride_lessthan_one
    blt a4, t0, exit_stride_lessthan_one
    li t0, 0                # the counter of loop
    li t1, 0                # store the result of dot product

loop_start:
    bge t0, a2, loop_end
    mul t3, t0, a3          # the index of current loop of v0 with stride a3
    mul t4, t0, a4          # the index of current loop of v1 with stride a4
    slli t3, t3, 2
    slli t4, t4, 2
    add t3, t3, a0          # address of current element of v0
    add t4, t4, a1          # address of current element of v1
    lw t5, 0(t3)
    lw t6, 0(t4)
    mul t2, t5, t6
    add t1, t1, t2
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4

    add a0, t1, x0
    ret

exit_length_lessthan_one:
    li a1, 75
    j exit2

exit_stride_lessthan_one:
    li a1, 76
    j exit2