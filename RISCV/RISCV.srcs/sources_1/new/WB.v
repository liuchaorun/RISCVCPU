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

module WB(clk, rst, start, rd_val, rd_idx, op_type, rs1_val, csr_idx, imm, wb_ena, wb, wbRd, wbV);
    input clk;
    input rst;
    input start;
    input [31:0] rd_val;
    input [4:0] rd_idx;
    input [3:0] op_type;
    input [4:0] rs1_val;
    input [31:0] imm;
    input [12:0] csr_idx;
    input wb_ena;
    output reg wb;
    output reg[4:0] wbRd;
    output reg[31:0] wbV;

    reg[31:0] csr[4095:0];
    integer i;

    initial begin
        wb = 1'b0;
        wbRd = 5'b0;
//        wbV = 32'b0;
        for (i = 0; i < 4096; i = i+1) csr[i] = 32'b0;
    end

    always @(posedge clk) begin
        if (start) begin
            case (op_type)
            `OPCSRRW: begin
                wb = 1'b1;
                wbV = csr[csr_idx];
                wbRd = rd_idx;
                csr[csr_idx] = rs1_val;
            end 
            `OPCSRRWI: begin
                wb = 1'b1;
                wbV = csr[csr_idx];
                wbRd = rd_idx;
                csr[csr_idx] = imm;
            end
            `OPCSRRS: begin
                wb = 1'b1;
                wbV = csr[csr_idx];
                wbRd = rd_idx;
                csr[csr_idx] = rs1_val | csr[csr_idx];
            end
            `OPCSRRSI: begin
                wb = 1'b1;
                wbV = csr[csr_idx];
                wbRd = rd_idx;
                csr[csr_idx] = imm | csr[csr_idx];
            end
            `OPCSRRC: begin
                wb = 1'b1;
                wbV = csr[csr_idx];
                wbRd = rd_idx;
                csr[csr_idx] = ~rs1_val & csr[csr_idx];
            end
            `OPCSRRCI: begin
                wb = 1'b1;
                wbV = csr[csr_idx];
                wbRd = rd_idx;
                csr[csr_idx] = ~imm & csr[csr_idx];
            end
            `OPWRD: begin
                wb = 1'b1;
                wbRd = rd_idx;
                wbV = rd_val;
            end
            `OPLB: begin
                wb = 1'b1;
                wbRd = rd_idx;
                wbV = rd_val;
            end
            `OPLBU: begin
                wb = 1'b1;
                wbRd = rd_idx;
                wbV = rd_val;
            end
            `OPLH: begin
                wb = 1'b1;
                wbRd = rd_idx;
                wbV = rd_val;
            end
            `OPLHU: begin
                wb = 1'b1;
                wbRd = rd_idx;
                wbV = rd_val;
            end
            `OPLW: begin
                wb = 1'b1;
                wbRd = rd_idx;
                wbV = rd_val;
            end
            default: begin
                if (wb_ena) begin
                    wb = 1'b1;
                    wbRd = rd_idx;
                    wbV = rd_val;
                end
                else begin
                    wb = 1'b0;
                    wbRd = 5'b0;
                    wbV = 32'b0;
                end
            end 
        endcase
        end
    end

endmodule
