`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 13:33:45
// Design Name: 
// Module Name: RegisterFiles
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


module RegisterFiles(clk, rst, rs1_idx, rs2_idx, rs1_val, rs2_val, wb, wb_idx, wb_val);
    input clk;
    input rst;

    // read registers
    input   [4:0]   rs1_idx;
    input   [4:0]   rs2_idx;
    output  [31:0]  rs1_val;
    output  [31:0]  rs2_val;
    
    // write back
    input           wb;
    input   [4:0]   wb_idx;
    input   [31:0]  wb_val;
    
    
    reg     [31:0]  registers   [31:0];

    reg[31:0] rs1_v;
    reg[31:0] rs2_v;
    
    always @(negedge clk) begin
        rs1_v = registers[rs1_idx];
        rs2_v = registers[rs2_idx];
    end

    assign rs1_val = rs1_v;
    assign rs2_val = rs2_v;
    
    // write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
                registers[0]    <= 32'h0000_0000;
                registers[1]    <= 32'h0000_0000;
                registers[2]    <= 32'h0000_0000;
                registers[3]    <= 32'h0000_0000;
                registers[4]    <= 32'h0000_0000;
                registers[5]    <= 32'h0000_0000;
                registers[6]    <= 32'h0000_0000;
                registers[7]    <= 32'h0000_0000;
                registers[8]    <= 32'h0000_0000;
                registers[9]    <= 32'h0000_0000;
                registers[10]   <= 32'h0000_0000;
                registers[11]   <= 32'h0000_0000;
                registers[12]   <= 32'h0000_0000;
                registers[13]   <= 32'h0000_0000;
                registers[14]   <= 32'h0000_0000;
                registers[15]   <= 32'h0000_0000;
                registers[16]   <= 32'h0000_0000;
                registers[17]   <= 32'h0000_0000;
                registers[18]   <= 32'h0000_0000;
                registers[19]   <= 32'h0000_0000;
                registers[20]   <= 32'h0000_0000;
                registers[21]   <= 32'h0000_0000;
                registers[22]   <= 32'h0000_0000;
                registers[23]   <= 32'h0000_0000;
                registers[24]   <= 32'h0000_0000;
                registers[25]   <= 32'h0000_0000;
                registers[26]   <= 32'h0000_0000;
                registers[27]   <= 32'h0000_0000;
                registers[28]   <= 32'h0000_0000;
                registers[29]   <= 32'h0000_0000;
                registers[30]   <= 32'h0000_0000;
                registers[31]   <= 32'h0000_0000;
            end
        else if (wb)
                registers[wb_idx] <= wb_val;
    end


endmodule
