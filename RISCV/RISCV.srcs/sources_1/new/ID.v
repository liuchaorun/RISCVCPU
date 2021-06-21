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

module ID(NPC,IR,clk,rst,wbRd,wbV,wb,decodeInstructionInfo,stall,newPC,pcSel,rs1_v,rs2_v);
    input clk;
    input rst;
    input [31:0]NPC;
    input [31:0]IR;
    input [4:0]wbRd;
    input [31:0]wbV;
    input wb;
    output reg[159:0] decodeInstructionInfo;
    output reg stall;
    output reg[31:0] newPC;
    output reg pcSel;
    output rs1_v;
    output rs2_v;

    reg[4:0] rs1 = 5'd0;
    reg[4:0] rs2 = 5'd0;
    reg[4:0] rd = 5'd0;
    reg[31:0] imm = 32'd0;
    wire[31:0] rs1_v = 32'd0;
    wire[31:0] rs2_v = 32'd0;
    reg[11:0] csr = 12'd0;
    reg[4:0] shamt = 5'd0;
    reg registerStauts[31:0];

    integer i;

    initial begin
        for (i = 0; i < 32; i=i+1) registerStauts[i] <= 1'b0;
        stall = 1'b0;
    end

    always @(posedge clk) begin
        casex (IR)
            `LUI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                imm = {IR[31:12], 12'b0};
            end
            `AUIPC: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                imm = {IR[31:12], 12'b0};
            end
            `JAL: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                if (IR[31]) imm = {12'b1111_1111_1111, IR[31], IR[10:1], IR[11], IR[19:12]};
                else imm = {11'b0, IR[31], IR[19:12], IR[20], IR[30:21], 1'b0};
                newPC = imm;
                pcSel = 1'b1;
            end
            `JALR: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `LB: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `LH: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `LBU: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `LHU: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `LW: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `ADDI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `SLTI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `SLTIU: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (registerStauts[rs1]) stall = 1'b1;
                imm = {20'd0, IR[31:20]};
            end
            `XORI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (registerStauts[rs1]) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `ORI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (registerStauts[rs1]) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `ANDI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[11:0]};
                else imm = {20'd0, IR[31:20]};
            end
            `SLLI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                shamt = IR[24:20];
            end
            `SRLI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                shamt = IR[24:20];
            end
            `SRAI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                shamt = IR[24:20];
            end
            `CSRRW: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                csr = IR[31:20];
            end
            `CSRRS: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                csr = IR[31:20];
            end
            `CSRRC: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                csr = IR[31:20];
            end
            `CSRRWI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                imm = {27'b0, IR[19:15]};
                csr = IR[31:20];
            end
            `CSRRSI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                imm = {27'b0, IR[19:15]};
                csr = IR[31:20];
            end
            `CSRRCI: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                imm = {27'b0, IR[19:15]};
                csr = IR[31:20];
            end
            `BEQ: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                if (rs1 == rs2) begin
                    newPC = NPC - 4 + imm;
                    pcSel = 1'b1;
                end
            end
            `BNE: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                if (rs1 != rs2) begin
                    newPC = NPC - 4 + imm;
                    pcSel = 1'b1;
                end
            end
            `BLT: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                if (rs1 < rs2) begin
                    newPC = NPC - 4 + imm;
                    pcSel = 1'b1;
                end
            end
            `BGE: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                if (IR[31]) imm = {19'b111_1111_1111_1111_1111, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                else imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                if (rs1 >= rs2) begin
                    newPC = NPC - 4 + imm;
                    pcSel = 1'b1;
                end
            end
            `BLTU: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                if (rs1 < rs2) begin
                    newPC = NPC - 4 + imm;
                    pcSel = 1'b1;
                end
            end
            `BGEU: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                imm = {19'b0, IR[31], IR[7], IR[30:25], IR[11:8], 1'b0};
                if (rs1 >= rs2) begin
                    newPC = NPC - 4 + imm;
                    pcSel = 1'b1;
                end
            end
            `ADD: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `SUB: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `SLL: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `SLT: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `SLTU: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `XOR: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `SRL: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `SRA: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `OR: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `AND: begin
                rd = IR[11:7];
                registerStauts[rd] = 1'b1;
                rs1 = IR[19:15];
                if (registerStauts[rs1] && rs1 != rd) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2] && rs2 != rd) stall = 1'b1;
            end
            `SB: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:25], IR[11:7]};
                else imm = {20'b0, IR[31:25], IR[11:7]};
            end
            `SH: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:25], IR[11:7]};
                else imm = {20'b0, IR[31:25], IR[11:7]};
            end
            `SW: begin
                rs1 = IR[19:15];
                if (registerStauts[rs1]) stall = 1'b1;
                rs2 = IR[24:20];
                if (registerStauts[rs2]) stall = 1'b1;
                if (IR[31]) imm = {20'b1111_1111_1111_1111_1111, IR[31:25], IR[11:7]};
                else imm = {20'b0, IR[31:25], IR[11:7]};
            end
            default: begin
                csr = 12'b0;
            end
        endcase
        decodeInstructionInfo = {IR, rs1, rs2, rd, rs1_v, rs2_v, imm, csr, shamt};
    end

    always @(posedge clk) begin
        if (wb) registerStauts[wbRd] <= 1'b0;
    end

    RegisterFiles RegisterFiles(
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(wbRd),
        .wb(wb),
        .rd_v(wbV),
        .rs1_v(rs1_v),
        .rs2_v(rs2_v)
    );
endmodule
