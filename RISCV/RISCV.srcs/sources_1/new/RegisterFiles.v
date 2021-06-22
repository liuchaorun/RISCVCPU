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


module RegisterFiles(clk, rst, IR, rd, wb, rd_v, rs1_v, rs2_v);
    input clk;
    input rst;
    input wire[31:0] IR;
    input wire[4:0] rd;
    input wb;
    input wire[31:0] rd_v;
    output wire[31:0] rs1_v;
    output wire[31:0] rs2_v;
    integer i;

    reg[31:0] registers[31:0];

    initial begin
        for(i = 0; i < 32; i=i+1) begin
            registers[i] <= 32'h00000000;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i = 0; i < 32; i=i+1) begin
                registers[i] <= 32'h00000000;
            end
        end
        else begin
            if (wb) begin
                registers[rd] <= rd_v;
            end
        end    
    end

    // always @(posedge clk) begin
    //     rs1_v <= registers[IR[19:15]];
    //     rs2_v <= registers[IR[24:20]];
    // end

    assign rs1_v = registers[IR[19:15]];
    assign rs2_v = registers[IR[24:20]];

endmodule
