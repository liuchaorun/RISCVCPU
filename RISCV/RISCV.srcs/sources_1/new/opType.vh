`define     OPALU       6'b0000000

`define     OPLB        6'b000001
`define     OPLH        6'b000010
`define     OPLBU       6'b000011
`define     OPLHU       6'b000100
`define     OPLW        6'b000101

`define     OPSB        6'b000110
`define     OPSH        6'b000111
`define     OPSW        6'b001000

`define     OPBEQ       6'b001001
`define     OPBNE       6'b001010
`define     OPBLT       6'b001011
`define     OPBLTU      6'b001100
`define     OPBGE       6'b001101
`define     OPBGEU      6'b001110
`define     OPJAL       6'b001111
`define     OPJALR      6'b010000

`define     OPCSRRW     6'b010001
`define     OPCSRRS     6'b010010
`define     OPCSRRC     6'b010011
`define     OPCSRRWI    6'b010100
`define     OPCSRRSI    6'b010101
`define     OPCSRRCI    6'b010110

`define     OPMUL       6'b010111
`define     OPMULH      6'b011000
`define     OPMULHSU    6'b011001
`define     OPMULHU     6'b011010
`define     OPDIV       6'b011011
`define     OPDIVU      6'b011100
`define     OPREM       6'b011101
`define     OPREMU      6'b011110
`define     OPNO        6'b011111

`define     OPFLD       6'b100000
`define     OPFSD       6'b100001
`define     OPFMULD     6'b100010
`define     OPFDIVD     6'b100011

`define     OPECALL     6'b100100
`define     OPSRET      6'b100101


`define ALUSL 4'b0000
`define ALUSR 4'b0001
`define ALUADD 4'b0010
`define ALUSUB 4'b0011
`define ALUXOR 4'b0100
`define ALUAND 4'b0101
`define ALUOR 4'b0110
`define ALUCMP 4'b0111
`define ALUMUL 4'b1000
`define ALUDIV 4'b1001
`define ALUREM 4'b1010
`define ALUSRA 4'b1011
`define ALUAUIPC 4'b1100
`define ALUNO 4'b1101

`define mepc    12'h341
`define mcause  12'h342
`define mtval   12'h343
`define mstatus 12'h300
`define misa    12'h301
`define mtvec   12'h305
`define fflags  12'h333

