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

logic ack_signal;

typedef enum logic[7:0] { 
    IDLE                 = 8'b00000001,
    RECEIVING_SLAVE_ADDR = 8'b00000010,
    SLAVE_SELECT_ACK     = 8'b00000100,
    WRITE_REG_ADDR       = 8'b00001000,
    WRITE_REG_DATA       = 8'b00010000,
    READ                 = 8'b00100000,
    ACK                  = 8'b01000000,
    WAIT_STOP_CONDITION  = 8'b10000000
} i2c_states;

i2c_states current_state, next_state;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end    
end

logic[7:0] data;
logic [7:0] bno_data_o;
logic[2:0] bit_index;
logic[3:0] bit_count;
logic start_condition;
logic stop_condition;
logic byte_received;
logic device_selected;
logic operation_read;
logic operation_write;
logic byte_sent;
always_comb begin 
    next_state = IDLE;
    unique case(current_state)
        IDLE: begin
            if(start_condition && scl_falling)
                next_state = RECEIVING_SLAVE_ADDR;
            else
                next_state = IDLE;
        end
        RECEIVING_SLAVE_ADDR: begin
            if(byte_received) begin
                if(device_selected)
                    next_state = SLAVE_SELECT_ACK;
                else
                    next_state = WAIT_STOP_CONDITION;
            end
            else if(stop_condition)
                next_state = IDLE;
            else
                next_state = RECEIVING_SLAVE_ADDR;
        end
        SLAVE_SELECT_ACK: begin
            if(ack_signal) begin
                if(operation_read)
                    next_state = READ;
                else if(operation_write)
                    next_state = WRITE_REG_ADDR;
            end
            else if(stop_condition)
                next_state = IDLE;
            else
                next_state = SLAVE_SELECT_ACK;
        end
        WRITE_REG_ADDR: begin
            if(byte_received)
                next_state = ACK;
            else if(stop_condition)
                next_state = IDLE;
            else next_state = WRITE_REG_ADDR;
        end
        WRITE_REG_DATA: begin
            if(byte_received)
                next_state = ACK;
            else if(stop_condition)
                next_state = IDLE;
            else
                next_state = WRITE_REG_DATA;
        end
        WAIT_STOP_CONDITION: begin
            if(stop_condition) begin
                next_state = IDLE;
            end
        end
        READ: begin
            if(byte_sent) begin
                next_state = ACK;
            end
            else if(stop_condition) begin
                next_state = IDLE;
            end 
            else
                next_state = READ;
        end
        ACK: begin
            if(ack_signal) begin
                if(operation_write) begin
                    next_state = WRITE_REG_DATA;
                end
                if(operation_read) begin
                    next_state = READ;
                end
            end
            else if(stop_condition) begin
                next_state = IDLE;
            end
            else
                next_state = ACK;
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
        end
        else if(current_state != IDLE) 
            start_condition <= '0;
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

logic [7:0] slave_addr;
always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        slave_addr <= 8'b0;
    end
    else begin
        unique case(current_state)
            RECEIVING_SLAVE_ADDR: begin
                if(scl_rising) begin
                    slave_addr[bit_index] <= sda_i;
                end
            end
            default: ;
        endcase
    end
end
logic [7:0] reg_addr;
logic [7:0] reg_addr_temp;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        reg_addr <= 8'b0;
    end
    else begin
        unique case(current_state)
            WRITE_REG_ADDR: begin
                if(scl_rising) begin
                    reg_addr[bit_index] <= sda_i;
                end
            end
            default: ;
        endcase
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        reg_addr_temp <= '0;
    end 
    else begin
        unique case(current_state)
            IDLE: reg_addr_temp <= reg_addr;
            WRITE_REG_ADDR: begin
                if(byte_received)
                    reg_addr_temp <= reg_addr;
            end
            READ: begin
                if(byte_sent)
                    reg_addr_temp <= reg_addr_temp + 1'b1;
            end
            default: ;
        endcase
    end
