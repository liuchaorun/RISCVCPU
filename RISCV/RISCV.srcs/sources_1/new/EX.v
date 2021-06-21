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


module EX(
        input                   clk,
        input                   rst,
        input                   start,

        input       [31:0]      rs1_val,
        input       [31:0]      rs2_val,
        input       [31:0]      imm,
        input       [4:0]       rd_idx,
        input       [3:0]       op_type,
        input       [3:0]       alu_type,
        input                   operand2_sel,
        input       [31:0]      rd_pc,              // lui, auipc, jal, jalr write to rd
        input                   rdpc_sel,

        output      [31:0]      rd_val,
        output      [4:0]       rd_idx,
        output      [4:0]       op_type_out,
        output      [31:0]      rs1_val_out,
        output      [31:0]      imm_out
    );

    
endmodule
