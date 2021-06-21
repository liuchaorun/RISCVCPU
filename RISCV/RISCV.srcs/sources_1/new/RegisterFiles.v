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


module RegisterFiles(clk, rst, rs1, rs2, rd, wb, rd_v, rs1_v, rs2_v);
    input clk;
    input rst;
    input[4:0] rs1;
    input[4:0] rs2;
    input[4:0] rd;
    input wb;
    input[31:0] rd_v;
    output reg[31:0] rs1_v;
    output reg[31:0] rs2_v;
    integer i;

    reg[31:0] registers[31:0]; //32¸ö¼Ä´æÆ÷

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i = 0; i < 32; i=i+1) begin
                registers[i] <= 32'h0000;
            end
        end
        else begin
            if (wb) begin
                registers[rd] <= rd_v;
                // case(rd)
                //     5'd0: registers[0] <= rd_v;
                //     5'd1: registers[1] <= rd_v;
                //     5'd2: registers[2] <= rd_v;
                //     5'd3: registers[3] <= rd_v;
                //     5'd4: registers[4] <= rd_v;
                //     5'd5: registers[5] <= rd_v;
                //     5'd6: registers[6] <= rd_v;
                //     5'd7: registers[7] <= rd_v;
                //     5'd8: registers[8] <= rd_v;
                //     5'd9: registers[9] <= rd_v;
                //     5'd10: registers[10] <= rd_v;
                //     5'd11: registers[11] <= rd_v;
                //     5'd12: registers[12] <= rd_v;
                //     5'd13: registers[13] <= rd_v;
                //     5'd14: registers[14] <= rd_v;
                //     5'd15: registers[15] <= rd_v;
                //     5'd16: registers[16] <= rd_v;
                //     5'd17: registers[17] <= rd_v;
                //     5'd18: registers[18] <= rd_v;
                //     5'd19: registers[19] <= rd_v;
                //     5'd20: registers[20] <= rd_v;
                //     5'd21: registers[21] <= rd_v;
                //     5'd22: registers[22] <= rd_v;
                //     5'd23: registers[23] <= rd_v;
                //     5'd24: registers[24] <= rd_v;
                //     5'd25: registers[25] <= rd_v;
                //     5'd26: registers[26] <= rd_v;
                //     5'd27: registers[27] <= rd_v;
                //     5'd28: registers[28] <= rd_v;
                //     5'd29: registers[29] <= rd_v;
                //     5'd30: registers[30] <= rd_v;
                //     default: registers[31] <= rd_v;
                // endcase
            end
        end    
    end

    always @(posedge clk) begin
        rs1_v <= registers[rs1];
        rs2_v <= registers[rs2];
    end
endmodule
