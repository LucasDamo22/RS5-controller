module i2c_generic #(
    parameter int unsigned ADDR_SIZE = 8,
    parameter int unsigned DATA_SIZE = 8,
    parameter int unsigned CLK_FREQUENCE = 200_000_000,
	parameter int unsigned I2C_FREQ 	 = 400_000
)(
    input logic clk,
    input logic reset_n,

    input logic [24:0] command_i,
    input logic        we_en_i,
    input logic        sda_i,
    output logic [7:0] data_o,
    output logic       data_valid_o,
    output logic       done,
    output logic       sda_o,
    output logic       sda_tristate_en_o,
    output logic       scl_o
);



typedef enum logic[7:0] { 
    IDLE                = 8'b00000001,
    GEN_START_CONDITION = 8'b00000010,
    SEND_ADDR           = 8'b00000100,
    WAIT_ACK            = 8'b00001000,
    WRITE_REG_ADDR      = 8'b00010000,
    WRITE_REG_DATA      = 8'b00100000,
    READ                = 8'b01000000,
    GEN_STOP_CONDITION  = 8'b10000000
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

logic send_addr_done;
logic ack_received;
logic write_data_byte_done;
logic write_addr_byte_done;
logic started;
logic stopped;
logic read_complete;
logic read_byte_done;
logic rising_scl;
logic falling_scl;
logic scl_r;
logic third_quarter;
logic clk_count_half;
logic[7:0] data_r_o;

logic[24:0] command_reg;


always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        command_reg <= '0;
    end 
    else begin
        if (we_en_i && current_state == IDLE) begin
            command_reg <= command_i;
        end
    end
end

logic only_write_reg_addr;
assign only_write_reg_addr = command_reg[24];

logic operation_read;
assign operation_read = command_reg[16];

logic operation_write;
assign operation_write = ~command_reg[16];

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        data_o <= '0;
        data_valid_o <= '0;    
    end
    else begin
        if(operation_read && read_byte_done) begin
            data_o <= data_r_o;
            data_valid_o <= 1'b1;
        end 
        else
            data_valid_o <= 1'b0;
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        done <= '0;
    end
    else begin
        if(current_state == GEN_STOP_CONDITION && stopped) begin
            done <= 1'b1;
        end 
        else begin
            done <= 1'b0;
        end
    end
end

always_comb begin
    next_state  = IDLE;
    unique case(current_state)
        IDLE: begin 
            if(we_en_i)
                next_state = GEN_START_CONDITION;
            else 
                next_state = IDLE;
        end
        GEN_START_CONDITION: begin
            if(started)
                next_state = SEND_ADDR;
            else
                next_state = GEN_START_CONDITION;
        end
        SEND_ADDR: begin 
            if(send_addr_done)
                next_state = WAIT_ACK;
            else
                next_state = SEND_ADDR;
        end
        WAIT_ACK: begin 
            if(ack_received && falling_scl) begin
                if(operation_read)
                    if(read_complete)
                        next_state = GEN_STOP_CONDITION;
                    else 
                        next_state = READ;
                if(operation_write) begin
                    if(write_addr_byte_done)
                        if(only_write_reg_addr)
                            next_state = GEN_STOP_CONDITION;
                        else
                            next_state = WRITE_REG_DATA;
                    else 
                        next_state = WRITE_REG_ADDR;
                end
            end
            else begin
                next_state = WAIT_ACK;
            end
        end     
        WRITE_REG_ADDR: begin 
            if(write_addr_byte_done) begin
                next_state = WAIT_ACK;
            end
            else begin
                next_state = WRITE_REG_ADDR;
            end
        end
        WRITE_REG_DATA:
            if(write_data_byte_done)
                next_state = GEN_STOP_CONDITION;
            else
                next_state = WRITE_REG_DATA;
        READ: begin 
            if(read_byte_done)
                next_state = WAIT_ACK;
            else
                next_state = READ;

        end
        GEN_STOP_CONDITION: begin
            if(stopped)
                next_state = IDLE;
            else
                next_state =  GEN_STOP_CONDITION;
        end
    
    endcase
end



logic [7:0] slave_addr;
logic [15:0] data;

always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        slave_addr <= '0;
    end 
    else begin
        if (we_en_i && current_state == IDLE) begin
            slave_addr <= command_i[23:16];
        end
    end
end

logic[2:0] bit_index;
logic[3:0] bit_count;


logic [15:0] read_size;
logic [15:0] read_compare;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        read_size <= '0;
        read_compare <= '0;
    end
    else begin 
        unique case(current_state)
            IDLE: read_compare <= '0;
            GEN_START_CONDITION: begin
                if(operation_read) begin
                    read_size <= command_reg[15:0];
                end
                read_compare <= '0;
            end
            READ:
                if(read_byte_done) begin
                    read_compare <= read_compare + 1;
                end
            default: ;
        endcase
    end
end
assign read_complete = (read_compare >= read_size);

logic[7:0] reg_addr;
logic[7:0] reg_data;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        reg_addr <= '0;
        reg_data <= '0;
    end
    else begin
        unique case (current_state)
            IDLE: begin
                reg_addr <= '0;
                reg_data <= '0;
            end
            GEN_START_CONDITION: begin
                if(operation_write) begin
                    reg_addr <= command_reg[15:8];
                    reg_data <= command_reg[7:0];
                end
            end
            default: ;
        endcase
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        read_byte_done <= '0;
    end 
    else begin
        unique case(current_state)
            READ: begin
                if(bit_count >= 8) begin
                    read_byte_done <= 1'b1;
                end
            end
            default: read_byte_done <= 1'b0;
        endcase
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        data_r_o <= '0;
    end
    else begin
        unique case(current_state)
            READ: begin
                if(rising_scl) begin
                    data_r_o[bit_index] <= sda_i;
                end
            end
            default: ;
        endcase
    end
end

logic quarter_period;
always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        sda_o <= '1;
    end
    else begin
        unique case(current_state)
            IDLE: sda_o <= '1;
            GEN_START_CONDITION: begin
                    sda_o <= '0;
            end
            SEND_ADDR: begin
                sda_o <= slave_addr[bit_index];
            end
            WAIT_ACK: begin
                if(operation_read)
                    if(read_complete)
                        sda_o <= 1'b1;
                    else
                        sda_o <= 1'b0;
                
            end
            WRITE_REG_ADDR: begin
                sda_o <= reg_addr[bit_index];
            end
            WRITE_REG_DATA: begin
                sda_o <= reg_data[bit_index];
            end
            GEN_STOP_CONDITION: begin
                if(quarter_period && scl_o == 1'b1) begin
                    sda_o <= 1'b1;
                end
                else begin
                    sda_o <= 1'b0;
                end    
            end
            default: ;
        endcase
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        bit_count <= '0;
    end
    else begin
        if(current_state inside{READ, SEND_ADDR, WRITE_REG_ADDR, WRITE_REG_DATA}) begin
            if(falling_scl) begin
                bit_count <= bit_count + 1'b1;
            end
        end else begin
            bit_count <= '0;
        end
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        write_addr_byte_done <= '0;
    end
    else begin
        unique case(current_state)
            WRITE_REG_ADDR: begin
                if(bit_count >= 7 && falling_scl) begin
                    write_addr_byte_done <= 1'b1;
                end
            end
            IDLE: begin
                write_addr_byte_done <= '0;
            end
            default: ;
        endcase
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        write_data_byte_done <= '0;
    end
    else begin
        unique case(current_state)
            WRITE_REG_DATA: begin
                if(bit_count >= 7 && falling_scl) begin
                    write_data_byte_done <= 1'b1;
                end
            end
            IDLE: begin
                write_data_byte_done <= '0;
            end
            default: ;
        endcase
    end
end

assign send_addr_done = (current_state == SEND_ADDR && bit_count >= 7 && falling_scl);

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        bit_index <= 3'b111;
    end
    else begin
        if(current_state inside{SEND_ADDR, READ, WRITE_REG_ADDR, WRITE_REG_DATA } ) begin
            if(falling_scl) begin
                bit_index <= bit_index - 1'b1;
            end
        end
        else 
            bit_index <= 3'b111;
    end
end

localparam int unsigned CLKS_PER_BIT = (CLK_FREQUENCE / I2C_FREQ) - 1;
localparam int unsigned SIZE = CLKS_PER_BIT == 0 ? 1 : $clog2(CLKS_PER_BIT+1);

logic [SIZE -1:0] clk_count;

logic clk_count_top;
logic enable_clk_count;


logic en_scl;
always_comb begin
    en_scl = (current_state inside {GEN_START_CONDITION, SEND_ADDR, WAIT_ACK, READ, WRITE_REG_ADDR, WRITE_REG_DATA, GEN_STOP_CONDITION});
    enable_clk_count = en_scl || current_state == GEN_STOP_CONDITION;
end


assign third_quarter = (clk_count == (SIZE'(CLKS_PER_BIT/4)) * 3);
assign quarter_period = (clk_count == SIZE'(CLKS_PER_BIT/4));
assign clk_count_half = (clk_count == SIZE'(CLKS_PER_BIT/2));
assign clk_cnt_top = (clk_count == SIZE'(CLKS_PER_BIT));

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        clk_count <= '0;
    end
    else begin
        if(enable_clk_count) begin
            if(clk_cnt_top)
                clk_count <= '0;
            else
                clk_count <= clk_count + 1;
        end
        if(current_state == IDLE) 
            clk_count <= '0;
    end
end
logic slave_select_ack;

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        ack_received <= '0;
    end 
    else begin
        if(current_state == WAIT_ACK && operation_read) begin
            if(!slave_select_ack) begin
                if(rising_scl && sda_i == 1'b0)
                    ack_received <= 1'b1;
            end
            else begin
                if(read_complete && rising_scl)
                    ack_received <= 1'b1;
                else if(rising_scl && sda_o == 1'b0)
                    ack_received <= 1'b1;
            end
        end 
        else if(current_state == WAIT_ACK && operation_write) begin
            if(rising_scl && sda_o == 1'b0)
                ack_received <= 1'b1;
        end
        else begin
            ack_received <= 1'b0;
        end
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        slave_select_ack <= '0;
    end else begin
        if(operation_read && ack_received) begin
            slave_select_ack <= 1'b1;
        end
        else if(current_state == IDLE)
            slave_select_ack <= 1'b0;
    end
end
always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        sda_tristate_en_o <= 1'b0;
    end else begin
        if(operation_read) begin
            unique case(current_state)
                READ: sda_tristate_en_o <= 1'b0;
                WAIT_ACK: sda_tristate_en_o <= slave_select_ack ? 1'b1 : 1'b0;
                default: sda_tristate_en_o <= 1'b1;
            endcase
        end
        else if(operation_write) begin
            unique case(current_state)
                WAIT_ACK: sda_tristate_en_o <= 1'b0;
                default: sda_tristate_en_o <= 1'b1;
            endcase
        end
    end
end

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        scl_o <= '1;
    end
    else begin
        // if(current_state == GEN_START_CONDITION && sda_o == '0) begin
        //     scl_o <= 1'b0;
        // end
        if (en_scl) begin
            if(clk_count_half)
                scl_o <= ~scl_o;
        end
        else begin
            scl_o <= 1'b1;
        end
    end
end

assign stopped = (current_state == GEN_STOP_CONDITION && scl_o == 1'b1 && quarter_period);
assign started = ((current_state == GEN_START_CONDITION) && (sda_o == 0) && (scl_o == 0) && quarter_period) ? 1'b1 : 0;
always_ff@(posedge clk) begin
    scl_r <= scl_o;
end


assign rising_scl = !scl_r && scl_o;
assign falling_scl = scl_r && !scl_o;

endmodule