`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/20 21:48:00
// Design Name: 
// Module Name: IF_sim
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


module IF_sim(

    );
    
    // input
    reg                 clk = 1'b0;
    reg                 rst = 1'b0;
    reg     [31:0]      PC = 32'd4;
    reg                 PC_jmp = 1'b0;
    reg     [31:0]      PC_branch = 32'd8;      // the 3rd instruction
    
    // output
    wire     [31:0]      PC_plus4;
    wire     [31:0]      next_PC;
    wire     [31:0]      instruction;
    
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

    initial begin
        #100   rst = 1'b0;  
        #100   PC_jmp = 1'b1;        
    end
    always #50 clk = ~clk;
    
endmodule
