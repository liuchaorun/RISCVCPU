.main
    LW x5,x0,0      # n值 = Mem[0]
    ADDI x1,x0,0    # x1 = 0/i
    ADDI x2,x0,1    # x2 = 1/j
    ADDI x3,x0,2    # x3 = count = 2
    ADDI x4,x1,0
    BEQ x5,x2,32    # n == 1, jump to write x4
    ADDI x4,x2,0
    BEQ x5,x3,20    # n == 2, jump to write x4
    ADD x4,x1,x2    # x4 = fib = i + j
    ADDI x3,x3,1    # x3(count)++
    ADDI x1,x2,0    # i = j
    ADDI x2,x4,0    # j = fib
    BLT x3,x5,-12   # if count < n branch (PC already point to the PC+4) -8
    SW x0,x4,4      # Mem[1] = fib