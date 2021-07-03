`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/21 10:03:55
// Design Name: 
// Module Name: WB
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

module WB(clk, rst, start, rd_val, rd_idx, op_type, rs1_val, csr_idx, imm, wb, wb_idx, wb_val);
    input clk;
    input rst;
    input start;

    input [31:0] rd_val;
    input [4:0] rd_idx;
    input [3:0] op_type;
    input [4:0] rs1_val;
    input [31:0] imm;
    input [12:0] csr_idx;

    output reg wb;
    output reg[4:0] wb_idx;
    output reg[31:0] wb_val;

    reg[31:0] csr[4095:0];
    integer i;

    always @(posedge clk) begin
        wb = 1'b0;
        if (start) begin
            case (op_type)
            // CSR
            `OPCSRRW: begin
                wb = 1'b1;
                wb_val = csr[csr_idx];
                wb_idx = rd_idx;
                csr[csr_idx] = rs1_val;
            end 
            `OPCSRRWI: begin
                wb = 1'b1;
                wb_val = csr[csr_idx];
                wb_idx = rd_idx;
                csr[csr_idx] = imm;
            end
            `OPCSRRS: begin
                wb = 1'b1;
                wb_val = csr[csr_idx];
                wb_idx = rd_idx;
                csr[csr_idx] = rs1_val | csr[csr_idx];
            end
            `OPCSRRSI: begin
                wb = 1'b1;
                wb_val = csr[csr_idx];
                wb_idx = rd_idx;
                csr[csr_idx] = imm | csr[csr_idx];
            end
            `OPCSRRC: begin
                wb = 1'b1;
                wb_val = csr[csr_idx];
                wb_idx = rd_idx;
                csr[csr_idx] = ~rs1_val & csr[csr_idx];
            end
            `OPCSRRCI: begin
                wb = 1'b1;
                wb_val = csr[csr_idx];
                wb_idx = rd_idx;
                csr[csr_idx] = ~imm & csr[csr_idx];
            end

            default: begin
                wb = 1'b1;
                wb_idx = rd_idx;
                wb_val = rd_val;
            end 
        endcase
        end
    end

endmodule
