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

module WB(clk, rst, start, rd_val, rd_float_val, rd_idx, op_type, rs1_val, csr_idx, float_rm, float_rm_val, fflags_accured_exceptions, imm, wb, wb_idx, wb_val, wb_float, wb_float_idx, wb_float_val);
    input clk;
    input rst;
    input start;

    input [31:0] rd_val;
    input [63:0] rd_float_val;
    input [4:0] rd_idx;
    input [5:0] op_type;
    input [4:0] rs1_val;
    input [31:0] imm;
    input [12:0] csr_idx;
    input [2:0] float_rm;
    input [2:0] float_rm_val;
    input [4:0] fflags_accured_exceptions;

    output reg wb;
    output reg[4:0] wb_idx;
    output reg[31:0] wb_val;
    output reg wb_float;
    output reg[4:0] wb_float_idx;
    output reg[63:0] wb_float_val;

    reg[31:0] csr[4095:0];
    reg[31:0] fflags;
    reg[2:0] rm;
    reg float_flag;
    reg [11:0] e;
    reg s;
    reg [53:0] m;
    integer i;

    always @(posedge clk) begin
        wb = 1'b0;
        wb_float = 1'b0;
        if (start) begin
            case (op_type)
            `OPECALL: begin
                csr[csr_idx] = rd_val;
            end
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
            `OPFMULD: begin
                if (fflags_accured_exceptions[4] == 1'b1 || fflags_accured_exceptions[3] == 1'b1) begin
                    fflags[4:3] = fflags_accured_exceptions[4:3];
                end
                else if (fflags_accured_exceptions[2] == 1'b1) begin
                    wb = 1'b0;
                    wb_float = 1'b1;
                    wb_float_idx = rd_idx;
                    if (rm == 3'b000 || rm == 3'b100) wb_float_val = {s, 11'b111_1111_1111, 52'b0};
                    else if (rm == 3'b010 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b111_1111_1111, 52'b0};
                    else if (rm == 3'b010 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1110, 52'hf_ffff_ffff_ffff};
                    else if (rm == 3'b011 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                    else if (rm == 3'b011 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1111, 52'b0};
                    else if (rm == 3'b001 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                    else if (rm == 3'b001 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1110, 52'hf_ffff_ffff_ffff};
                end
                else if (fflags_accured_exceptions[1] == 1'b1) begin
                     if (wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                     else if (wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                end
                else begin
                    if (float_rm == 3'b111) rm = fflags[7:5];
                    else rm = float_rm;
                    case(rm)
                        //RNE
                        3'b000: begin
                            if (float_rm_val == 3'b100) begin
                                float_flag =  rd_float_val[0];
                            end
                            else begin
                                float_flag = float_rm_val[2];
                            end
                        end
                        //RTZ
                        3'b001: begin
                            float_flag = 1'b0;
                        end
                        //RDN
                        3'b010: begin
                            if (rd_float_val[63] == 1'b1) float_flag = 1'b1;
                            else float_flag = 1'b0;
                        end
                        //RUP
                        3'b011: begin
                            if (rd_float_val[63] == 1'b0) float_flag = 1'b1;
                            else float_flag = 1'b0;
                        end
                        //RMM
                        3'b100: begin
                            if (float_rm_val == 3'b100) begin
                                
                            end
                            else begin
                                float_flag = float_rm_val[2];
                            end
                        end
                    endcase
                    wb = 1'b0;
                    wb_float = 1'b1;
                    wb_float_idx = rd_idx;
                    if (float_flag == 1'b1) begin
                        s = rd_float_val[63];
                        e[10:0] = rd_float_val[62:52];
                        m[51:0] = rd_float_val[51:0];
                        m[52] = 1'b1;
                        m = m + 1'b1;
                        if (m[53] == 1'b1) begin
                            e = e + 1;
                            if (e[11] == 1'b1) begin
                                fflags[2] = 1'b1;
                                if (rm == 3'b000 || rm == 3'b100) wb_float_val = {s, 11'b111_1111_1111, 52'b0};
                                else if (rm == 3'b010 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b111_1111_1111, 52'b0};
                                else if (rm == 3'b010 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1110, 52'hf_ffff_ffff_ffff};
                                else if (rm == 3'b011 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                                else if (rm == 3'b011 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1111, 52'b0};
                            end
                            else wb_float_val = {s, e[10:0], m[52:1]};
                        end
                        else begin
                            wb_float_val = {s, e[10:0], m[51:0]};
                        end 
                    end
                    else wb_float_val = rd_float_val; 
                end
            end
            `OPFDIVD: begin
                if (fflags_accured_exceptions[4] == 1'b1 || fflags_accured_exceptions[3] == 1'b1) begin
                    fflags[4:3] = fflags_accured_exceptions[4:3];
                end
                else if (fflags_accured_exceptions[2] == 1'b1) begin
                    wb = 1'b0;
                    wb_float = 1'b1;
                    wb_float_idx = rd_idx;
                    if (rm == 3'b000 || rm == 3'b100) wb_float_val = {s, 11'b111_1111_1111, 52'b0};
                    else if (rm == 3'b010 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b111_1111_1111, 52'b0};
                    else if (rm == 3'b010 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1110, 52'hf_ffff_ffff_ffff};
                    else if (rm == 3'b011 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                    else if (rm == 3'b011 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1111, 52'b0};
                    else if (rm == 3'b001 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                    else if (rm == 3'b001 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1110, 52'hf_ffff_ffff_ffff};
                end
                else if (fflags_accured_exceptions[1] == 1'b1) begin
                     if (wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                     else if (wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                end
                else begin
                    if (float_rm == 3'b111) rm = fflags[7:5];
                    else rm = float_rm;
                    case(rm)
                        //RNE
                        3'b000: begin
                            if (float_rm_val == 3'b100) begin
                                float_flag =  rd_float_val[0];
                            end
                            else begin
                                float_flag = float_rm_val[2];
                            end
                        end
                        //RTZ
                        3'b001: begin
                            float_flag = 1'b0;
                        end
                        //RDN
                        3'b010: begin
                            if (rd_float_val[63] == 1'b1) float_flag = 1'b1;
                            else float_flag = 1'b0;
                        end
                        //RUP
                        3'b011: begin
                            if (rd_float_val[63] == 1'b0) float_flag = 1'b1;
                            else float_flag = 1'b0;
                        end
                        //RMM
                        3'b100: begin
                            if (float_rm_val == 3'b100) begin
                                
                            end
                            else begin
                                float_flag = float_rm_val[2];
                            end
                        end
                    endcase
                    wb = 1'b0;
                    wb_float = 1'b1;
                    wb_float_idx = rd_idx;
                    if (float_flag == 1'b1) begin
                        s = rd_float_val[63];
                        e[10:0] = rd_float_val[62:52];
                        m[51:0] = rd_float_val[51:0];
                        m[52] = 1'b1;
                        m = m + 1'b1;
                        if (m[53] == 1'b1) begin
                            e = e + 1;
                            if (e[11] == 1'b1) begin
                                fflags[2] = 1'b1;
                                if (rm == 3'b000 || rm == 3'b100) wb_float_val = {s, 11'b111_1111_1111, 52'b0};
                                else if (rm == 3'b010 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b111_1111_1111, 52'b0};
                                else if (rm == 3'b010 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1110, 52'hf_ffff_ffff_ffff};
                                else if (rm == 3'b011 && wb_float_val[63] == 1'b1) wb_float_val = {1'b1, 11'b000_0000_0000, 52'b0_0000_0000_0001};
                                else if (rm == 3'b011 && wb_float_val[63] == 1'b0) wb_float_val = {1'b0, 11'b111_1111_1111, 52'b0};
                            end
                            else wb_float_val = {s, e[10:0], m[52:1]};
                        end
                        else begin
                            wb_float_val = {s, e[10:0], m[51:0]};
                        end 
                    end
                    else wb_float_val = rd_float_val; 
                end
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
    end

endmodule
