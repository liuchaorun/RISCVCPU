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
        input                   [4:0]       rd_idx,
        input                   [3:0]       op_type,
        input                   [31:0]      rs1_val,
        input                   [31:0]      rs2_val,
        input                   [31:0]      imm,
        input                   [11:0]      csr_idx,
        input                               alu_w_rd,

        output      reg         [31:0]      rd_val,
        output      reg         [4:0]       rd_idx_out,
        output      reg         [3:0]       op_type_out,
        output      reg         [31:0]      rs1_val_out,
        output      reg         [31:0]      imm_out,
        output      reg         [11:0]      csr_idx_out,
        output      reg                     wb_ena
    );

    initial begin
        wb_ena <= 1'b0;
    end
    
    reg [3:0] mask;
    wire [31:0] r_data;
    
    assign r_data[31:0] = 32'b0;

    wire    store_ena;
    wire    load_ena;

    assign store_ena = (op_type == (`OPSB || `OPSH || `OPSW)) ? 1'b1 : 1'b0;
    assign load_ena = (op_type == (`OPLB || `OPLH || `OPLBU || `OPLHU || `OPLW)) ? 1'b1 : 1'b0;

    RAM ram(
        .clk(clk),
        .rst(rst),
        .r_addr(ex_output),
        .w_addr(ex_output),
        .w_data(rs2_val),
        .wen(store_ena),
        .mask(mask),
        .data(r_data)
    );
    $readmemh("C:\\Users\\pqc\\Desktop\\rv32imf\\rv32imf.srcs\\sources_1\\new\\data_ram.hex", ram);

    always @(posedge clk or posedge rst) begin
        rd_idx_out[4:0] = rd_idx[4:0];
        op_type_out[4:0] = op_type[4:0];
        rs1_val_out[31:0] = rs1_val[31:0];
        imm_out[31:0] = imm[31:0];
        csr_idx_out[11:0] = csr_idx[11:0];
        if (alu_w_rd) wb_ena <= 1'b1;
        else wb_ena <= 1'b0; 
        if(rst) begin
            rd_val[31:0] <= 32'd0;
            wb_ena = 1'b0;
        end
        else if(start) begin
            // Loads
            if(store_ena) begin
                wb_ena = 1'b0;
                case (op_type)
                    `OPSB: mask = 4'b0001;
                    `OPSH: mask = 4'b0011;
                    `OPSW: mask = 4'b1111;
                    default: ;
                endcase
            end
            else if(load_ena) begin
                wb_ena = 1'b1;
                case (op_type)
                    `OPLB: begin
                        if (r_data[7]) rd_val = {24'b1111_1111_1111_1111_1111_1111, r_data[7:0]};
                        else rd_val = {24'b0, r_data[7:0]};
                    end
                    `OPLBU: begin
                        rd_val = {24'b0, r_data[7:0]};
                    end
                    `OPLH: begin
                        if (r_data[15]) rd_val = {24'b1111_1111_1111_1111, r_data[15:0]};
                        else rd_val = {24'b0, r_data[15:0]};
                    end
                    `OPLHU: begin
                        rd_val = {16'b0, r_data[15:0]};
                    end
                    default: begin
                        rd_val = r_data;
                    end
                endcase
            end
            else begin
                rd_val[31:0] <= ex_output[31:0];
            end
        end
        else begin

        end
    end

endmodule
