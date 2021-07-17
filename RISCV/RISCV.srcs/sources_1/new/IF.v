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
    
    input                   [31:0]          PC,
    input                                   PC_sel,        // choose PC_plus4 or PC_branch
    input                   [31:0]          PC_jmp,
    input                                   data_conflict,
    input                                   flush,

    output      reg         [31:0]          next_PC,
    output                  [31:0]          instruction,
    
    output      reg                         next_ena
    );
    
   
    // 64KB program ROM, fetch instruction
    prgROM instMem(
        .clka(clk),             // input wire clka
        .ena(start),
        .addra(PC[19:2]),       // input wire [17:0] addra
        .douta(instruction)     // output wire [31:0] douta
    );
    
    initial begin
        next_PC[31:0] <= 32'd0;
        next_ena <= 1'b0;
    end
    
    // next PC
    always @(posedge clk or posedge rst) begin
        if(rst)
            next_PC[31:0] <= 32'h0001008c;
//            next_PC[31:0] <= 32'h00000000;
        else begin
            if(start & ~data_conflict)
                next_PC[31:0] = PC_sel ? PC_jmp[31:0] : (PC[31:0] + 3'b100);
            else if (PC_sel) 
                next_PC[31:0] = PC_jmp[31:0];
            else if (flush) 
                next_PC[31:0] = PC[31:0] - 3'b100;
            else
                next_PC[31:0] <= PC[31:0];      // remain
        end
    end
    
    // ID enable
    always @(posedge clk or posedge rst) begin
        if(rst)
            next_ena <= 1'b0;
        else if(start & ~PC_sel & ~data_conflict)
            next_ena <= 1'b1;
        else
            next_ena <= 1'b0;
    end

endmodule
