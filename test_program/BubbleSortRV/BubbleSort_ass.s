main:
    addi a2,x0,9
    addi a4,x0,0
.L0:
    addi a5,a4,0
.L1:
    slli a6,a5,2
    lw   t0,0(a6)
    lw   t1,4(a6)
    blt  t0,t1,.L3
    sw   t0,4(a6)
    sw   t1,0(a6)
.L3:
    addi a5,a5,1
    blt  a5,a2,.L1
    addi a4,a4,1
    blt  a4,a2,.L0
    jal  ra
    