`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/20 20:03:33
// Design Name: 
// Module Name: IF
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


module IF(
    input                                   clk,
    input                                   rst,
    input                                   start,
    input                                   stall,
    input                                   PC_jmp,        // choose PCPlus4 or nextPC
    input                   [31:0]          PC_branch,
    input                                   flush,
    input                                   br_flush,
    output      reg         [31:0]          PC_plus4,
    output      reg         [31:0]          next_PC,
    output                  [31:0]          instruction,
    output      reg                         id_ena
    );
    
    initial begin
        PC_plus4[31:0] = 32'b0;
        next_PC = 32'b0;
    end
   
    // 64KB program ROM, fetch instruction
    prgROM instMem(
        .clka(clk),             // input wire clka
        .ena(start),
        .addra(PC_plus4[15:2]),       // input wire [13:0] addra
        .douta(instruction)     // output wire [31:0] douta
    ); 

    // PC + 4
    always @(posedge clk or posedge rst) begin
        if(rst)
            PC_plus4[31:0] <= 32'd0;
        else if(start && ~stall && ~flush && ~br_flush)
            PC_plus4[31:0] <= PC_plus4[31:0] + 3'b100;
        else if(flush) begin
            PC_plus4[31:0] <= PC_plus4[31:0] - 4'b1000;
            next_PC[31:0] <= next_PC[31:0] - 4'b1000;
        end
        else if(br_flush) begin
            PC_plus4[31:0] <= PC_branch + 3'b100;
            next_PC[31:0] <= PC_branch;
        end
        else
            PC_plus4[31:0] <= PC_plus4[31:0];
    end 
    
    // next PC
    always @(posedge clk or posedge rst) begin
        if(rst)
            next_PC[31:0] <= 32'd0;
        else if(start && ~stall && ~flush && ~br_flush)
            next_PC[31:0] <= PC_plus4;
        else if (~flush && ~br_flush)
            next_PC[31:0] <= PC_plus4[31:0];
    end
    
    // ID enable
    always @(posedge clk or posedge rst) begin
        if(rst)
            id_ena <= 1'b0;
        else if(start && ~stall && ~br_flush)
            id_ena <= 1'b1;
        else
            id_ena <= 1'b0;
    end

endmodule
