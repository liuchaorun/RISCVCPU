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
`include "InstructionFormat.vh"
`include "opType.vh"

module ID(
    input clk,
    input rst,
    input start,
    input [31:0]NPC,
    input [31:0]IR,
    input [4:0]wbRd,
    input [31:0]wbV,
    input wb,
    input br_flush,
    output [31:0] rs1_val,
    output [31:0] rs2_val,
    output reg[31:0] imm,
    output reg[4:0] rd_idx,
    // no op(1), load(5), store(3), write rd(1), csr(6)
    output reg[3:0] op_type,
    // << >> + - ^ & | cmp(<) * / %
    output reg[3:0] alu_type,
    output reg[3:0] br_type,
    output reg operand_type,
    output reg[31:0] npc_id,
    output reg stall,
    output reg[11:0] csr_idx,
    output reg flush
);
    reg[31:0] registerStauts;
    reg[4:0] rs1;
    reg[4:0] rs2;

    integer i;

    initial begin
        for (i = 0; i < 32; i=i+1) registerStauts[i] <= 1'b0;
        stall = 1'b0;
        flush = 1'b0;
        npc_id = 32'b0;
    end

    always @(posedge clk) begin
        flush = 1'b0;
        operand_type = 1'b0;
        npc_id = 32'b0;
        br_type = `BRNO;
        if (br_flush) begin
                csr_idx = 12'b0;
                op_type = `OPNO;
                alu_type = `ALUNO;
                br_type = `BRNO;
                registerStauts = 32'b0;
        end
        if (~stall && ~br_flush) begin
        casex (IR)
            `LUI: begin
                rd_idx = IR[11:7];
                registerStauts[rd_idx] = 1'b1;
                imm = {IR[31:12], 12'b0};
                op_type = `OPWRD;
                alu_type = `ALUNO;
            end
            `AUIPC: begin
                rd_idx = IR[11:7];
                registerStauts[rd_idx] = 1'b1;
                imm = {IR[31:12], 12'b0};
                npc_id = NPC;
                br_type = `BRNO;
                op_type = `OPWRD;
                alu_type = `ALUAUIPC;
            end
            `JAL: begin
                rd_idx = IR[11:7];
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {12'b1111_1111_1111, IR[31], IR[10:1], IR[11], IR[19:12]};
                else imm = {11'b0, IR[31], IR[19:12], IR[20], IR[30:21], 1'b0};
                npc_id = NPC;
                br_type = `BRJAL;
                op_type = `OPWRD;
                alu_type = `ALUNO;
            end
            `JALR: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                npc_id = NPC;
                br_type = `BRJALR;
                op_type = `OPWRD;
                alu_type = `ALUNO;
            end
            `LB: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                operand_type = 1'b1;
                op_type = `OPLB;
                alu_type = `ALUNO;
            end
            `LH: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                operand_type = 1'b1;
                op_type = `OPLH;
                alu_type = `ALUNO;
            end
            `LBU: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                operand_type = 1'b1;
                op_type = `OPLBU;
                alu_type = `ALUNO;
            end
            `LHU: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                operand_type = 1'b1;
                op_type = `OPLHU;
                alu_type = `ALUNO;
            end
            `LW: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                operand_type = 1'b1;
                op_type = `OPLW;
                alu_type = `ALUNO;
            end
            `ADDI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                op_type = `OPNO;
                alu_type = `ALUADD;
                operand_type = 1'b1;
            end
            `SLTI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                op_type = `OPNO;
                alu_type = `ALUCMP;
                operand_type = 1'b1;
            end
            `SLTIU: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                imm = {20'd0, IR[31:20]};
                op_type = `OPNO;
                alu_type = `ALUCMP;
                operand_type = 1'b1;
            end
            `XORI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                op_type = `OPNO;
                alu_type = `ALUXOR;
                operand_type = 1'b1;
            end
            `ORI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                op_type = `OPNO;
                alu_type = `ALUOR;
                operand_type = 1'b1;
            end
            `ANDI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:20]};
                else imm = {20'd0, IR[31:20]};
                op_type = `OPNO;
                alu_type = `ALUAND;
                operand_type = 1'b1;
            end
            `SLLI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                imm = {27'b0, IR[24:20]};
                op_type = `OPNO;
                alu_type = `ALUSLL;
                operand_type = 1'b1;
            end
            `SRLI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                imm = {27'b0, IR[24:20]};
                op_type = `OPNO;
                alu_type = `ALUSRL;
                operand_type = 1'b1;
            end
            `SRAI: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                imm = {27'b0, IR[24:20]};
                op_type = `OPNO;
                alu_type = `ALUSRA;
                operand_type = 1'b1;
            end
            `CSRRW: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                csr_idx = IR[31:20];
                op_type = `OPCSRRW;
                alu_type = `ALUNO;
            end
            `CSRRS: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                csr_idx = IR[31:20];
                op_type = `OPCSRRS;
                alu_type = `ALUNO;
            end
            `CSRRC: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                csr_idx = IR[31:20];
                op_type = `OPCSRRC;
                alu_type = `ALUNO;
            end
            `CSRRWI: begin
                rd_idx = IR[11:7];
                registerStauts[rd_idx] = 1'b1;
                imm = {27'b0, IR[19:15]};
                csr_idx = IR[31:20];
                op_type = `OPCSRRWI;
                alu_type = `ALUNO;
            end
            `CSRRSI: begin
                rd_idx = IR[11:7];
                registerStauts[rd_idx] = 1'b1;
                imm = {27'b0, IR[19:15]};
                csr_idx = IR[31:20];
                op_type = `OPCSRRSI;
                alu_type = `ALUNO;
            end
            `CSRRCI: begin
                rd_idx = IR[11:7];
                registerStauts[rd_idx] = 1'b1;
                imm = {27'b0, IR[19:15]};
                csr_idx = IR[31:20];
                op_type = `OPCSRRCI;
                alu_type = `ALUNO;
            end
            `BEQ: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                npc_id = NPC;
                br_type = `BRBEQ;
                op_type = `OPNO;
                alu_type = `ALUNO;
            end
            `BNE: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                npc_id = NPC;
                br_type = `BRBNE;
                op_type = `OPNO;
                alu_type = `ALUNO;
            end
            `BLT: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                npc_id = NPC;
                br_type = `BRBLT;
                op_type = `OPNO;
                alu_type = `ALUNO;
            end
            `BGE: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                npc_id = NPC;
                br_type = `BRBGE;
                op_type = `OPNO;
                alu_type = `ALUNO;
            end
            `BLTU: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                npc_id = NPC;
                br_type = `BRBLTU;
                op_type = `OPNO;
                alu_type = `ALUNO;
            end
            `BGEU: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                npc_id = NPC;
                br_type = `BRBGEU;
                op_type = `OPNO;
                alu_type = `ALUNO;
            end
            `ADD: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUADD;
                operand_type = 1'b0;
            end
            `SUB: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUSUB;
                operand_type = 1'b0;
            end
            `SLL: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUSLL;
                operand_type = 1'b0;
            end
            `SLT: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUCMP;
                operand_type = 1'b0;
            end
            `SLTU: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUCMP;
                operand_type = 1'b0;
            end
            `XOR: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUXOR;
                operand_type = 1'b0;
            end
            `SRL: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUSRL;
                operand_type = 1'b0;
            end
            `SRA: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUSRA;
                operand_type = 1'b0;
            end
            `OR: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUOR;
                operand_type = 1'b0;
            end
            `AND: begin
                rd_idx = IR[11:7];
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                registerStauts[rd_idx] = 1'b1;
                op_type = `OPNO;
                alu_type = `ALUAND;
                operand_type = 1'b0;
            end
            `SB: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:25], IR[11:7]};
                else imm = {20'b0, IR[31:25], IR[11:7]};
                operand_type = 1'b1;
                op_type = `OPSB;
                alu_type = `ALUADD;
            end
            `SH: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:25], IR[11:7]};
                else imm = {20'b0, IR[31:25], IR[11:7]};
                operand_type = 1'b1;
                op_type = `OPSH;
                alu_type = `ALUADD;
            end
            `SW: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                rs2 = IR[24:20];
                if (registerStauts[rs2]) begin
                    stall = 1'b1;
                    flush = 1'b1;
                end
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:25], IR[11:7]};
                else imm = {20'b0, IR[31:25], IR[11:7]};
                operand_type = 1'b1;
                op_type = `OPSW;
                alu_type = `ALUADD;
            end
            default: begin
                csr_idx = 12'b0;
                op_type = `OPNO;
                alu_type = `ALUNO;
                br_type = `BRNO;
                npc_id = NPC;
            end
        endcase
        end
    end

    always @(posedge clk) begin
        if (wb) begin
            registerStauts[wbRd] = 1'b0;
            if(registerStauts[rd_idx]) begin
                registerStauts[rd_idx] = 1'b0;
                if (~(|registerStauts)) stall = 1'b0; 
                registerStauts[rd_idx] = 1'b1;
            end
//            else stall = |registerStauts;
        end
        if (~(|registerStauts)) stall = 1'b0;
    end

    RegisterFiles RegisterFiles(
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(wbRd),
        .wb(wb),
        .rd_v(wbV),
        .rs1_v(rs1_val),
        .rs2_v(rs2_val)
    );
endmodule
