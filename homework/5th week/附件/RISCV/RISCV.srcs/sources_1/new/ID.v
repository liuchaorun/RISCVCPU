`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 12:08:03
// Design Name: 
// Module Name: ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "RegisterFiles.v"
`include "opType.vh"

module ID(
    input                           clk,
    input                           rst,
    input                           start,

    input               [31:0]      next_PC,
    input               [31:0]      IR,
    input               [4:0]       wb_idx,
    input               [31:0]      wb_val,
    input                           wb,
    input               [4:0]       wb_float_idx,
    input               [63:0]      wb_float_val,
    input                           wb_float,
    input                           pc_sel,

    output              [31:0]      rs1_val,
    output              [63:0]      rs1_float_val,
    output      reg     [31:0]      PC,
    output      reg                 operand1_sel,
    output              [31:0]      rs2_val,
    output              [63:0]      rs2_float_val,
    output      reg     [31:0]      imm,
    output      reg                 operand2_sel,
    output      reg     [4:0]       rd_idx,
    // no op(1), load(5), store(3), branch(8), write rd(1), csr(6)
    output      reg     [5:0]       op_type,
    // << >> + - ^ & | cmp(<) * / %
    output      reg     [3:0]       alu_type,
    output      reg     [2:0]       float_rm,
    output      reg     [11:0]      csr_idx,
    output      reg                 data_conflict,
    output      reg                 next_ena,
    output      reg                 flush
);

    reg    [4:0]       rs1_idx;
    reg    [4:0]       rs2_idx;
 
    // register write table to detect data conflict
    reg [63:0] conflictRegisterRs1;
    reg isConflictRegisterRs1;
    reg [63:0] conflictRegisterRs2;
    reg isConflictRegisterRs2;
    reg [63:0]  registerWriteStatus[63:0];
    reg [63:0]  registerWriteStatusLast[63:0];
    integer i;

    RegisterFiles RegisterFiles(
        .clk(clk),
        .rst(rst),
        // read
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        // write
        .wb(wb),
        .wb_idx(wb_idx),
        .wb_val(wb_val)
    );
    
    FloatRegisterFiles FloatRegisterFiles(
        .clk(clk),
        .rst(rst),
        // read
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rs1_val(rs1_float_val),
        .rs2_val(rs2_float_val),
        // write
        .wb(wb_float),
        .wb_idx(wb_float_idx),
        .wb_val(wb_float_val)
    );

    always @(posedge clk or posedge rst) begin
        flush = 1'b0;
        if(rst) begin
            PC[31:0]        = 32'h0000_0000;
            operand1_sel    = 1'b0;
            imm[31:0]       = 32'h0000_0000;
            operand2_sel    = 1'b0;
            op_type[5:0]    = `OPNO;
            alu_type[3:0]   = `ALUNO;
            csr_idx[11:0]   = 12'b0000_0000_0000;
            data_conflict   = 1'b0;
            next_ena        = 1'b0;
            for (i=0;i<64;i=i+1) begin
                registerWriteStatus[i] = 64'b0;
                registerWriteStatusLast[i] = 64'b0;
            end
            conflictRegisterRs1 = 64'b0;
            isConflictRegisterRs1 = 1'b0;
            conflictRegisterRs2 = 64'b0;
            isConflictRegisterRs2 = 1'b0;
        end
        else if (pc_sel) begin
            for (i=0;i<64;i=i+1) begin
                if(registerWriteStatus[i] > registerWriteStatusLast[i]) registerWriteStatus[i] = registerWriteStatusLast[i];
            end
            if (registerWriteStatus[rd_idx] != 32'b0) registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] - 1'b1;
            conflictRegisterRs1 = 64'b0;
            isConflictRegisterRs1 = 1'b0;
            conflictRegisterRs2 = 64'b0;
            isConflictRegisterRs2 = 1'b0;
            PC[31:0]        = 32'h0000_0000;
            operand1_sel    = 1'b0;
            imm[31:0]       = 32'h0000_0000;
            operand2_sel    = 1'b0;
            op_type[5:0]    = `OPNO;
            alu_type[3:0]   = `ALUNO;
            csr_idx[11:0]   = 12'b0000_0000_0000;
            data_conflict   = 1'b0;
            next_ena        = 1'b0;
        end 
        else if (data_conflict) flush = 1'b0;
        else if(start && ~data_conflict && ~pc_sel) begin
            for (i=0;i<64;i=i+1) begin
                registerWriteStatusLast[i] = registerWriteStatus[i];
            end
            rs1_idx = IR[19:15];
            rs2_idx = IR[24:20];
            rd_idx  = IR[11:7];
            PC[31:0] = next_PC[31:0] -3'b100;
            csr_idx  = IR[31:20];
            next_ena = 1'b1;
            data_conflict = 1'b0;
            
            if (IR == 32'b0) begin
                next_ena = 1'b0;
                op_type[5:0]    = `OPNO;
                alu_type[3:0]   = `ALUNO;
            end
            // lb lh lw lbu lhu
            else if(IR[6:2] == 5'b00000) begin
                operand1_sel    = 1'b0;   // select rs1
                operand2_sel    = 1'b1;   // select imm
                imm[31:0]       = {{20{IR[31]}}, IR[31:20]};
                alu_type[3:0]   = `ALUADD;
                // data_conflict
                if(registerWriteStatus[rs1_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] + 1'b1;
                case(IR[14:12])
                    3'b000: op_type[5:0] = `OPLB;
                    3'b001: op_type[5:0] = `OPLH;
                    3'b010: op_type[5:0] = `OPLW;
                    3'b100: op_type[5:0] = `OPLBU;
                    3'b101: op_type[5:0] = `OPLHU;
                    default: op_type[5:0] = `OPALU;
                endcase
            end
            //addi slti sltiu xori ori andi slli srli srai
            else if(IR[6:2] == 5'b00100) begin
                operand1_sel    = 1'b0;   // select rs1
                operand2_sel    = 1'b1;   // select imm
                // data_conflict
                if(registerWriteStatus[rs1_idx]  != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] + 1'b1;
                // slli srli srai
                if(IR[14:12] == 3'b001 || IR[14:12] == 3'b101) begin
                    imm[31:0]       = {27'b0, IR[24:20]};
                    op_type[5:0]    = `OPALU;
                    // slli
                    if(IR[14:12] == 3'b001) begin
                        alu_type[3:0] = `ALUSL;
                    end
                    // srli srai
                    else begin
                        alu_type[3:0] = `ALUSR;
                    end
                end
                //addi slti sltiu xori ori andi
                else begin
                    imm[31:0] = {{20{IR[31]}}, IR[31:20]};
                    op_type[5:0] = `OPALU;
                    case(IR[14:12])
                        3'b000: alu_type[3:0] = `ALUADD;
                        3'b010: alu_type[3:0] = `ALUCMP;
                        3'b011: alu_type[3:0] = `ALUCMP;
                        3'b100: alu_type[3:0] = `ALUXOR;
                        3'b110: alu_type[3:0] = `ALUOR;
                        3'b111: alu_type[3:0] = `ALUAND;
                        default:alu_type[3:0] <= `ALUNO;
                    endcase
                end
            end
            // U - auipc
            else if(IR[6:2] == 5'b00101) begin
                operand1_sel    = 1'b1;   
                operand2_sel    = 1'b1;   // select imm
                imm[31:0]       = {IR[31:12], 12'b0};
                op_type = `OPALU;
                alu_type = `ALUADD;
                // data_conflict
                registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] + 1'b1;
            end
            // S sb sh sw
            else if(IR[6:2] == 5'b01000) begin
                operand1_sel    = 1'b0;   // select rs1
                operand2_sel    = 1'b1;   // select imm
                imm[31:0]       = {{20{IR[31]}}, IR[31:25], IR[11:7]};
                alu_type[3:0]   = `ALUADD;
                if(registerWriteStatus[rs1_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                if(registerWriteStatus[rs2_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs2 = rs2_idx;
                    isConflictRegisterRs2 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                case(IR[14:12])
                    3'b000: op_type[5:0] = `OPSB;
                    3'b001: op_type[5:0] = `OPSH;
                    3'b010: op_type[5:0] = `OPSW;
                    default:op_type[5:0] = `OPALU;
                endcase
            end
            // R add sub sll slt sltu xor srl sra or and mul mulh mulhsu mulhu div divu rem remu
            else if(IR[6:2] == 5'b01100) begin
                operand1_sel    = 1'b0;   
                operand2_sel    = 1'b0;
                // data conflict
                if(registerWriteStatus[rs1_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                if(registerWriteStatus[rs2_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs2 = rs2_idx;
                    isConflictRegisterRs2 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] + 1'b1;
                // RVM
                if(IR[31:25] == 7'b0000001) begin
                    // MUL
                    if(IR[14] == 1'b0) begin
                        alu_type[3:0] = `ALUMUL;
                        case(IR[13:12])
                            2'b00: op_type = `OPMUL;
                            2'b01: op_type = `OPMULH;
                            2'b10: op_type = `OPMULHSU;
                            2'b11: op_type = `OPMULHU;
                        endcase
                    end
                    else begin
                        // DIV
                        if(IR[13:12] == 2'b00 || IR[13:12] == 2'b01) begin
                            alu_type[3:0] = `ALUDIV;
                            if(IR[13:12] == 2'b00) op_type[5:0] = `OPDIV;
                            else op_type[5:0] = `OPDIVU;
                        end
                        // REM
                        else begin
                            alu_type[3:0] = `ALUREM;
                            if(IR[13:12] == 2'b10) op_type[5:0] = `OPREM;
                            else op_type[5:0] = `OPREMU;
                        end
                    end
                end
                // add sub sll slt sltu xor srl sra or and
                else begin
                    op_type[5:0] = `OPALU;
                    case(IR[14:12])
                        3'b000: begin
                            if(IR[31:25] == 7'b0000000) alu_type[3:0] = `ALUADD;
                            else alu_type[3:0] = `ALUSUB;
                        end
                        3'b001: alu_type[3:0] = `ALUSL;
                        3'b010: alu_type[3:0] = `ALUCMP;
                        3'b011: alu_type[3:0] = `ALUCMP;
                        3'b100: alu_type[3:0] = `ALUXOR;
                        3'b101: alu_type[3:0] = `ALUSR;
                        3'b110: alu_type[3:0] = `ALUOR;
                        3'b111: alu_type[3:0] = `ALUAND;
                        default: alu_type[3:0] = `ALUNO;
                    endcase
                end
            end
            // U - lui
            else if(IR[6:2] == 5'b01101) begin
                operand1_sel    = 1'b0;
                operand2_sel    = 1'b1;   // select imm
                imm[31:0]       = {IR[31:12], 12'b0};
                op_type = `OPALU;
                alu_type = `ALUNO;
                // data_conflict
                registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] + 1'b1;
            end
            // B
            else if(IR[6:2] == 5'b11000) begin
                operand1_sel    = 1'b1;
                operand2_sel    = 1'b1;   // select imm
                imm = {{20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};
                if(registerWriteStatus[rs1_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                if(registerWriteStatus[rs2_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs2 = rs2_idx;
                    isConflictRegisterRs2 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                alu_type = `ALUADD;
                case(IR[14:12])
                    3'b000: op_type = `OPBEQ;
                    3'b001: op_type = `OPBNE;
                    3'b100: op_type = `OPBLT;
                    3'b101: op_type = `OPBGE;
                    3'b110: op_type = `OPBLTU;
                    3'b111: op_type = `OPBGEU;
                endcase
            end
            // jalr
            else if(IR[6:2] == 5'b11001) begin
                operand1_sel    = 1'b0;
                operand2_sel    = 1'b1;   // select imm
                imm[31:0] = {{20{IR[31]}}, IR[31:20]};
                op_type = `OPJALR;
                alu_type = `ALUNO;
                // data_conflict
                if(registerWriteStatus[rs1_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] + 1'b1;
            end
            // jal
            else if(IR[6:2] == 5'b11011) begin
                operand1_sel    = 1'b1;
                operand2_sel    = 1'b1;   // select imm
                imm = {{12{IR[31]}}, IR[19:12], IR[20], IR[30:21], 1'b0};
                op_type = `OPJAL;
                alu_type = `ALUNO;
                registerWriteStatus[IR[11:7]] = 1'b1;
            end
            // ebreak ecall csr
            else if (IR[6:2] == 5'b11100) begin
                // ecall
                if(IR[14:12] == 3'b000) begin
                    if(IR[31:20] == 12'd0) begin
                        op_type = `OPECALL;
                    end
                    else begin  // IR[31:20] == 12'd1;
                        op_type = `OPSRET;
                    end
                end
                else begin
                    operand1_sel = 1'b0;
                    alu_type = 4'b1111;
                    // data_conflict
                    if(registerWriteStatus[rs1_idx] != 64'b0) begin
                        data_conflict = 1'b1;
                        conflictRegisterRs1 = rs1_idx;
                        isConflictRegisterRs1 = 1'b1;
                        flush = 1'b1;
                        next_ena = 1'b0;
                    end
                    registerWriteStatus[rd_idx] = registerWriteStatus[rd_idx] + 1'b1;
                    // csrrwi cssrrsi csrrci
                    if(IR[14] == 1'b1) begin
                        operand2_sel = 1'b1;
                        imm = {27'b0, IR[24:20]};
                        case(IR[13:12])
                            2'b01: op_type = `OPCSRRWI;
                            2'b10: op_type = `OPCSRRSI;
                            2'b11: op_type = `OPCSRRCI;
                            default: op_type = `OPALU;
                        endcase
                    end
                    else begin
                        operand2_sel = 1'b0;
                        case(IR[13:12])
                            //2'b00: op_type <= `OPCSRRWI;
                            2'b01: op_type = `OPCSRRW;
                            2'b10: op_type = `OPCSRRS;
                            2'b11: op_type = `OPCSRRC;
                            default: op_type = `OPALU;
                        endcase
                    end
                end
            end
            //fld
            else if (IR[6:0] == 7'b0000111) begin
                operand1_sel    = 1'b0;   // select rs1
                operand2_sel    = 1'b1;   // select imm
                imm[31:0]       = {{20{IR[31]}}, IR[31:20]};
                alu_type[3:0]   = `ALUADD;
                // data_conflict
                if(registerWriteStatus[rs1_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                registerWriteStatus[rd_idx + 32] = registerWriteStatus[rd_idx + 32] + 1'b1;
                op_type[5:0] = `OPFLD;
            end
            //fsd
            else if (IR[6:0] == 7'b0100111) begin
                operand1_sel    = 1'b0;   // select rs1
                operand2_sel    = 1'b1;   // select imm
                imm[31:0]       = {{20{IR[31]}}, IR[31:25], IR[11:7]};
                alu_type[3:0]   = `ALUADD;
                if(registerWriteStatus[rs1_idx] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                if(registerWriteStatus[rs2_idx + 32] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs2 = rs1_idx + 64'd32;
                    isConflictRegisterRs2 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                op_type[5:0] = `OPFSD;
            end
            //fdivd fmuld
            else if (IR[6:0] == 7'b1010011) begin
                operand1_sel    = 1'b0;   
                operand2_sel    = 1'b0;
                // data conflict
                if(registerWriteStatus[rs1_idx + 64'd32] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs1_idx + 64'd32;
                    isConflictRegisterRs1 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                if(registerWriteStatus[rs2_idx + 64'd32] != 64'b0) begin
                    data_conflict = 1'b1;
                    conflictRegisterRs1 = rs2_idx + 64'd32;
                    isConflictRegisterRs2 = 1'b1;
                    flush = 1'b1;
                    next_ena = 1'b0;
                end
                registerWriteStatus[rd_idx + 32] = registerWriteStatus[rd_idx + 32] + 1'b1;
                float_rm = IR[14:12];
                //fmuld
                if (IR[31:25] == 7'b0001001) begin
                    op_type = `OPFMULD;
                    alu_type = `ALUNO;
                end
                //fdivd
                else if (IR[31:25] == 7'b0001100) begin
                    op_type = `OPFDIVD;
                    alu_type = `ALUNO;
                end
            end
            else begin
                next_ena = 1'b0;
                op_type[5:0]    = `OPNO;
                alu_type[3:0]   = `ALUNO;
            end
        end
        // stall
        else begin
            // other signals to keep
            next_ena = 1'b0;
            op_type[5:0]    = `OPNO;
            alu_type[3:0]   = `ALUNO;
        end
    end

    always @(posedge clk) begin
        if (wb) begin
            if (registerWriteStatus[wb_idx] != 64'b0) begin
                registerWriteStatus[wb_idx] = registerWriteStatus[wb_idx] - 1'b1;
            end
            if (data_conflict) begin
                if(isConflictRegisterRs1 && conflictRegisterRs1 < 64'd32) begin
                    if (registerWriteStatus[conflictRegisterRs1] == 64'b0) isConflictRegisterRs1=1'b0;
                    if (registerWriteStatus[conflictRegisterRs1] == 64'b1 && rd_idx == wb_idx && conflictRegisterRs1 == rd_idx) isConflictRegisterRs1=1'b0;
                end
                if(isConflictRegisterRs2 && conflictRegisterRs2 < 64'd32) begin
                    if (registerWriteStatus[conflictRegisterRs2] == 64'b0) isConflictRegisterRs2=1'b0;
                    if (registerWriteStatus[conflictRegisterRs2] == 64'b1 && rd_idx == wb_idx && conflictRegisterRs2 == rd_idx) isConflictRegisterRs2=1'b0;
                end
                data_conflict = isConflictRegisterRs1 | isConflictRegisterRs2;
            end
        end
        if (wb_float) begin
            if (registerWriteStatus[wb_float_idx + 64'd32] != 64'b0) begin
                registerWriteStatus[wb_float_idx + 64'd32] = registerWriteStatus[wb_float_idx + 64'd32] - 1'b1;
            end
            if (data_conflict) begin
                if(isConflictRegisterRs1 && conflictRegisterRs1 > 64'd31) begin
                    if (registerWriteStatus[conflictRegisterRs1] == 64'b0) isConflictRegisterRs1=1'b0;
                    if (registerWriteStatus[conflictRegisterRs1] == 64'b1 && rd_idx == wb_float_idx && conflictRegisterRs1 == rd_idx) isConflictRegisterRs1=1'b0;
                end
                if(isConflictRegisterRs2 && conflictRegisterRs2 > 64'd31) begin
                    if (registerWriteStatus[conflictRegisterRs2] == 64'b0) isConflictRegisterRs2=1'b0;
                    if (registerWriteStatus[conflictRegisterRs2] == 64'b1 && rd_idx == wb_float_idx && conflictRegisterRs1 == rd_idx) isConflictRegisterRs2=1'b0;
                end
                data_conflict = isConflictRegisterRs1 | isConflictRegisterRs2;
            end
        end
    end

endmodule
