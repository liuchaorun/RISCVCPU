`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/21 08:51:52
// Design Name: 
// Module Name: EX
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

`include "opType.vh"

module EX(
        input                   clk,
        input                   rst,
        input                   start,

        input                   [31:0]      rs1_val,
        input                   [63:0]      rs1_float_val,
        input                   [31:0]      PC,
        input                               operand1_sel,

        input                   [31:0]      rs2_val,
        input                   [63:0]      rs2_float_val,
        input                   [31:0]      imm,
        input                               operand2_sel,

        input                   [4:0]       rd_idx,
        input                   [5:0]       op_type,
        input                   [3:0]       alu_type,
        input                   [2:0]       float_rm,
        
        input                   [11:0]      csr_idx,
  
        output      reg         [31:0]      rs1_val_out,        // just forward
        output      reg         [63:0]      float_rs1_val_out,
        output      reg         [31:0]      PC_out,
        output      reg         [31:0]      rs2_val_out,
        output      reg         [63:0]      float_rs2_val_out,
        output      reg         [31:0]      imm_out,
        output      reg         [4:0]       rd_idx_out,
        output      reg         [5:0]       op_type_out,
        output      reg         [11:0]      csr_idx_out,

        output      reg         [31:0]      ex_output,           // address or rd_val
        output      reg         [63:0]      ex_float_output,
        output      reg         [2:0]       float_rm_out,
        output      reg         [2:0]       float_rm_val,
        output      reg         [4:0]       fflags_accured_exceptions,
        output      reg         [31:0]      new_pc,
        output      reg                     pc_sel,
        output      reg         [7:0]       mask,
        output      reg                     next_ena,
        output      reg                     store_ena
    );

    wire [31:0] operand1;
    wire [31:0] operand2;
    assign operand1 = operand1_sel ? PC : rs1_val;
    assign operand2 = operand2_sel ? imm : rs2_val;
    reg compare;
    reg [63:0] rs1_val_64 = 64'b0;
    reg [63:0] rs2_val_64 = 64'b0;
    
    //float
    reg s1;
    reg s2;
    reg [10:0] e1;
    reg [10:0] e2;
    reg [52:0] m1;
    reg [52:0] m2;
    reg [11:0] e_result;
    reg [105:0] m_result;
    
    initial begin
        new_pc = 32'b0;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ex_output[31:0]     <= 32'b0;      // address or rd_val
            pc_sel              <= 1'b0;
            mask                <= 8'b0;
            next_ena            <= 1'b0;
            compare             <= 1'b0;
            store_ena            = 1'b0;
            fflags_accured_exceptions = 5'b0;
        end
        else if(start & ~pc_sel) begin
            // just forward
            PC_out[31:0]        = PC[31:0];     
            rs1_val_out[31:0]   <= rs1_val[31:0];       
            rs2_val_out[31:0]   <= rs2_val[31:0];
            imm_out[31:0]       <= imm[31:0];
            rd_idx_out[4:0]     <= rd_idx[4:0];
            op_type_out[5:0]    <= op_type[5:0];
            csr_idx_out[11:0]   <= csr_idx[11:0];
            next_ena            <= 1'b1;
            compare             <= 1'b0;
            store_ena            = 1'b0;
            fflags_accured_exceptions = 5'b0;
            // PC
            case(op_type)
                // store
                `OPSB: begin
                    pc_sel <= 1'b0;
                    mask <= 8'b00000001;
                    store_ena = 1'b1;
                end
                `OPSH: begin
                    pc_sel <= 1'b0;
                    mask <= 8'b00000011;
                    store_ena = 1'b1;
                end
                `OPSW: begin
                    pc_sel <= 1'b0;
                    mask <= 8'b00001111;
                    store_ena = 1'b1;
                end
                `OPFSD: begin
                    pc_sel <= 1'b0;
                    mask <= 8'b11111111;
                    store_ena = 1'b1;
                end
                // branch
                `OPBEQ: begin
                    pc_sel <= (rs1_val == rs2_val) ? 1'b1 : 1'b0;
                    if (rs1_val == rs2_val) new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPBNE: begin     
                    pc_sel <= (rs1_val != rs2_val) ? 1'b1 : 1'b0;
                    if (rs1_val != rs2_val) new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPBLT: begin     
                    // < 1 >= 0
                    if (rs1_val[31] == 1 && rs2_val[31] == 1) compare = rs1_val < rs2_val ? 0 : 1;
                    else if (rs1_val[31] == 1 && rs2_val[31] == 0) compare = 1'b1;
                    else if (rs1_val[31] == 0 && rs2_val[31] == 1) compare = 1'b0;
                    else compare = rs1_val < rs2_val ? 1 : 0;
                    pc_sel <= (compare) ? 1'b1 : 1'b0;
                    if (compare) new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPBLTU: begin    
                    pc_sel <= (rs1_val < rs2_val) ? 1'b1 : 1'b0;
                    if (rs1_val < rs2_val) new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPBGE: begin     
                    // < 1 >= 0
                    if (rs1_val[31] == 1 && rs2_val[31] == 1) compare = rs1_val < rs2_val ? 0 : 1;
                    else if (rs1_val[31] == 1 && rs2_val[31] == 0) compare = 1'b1;
                    else if (rs1_val[31] == 0 && rs2_val[31] == 1) compare = 1'b0;
                    else compare = rs1_val < rs2_val ? 1 : 0;
                    pc_sel <= (compare) ? 1'b0 : 1'b1;
                    if (~compare) new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPBGEU: begin    
                    pc_sel <= (rs1_val >= rs2_val) ? 1'b1 : 1'b0;
                    if (rs1_val >= rs2_val) new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPJAL: begin     
                    pc_sel <= 1'b1;
                    new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPJALR: begin    
                    pc_sel <= 1'b1;
                    new_pc = PC + imm;
                    mask <= 4'b0000;
                end
                `OPMUL: begin
                    rs1_val_64 = {{32{rs1_val[31]}} ,rs1_val};
                    rs2_val_64 = {{32{rs1_val[31]}} ,rs2_val};
                    rs1_val_64 = rs1_val_64 * rs2_val_64;
                    ex_output = rs1_val_64[31:0];
                end
                `OPMULH: begin
                    rs1_val_64 = {{32{rs1_val[31]}} ,rs1_val};
                    rs2_val_64 = {{32{rs1_val[31]}} ,rs2_val};
                    rs1_val_64 = rs1_val_64 * rs2_val_64;
                    ex_output = rs1_val_64[63:32];
                end
                `OPMULHSU: begin
                    rs1_val_64 = {{32{rs1_val[31]}} ,rs1_val};
                    rs2_val_64 = {32'b0 ,rs2_val};
                    rs1_val_64 = rs1_val_64 * rs2_val_64;
                    ex_output = rs1_val_64[63:32];
                end
                `OPMULHU: begin
                    rs1_val_64 = {32'b0 ,rs1_val};
                    rs2_val_64 = {32'b0 ,rs2_val};
                    rs1_val_64 = rs1_val_64 * rs2_val_64;
                    ex_output = rs1_val_64[63:32];
                end
                `OPDIV: begin
                    rs1_val_64 = {{32{rs1_val[31]}} ,rs1_val};
                    rs2_val_64 = {{32{rs1_val[31]}} ,rs2_val};
                    rs1_val_64 = rs1_val_64 / rs2_val_64;
                    ex_output = rs1_val_64[31:0];
                end
                `OPDIVU: begin
                    rs1_val_64 = {32'b0 ,rs1_val};
                    rs2_val_64 = {32'b0 ,rs2_val};
                    rs1_val_64 = rs1_val_64 / rs2_val_64;
                    ex_output = rs1_val_64[31:0];
                end
                `OPREM: begin
                    rs1_val_64 = {{32{rs1_val[31]}} ,rs1_val};
                    rs2_val_64 = {{32{rs1_val[31]}} ,rs2_val};
                    rs1_val_64 = rs1_val_64 % rs2_val_64;
                    ex_output = rs1_val_64[31:0];
                end
                `OPREMU: begin
                    rs1_val_64 = {32'b0 ,rs1_val};
                    rs2_val_64 = {32'b0 ,rs2_val};
                    rs1_val_64 = rs1_val_64 % rs2_val_64;
                    ex_output = rs1_val_64[31:0];
                end
                `OPFMULD: begin
                    s1 = rs1_float_val[63];
                    e1 = rs1_float_val[62:52];
                    m1 = {1'b1, rs1_float_val[51:0]};
                    s2 = rs2_float_val[63];
                    e2 = rs2_float_val[62:52];
                    m2 = {1'b1, rs2_float_val[51:0]};
                    m_result = m1*m2;
                    //infine or nan?
                    if (e1 == 11'b111_1111_1111 || e2 == 11'b111_1111_1111) begin
                        if ((e1 == 11'b111_1111_1111 && rs1_float_val[51:0] != 52'b0) || (e2 == 11'b111_1111_1111 && rs2_float_val[51:0] != 52'b0)) begin
                            fflags_accured_exceptions[4] = 1'b1;
                            ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                        end
                        else begin
                            if ((e1 == 11'b0 && rs1_float_val[51:0] == 52'b0) && (e2 == 11'b111_1111_1111 && rs2_float_val[51:0] == 52'b0)) begin
                                fflags_accured_exceptions[4] = 1'b1;
                                ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                            end
                            else if ((e1 == 11'b111_1111_1111 && rs1_float_val[51:0] == 52'b0) && (e2 == 11'b0 && rs2_float_val[51:0] == 52'b0)) begin
                                fflags_accured_exceptions[4] = 1'b1;
                                ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                            end
                            else begin
                                ex_float_output = {s1^s2, 11'b111_1111_1111, 52'h0_0000_0000_0000};
                            end
                        end
                    end
                    //0
                    else if ((e1 == 11'b0 && rs1_float_val[51:0] == 52'b0) || (e2 == 11'b0 && rs2_float_val[51:0] == 52'b0)) begin
                        ex_float_output = {s1^s2, 11'b000_0000_0000, 52'h0_0000_0000_0000};
                    end
                    //other
                    else begin
                        if (m_result[105] == 1'b1) begin
                            e_result = e1 + e2 + 1;
                            if (e1+e2+1 < 12'd1023) begin
                                fflags_accured_exceptions[1] = 1'b1;
                                e_result = e_result - 1023;
                            end
                            else begin
                                e_result = e_result - 1023;
                                if (e_result[11] == 1'b1) fflags_accured_exceptions[2] = 1'b1;
                            end
                            ex_float_output = {s1^s2, e_result[10:0], m_result[104:53]};
                            float_rm_val = m_result[52:50];
                        end
                        else begin
                            e_result = e1 + e2;
                            if (e1+e2+1 < 12'd1023) begin
                                fflags_accured_exceptions[1] = 1'b1;
                                e_result = e_result - 1023;
                            end
                            else begin
                                e_result = e_result - 1023;
                                if (e_result[11] == 1'b1) fflags_accured_exceptions[2] = 1'b1;
                            end
                            ex_float_output = {s1^s2, e_result[10:0], m_result[103:52]};
                            float_rm_val = m_result[51:49];
                        end
                    end
                    
                end
                `OPFDIVD: begin
                    s1 = rs1_float_val[63];
                    e1 = rs1_float_val[62:52];
                    m1 = {1'b1, rs1_float_val[51:0]};
                    s2 = rs2_float_val[63];
                    e2 = rs2_float_val[62:52];
                    m2 = {1'b1, rs2_float_val[51:0]};
                     //infine or nan?
                    if (e1 == 11'b111_1111_1111 || e2 == 11'b111_1111_1111) begin
                        if ((e1 == 11'b111_1111_1111 && rs1_float_val[51:0] != 52'b0) || (e2 == 11'b111_1111_1111 && rs2_float_val[51:0] != 52'b0)) begin
                            fflags_accured_exceptions[4] = 1'b1;
                            ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                        end
                        else begin
                            if ((e1 == 11'b111_1111_1111 && rs1_float_val[51:0] == 52'b0) && (e2 == 11'b111_1111_1111 && rs2_float_val[51:0] == 52'b0)) begin
                                fflags_accured_exceptions[4] = 1'b1;
                                ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                            end
                            else if ((e1 == 11'b111_1111_1111 && rs1_float_val[51:0] == 52'b0)) begin
                                if ((e2 == 11'b0 && rs2_float_val[51:0] == 52'b0)) begin
                                    fflags_accured_exceptions[3] = 1'b1;
                                    ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                                end
                                else begin
                                    ex_float_output = {s1^s2, 11'b111_1111_1111, 52'h0_0000_0000_0000};
                                end
                            end
                            else if ((e2 == 11'b111_1111_1111 && rs2_float_val[51:0] == 52'b0)) begin
                                ex_float_output = {s1^s2, 11'b000_0000_0000, 52'h0_0000_0000_0000};
                            end
                        end
                    end
                    //0
                    else if ((e1 == 11'b0 && rs1_float_val[51:0] == 52'b0) || (e2 == 11'b0 && rs2_float_val[51:0] == 52'b0)) begin
                        if ((e1 == 11'b0 && rs1_float_val[51:0] == 52'b0) && (e2 == 11'b0 && rs2_float_val[51:0] == 52'b0)) begin
                            fflags_accured_exceptions[3] = 1'b1;
                            fflags_accured_exceptions[4] = 1'b1;
                            ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                        end
                        else if ((e2 == 11'b0 && rs2_float_val[51:0] == 52'b0)) begin
                            fflags_accured_exceptions[3] = 1'b1;
                            ex_float_output = {s1^s2, 11'b111_1111_1111, 52'hf_ffff_ffff_ffff};
                        end
                        else begin
                            ex_float_output = {s1^s2, 11'b000_0000_0000, 52'h0_0000_0000_0000};
                        end
                    end
                    //other
                    else begin
                        m_result = {m1, 55'b0}/m2;
                        e_result = e1 - e2 + 1023;
                        if (e_result[11] == 1'b1) fflags_accured_exceptions[2] = 1'b1;
                        ex_float_output = {s1^s2, e_result[10:0], m_result[54:3]};
                        float_rm_val = m_result[2:0];
                    end
                end
                default: begin
                    pc_sel <= 1'b0;
                    mask <= 4'b0000;
                end
            endcase

            // ALU compute
            case(alu_type)
                `ALUSL: ex_output <= operand1 << operand2;
                `ALUSR: ex_output <= operand1 >> operand2;
                `ALUADD: ex_output <= operand1 + operand2;
                `ALUSUB: ex_output <= operand1 - operand2;
                `ALUXOR: ex_output <= operand1 ^ operand2;
                `ALUAND: ex_output <= operand1 & operand2;
                `ALUOR:  ex_output <= operand1 | operand2;
                `ALUCMP: ex_output <= (operand1 < operand2) ? 32'd1: 32'd0;
                `ALUNO:  ex_output <= operand2;
            endcase
        end
        // stall
        else begin
            next_ena    <= 1'b0;
            pc_sel      <= 1'b0;
            mask        <= mask;
            ex_output   <= ex_output;
        end
    end
    
endmodule
