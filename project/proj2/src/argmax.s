.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    li t0, 0            # the counter of the array 
    li t1, 1
    blt a1, t1, exception

loop_start:
    lw t2, 0(a0)        # t2 store the current biggest number 
    add t3, t0, x0      # t3 store the index of the biggest number
    addi t0, t0, 1

loop_continue:
    bge t0, a1, loop_end     
    slli t4, t0, 2
    add t5, a0, t4
    lw t6, 0(t5)
    blt t2, t6, swap
    addi t0, t0, 1
    j loop_continue

swap:
    add t2, t6, x0
    add t3, t0, x0
    addi t0, t0, 1
    j loop_continue

loop_end:
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    
    add a0, t3, x0
    ret

exception:
    li a1, 77
    j exit2