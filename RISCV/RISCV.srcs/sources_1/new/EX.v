`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/21 08:51:52
// Design Name: 
// Module Name: EX
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

`include "opType.vh"

module EX(
        input                   clk,
        input                   rst,
        input                   start,

        input                   [31:0]      rs1_val,
        input                   [31:0]      rs2_val,
        input                   [31:0]      imm,
        input                   [4:0]       rd_idx,
        input                   [3:0]       op_type,
        input                   [3:0]       alu_type,
        input                   [3:0]       br_type,
        input                               operand2_sel,
        input                   [31:0]      rd_pc,              // lui, auipc, jal, jalr write to rd
        input                               rdpc_sel,
        input                   [11:0]      csr_idx,
  
        output      reg         [31:0]      rs1_val_out,        // just forward
        output      reg         [31:0]      rs2_val_out,
        output      reg         [31:0]      imm_out,
        output      reg         [4:0]       rd_idx_out,
        output      reg         [4:0]       op_type_out,
        output      reg         [11:0]      csr_idx_out,

        output      reg         [31:0]      ex_output,           // address or rd_val
        output      reg                     mem_stall,
        output      reg                     alu_w_rd
    );

    wire [31:0] operand2;
    assign operand2 = operand2_sel ? imm : rs2_val;
    initial begin
        alu_w_rd = 1'b0;
    end

    always @(posedge clk or posedge rst) begin
        rs1_val_out[31:0] = rs1_val[31:0];
        rs2_val_out[31:0] = rs2_val[31:0];
        imm_out[31:0] = imm[31:0];
        rd_idx_out[4:0] = rd_idx[4:0];
        op_type_out[4:0] = op_type[4:0];
        csr_idx_out[11:0] = csr_idx[11:0];
        mem_stall = start;
        alu_w_rd = 1'b0;
        if(rst) begin
            ex_output <= 32'd0;
        end
        else if(start) begin
            if(rdpc_sel) begin
                ex_output <= rd_pc;
            end
            else begin                  // ALU compute
                case(alu_type)
                    `ALUSLL: ex_output <= rs1_val << operand2;
                    `ALUSRL: ex_output <= rs1_val >> operand2;
                    `ALUADD: ex_output <= rs1_val + operand2;
                    `ALUSUB: ex_output <= rs1_val - operand2;
                    `ALUXOR: ex_output <= rs1_val ^ operand2;
                    `ALUAND: ex_output <= rs1_val & operand2;
                    `ALUOR:  ex_output <= rs1_val | operand2;
                    `ALUCMP: ex_output <= (rs1_val < operand2) ? 32'd1: 32'd0;
                    `ALUMUL: ex_output <= rs1_val * operand2;
                    `ALUDIV: ex_output <= rs1_val / operand2;
                    `ALUREM: ex_output <= rs1_val % operand2;
                endcase
                if (alu_type != `ALUNO) alu_w_rd <= 1'b1;
                else alu_w_rd <= 1'b0;
            end
        end
        else begin
            ex_output <= ex_output;           // maintain
        end
    end
    
endmodule
