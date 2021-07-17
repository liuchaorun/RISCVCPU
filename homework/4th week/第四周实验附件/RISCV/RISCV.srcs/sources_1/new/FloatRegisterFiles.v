`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/03 21:10:41
// Design Name: 
// Module Name: FloatRegisterFiles
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


module FloatRegisterFiles(
    input clk,
    input rst,

    input   [4:0]   rs1_idx,
    input   [4:0]   rs2_idx,
    output  [63:0]  rs1_val,
    output  [63:0]  rs2_val,

    input           wb,
    input   [4:0]   wb_idx,
    input   [63:0]  wb_val
    );
    
    
    reg     [63:0]  registers   [31:0];

    reg[63:0] rs1_v;
    reg[63:0] rs2_v;
    
    always @(negedge clk) begin
        rs1_v = registers[rs1_idx];
        rs2_v = registers[rs2_idx];
    end

    assign rs1_val = rs1_v;
    assign rs2_val = rs2_v;
    
    // write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
                registers[0]    <= 64'h3FF8000000000000; //1.5
                registers[1]    <= 64'h3FFCCCCCCCCCCCCD; //1.8
                registers[2]    <= 64'h0000_0000_0000_0000;
                registers[3]    <= 64'h0000_0000_0000_0000;
                registers[4]    <= 64'h0000_0000_0000_0000;
                registers[5]    <= 64'h0000_0000_0000_0000;
                registers[6]    <= 64'h0000_0000_0000_0000;
                registers[7]    <= 64'h0000_0000_0000_0000;
                registers[8]    <= 64'h0000_0000_0000_0000;
                registers[9]    <= 64'h0000_0000_0000_0000;
                registers[10]   <= 64'h0000_0000_0000_0000;
                registers[11]   <= 64'h0000_0000_0000_0000;
                registers[12]   <= 64'h0000_0000_0000_0000;
                registers[13]   <= 64'h0000_0000_0000_0000;
                registers[14]   <= 64'h0000_0000_0000_0000;
                registers[15]   <= 64'h0000_0000_0000_0000;
                registers[16]   <= 64'h0000_0000_0000_0000;
                registers[17]   <= 64'h0000_0000_0000_0000;
                registers[18]   <= 64'h0000_0000_0000_0000;
                registers[19]   <= 64'h0000_0000_0000_0000;
                registers[20]   <= 64'h0000_0000_0000_0000;
                registers[21]   <= 64'h0000_0000_0000_0000;
                registers[22]   <= 64'h0000_0000_0000_0000;
                registers[23]   <= 64'h0000_0000_0000_0000;
                registers[24]   <= 64'h0000_0000_0000_0000;
                registers[25]   <= 64'h0000_0000_0000_0000;
                registers[26]   <= 64'h0000_0000_0000_0000;
                registers[27]   <= 64'h0000_0000_0000_0000;
                registers[28]   <= 64'h0000_0000_0000_0000;
                registers[29]   <= 64'h0000_0000_0000_0000;
                registers[30]   <= 64'h0000_0000_0000_0000;
                registers[31]   <= 64'h0000_0000_0000_0000;
            end
        else if (wb)
                registers[wb_idx] <= wb_val;
    end
endmodule
