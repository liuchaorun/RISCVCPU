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

module WB(
    input clk,
    input rst,
    input start,

    input [31:0] rd_val,
    input [63:0] rd_float_val,
    input [4:0] rd_idx,
    input [5:0] op_type,
    input [4:0] rs1_val,
    input [31:0] imm,
    input [12:0] csr_idx,

    output reg wb,
    output reg[4:0] wb_idx,
    output reg[31:0] wb_val,
    output reg wb_float,
    output reg[4:0] wb_float_idx,
    output reg[63:0] wb_float_val
);

    // reg[31:0] csr[4095:0];
    integer i;

    always @(posedge clk) begin
        wb = 1'b0;
        wb_float = 1'b0;
        if (start) begin
            case (op_type)
            // CSR
            `OPCSRRW: begin
                wb = 1'b1;
                wb_val = rd_val;
                wb_idx = rd_idx;
            end 
            `OPCSRRWI: begin
                wb = 1'b1;
                wb_val = rd_val;
                wb_idx = rd_idx;
            end
            `OPCSRRS: begin
                wb = 1'b1;
                wb_val = rd_val;
                wb_idx = rd_idx;
            end
            `OPCSRRSI: begin
                wb = 1'b1;
                wb_val = rd_val;
                wb_idx = rd_idx;
            end
            `OPCSRRC: begin
                wb = 1'b1;
                wb_val = rd_val;
                wb_idx = rd_idx;
            end
            `OPCSRRCI: begin
                wb = 1'b1;
                wb_val = rd_val;
                wb_idx = rd_idx;
            end
            `OPFMULD: begin
                wb = 1'b0;
                wb_float = 1'b1;
                wb_float_idx = rd_idx;
                wb_float_val = rd_float_val; 
            end
            `OPFDIVD: begin
                wb = 1'b0;
                wb_float = 1'b1;
                wb_float_idx = rd_idx;
                wb_float_val = rd_float_val; 
            end
            default: begin
                if (op_type == `OPFLD || op_type == `OPFMULD || op_type == `OPFDIVD) begin
                    wb = 1'b0;
                    wb_float = 1'b1;
                    wb_float_idx = rd_idx;
                    wb_float_val = rd_float_val;
                end
                else begin
                    wb = 1'b1;
                    wb_idx = rd_idx;
                    wb_val = rd_val;
                    wb_float = 1'b0;
                end
            end 
        endcase
        end
        else begin
            wb = 1'b0;
            wb_float = 1'b0;
        end
    end

endmodule
