`define OPNO 4'b0000
`define OPLB 4'b0001
`define OPLH 4'b0010
`define OPLBU 4'b0011
`define OPLHU 4'b0100
`define OPLW 4'b0101
`define OPSB 4'b0110
`define OPSH 4'b0111
`define OPSW 4'b1000
`define OPWRD 4'b1001
`define OPCSRRW 4'b1010
`define OPCSRRS 4'b1011
`define OPCSRRC 4'b1100
`define OPCSRRWI 4'b1101
`define OPCSRRSI 4'b1110
`define OPCSRRCI 4'b1111

`define ALUSLL 4'b0000
`define ALUSRL 4'b0001
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
`define ALUNO 4'b1111

`define BRNO 4'b0000
`define BRBEQ 4'b0001
`define BRBNE 4'b0010
`define BRBLT 4'b0011
`define BRBLTU 4'b0100
`define BRBGE  4'b0101
`define BRBGEU 4'b0110
`define BRJAL 4'b0111
`define BRJALR 4'b1000
