`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/21 09:07:26
// Design Name: 
// Module Name: MEM
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


module MEM(
        input                               clk,
        input                               rst,
        input                               start,

        input                   [31:0]      ex_output,
        input                   [63:0]      ex_float_output,
        input                   [4:0]       rd_idx,
        input                   [5:0]       op_type,
        input                   [31:0]      rs1_val,
        input                   [63:0]      rs1_float_val,
        input                   [31:0]      rs2_val,
        input                   [63:0]      rs2_float_val,
        input                   [31:0]      imm,
        input                   [31:0]      PC,
        input                   [11:0]      csr_idx,
        input                   [7:0]       mask,
        input                               store_ena,

        output      reg         [31:0]      rd_val,
        output      reg         [63:0]      rd_float_val,
        output      reg         [4:0]       rd_idx_out,
        output      reg         [5:0]       op_type_out,
        output      reg         [31:0]      rs1_val_out,
        output      reg         [31:0]      imm_out,
        output      reg         [11:0]      csr_idx_out,
        output      reg                     next_ena
    );
    
    wire [63:0] read_data;

    RAM ram(
        .clk(clk),
        .rst(rst),
        .r_addr(ex_output),
        .w_addr(ex_output),
        .w_data(rs2_val),
        .w_float_data(rs2_float_val),
        .wen(store_ena),
        .mask(mask),
        .data(read_data)
    );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_val[31:0] <= 32'd0;
            next_ena = 1'b0;
        end
        else if(start) begin
            next_ena = 1'b0;
            rd_idx_out = rd_idx;
            op_type_out = op_type;
            rs1_val_out = rs1_val;
            rd_float_val = ex_float_output;
            imm_out = imm;
            csr_idx_out = csr_idx;
            // store
            if(op_type == `OPSB || op_type == `OPSH || op_type == `OPSW || op_type == `OPFSD) begin
                rd_val[31:0] <= 32'd0;
                next_ena = 1'b0;
            end
            // Loads
            else if(op_type == `OPLB || op_type == `OPLH || op_type == `OPLBU || op_type == `OPLHU || op_type == `OPLW || op_type == `OPFLD) begin
                next_ena = 1'b1;
                case (op_type)
                    `OPLB: begin
                        rd_val = {{24{read_data[7]}}, read_data[7:0]};
                    end
                    `OPLBU: begin
                        rd_val = {24'b0, read_data[7:0]};
                    end
                    `OPLH: begin
                        rd_val = {{16{read_data[15]}}, read_data[15:0]};
                    end
                    `OPLHU: begin
                        rd_val = {16'b0, read_data[15:0]};
                    end
                    `OPFLD: begin
                        rd_float_val = read_data[63:0];
                    end
                    default: begin
                        rd_val = read_data[31:0];
                    end
                endcase
            end
            else if(op_type == `OPJAL || op_type == `OPJALR) begin
                next_ena <= 1'b1;
                rd_val <= PC + 3'b100;
            end
            else if(op_type == `OPBEQ || op_type == `OPBNE || op_type == `OPBLT || op_type == `OPBLTU || op_type == `OPBGE || op_type == `OPBGEU) begin
                next_ena <= 1'b0;
            end
            else if(op_type == `OPNO) 
                next_ena = 1'b0;
            else begin
                next_ena <= 1'b1;
                rd_val[31:0] <= ex_output[31:0];
            end
        end
        else begin
            next_ena <= 1'b0;
            rd_val <= rd_val;
        end
    end

endmodule
