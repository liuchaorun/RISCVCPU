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

        output                  [31:0]      rd_val,
        output                  [4:0]       rd_idx_out,
        output                  [3:0]       op_type_out,
        output                  [31:0]      rs1_val_out,
        output                  [31:0]      imm_out,
        output                  [11:0]      csr_idx_out,
    );

    assign rd_idx_out[4:0] = rd_idx[4:0];
    assign op_type_out[4:0] = op_type[4:0];
    assign rs1_val_out[31:0] = rs1_val[31:0];
    assign imm_out[31:0] = imm[31:0];
    assign csr_idx_out[11:0] = crs_idx[11:0];

    wire    store_ena;
    wire    load_ena;

    assign store_ena = (op_type == (`OPSB || `OPSH || `OPSW)) ? 1'b1 : 1'b0;
    assign load_ena = (op_type == (`OPLB || `OPLH || `OPLBU || `OPLHU || `OPLW)) ? 1'b1 : 1'b0;

    // 64KB data RAM, load or store data
    dataRAM dataMem(
        .clka(clk),             // input wire clka
        .wea(store_ena),        // input wire [0:0] wea
        .addra(ex_output),      // input wire [13:0] addra
        .dina(write_data),      // input wire [31:0] dina
        .douta(read_data)       // output wire [31:0] douta
    ); 

    assign rd_val[]

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_val_out[31:0] <= 32'd0;
        end
        else if(start) begin
            // Loads
            if(store_ena) begin
            
            end
            else if(load_ena) begin
                
            end
            else begin
                rd_val[31:0] <= ex_output[31:0];
            end
        end
        else begin

        end
    end

endmodule
