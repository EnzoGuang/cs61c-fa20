# Document of ex1.c
<br>

## 1. What do the `.data`, `.word`, `.text` directives mean(i.e. what do you use them for)?<br>
#### .data directive:
    is used to define and allocate memory for data variable in the program
#### .word directive:
    is used within the .data or .text section to allocate memory for a word sized data variable
#### .text directive:
    is used to define the program's code or instruction section.

<br>


## 2. Run the program to completion. What number did the program output? What does this number represent?
    The output is 34, the result of 13th fibonacci.

<br>

## 3. At what address is n stored in memory? Hint: Look at the contents of the registers.
> the instruction `la t3, n`; la means load the address of variable n to the register t3.

<br> 

# 4. Without actually editing the code (i.e. without going into the “Editor” tab), have the program calculate the 13th fib number (0-indexed) by manually modifying the value of a register. You may find it helpful to first step through the code. If you prefer to look at decimal values, change the “Display Settings” option at the bottom.
    The program successfully calculate the 13th fib number, is 34.