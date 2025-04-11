`include "i2c_bno055_emulator_pkg.sv"
module i2c_bno055_emulator
    import i2c_bno055_emulator_pkg::*;
#(
    parameter logic [6:0]  ADDR = 7'h29,
    parameter int unsigned ADDR_SIZE = 8,
    parameter int unsigned DATA_SIZE = 8
)(
    input logic clk,
    input logic reset_n,

    input  logic                     we_core_i,
    input  logic [((ADDR_SIZE)-1):0] core_addr_i,
    input  logic [((DATA_SIZE)-1):0] core_data_i,
    output logic [((DATA_SIZE)-1):0] core_data_o,

    input  logic       start_condition,
    input  logic       stop_condition,

    input  logic [7:0] i2c_data_i,
    input  logic       i2c_dv_i,

    output logic [7:0] bno_data_o,
    output logic       bno_dv_o
);

typedef enum logic[6:0] { 
    IDLE      = 7'b0000001,
    START     = 7'b0000010,
    READ      = 7'b0000100,
    READ_SEQ  = 7'b0001000,
    WRITE     = 7'b0010000,
    WRITE_SEQ = 7'b0100000,
    STOP      = 7'b1000000
} state;

state current_state, next_state;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end




always_comb begin
    next_state = IDLE;
    unique case(current_state)
        IDLE:begin
            if(start_condition)
                next_state = START;
            else
                next_state = IDLE;
        end
        START: begin
            if(stop_condition)
                next_state = IDLE;
            
            else if(i2c_dv_i) begin  // new data incoming
                if(i2c_data_i[7:1] == ADDR) begin // sensor selected
                    if(i2c_data_i[0])             // read operation
                        next_state = READ;
                    else
                        next_state = WRITE;
                end else
                    next_state = IDLE;
            end
            else
                next_state = START;
        end
    endcase
end


logic [7:0] reg_addr;
logic [7:0] reg_data;

logic [7:0] i2c_data_i;


always_comb begin
    bno_data_o = i2c_data_o;
end


always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        reg_addr <= 8'b0;
        bno_dv_o <= 1'b0;
    end
    else begin
        if(current_state == READ && i2c_dv_i) begin
            reg_addr <= i2c_data_i;
            new_addr <= 1'b1;
        end
        if(current_state == READ_SEQ && i2c_dv_i) begin
            reg_addr <= reg_addr + 1;
            new_addr <= 1'b1;
        end
        else
            new_addr <= 1'b0;
    end
end

always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        bno_dv_o <= 1'b0;
    end
    else begin
        if(new_addr)
            bno_dv_o <= 1'b1;
        else
            bno_dv_o <= 1b0;
    end
end

i2c_bno055_emulator_regs #(
    .ADDR_SIZE(ADDR_SIZE),
    .DATA_SIZE(DATA_SIZE)
) regs (
    .clk(clk),
    .reset_n(reset_n),
    
    .we_core_i(we_core_i),
    .core_addr_i(core_addr_i),
    .core_data_i(core_data_i),
    .core_data_o(core_data_o),

    .we_i2c_i(),
    .i2c_addr_i(reg_addr),
    .i2c_data_i(i2c_data_i),
    .i2c_data_o(bno_data_o)
);

endmodule

