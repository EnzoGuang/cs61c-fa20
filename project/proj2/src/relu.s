.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    addi t0, x0, 1
    bge a1, t0, loop_start
    jal x0, exceptions

loop_start:
    add t0, x0, x0      # the counter of the array index

loop_continue:
    bge t0, a1, loop_end
    slli t1, t0, 2
    add t2, a0, t1
    lw t3, 0(t2)
    bge t3, zero, modify_to_zero 
    addi t3, x0, 0
    sw t3, 0(t2)

modify_to_zero:
    addi t0, t0, 1
    blt t0, a1, loop_continue

loop_end:
    lw ra, 0(sp)
    addi sp, sp, 4
	ret

exceptions:
    li a1, 78
    j exit2