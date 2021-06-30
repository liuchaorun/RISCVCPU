.main:
    #Arithmetic
    ADDI    x1,x0,0x10  
    ADDI    x6,x0,0x10  
    SUB     x2,x0,x6    
    LUI     x3,0x1      
    AUIPC   x4,0x4      
    ADD     x5,x1,x2    
    #Shifts
    ADDI    x1,x0,0xff      
    ADDI    x2,x0,0x3        
    SLL     x3,x1,x2         
    SLLI    x4,x1,3          
    SRL     x5,x3,x2         
    SRLI    x6,x4,3          
    SRA     x7,x1,x2         
    SRAI    x8,x1,3          
    #Logical
    ADDI    x1,x0,0xf0      
    ADDI    x2,x0,0x33      
    XOR     x3,x1,x2        
    XORI    x4,x1,0x33      
    OR      x5,x1,x2        
    ORI     x6,x1,0x33      
    AND     x7,x1,x2        
    ANDI    x8,x1,0x33      
    #compare&eviroment%csr
    ADDI    x1,x0,0x1       
    ADDI    x2,x0,0xff     
    ADDI    x8,x0,0x16      
    SLT     x3,x1,x2        
    SLTU    x4,x1,x2        
    SLTI    x5,x1,0x2       
    ecall
    csrrs   x6,fflags,x8
    csrrsi  x7,fflags,0x16
    #mul&div&rem
    ADDI x1,x0,0x10
    ADDI x2,x0,0x5
    MUL  x3,x1,x2
    MULHU x4,x1,x2
    DIV  x5,x1,x2
    DIVU x6,x1,x2
    REM  x7,x1,x2
    REMU x8,x1,x2