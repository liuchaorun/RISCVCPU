.main:
    #branch&jl
    ADDI x1,x0,5
    ADDI x2,x2,1
    BEQ  x1,x2,-4
    ADDI x3,x3,1
    BNE  x1,x3,-4
    ADDI x4,x4,1
    BLT  x4,x1,-4
    ADDI x5,x5,1
    BGE  x1,x4,-4
    ADDI x6,x6,1
    BLTU x6,x1,-4
    ADDI x7,x7,1
    BGEU x1,x7,-4
    JAL   x8,4
    ADDI x9,x0,1
    jALR x10,4
    ADDI x10,x0,1
