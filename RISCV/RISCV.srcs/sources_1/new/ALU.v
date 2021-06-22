`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/21 09:53:16
// Design Name: 
// Module Name: ALU
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


module ALU(
    input      [31:0]  operand1,
    input      [31:0]  operand2,
    input      [1:0]   type,
    input      [2:0]   OP,
    output reg [31:0]  result);

    wire[4:0]shamt;

    assign shamt = operand2[4:0];

    always@(*)
    begin
        case(type)
            2'b00://shifts
                case(OP)
                   3'b000: //SLL
                   result <= operand1 << shamt; 
                   3'b001: //SLLI
                   result <= operand1 << shamt; 
                   3'b010: //SRL
                   result <= operand1 >> shamt;
                   3'b011: //SRLI
                   result <= operand1 >> shamt;
                   3'b100: //SRA
                   result <= {31{operand1[31]},operand1} >> shamt;
                   3'b101: //SRAI
                   result <= {31{operand1[31]},operand1} >> shamt;
                endcase                 
            2'b01://arithmatic
                case(OP)
                   3'b000://ADD
                   result <= operand1 + operand2; 
                   3'b001://ADDI
                   result <= operand1 + operand2; 
                   3'b010://SUB
                   result <= operand1 - operand2; 
                   3'b011://LUI
                   result <= operand1 + operand2; 
                   3'b100://AUIPC
                   result <= operand1 + operand2; 
                endcase    
            2'b10://logical
                case(OP)
                   3'b000://XOR
                   result = operand1 ^ operand2; 
                   3'b001://XORI
                   result = operand1 ^ operand2;
                   3'b010://OR
                   result = operand1 | operand2;
                   3'b011://ORI
                   result = operand1 | operand2;
                   3'b100://AND
                   result = operand1 & operand2;
                   3'b101://ANDI
                   result = operand1 & operand2;
                endcase  
            2'b11://compare
                case(OP)
                   3'b000://SLT
                   if(operand1[31] > operand2[31]) 
                        result <= 32'd1;
				   else 
                       if(operand1[31] == operand2[31])
                        begin
					       if(operand1[31] < operand2) result <= 32'd1;
					       else result <= 32'd0;
				        end 
                        else result <= 32'd0;
                   3'b001://SLTI
                   if(operand1[31] > operand2[31]) 
                        result <= 32'd1;
				    else 
                       if(operand1[31] == operand2[31])
                       begin
					       if(operand1[31] < operand2) result <= 32'd1;
					       else result <= 32'd0;
				        end 
                        else result <= 32'd0;
                   3'b010://SLTU
                   if(operand1 < operand2) 
                        result <= 32'd1;
				    else 
                        result <= 32'd0;
                   3'b011://SLTIU
                   if(operand1 < operand2)
                        result <= 32'd1;
				    else 
                        result <= 32'd0;
                endcase
            default:result <= 32'd0
        endcase
    end
endmodule
