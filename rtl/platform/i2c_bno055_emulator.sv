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

    input  logic scl_i,
    input  logic sda_i,
    output logic sda_o,
    output logic sda_tristate_en_o
);

logic sda_r;
logic scl_r;
always_ff @(posedge clk) begin 
    sda_r <= sda_i;
    scl_r <= scl_i;
end

logic scl_rising;
logic scl_falling;
assign scl_rising  = scl_i && !scl_r ? 1'b1 : 1'b0;
assign scl_falling = !scl_i && scl_r ? 1'b1 : 1'b0;

logic sda_rising;
logic sda_falling;
assign sda_rising  = sda_i && !sda_r ? 1'b1 : 1'b0;
assign sda_falling = !sda_i && sda_r ? 1'b1 : 1'b0;

typedef enum logic[4:0] { 
    IDLE_I2C           = 5'b00001,
    RECEIVING_I2C_DATA = 5'b00010,
    SENDING_I2C_ACK    = 5'b00100,
    SENDING_I2C_DATA   = 5'b01000,
    RECEIVING_I2C_ACK  = 5'b10000
} i2c_states;

i2c_states current_state_i2c, next_state_i2c;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        current_state_i2c <= IDLE_I2C;
    end
    else begin
        current_state_i2c <= next_state_i2c;
    end    
end

logic[7:0] data;
logic[3:0] bit_index;
logic[3:0] bit_count;
logic start_condition;
logic stop_condition;
logic byte_received;
logic device_selected;
always_comb begin 
    next_state_i2c = IDLE_I2C;
    unique case(current_state_i2c)
        IDLE_I2C: begin
            if(start_condition)
                next_state_i2c = RECEIVING_I2C_DATA;
            else
                next_state_i2c = IDLE_I2C;
        end
        RECEIVING_I2C_DATA: begin
            if(byte_received) begin
                if(device_selected)
                    next_state_i2c = SENDING_I2C_ACK;
                else
                    next_state_i2c = IDLE_I2C;
            end else
                next_state_i2c = RECEIVING_I2C_DATA;
        end
        SENDING_I2C_ACK: begin
            // if(ack_sent)
            //     next_state_i2c = rece
            
        end
        SENDING_I2C_DATA: begin
        end
    endcase
end



always_ff @ (posedge clk or reset_n) begin
    if(!reset_n) begin
        start_condition <= 1'b0;
    end
    else begin
        if(scl_i) begin
            if(sda_falling)
                start_condition <= 1'b1;
            else
                start_condition <= 1'b0;
        end
    end
end
always_ff @ (posedge clk or reset_n) begin
    if(!reset_n) begin
        stop_condition <= 1'b0;
    end
    else begin
        if(scl_i) begin
            if(sda_rising)
                stop_condition <= 1'b1;
            else
                stop_condition <= 1'b0;
        end
    end
end

typedef enum logic[2:0] { 
    IDLE  = 3'b001,
    WRITE = 3'b010,
    READ  = 3'b100
} states;

states current_state, next_state;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

logic [7:0] reg_addr;
logic [7:0] i2c_data_i;
logic [7:0] bno_data_o;



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

