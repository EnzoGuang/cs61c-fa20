* The register representing the variable k.
    > register t0(x5) . 

* The register representing the variable sum.
    > register s0(x8)  

* The registers acting as pointers to the source and dest arrays.
    > register t1(x6) for source array  
    > register t3(x28) for dest array 

* The assembly code for the loop found in the C code.
    ```
    loop:
    slli s3, t0, 2
    add t1, s1, s3
    lw t2, 0(t1)
    beq t2, x0, exit
    add a0, x0, t2
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t2, 4(sp)
    jal fun
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    add t2, x0, a0
    add t3, s2, s3
    sw t2, 0(t3)
    add s0, s0, t2
    addi t0, t0, 1
    jal x0, loop
    ```
* How the pointers are manipulated in the assembly code.