end
logic [7:0] reg_data;
always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        reg_data <= 8'b0;
    end
    else begin
        unique case(current_state)
            WRITE_REG_DATA: begin
                if(scl_rising) begin
                    reg_data[bit_index] <= sda_i;
                end
            end
            default: ;
        endcase
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        operation_read <= '0;
        operation_write <= '0;
    end
    else begin
        if(current_state == SLAVE_SELECT_ACK) begin
            operation_read  <= slave_addr[0];
            operation_write <= !slave_addr[0];
        end
        if(current_state == IDLE) begin
            operation_read <= '0;
            operation_write <= '0;
        end
    end
end
assign device_selected = (slave_addr[7:1] == ADDR);

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        bit_index <= 3'b111;
    end
    else begin
        if(current_state inside{RECEIVING_SLAVE_ADDR, WRITE_REG_ADDR, WRITE_REG_DATA, READ}) begin
            if(scl_falling) begin
                bit_index <= bit_index - 1'b1;
            end
        end
        else
            bit_index <= 3'b111;
    end
end
always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        bit_count <= 3'b0;
    end
    else begin
        if(current_state inside{RECEIVING_SLAVE_ADDR, WRITE_REG_ADDR, WRITE_REG_DATA, READ}) begin
            if(scl_falling) begin
                bit_count <= bit_count + 1'b1;
            end
        end
        else
            bit_count <= '0;
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        sda_o <= 1'b1;
    end 
    else begin
        unique case(current_state)
            RECEIVING_SLAVE_ADDR: sda_o <= 1'b0;
            SLAVE_SELECT_ACK:     sda_o <= 1'b0;
            ACK:                  sda_o <= 1'b0;
            READ: begin
                sda_o <= bno_data_o[bit_index];
            end
            IDLE: sda_o <= 1'b1;
            default: ; 
        endcase
    end
end
always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        sda_tristate_en_o <= 1'b1;
    end 
    else begin
        if(operation_write) begin
            unique case (current_state)
                SLAVE_SELECT_ACK: sda_tristate_en_o <= 1'b0;
                ACK:              sda_tristate_en_o <= 1'b0;
                default:          sda_tristate_en_o <= 1'b1;
            endcase
        end else if (operation_read) begin
            unique case (current_state)
                SLAVE_SELECT_ACK: sda_tristate_en_o <= 1'b0;
                ACK:              sda_tristate_en_o <= 1'b1;
                default:          sda_tristate_en_o <= 1'b0;
            endcase
        end else begin
            sda_tristate_en_o <= 1'b1;
        end
    end
end

always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        ack_signal <= 1'b0;
    end
    else begin
        unique case (current_state)
            SLAVE_SELECT_ACK: ack_signal <= (scl_falling && !sda_o);
            ACK: ack_signal <= (scl_falling && !sda_o);
            default: ;
        endcase
    end
    
end

logic reg_we;
assign reg_we = ((current_state == WRITE_REG_DATA) && byte_received);
assign byte_sent = ((current_state inside{READ}) && bit_count >= 8);
assign byte_received = (current_state inside{RECEIVING_SLAVE_ADDR, WRITE_REG_ADDR, WRITE_REG_DATA}) && bit_count >= 8;




i2c_bno055_emulator_regs #(
    .ADDR_SIZE(ADDR_SIZE),
    .DATA_SIZE(DATA_SIZE)
) regs (
    .clk(clk),
    .reset_n(reset_n),
    
    .core_we_i(we_core_i),
    .core_addr_i(core_addr_i),
    .core_data_i(core_data_i),
    .core_data_o(core_data_o),

    .i2c_we_i(reg_we),
    .i2c_addr_i(reg_addr_temp),
    .i2c_data_i(reg_data),
    .i2c_data_o(bno_data_o)
);

endmodule

