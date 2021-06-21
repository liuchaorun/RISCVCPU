`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/20 22:32:10
// Design Name: 
// Module Name: IFID_sim
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


module IFID_sim(

    );
    
    // IF signal
    // input
    reg                 clk = 1'b0;
    reg                 rst = 1'b0;
    reg     [31:0]      PC = 32'd0;
    
    // output
    wire                 PC_jmp;
    wire     [31:0]      PC_branch;      // the 3rd instruction
    
    wire     [31:0]      PC_plus4;
    wire     [31:0]      next_PC;
    wire     [31:0]      instruction;
    
    wire     [159:0]    decodeInstructionInfo;
    wire                stall;
    
    IF if_unit(
        .clk(clk),
        .rst(rst),
        .PC(PC),
        .PC_jmp(PC_jmp),
        .PC_branch(PC_branch),
        .PC_plus4(PC_plus4),
        .next_PC(next_PC),
        .instruction(instruction)
    );
    
    // ID signal
    
    ID id_unit(
    .NPC(next_PC),
    .IR(instruction),
    .clk(clk),
    .rst(rst),
    .wbRd(5'd0),
    .wbV(32'd0),
    .wb(1'b0),
    .decodeInstructionInfo(decodeInstructionInfo),
    .stall(stall),
    .newPC(PC_branch),
    .pcSel(PC_jump)
    );


    initial begin
        #100   rst = 1'b0;
        $monitor("at time %t,",$time, "d=%d", decodeInstructionInfo);
    end
    always #50 clk = ~clk;
    
endmodule
