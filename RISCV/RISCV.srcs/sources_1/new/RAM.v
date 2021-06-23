`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/22 09:37:02
// Design Name: 
// Module Name: RAM
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


module RAM(
    input clk,
    input rst,
    input[31:0] r_addr,
    input[31:0] w_addr,
    input[31:0] w_data,
    input wen,
    input [3:0] mask,
    output [31:0] data
    );

    reg[7:0] ram[65534:0];
    integer i;

    initial begin
        for (i = 0; i < 65535; i = i + 1) ram[i] = 32'b0;
        ram[0] = 8'b00000110; 
        ram[1] = 8'b0;
        ram[2] = 8'b0;
        ram[3] = 8'b0;
    end

    assign data = {ram[{r_addr[15:2], 2'b11}], ram[{r_addr[15:2], 2'b10}], ram[{r_addr[15:2], 2'b01}], ram[{r_addr[15:2], 2'b00}]};

    always @(posedge clk) begin
        if (wen) begin
            if (mask[0]) ram[{r_addr[15:2], 2'b00}] <= w_data[7:0];
            if (mask[1]) ram[{r_addr[15:2], 2'b01}] <= w_data[15:8];
            if (mask[2]) ram[{r_addr[15:2], 2'b10}] <= w_data[23:16];
            if (mask[3]) ram[{r_addr[15:2], 2'b11}] <= w_data[31:24];
        end
    end


endmodule
