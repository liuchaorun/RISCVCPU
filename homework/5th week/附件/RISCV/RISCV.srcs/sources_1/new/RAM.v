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
    input[31:0] w_float_data,
    input wen,
    input [7:0] mask,
    output [63:0] data
    );

    reg[7:0] ram[327674:0];
    integer i;

    initial begin
        for (i = 0; i < 327675; i = i + 1) ram[i] = 8'b0;
        $readmemh("C:\\Users\\chaorunliu\\Desktop\\files\\RISCVCPU\\RISCV\\RISCV.srcs\\sources_1\\f.txt", ram);
        $display("r_addr = %h, data = %h",32'h00010074, ram[32'h00010074]);
    end

    assign data = {ram[r_addr[31:0]+7], ram[r_addr[31:0]+6], ram[r_addr[31:0]+4], ram[r_addr[31:0]+4],ram[r_addr[31:0]+3], ram[r_addr[31:0]+2], ram[r_addr[31:0]+1], ram[r_addr[31:0]]};

    always @(posedge clk) begin
        if (wen) begin
            if (mask[4] == 1'b0) begin
                if (mask[0]) ram[w_addr[31:0]] <= w_data[7:0];
                if (mask[1]) ram[w_addr[31:0]+1] <= w_data[15:8];
                if (mask[2]) ram[w_addr[31:0]+2] <= w_data[23:16];
                if (mask[3]) ram[w_addr[31:0]+3] <= w_data[31:24];
            end
            else begin
                if (mask[0]) ram[w_addr[31:0]] <= w_float_data[7:0];
                if (mask[1]) ram[w_addr[31:0]+1] <= w_float_data[15:8];
                if (mask[2]) ram[w_addr[31:0]+2] <= w_float_data[23:16];
                if (mask[3]) ram[w_addr[31:0]+3] <= w_float_data[31:24];
                if (mask[4]) ram[w_addr[31:0]+4] <= w_float_data[39:32];
                if (mask[5]) ram[w_addr[31:0]+5] <= w_float_data[47:40];
                if (mask[6]) ram[w_addr[31:0]+6] <= w_float_data[55:48];
                if (mask[7]) ram[w_addr[31:0]+7] <= w_float_data[63:56];
            end
            $display("w_addr = %h, data = %h",w_addr, w_data);
        end
    end


endmodule
